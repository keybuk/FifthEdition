//
//  Alignments+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Alignment {
    /// Converts between ``Creature/Alignment`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Creature.Alignment.alignment([chaoticGood], chance: 25)
        ///     .formatted(.alignment(case: .capitalized))
        /// // "Chaotic Good (25%)"
        ///
        /// Creature.Alignment.alignment([chaoticGood], chance: 25)
        ///     .formatted(.alignment(case: .lowercased))
        /// // "chaotic good (25%)"
        /// ```
        public enum Case: String, CaseIterable, Codable, Sendable {
            case capitalized
            case lowercased
        }

        /// How to capitalize the formatted value.
        public var `case`: Case

        /// The locale of the format style.
        public var locale: Locale

        public init(case: Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            self.case = `case`
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Alignment) -> String {
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

        /// Returns the matching style for formatting ``Alignment``.
        fileprivate var alignment: Alignment.FormatStyle {
            switch `case` {
            case .capitalized: .alignment(case: .capitalized)
            case .lowercased: .alignment(case: .lowercased)
            }
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

public extension Creature.Alignment.FormatStyle {
    /// Converts between ``Creature/Alignment`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Alignment.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Alignment) -> AttributedString {
            var attributed: AttributedString
            switch value {
            case let .alignment(alignment, chance, note):
                attributed = alignment
                    .formatted(.alignments(memberStyle: style.alignment).locale(style.locale).attributed)

                if let chance {
                    attributed += " "
                    attributed += chance.formatted(.group(style: .percent.locale(style.locale).attributed))
                }

                if let note {
                    let note = switch style.case {
                    case .capitalized: AttributedString(note.capitalized(with: style.locale))
                    case .lowercased: AttributedString(note.lowercased(with: style.locale))
                    }

                    attributed += " "
                    attributed += note.formatted(.group().locale(style.locale))
                }
            case let .special(special):
                attributed = switch style.case {
                case .capitalized: AttributedString(special.capitalized(with: style.locale))
                case .lowercased: AttributedString(special.lowercased(with: style.locale))
                }
            }

            attributed.creature.alignment = value
            return attributed
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.style = style.locale(locale)
            return new
        }
    }
}

public extension FormatStyle where Self == Creature.Alignment.FormatStyle {
    /// Returns a format style to format a creature's alignment.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func alignment(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Creature.Alignments {
    /// Converts between ``Creature/Alignments`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// [
        ///     .alignment([chaoticGood], chance: 25)
        ///     .alignment([chaoticEvil], chance: 75)
        /// ]
        /// .formatted(.alignments(case: .capitalized))
        /// // "Chaotic Good (25%) or Chaotic Evil (25%)"
        ///
        /// [
        ///     .alignment([chaoticGood], chance: 25)
        ///     .alignment([chaoticEvil], chance: 75)
        /// ]
        /// .formatted(.alignments(case: .lowercased))
        /// // "chaotic good (25%) or chaotic evil (25%)"
        /// ```
        public enum Case: String, CaseIterable, Codable, Sendable {
            case capitalized
            case lowercased
        }

        /// How to capitalize the formatted value.
        public var `case`: Case

        /// The locale of the format style.
        public var locale: Locale

        public init(case: Case = .capitalized,
                    locale: Locale = .autoupdatingCurrent)
        {
            self.case = `case`
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Alignments) -> String {
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

        /// Returns the matching style for formatting ``Alignment``.
        fileprivate var alignment: Creature.Alignment.FormatStyle {
            switch `case` {
            case .capitalized: .alignment(case: .capitalized)
            case .lowercased: .alignment(case: .lowercased)
            }
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

public extension Creature.Alignments.FormatStyle {
    /// Converts between ``Creature/Alignments`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Alignments.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Alignments) -> AttributedString {
            var attributed = value.alignments
                .formatted(.list(memberStyle: style.alignment.attributed, type: .or).locale(style.locale))

            if let prefix = value.prefix {
                attributed = switch style.case {
                case .capitalized: AttributedString(prefix.capitalized(with: style.locale)) + attributed
                case .lowercased: AttributedString(prefix.lowercased(with: style.locale)) + attributed
                }
            }

            attributed.creature.alignments = value
            return attributed
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.style = style.locale(locale)
            return new
        }
    }
}

public extension FormatStyle where Self == Creature.Alignments.FormatStyle {
    /// Returns a format style to format a creature's alignments.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func alignments(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}
