//
//  DiceNotation+Parsing.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

import RegexBuilder

public extension DiceNotation {
    /// Creates a new dice notation from the given string.
    /// - Parameter string: The string representation of the dice notation.
    /// - Returns: `nil` if the string does not match the format of a dice notation.
    init?(_ string: String) {
        let signRegex = Regex {
            ZeroOrMore(.whitespace)
            Capture {
                One(CharacterClass.anyOf("+\u{2012}\u{2212}-"))
            } transform: { match in
                match == "+" ? 1 : -1
            }
            ZeroOrMore(.whitespace)
        }

        let diceRegex = Regex {
            Capture {
                ZeroOrMore(.digit)
            } transform: { match in
                !match.isEmpty ? Int(match)! : 1
            }
            "d"
            TryCapture {
                OneOrMore(.digit)
            } transform: { match in
                Die(rawValue: Int(match)!)
            }
        }

        let modifierRegex = Regex {
            Capture {
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
                (_, sign) = match.output
                remainingString = remainingString[match.range.upperBound...]
            } else if dice.isEmpty {
                sign = 1
            } else {
                return nil
            }

            if let match = remainingString.prefixMatch(of: diceRegex) {
                let (_, count, die) = match.output
                dice.append(.die(die, count: sign * count))
                remainingString = remainingString[match.range.upperBound...]
            } else if let match = remainingString.prefixMatch(of: modifierRegex) {
                let (_, modifier) = match.output
                dice.append(.modifier(sign * modifier))
                remainingString = remainingString[match.range.upperBound...]
            } else {
                return nil
            }
        }

        self.init(dice)
    }
}
