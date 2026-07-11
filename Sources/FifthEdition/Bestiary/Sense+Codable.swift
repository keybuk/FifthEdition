//
//  Sense+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/19/26.
//

import RegexBuilder

extension Sense: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string tag mapping to the enum.
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = switch value {
        case "B": .blindsight
        case "D": .darkvision
        case "SD": .superiorDarkvision
        case "T": .tremorsense
        case "U": .truesight
        default:
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Could not parse sense: \(value)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        let value = switch self {
        case .blindsight: "B"
        case .darkvision: "D"
        case .superiorDarkvision: "SD"
        case .tremorsense: "T"
        case .truesight: "U"
        }
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

extension Telepathy {
    /// Initialize from the given string.
    /// - Parameter string: The string representation of the telepathic range.
    /// - Returns: The parsed telepathy.
    init(string: String) {
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
            "telepathy"
            OneOrMore(.whitespace)
            Regex {
                rangeRegex
                Optionally {
                    OneOrMore(.whitespace)
                    noteRegex
                }
            }
        }
        .ignoresCase()

        if let match = string.wholeMatch(of: regex) {
            let (_, range, note) = match.output
            self = .telepathy(range: range, note: note.map(String.init))
        } else {
            self = .special(string)
        }
    }

    /// Returns the string representation of the telepathic range.
    var string: String {
        switch self {
        case let .telepathy(range: range, note):
            [
                "telepathy \(range) ft.",
                note,
            ]
            .compactMap(\.self)
            .joined(separator: " ")
        case let .special(special):
            special
        }
    }
}
