//
//  Ability+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/7/26.
//

import Foundation

public extension Ability {
    /// Converts between ``Ability`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Ability.strength
        ///     .formatted(.ability(case: .capitalized))
        /// // "Strength"
        ///
        /// Ability.strength
        ///     .formatted(.ability(case: .lowercased))
        /// // "strength"
        ///
        /// Ability.strength
        ///     .formatted(.ability(case: .uppercased))
        /// // "STRENGTH"
        /// ```
        public enum Case: String, CaseIterable, Codable, Sendable {
            case capitalized
            case lowercased
            case uppercased
        }

        /// Width of the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Ability.strength
        ///     .formatted(.ability(width: .standard))
        /// // "Strength"
        ///
        /// Ability.strength
        ///     .formatted(.ability(width: .short))
        /// // "Str"
        /// ```
        public enum Width: String, CaseIterable, Codable, Sendable {
            case standard
            case short
        }

        /// How to capitalize the formatted value.
        public var `case`: Case

        /// Width of the formatted value.
        public var width: Width

        /// The locale of the format style.
        public var locale: Locale

        public init(case: Case = .capitalized, width: Width = .standard, locale: Locale = .autoupdatingCurrent) {
            self.case = `case`
            self.width = width
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Ability) -> String {
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

public extension Ability.FormatStyle {
    /// Converts between ``Ability`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Ability.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Ability) -> AttributedString {
            let rawValue = switch style.width {
            case .standard: value.rawValue
            case .short: String(value.rawValue.prefix(3))
            }

            var attributed = switch style.case {
            case .capitalized: AttributedString(rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(rawValue.lowercased(with: style.locale))
            case .uppercased: AttributedString(rawValue.uppercased(with: style.locale))
            }

            attributed.ability = value
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

public extension FormatStyle where Self == Ability.FormatStyle {
    /// Returns a format style to format an ability.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    ///   - width: Width of the formatted value.
    /// - Returns: Formatted value.
    static func ability(case: Self.Case = .capitalized, width: Self.Width = .standard) -> Self {
        Self(case: `case`, width: width)
    }
}

public extension AbilityModifier {
    /// Converts between ``AbilityModifier`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: AbilityModifier) -> String {
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

public extension AbilityModifier.FormatStyle {
    /// Converts between ``AbilityModifier`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: AbilityModifier.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: AbilityModifier) -> AttributedString {
            var attributed = switch value {
            case let .modifier(modifier):
                modifier.formatted(.number.sign(strategy: .always()).locale(style.locale).attributed)
            case let .special(special):
                AttributedString(special)
            }

            attributed.abilityModifier = value
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

public extension FormatStyle where Self == AbilityModifier.FormatStyle {
    /// Returns a format style to format an ability modifier.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    ///   - width: Width of the formatted value.
    /// - Returns: Formatted value.
    static var abilityModifier: Self {
        Self()
    }
}

public extension AbilityScore {
    /// Converts between ``AbilityScore`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: AbilityScore) -> String {
            String(attributed.format(value).characters)
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var copy = self
            copy.locale = locale
            return copy
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

public extension AbilityScore.FormatStyle {
    /// Converts between ``AbilityScore`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        public private(set) var style: AbilityScore.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: AbilityScore) -> AttributedString {
            var attributed = switch value {
            case let .score(score):
                score.formatted(.number.locale(style.locale).attributed)
            case let .special(special):
                AttributedString(special)
            }

            attributed.abilityScore = value
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

public extension FormatStyle where Self == AbilityScore.FormatStyle {
    /// Returns a format style to format an ability score.
    static var abilityScore: Self {
        Self()
    }
}

public extension Passive {
    /// Converts between ``Passive`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Passive) -> String {
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

public extension Passive.FormatStyle {
    /// Converts between ``Passive`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Passive.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Passive) -> AttributedString {
            var attributed = switch value {
            case let .passive(passive):
                passive.formatted(.number.locale(style.locale).attributed)
            case let .special(special):
                AttributedString(special)
            }

            attributed.passive = value
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

public extension FormatStyle where Self == Passive.FormatStyle {
    /// Returns a format style to format a passive score.
    static var passive: Self {
        Self()
    }
}

public extension Skill {
    /// Converts between ``Skill`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Skill.deception
        ///     .formatted(.skill(case: .capitalized))
        /// // "Deception"
        ///
        /// Skill.deception
        ///     .formatted(.skill(case: .lowercased))
        /// // "deception"
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
        public func format(_ value: Skill) -> String {
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

public extension Skill.FormatStyle {
    /// Converts between ``Skill`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Skill.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Skill) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.skill = value
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

public extension FormatStyle where Self == Skill.FormatStyle {
    /// Returns a format style to format a skill.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func skill(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}
