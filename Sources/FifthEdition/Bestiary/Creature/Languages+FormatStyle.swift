//
//  Languages+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Languages {
    /// Converts between collections of ``Creature/Languages`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the language.
        public var language: Language.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Language.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            language = style
            self.locale = locale
        }

        public init(case: Language.FormatStyle.Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            language = Language.FormatStyle(case: `case`)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Languages) -> String {
            String(attributed.format(value).characters)
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.locale = locale
            return new
        }

        /// Returns an equivalent attributed format style.
        public var attributed: Attributed {
            Attributed(style: self)
        }
    }

    /// Returns a formatted value.
    func formatted() -> String {
        formatted(FormatStyle())
    }

    /// Returns a value formatted using the specified style.
    func formatted<S: Foundation.FormatStyle>(_ style: S) -> S.FormatOutput where S.FormatInput == Self {
        style.format(self)
    }
}

public extension Creature.Languages.FormatStyle {
    /// Converts between ``Creature/Languages`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Languages.FormatStyle

        /// Formats a count of additional languages spoken or understood.
        /// - Parameters:
        ///   - count: Count of languages.
        ///   - note: Human-readable text accompanying the count.
        ///   - isAdditional: True if these languages are additional.
        /// - Returns: Formatted string.
        private func format(count: Int,
                            note: String? = nil,
                            isPlus: Bool)
            -> AttributedString
        {
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            formatter.locale = style.locale

            let number = formatter.string(from: count as NSNumber) ?? count.formatted(.number)

            var morphology = Morphology()
            morphology.number = count == 1 ? .singular : .plural

            var attributed = if isPlus {
                AttributedString(localized: " plus \(number) other language", locale: style.locale)
            } else {
                AttributedString(localized: "any \(number) language", locale: style.locale)
            }

            attributed.inflect = InflectionRule(morphology: morphology)
            attributed = attributed.inflected(locale: style.locale)

            if let note {
                // FIXME: MARKUP:
                attributed += " "
                attributed += AttributedString(note).formatted(.group().locale(style.locale))
            }

            return attributed
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Languages) -> AttributedString {
            var attributed: AttributedString
            let attributedSpoken = value.spoken
                .sorted()
                .map { language in
                    language.formatted(style.language.locale(style.locale).attributed)
                }

            if let count = value.additionalSpokenCount {
                attributed = attributedSpoken
                    .formatted(.list(type: .and).locale(style.locale))

                attributed += format(count: count,
                                     note: value.additionalSpokenNote,
                                     isPlus: !value.spoken.isEmpty)
            } else {
                attributed = attributedSpoken
                    .formatted(.list(type: .and, width: .narrow).locale(style.locale))
            }

            var attributedUnderstood = value.understood
                .sorted()
                .map { language in
                    language.formatted(style.language.locale(style.locale).attributed)
                }
                .formatted(.list(type: .and).locale(style.locale))

            if let count = value.additionalUnderstoodCount {
                attributedUnderstood += format(count: count,
                                               note: value.additionalUnderstoodNote,
                                               isPlus: !value.understood.isEmpty)
            }

            if !attributedUnderstood.characters.isEmpty {
                if !attributed.characters.isEmpty {
                    attributed += "; "
                }

                attributedUnderstood = if value.spoken.isEmpty {
                    AttributedString(
                        localized: "understands \(attributedUnderstood) but can't speak",
                        locale: style.locale,
                    )
                } else if value.understood.count > 1 || value.additionalUnderstoodCount != nil {
                    AttributedString(
                        localized: "understands \(attributedUnderstood) but can't speak them",
                        locale: style.locale,
                    )
                } else {
                    AttributedString(
                        localized: "understands \(attributedUnderstood) but can't speak it",
                        locale: style.locale,
                    )
                }

                if style.language.case == .capitalized {
                    let idx = attributedUnderstood.characters.startIndex
                    attributedUnderstood.characters.replaceSubrange(
                        idx...idx,
                        with: attributedUnderstood.characters[idx].uppercased(),
                    )
                }

                attributed += attributedUnderstood
            }

            if let telepathy = value.telepathy {
                if !attributed.characters.isEmpty {
                    attributed += "; "
                }

                attributed += telepathy.formatted(.telepathy.locale(style.locale).attributed)
            }

            attributed.creature.languages = value
            return attributed
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.style.locale = locale
            return new
        }
    }
}

public extension FormatStyle where Self == Creature.Languages.FormatStyle {
    static func languages(case: Language.FormatStyle.Case = .capitalized) -> Self {
        Self(style: Language.FormatStyle(case: `case`))
    }
}
