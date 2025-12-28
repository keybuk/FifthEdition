//
//  DiceNotation.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Foundation

/// Die to be rolled.
///
/// Can represent those both in and out of jail.
public enum Die: Int, Comparable, Equatable, Sendable {
    case d3   = 3
    case d4   = 4
    case d6   = 6
    case d8   = 8
    case d10  = 10
    case d12  = 12
    case d20  = 20
    case d100 = 100

    public static func < (lhs: Die, rhs: Die) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// Dice notation.
///
/// Encodes the notation of a number of dice to be rolled, and a modifier added or subtracted, e.g. `"2d6 + 4"`.
public struct DiceNotation: Equatable, Sendable {
    /// Number of dice to be rolled.
    public let count: Int

    /// Die to be rolled.
    public let die: Die

    /// Modifier to be added or subtracted from the rolled total.
    public let modifier: Int

    /// The average roll this notation yields.
    public var average: Int {
        (count * (die.rawValue + 1)) / 2 + modifier
    }

    /// The range of possible rolls this notation yields.
    public var range: ClosedRange<Int> {
        (count + modifier)...(count * die.rawValue + modifier)
    }

    /// The dice notation expressed as a human readable string.
    public var stringValue: String {
        let rolledString = "\(count)d\(die.rawValue)"

        switch modifier {
        case 1...: return "\(rolledString) + \(modifier)"
        case ..<0: return "\(rolledString) - \(abs(modifier))"
        default:   return rolledString
        }
    }

    /// Crates a new dice notation.
    /// - Parameters:
    ///   - die: The die to roll.
    ///   - count: Number of `die` to roll.
    ///   - modifier: Modifier to add or subtract from the rolled total.
    public init(_ die: Die, count: Int = 1, modifier: Int = 0) {
        self.count = count
        self.die = die
        self.modifier = modifier
    }

    /// Crates a new dice notation.
    /// - Parameters:
    ///   - count: Number of `die` to roll.
    ///   - die: The die to roll.
    ///   - modifier: Modifier to add or subtract from the rolled total.
    public init(count: Int = 1, die: Die, modifier: Int = 0) {
        self.count = count
        self.die = die
        self.modifier = modifier
    }

    /// Creates a new dice notation from the given string.
    /// - Parameter string: The string representation of the dice notation.
    ///
    /// If `string` does not match the format of a dice notation, the initializer returns `nil`.
    public init?(_ string: String) {
        let regex = /(\d*)d(\d+) *(?:([+-]) *(\d+))?/
        guard let match = string.wholeMatch(of: regex) else { return nil }

        let (_, countStr, dieStr, signStr, modifierStr) = match.output
        guard let die = Die(rawValue: Int(dieStr)!) else { return nil }
        self.die = die

        count = !countStr.isEmpty ? Int(countStr)! : 1

        if let signStr, let modifierStr {
            let modifierValue = Int(modifierStr)!
            modifier = signStr == "-" ? -modifierValue : modifierValue
        } else {
            modifier = 0
        }
    }

    /// Returns a random roll of the dice notation.
    /// - Returns: A random value within the range of the dice notation.
    public func roll() -> Int {
        .random(in: range)
    }

    /// Returns a random roll of the dice notation, using the given generator as a source for randomness.
    /// - Parameter generator: The random number generator to use when creating the roll.
    /// - Returns: A random value within the range of the dice notation.
    public func roll<G: RandomNumberGenerator>(using generator: inout G) -> Int {
        .random(in: range, using: &generator)
    }
}
