//
//  DiceNotation.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

/// Dice notation.
///
/// Encodes the notation of a number of dice to be rolled, and a modifier added or subtracted, e.g. `"2d6 + 4"`.
public struct DiceNotation: Equatable, Hashable, Sendable {
    /// Die to be rolled.
    public let die: Die

    /// Number of dice to be rolled.
    public let count: Int

    /// Modifier to be added or subtracted from the rolled total.
    public let modifier: Int

    /// Creates a new dice notation.
    /// - Parameters:
    ///   - die: The die to roll.
    ///   - count: Number of `die` to roll.
    ///   - modifier: Modifier to add or subtract from the rolled total.
    public init(_ die: Die, count: Int = 1, modifier: Int = 0) {
        self.die = die
        self.count = count
        self.modifier = modifier
    }
}

public extension DiceNotation {
    /// The average roll this notation yields.
    var average: Int {
        (count * (die.rawValue + 1)) / 2 + modifier
    }

    /// The range of possible rolls this notation yields.
    var range: ClosedRange<Int> {
        (count + modifier)...(count * die.rawValue + modifier)
    }

    /// Returns a random roll of the dice notation.
    /// - Returns: A random value within the range of the dice notation.
    func roll() -> Int {
        .random(in: range)
    }

    /// Returns a random roll of the dice notation, using the given generator as a source for randomness.
    /// - Parameter generator: The random number generator to use when creating the roll.
    /// - Returns: A random value within the range of the dice notation.
    func roll(using generator: inout some RandomNumberGenerator) -> Int {
        .random(in: range, using: &generator)
    }
}

extension DiceNotation: CustomStringConvertible {
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

    /// The dice notation described including its average.
    public var description: String {
        "\(average) (\(stringValue))"
    }

    /// The dice notation expressed as a human readable string.
    public var stringValue: String {
        let rolledString = "\(count)\(die)"

        switch modifier {
        case 1...: return "\(rolledString) + \(modifier)"
        case ..<0: return "\(rolledString) - \(abs(modifier))"
        default: return rolledString
        }
    }
}
