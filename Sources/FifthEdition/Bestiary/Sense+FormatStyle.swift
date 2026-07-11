//
//  Sense+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/19/26.
//

import Foundation

public extension Language {
    /// Converts between ``Language`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Language.theivesCant
        ///     .formatted(.language(case: .capitalized))
        /// // "Thieves' Cant"
        ///
        /// Language.theivesCant
        ///     .formatted(.language(case: .lowercased))
        /// // "thieves' cant"
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
        public func format(_ value: Language) -> String {
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

public extension Language.FormatStyle {
    /// Converts between ``Language`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Language.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Language) -> AttributedString {
            var attributed = switch value {
            case .other: AttributedString(value.rawValue)
            default:
                switch style.case {
                case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
                case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
                }
            }

            attributed.language = value
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

public extension FormatStyle where Self == Language.FormatStyle {
    /// Returns a format style to format a language.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func language(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Sense {
    /// Converts between ``Sense`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Sense.darkvision
        ///     .formatted(.sense(case: .capitalized))
        /// // "Darkvision"
        ///
        /// Sense.darkvision
        ///     .formatted(.sense(case: .lowercased))
        /// // "darkvision"
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
        public func format(_ value: Sense) -> String {
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

public extension Sense.FormatStyle {
    /// Converts between ``Sense`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Sense.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Sense) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.sense = value
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

public extension FormatStyle where Self == Sense.FormatStyle {
    /// Returns a format style to format a sense.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func sense(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Telepathy {
    /// Converts between ``Telepathy`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Telepathy) -> String {
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

public extension Telepathy.FormatStyle {
    /// Converts between ``Telepathy`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Telepathy.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Telepathy) -> AttributedString {
            var attributed: AttributedString
            switch value {
            case let .telepathy(range, note):
                attributed = AttributedString(localized: "telepathy \(range, format: .number.attributed) ft.",
                                              locale: style.locale)

                if let note {
                    attributed += " "
                    attributed += AttributedString(note)
                }
            case let .special(special):
                attributed = AttributedString(special)
            }

            attributed.telepathy = value
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

public extension FormatStyle where Self == Telepathy.FormatStyle {
    /// Returns a format style to format telepathy.
    static var telepathy: Self {
        Self()
    }
}
