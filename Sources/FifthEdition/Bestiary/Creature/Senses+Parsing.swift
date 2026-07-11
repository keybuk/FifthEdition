//
//  Senses+Parsing.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 10/9/26.
//

import RegexBuilder

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

    /// Returns the string representation of the sense.
    var string: String {
        switch self {
        case let .sense(sense, range, note):
            [
                "\(sense.rawValue) \(range) ft.",
                note,
            ]
            .compactMap(\.self)
            .joined(separator: " ")
        case let .special(special):
            special
        }
    }
}
