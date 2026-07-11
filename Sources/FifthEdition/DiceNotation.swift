//
//  DiceNotation.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import RegexBuilder

/// Something that can be rolled.
public protocol Rollable {
    /// Average roll.
    var average: Int { get }

    /// Range of possible rolls.
    var range: ClosedRange<Int> { get }

    /// Returns a random roll.
    /// - Returns: A random value within ``range``.
    func roll() -> Int

    /// Returns a random roll using the given generator as a source for randomness.
    /// - Parameter generator: The random number generator to use when creating the roll.
    /// - Returns: A random value within ``range``.
    func roll(using generator: inout some RandomNumberGenerator) -> Int
}

public extension Rollable {
    func roll() -> Int {
        .random(in: range)
    }

    func roll(using generator: inout some RandomNumberGenerator) -> Int {
        .random(in: range, using: &generator)
    }
}

/// Die to be rolled.
///
/// Can represent those both in and out of jail.
public enum Die: Int, CaseIterable, Equatable, Hashable, Sendable {
    case d1 = 1
    case d2 = 2
    case d3 = 3
    case d4 = 4
    case d6 = 6
    case d8 = 8
    case d10 = 10
    case d12 = 12
    case d20 = 20
    case d100 = 100
}

extension Die: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Die: CustomStringConvertible {
    public var description: String {
        "d\(rawValue)"
    }
}

extension Die: Rollable {
    /// The average roll from this die.
    public var average: Int {
        (rawValue + 1) / 2
    }

    /// The range of possible rolls from this die.
    public var range: ClosedRange<Int> {
        1...rawValue
    }
}

/// One or more ``Die`` to be rolled, or a modifier to be applied.
///
/// Each ``Die`` to be rolled, along with the count of that die, is given in the associated values of ``die(_:count:)``.
///
/// Modifiers to be added to, or subtracted from, the roll are given in the associated value of ``modifier(_:)``.
public enum Dice: Equatable, Hashable, Sendable {
    case die(Die, count: Int = 1)
    case modifier(Int)
}

extension Dice: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .die(die, count):
            count.formatted(.number) + die.description
        case let .modifier(modifier):
            modifier.formatted(.number)
        }
    }
}

extension Dice: Rollable {
    /// The average roll from the dice or value of the modifier.
    public var average: Int {
        switch self {
        case let .die(die, count): (count * (die.rawValue + 1)) / 2
        case let .modifier(modifier): modifier
        }
    }

    /// The range of possible rolls from the dice or value of the modifier.
    public var range: ClosedRange<Int> {
        switch self {
        case let .die(die, count) where count < 0:
            (die.range.upperBound * count)...(die.range.lowerBound * count)
        case let .die(die, count):
            (die.range.lowerBound * count)...(die.range.upperBound * count)
        case let .modifier(modifier):
            modifier...modifier
        }
    }
}

/// Dice notation.
///
/// Encodes the notation of ``Dice`` to be rolled, with modifiers added or subtracted, e.g. `"2d6 + 4"`.
public struct DiceNotation: Equatable, Hashable, Sendable {
    /// Dice to be rolled and modifiers to be added to or subtracted from the rolled total.
    public let dice: [Dice]

    /// Initialize dice.
    public init(_ dice: [Dice]) {
        self.dice = dice
    }

    /// Initialize a simple dice notation.
    /// - Parameters:
    ///   - die: Die to be rolled.
    ///   - count: Number of `die` to be rolled.
    ///   - modifier: Modifier to be added to or subtracted from the rolled total.
    public init(_ die: Die, count: Int = 1, modifier: Int = 0) {
        dice = [.die(die, count: count)]
            + (modifier != 0 ? [.modifier(modifier)] : [])
    }
}

extension DiceNotation: ExpressibleByArrayLiteral, ExpressibleByStringLiteral {
    /// Initialize ``dice`` from an array literal.
    public init(arrayLiteral elements: Dice...) {
        self.init(elements)
    }

    /// Initialize from a string literal by parsing as a string.
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)!
    }

    /// Initialize a new dice notation from the given string.
    /// - Parameter string: The string representation of the dice notation.
    /// - Returns: `nil` if the string does not match the format of a dice notation.
    public init?(string: String) {
        let signReference = RegexBuilder.Reference(Int.self)
        let signRegex = Regex {
            ZeroOrMore(.whitespace)
            Capture(as: signReference) {
                One(CharacterClass.anyOf("+\u{2012}\u{2212}-"))
            } transform: { match in
                match == "+" ? 1 : -1
            }
            ZeroOrMore(.whitespace)
        }

        let diceCountReference = RegexBuilder.Reference(Int.self)
        let dieReference = RegexBuilder.Reference(Die.self)
        let diceRegex = Regex {
            Capture(as: diceCountReference) {
                ZeroOrMore(.digit)
            } transform: { match in
                !match.isEmpty ? Int(match)! : 1
            }
            "d"
            TryCapture(as: dieReference) {
                OneOrMore(.digit)
            } transform: { match in
                Die(rawValue: Int(match)!)
            }
        }

        let modifierReference = RegexBuilder.Reference(Int.self)
        let modifierRegex = Regex {
            Capture(as: modifierReference) {
                OneOrMore(.digit)
            } transform: { match in
                Int(match)!
            }
        }

        var dice: [Dice] = []

        var remainingString = string[...]
        while !remainingString.isEmpty {
            let sign: Int
            if let match = remainingString.prefixMatch(of: signRegex) {
                sign = match[signReference]
                remainingString = remainingString[match.range.upperBound...]
            } else if dice.isEmpty {
                sign = 1
            } else {
                return nil
            }

            if let match = remainingString.prefixMatch(of: diceRegex) {
                dice.append(.die(match[dieReference], count: sign * match[diceCountReference]))
                remainingString = remainingString[match.range.upperBound...]
            } else if let match = remainingString.prefixMatch(of: modifierRegex) {
                dice.append(.modifier(sign * match[modifierReference]))
                remainingString = remainingString[match.range.upperBound...]
            } else {
                return nil
            }
        }

        self.init(dice)
    }
}

extension DiceNotation: CustomStringConvertible {
    public var description: String {
        dice.reduce("") { partialResult, dice in
            switch dice {
            case let .die(die, count):
                if partialResult.isEmpty {
                    dice.description
                } else if count < 0 {
                    "\(partialResult) - \(abs(count))\(die)"
                } else {
                    "\(partialResult) + \(count)\(die)"
                }
            case let .modifier(modifier):
                if partialResult.isEmpty {
                    dice.description
                } else if modifier < 0 {
                    "\(partialResult) - \(abs(modifier))"
                } else {
                    "\(partialResult) + \(modifier)"
                }
            }
        }
    }
}

extension DiceNotation: Rollable {
    public var average: Int {
        dice.reduce(0) { partialResult, dice in
            partialResult + dice.average
        }
    }

    public var range: ClosedRange<Int> {
        dice.reduce(0...0) { partialResult, dice in
            (partialResult.lowerBound + dice.range.lowerBound)...(partialResult.upperBound + dice.range.upperBound)
        }
    }
}
