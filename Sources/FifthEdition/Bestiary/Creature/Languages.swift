//
//  Languages.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import RegexBuilder

public extension Creature {
    /// Languages a creature can speak or understand.
    ///
    /// Knowledge of a language means the creature can communicate in it, either or both by speaking it or read ing and
    /// writing it.
    struct Languages: Equatable, Hashable, Sendable {
        /// Languages spoken.
        public var spoken: Set<Language>

        /// Languages understood
        public var understood: Set<Language>

        /// Number of additional languages the creature speaks.
        public var additionalSpokenCount: Int?

        /// Human-readable text concerning ``additionalSpokenCount``.
        public var additionalSpokenNote: String?

        /// Number of additional languages the creature understands.
        public var additionalUnderstoodCount: Int?

        /// Human-readable text concerning ``additionalUnderstoodCount``.
        public var additionalUnderstoodNote: String?

        /// Range of telepathy, if capable.
        public var telepathy: Telepathy?

        /// Initialize from number of languages.
        /// - Parameters:
        ///   - spoken: Number of languages spoken.
        ///   - understood: Number of languages understood.
        ///   - telepathy: Range of telepathy, if capable.
        public init(spoken: Int? = nil,
                    understood: Int? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = []
            additionalSpokenCount = spoken
            self.understood = []
            additionalUnderstoodCount = understood
            self.telepathy = telepathy
        }

        /// Initialize from spoken languages.
        /// - Parameters:
        ///   - spoken: Languages spoken.
        ///   - additionalSpokenCount: Number of additional languages spoken.
        ///   - additionalSpokenNote: Human-readable text concerning `additionalSpokenCount`.
        ///   - understood: Number of languages understood.
        ///   - telepathy: Range of telepathy, if capable.
        public init(_ spoken: Set<Language>,
                    plus additionalSpokenCount: Int? = nil,
                    note additionalSpokenNote: String? = nil,
                    understood: Int? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = spoken
            self.additionalSpokenCount = additionalSpokenCount
            self.additionalSpokenNote = additionalSpokenNote
            self.understood = []
            additionalUnderstoodCount = understood
            self.telepathy = telepathy
        }

        /// Initialize from understood languages.
        /// - Parameters:
        ///   - spoken: Number of languages spoken.
        ///   - understood: Languages understood.
        ///   - additionalUnderstoodCount: Number of additional languages understood.
        ///   - additionalUnderstoodNote: Human-readable text concerning `additionalUnderstoodCount`.
        ///   - telepathy: Range of telepathy, if capable.
        public init(spoken: Int? = nil,
                    understood: Set<Language>,
                    plus additionalUnderstoodCount: Int? = nil,
                    note additionalUnderstoodNote: String? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = []
            additionalSpokenCount = spoken
            self.understood = understood
            self.additionalUnderstoodCount = additionalUnderstoodCount
            self.additionalUnderstoodNote = additionalUnderstoodNote
            self.telepathy = telepathy
        }

        /// Initialize from understood languages.
        /// - Parameters:
        ///   - spoken: Languags spoken.
        ///   - understood: Languages understood.
        ///   - additionalUnderstoodCount: Number of additional languages understood.
        ///   - additionalUnderstoodNote: Human-readable text concerning `additionalUnderstoodCount`.
        ///   - telepathy: Range of telepathy, if capable..
        public init(_ spoken: Set<Language>,
                    understood: Set<Language>,
                    plus additionalUnderstoodCount: Int? = nil,
                    note additionalUnderstoodNote: String? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = spoken
            self.understood = understood
            self.additionalUnderstoodCount = additionalUnderstoodCount
            self.additionalUnderstoodNote = additionalUnderstoodNote
            self.telepathy = telepathy
        }

        /// Initialize from spoken and understood languages.
        /// - Parameters:
        ///   - spoken: Languages spoken.
        ///   - additionalSpokenCount: Number of additional languages spoken.
        ///   - additionalSpokenNote: Human-readable text concerning `additionalSpokenCount`.
        ///   - understood: Languages understood.
        ///   - additionalUnderstoodCount: Number of additional languages understood.
        ///   - additionalUnderstoodNote: Human-readable text concerning `additionalUnderstoodCount`.
        ///   - telepathy: Range of telepathy, if capable..
        public init(_ spoken: Set<Language>,
                    plus additionalSpokenCount: Int? = nil,
                    note additionalSpokenNote: String? = nil,
                    understood: Set<Language>,
                    plus additionalUnderstoodCount: Int? = nil,
                    note additionalUnderstoodNote: String? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = spoken
            self.additionalSpokenCount = additionalSpokenCount
            self.additionalSpokenNote = additionalSpokenNote
            self.understood = understood
            self.additionalUnderstoodCount = additionalUnderstoodCount
            self.additionalUnderstoodNote = additionalUnderstoodNote
            self.telepathy = telepathy
        }
    }
}

extension Creature.Languages: ExpressibleByArrayLiteral {
    /// Initialize ``spoken`` from an array literal.
    public init(arrayLiteral elements: Language...) {
        self.init(Set(elements))
    }
}

extension Creature.Languages {
    /// Parse languages field from array of strings.
    /// - Parameter strings: Strings of desconstructed field.
    init(strings: [String]) {
        // This goes well beyond 5etools parsing, which treats languages as a list of strings to be joined by commas.
        let languageReference = RegexBuilder.Reference(Language?.self)
        let languageRegex = Regex {
            TryCapture(as: languageReference) {
                OneOrMore(.reluctant) {
                    .anyNonNewline.subtracting(.anyOf("("))
                }
                // Matching "(...)" part separately prevents the reluctant capture stopping at "and" inside them.
                Optionally {
                    "("
                    OneOrMore(.anyOf(")").inverted)
                    ")"
                }
            } transform: { match in
                Language(rawValue: match.lowercased())
            }
        }

        let languageListReference = RegexBuilder.Reference([Language].self)
        let languageListRegex = Regex {
            languageRegex
            ChoiceOf {
                Regex {
                    Optionally {
                        ","
                    }
                    OneOrMore(.whitespace)
                    "and"
                    OneOrMore(.whitespace)
                }
                Regex {
                    ","
                    OneOrMore(.whitespace)
                }
            }
        }
        .ignoresCase()

        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut

        let additionalCountReference = RegexBuilder.Reference(Int?.self)
        let additionalNoteReference = RegexBuilder.Reference(String?.self)
        let additionalRegex = Regex {
            ChoiceOf {
                "any"
                "plus any"
                "plus"
            }
            OneOrMore(.whitespace)
            TryCapture(as: additionalCountReference) {
                OneOrMore(.word)
            } transform: { match in
                formatter.number(from: match.lowercased()) as? Int
            }
            Optionally {
                OneOrMore(.whitespace)
                ChoiceOf {
                    "more"
                    "other"
                }
            }
            Optionally {
                OneOrMore(.whitespace)
                ChoiceOf {
                    "languages"
                    "language"
                }
            }
            Optionally {
                OneOrMore(.whitespace)
                "of your choice"
            }
            Optionally {
                OneOrMore(.whitespace)
                "("
                Capture(as: additionalNoteReference) {
                    OneOrMore(.anyOf(")").inverted)
                } transform: { match in
                    String(match)
                }
                ")"
            }
        }
        .ignoresCase()

        let telepathyReference = RegexBuilder.Reference(Telepathy.self)
        let telepathyRegex = Regex {
            Capture(as: telepathyReference) {
                "telepathy"
                OneOrMore(.whitespace)
                OneOrMore(.anyNonNewline)
            } transform: { match in
                Telepathy(string: String(match))
            }
        }
        .ignoresCase()

        let understoodBeginReference = RegexBuilder.Reference(Bool?.self)
        let understoodBeginRegex = Regex {
            Capture(as: understoodBeginReference) {
                "understands"
            } transform: { _ in true }
        }
        .ignoresCase()

        let understoodEndReference = RegexBuilder.Reference(Bool?.self)
        let understoodEndRegex = Regex {
            Capture(as: understoodEndReference) {
                "but"
                OneOrMore(.whitespace)
                ChoiceOf {
                    "can't"
                    "cannot"
                    "doesn't"
                }
                OneOrMore(.whitespace)
                "speak"
                Optionally {
                    OneOrMore(.whitespace)
                    ChoiceOf {
                        "it"
                        "them"
                    }
                }
            } transform: { _ in true }
        }
        .ignoresCase()

        let regex = Regex {
            Optionally {
                ChoiceOf {
                    understoodBeginRegex
                    "and"
                }
                OneOrMore(.whitespace)
            }
            Capture(as: languageListReference) {
                ZeroOrMore {
                    languageListRegex
                }
            } transform: { match in
                match.matches(of: languageListRegex)
                    .map { $0[languageReference]! }
            }
            ChoiceOf {
                additionalRegex
                Regex {
                    languageRegex
                    Optionally {
                        OneOrMore(.whitespace)
                        additionalRegex
                    }
                }
            }
            Optionally {
                OneOrMore(.whitespace)
                understoodEndRegex
            }
        }

        let stringParts = strings
            .flatMap {
                $0.split(separator: ";")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            }

        spoken = []
        understood = []
        var inUnderstood = false

        for string in stringParts {
            if let match = string.wholeMatch(of: telepathyRegex) {
                telepathy = match[telepathyReference]
            } else if let match = string.wholeMatch(of: regex) {
                var languages = match[languageListReference]
                if let language = match[languageReference] {
                    languages.append(language)
                }

                let count = (match.output.4 ?? nil) ?? match[additionalCountReference]
                let note = (match.output.5 ?? nil) ?? match[additionalNoteReference]

                if match[understoodBeginReference] == true {
                    inUnderstood = true
                }

                if inUnderstood {
                    understood.formUnion(languages)
                    if let count {
                        additionalUnderstoodCount = count
                    }
                    if let note {
                        additionalUnderstoodNote = note
                    }
                } else {
                    spoken.formUnion(languages)
                    if let count {
                        additionalSpokenCount = count
                    }
                    if let note {
                        additionalSpokenNote = note
                    }
                }

                if match[understoodEndReference] == true {
                    // Some monsters are missing the "understands..." prefix, so move spoken to understood.
                    if !inUnderstood {
                        understood.formUnion(spoken)
                        spoken.removeAll()

                        additionalUnderstoodCount = additionalSpokenCount
                        additionalSpokenCount = nil

                        additionalUnderstoodNote = additionalSpokenNote
                        additionalSpokenNote = nil
                    }
                    inUnderstood = false
                }
            } else {
                let language = Language(rawValue: string)
                if inUnderstood {
                    understood.insert(language)
                } else {
                    spoken.insert(language)
                }
            }
        }
    }

    /// Returns the deconstructed strings of the language set.
    var strings: [String] {
        var strings = spoken
            .sorted()
            .map(\.rawValue.capitalized)

        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut

        if let count = additionalSpokenCount {
            let number = formatter.string(from: count as NSNumber) ?? count.formatted(.number)

            let note = if let additionalSpokenNote {
                " (\(additionalSpokenNote))"
            } else {
                ""
            }

            if !strings.isEmpty {
                strings.append(strings.removeLast()
                    + " plus \(number) other \(count > 1 ? "languages" : "language")\(note)")
            } else {
                strings.append("any \(number) \(count > 1 ? "languages" : "language")\(note)")
            }
        }

        var understoodStrings = understood
            .sorted()
            .map(\.rawValue.capitalized)

        if let count = additionalUnderstoodCount {
            let number = formatter.string(from: count as NSNumber) ?? count.formatted(.number)

            let note = if let additionalUnderstoodNote {
                " (\(additionalUnderstoodNote))"
            } else {
                ""
            }

            if !understoodStrings.isEmpty {
                understoodStrings.append(understoodStrings.removeLast()
                    + " plus \(number) other \(count > 1 ? "languages" : "language")\(note)")
            } else {
                understoodStrings.append("any \(number) \(count > 1 ? "languages" : "language")\(note)")
            }
        }

        let pronoun = !spoken.isEmpty
            ? (understoodStrings.count > 1 || additionalUnderstoodCount != nil ? " them" : " it")
            : ""

        if understoodStrings.count == 1 {
            understoodStrings = [
                "understands \(understoodStrings[0]) but can't speak\(pronoun)",
            ]
        } else if understoodStrings.count == 2 {
            understoodStrings = [
                "understands \(understoodStrings[0]) and \(understoodStrings[1]) but can't speak\(pronoun)",
            ]
        } else if understoodStrings.count > 2 {
            understoodStrings.insert("understands \(understoodStrings.removeFirst())", at: 0)
            understoodStrings
                .append("and \(understoodStrings.removeLast()) but can't speak\(pronoun)")
        }

        if !strings.isEmpty, !understoodStrings.isEmpty {
            strings.append(strings.removeLast() + "; " + understoodStrings.removeFirst())
        }

        strings.append(contentsOf: understoodStrings)

        if let telepathy {
            let telepathyString = switch telepathy {
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

            if !strings.isEmpty {
                strings.append(strings.removeLast() + "; \(telepathyString)")
            } else {
                strings.append("\(telepathyString)")
            }
        }

        return strings
    }
}

public extension Creature.Languages {
    var isEmpty: Bool {
        spoken.isEmpty && understood.isEmpty && telepathy == nil
    }
}
