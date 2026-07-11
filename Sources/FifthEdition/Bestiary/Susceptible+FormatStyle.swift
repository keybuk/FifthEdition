//
//  Susceptible+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/7/26.
//

import Algorithms
import Foundation

public extension Condition {
    /// Converts between ``Condition`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Condition.blinded
        ///     .formatted(.condition(case: .capitalized))
        /// // "Blinded"
        ///
        /// Condition.blinded
        ///     .formatted(.condition(case: .lowercased))
        /// // "blinded"
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
        public func format(_ value: Condition) -> String {
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

public extension Condition.FormatStyle {
    /// Converts between ``Condition`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        public private(set) var style: Condition.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Condition) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.condition = value
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

public extension FormatStyle where Self == Condition.FormatStyle {
    /// Returns a format style to format a condition.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func condition(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Susceptible {
    /// Converts between ``Susceptible`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Susceptible.condition(.blinded)
        ///     .formatted(.susceptible(case: .capitalized))
        /// // "BLINDED"
        ///
        /// Susceptible.condition(.blinded)
        ///     .formatted(.susceptible(case: .lowercased))
        /// // "blinded"
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
        public func format(_ value: Susceptible) -> String {
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

        /// Returns the matching style for formatting ``Condition``.
        fileprivate var condition: Condition.FormatStyle {
            switch `case` {
            case .capitalized: .condition(case: .capitalized)
            case .lowercased: .condition(case: .lowercased)
            }
        }

        /// Returns the matching style for formatting ``Damage``.
        fileprivate var damage: Damage.FormatStyle {
            switch `case` {
            case .capitalized: .damage(case: .capitalized)
            case .lowercased: .damage(case: .lowercased)
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

public extension Susceptible.FormatStyle {
    /// Converts between ``Susceptible`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Susceptible.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Susceptible) -> AttributedString {
            var attributed: AttributedString
            switch value {
            case let .condition(condition):
                attributed = condition.formatted(style.condition.locale(style.locale).attributed)
            case let .damage(damage):
                attributed = damage.formatted(style.damage.locale(style.locale).attributed)
            case let .susceptible(susceptible, preNote, note, isConditional):
                attributed = susceptible.formatted(
                    .susceptibles(memberStyle: style, width: isConditional ? .standard : .narrow)
                        .locale(style.locale).attributed,
                )

                if let preNote {
                    // FIXME: MARKUP
                    attributed = AttributedString(preNote) + " " + attributed
                }

                if let note {
                    // FIXME: MARKUP
                    attributed += " "
                    attributed += AttributedString(note)
                }
            case let .special(special):
                // FIXME: MARKUP
                attributed = AttributedString(special)
            }

            attributed.susceptible = value
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

public extension FormatStyle where Self == Susceptible.FormatStyle {
    /// Returns a format style to format a susceptibility.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func susceptible(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Susceptible {
    /// Converts between collections of ``Susceptible`` values and their textual representations.
    struct ListFormatStyle<Base: Collection>: Foundation.FormatStyle, Sendable
        where Base.Element == Susceptible
    {
        /// Format style to use for values.
        private(set) var memberStyle: Susceptible.FormatStyle

        typealias Width = Foundation.ListFormatStyle<Foundation.StringStyle, [String]>.Width

        /// The size of the list.
        fileprivate var width: Width

        /// The locale of the format style.
        public var locale: Locale

        fileprivate init(memberStyle: Susceptible.FormatStyle,
                         width: Width = .narrow,
                         locale: Locale = .autoupdatingCurrent)
        {
            self.memberStyle = memberStyle
            self.width = width
            self.locale = locale
        }

        public init(memberStyle: Susceptible.FormatStyle,
                    locale: Locale = .autoupdatingCurrent)
        {
            self.memberStyle = memberStyle
            width = .narrow
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Base) -> String {
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
}

public extension Susceptible.ListFormatStyle {
    /// Converts between lists of ``Susceptible`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Susceptible.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            value
                .sorted()
                .chunked { a, b in
                    switch (a, b) {
                    case (.condition, .condition): true
                    case (.damage, .damage): true
                    case (.susceptible, .susceptible): false
                    case (.special, .special): false
                    default: false
                    }
                }
                .map { susceptible in
                    susceptible
                        .map { susceptible in
                            susceptible.formatted(style.memberStyle.locale(style.locale).attributed)
                        }
                        .formatted(.list(type: .and, width: style.width).locale(style.locale))
                }
                .reduce(into: AttributedString()) { partialResult, attributedSusceptible in
                    if !partialResult.characters.isEmpty {
                        partialResult += AttributedString(localized: "; ", locale: style.locale)
                    }
                    partialResult += attributedSusceptible
                }
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.style = style.locale(locale)
            return new
        }
    }
}

public extension FormatStyle {
    /// Returns a format style to format collections of susceptibilities.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    ///   - width: The size of the list.
    /// - Returns: Format style.
    fileprivate static func susceptibles<Base>(memberStyle: Susceptible.FormatStyle,
                                               width: Self.Width = .narrow)
        -> Self
        where Self == Susceptible.ListFormatStyle<Base>
    {
        Self(memberStyle: memberStyle, width: width)
    }

    /// Returns a format style to format collections of susceptibilities.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func susceptibles<Base>(memberStyle: Susceptible.FormatStyle) -> Self
        where Self == Susceptible.ListFormatStyle<Base>
    {
        Self(memberStyle: memberStyle)
    }

    /// Returns a format style to format collections of susceptibilities.
    /// - Parameters:
    ///   - case: How to capitalize the formatted condition or damage type.
    /// - Returns: Format style.
    static func susceptibles<Base>(case: Susceptible.FormatStyle.Case = .capitalized) -> Self
        where Self == Susceptible.ListFormatStyle<Base>
    {
        Self(memberStyle: Susceptible.FormatStyle(case: `case`))
    }
}

public extension Damage {
    /// Converts between ``Damage`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Damage.necrotic
        ///     .formatted(.damage(case: .capitalized))
        /// // "Necrotic"
        ///
        /// Damage.necrotic
        ///     .formatted(.damage(case: .lowercased))
        /// // "necrotic"
        /// ```
        public enum Case: String, CaseIterable, Codable, Sendable {
            case capitalized
            case lowercased
        }

        /// How to capitalize the formatted value.
        public var `case`: Case

        /// Width of the formatted value.
        public var locale: Locale

        public init(case: Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            self.case = `case`
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Damage) -> String {
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

public extension Damage.FormatStyle {
    /// Converts between ``Damage`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Damage.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Damage) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.damage = value
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

public extension FormatStyle where Self == Damage.FormatStyle {
    /// Returns a format style to format a damage type.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func damage(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}
