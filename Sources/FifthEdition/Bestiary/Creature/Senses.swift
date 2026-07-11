//
//  Senses.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import RegexBuilder

public extension Creature {
    /// Creature's senses.
    ///
    /// Some creatures have special senses that help them perceive things in certain situations, given in the associated
    /// values of ``sense(_:range:note:)`` where `range` provides the range of the sense in feet and `note` provides
    /// additional optional human-readable text.
    ///
    /// Special rules are given as human-readable text in the associated value of ``special(_:)``.
    enum Sense: Equatable, Hashable, Sendable {
        case sense(FifthEdition.Sense, range: Int, note: String? = nil)
        case special(String)
    }
}

extension Creature.Sense {
    /// Initialize from the given string.
    /// - Parameter string: The string representation of the sense.
    /// - Returns: The parsed sense.
    init(string: String) {
        let senseRegex = Regex {
            TryCapture {
                OneOrMore(.word)
            } transform: { match in
                Sense(rawValue: String(match).lowercased())
            }
        }

        let rangeRegex = Regex {
            Capture {
                OneOrMore(.digit)
            } transform: { match in
                Int(match)!
            }
            ChoiceOf {
                Regex {
                    ZeroOrMore(.whitespace)
                    ChoiceOf {
                        "ft."
                        "ft"
                        "feet"
                    }
                }
                Anchor.endOfSubject
            }
        }
        .ignoresCase()

        let noteRegex = Regex {
            Capture {
                OneOrMore(.anyNonNewline)
            }
        }

        let regex = Regex {
            senseRegex
            ZeroOrMore(.whitespace)
            rangeRegex
            Optionally {
                OneOrMore(.whitespace)
                noteRegex
            }
        }

        if let match = string.wholeMatch(of: regex) {
            let (_, sense, range, note) = match.output
            self = .sense(sense, range: range, note: note.map(String.init))
        } else {
            self = .special(string)
        }
    }
}

extension Creature.Sense: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.sense(lhsSense, _, _), .sense(rhsSense, _, _)):
            lhsSense.rawValue < rhsSense.rawValue
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}
