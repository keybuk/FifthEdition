//
//  DiceNotation.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

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

/// One or more ``Die`` to bbe rolled, or a modifier to be applied.
public enum Dice: Equatable, Hashable, Sendable {
    case die(Die, count: Int = 1)
    case modifier(Int)
}

extension Dice: Rollable {
    public var average: Int {
        switch self {
        case let .die(die, count): (count * (die.rawValue + 1)) / 2
        case let .modifier(modifier): modifier
        }
    }

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
/// Encodes the notation of one or more ``Dice`` to be rolled, with zero or more modifiers added or subtracted,
/// e.g. `"2d6 + 4"`.
public struct DiceNotation: Equatable, Hashable, Sendable {
    /// Dice to be rolled and modifiers to be added to or subtracted from the rolled total.
    public let dice: [Dice]

    public init(_ dice: [Dice]) {
        self.dice = dice
    }

    /// Create a simple dice notation.
    /// - Parameters:
    ///   - die: Die to be rolled.
    ///   - count: Number of `die` to be rolled.
    ///   - modifier: Modifier to be added to or subtracted from the rolled total.
    public init(_ die: Die, count: Int = 1, modifier: Int = 0) {
        dice = [.die(die, count: count)]
            + (modifier != 0 ? [.modifier(modifier)] : [])
    }
}

extension DiceNotation: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Dice...) {
        self.init(elements)
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
