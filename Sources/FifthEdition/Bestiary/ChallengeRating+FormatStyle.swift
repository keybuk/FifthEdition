//
//  ChallengeRating+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/7/26.
//

import Foundation

public extension ChallengeRating {
    /// Converts between ``ChallengeRating`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: ChallengeRating) -> String {
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

public extension ChallengeRating.FormatStyle {
    /// Converts between ``ChallengeRating`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: ChallengeRating.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: ChallengeRating) -> AttributedString {
            var attributed = switch value {
            case .cr(1 / 8):
                AttributedString(localized: "1/8", locale: style.locale)
            case .cr(1 / 4):
                AttributedString(localized: "1/4", locale: style.locale)
            case .cr(1 / 2):
                AttributedString(localized: "1/2", locale: style.locale)
            case let .cr(cr):
                Int(cr).formatted(.number.locale(style.locale).attributed)
            case let .special(special):
                AttributedString(special)
            }

            attributed.challengeRating = value
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

public extension FormatStyle where Self == ChallengeRating.FormatStyle {
    /// Returns a format style to format a challenge rating.
    static var challengeRating: Self {
        ChallengeRating.FormatStyle()
    }
}

public extension ExperiencePoints {
    /// Converts between ``ExperiencePoints`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: ExperiencePoints) -> String {
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

public extension ExperiencePoints.FormatStyle {
    /// Converts between ``ExperiencePoints`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: ExperiencePoints.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: ExperiencePoints) -> AttributedString {
            var attributed = switch value {
            case let .xp(xp):
                xp.formatted(.number.locale(style.locale).attributed)
            }

            attributed.experiencePoints = value
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

public extension FormatStyle where Self == ExperiencePoints.FormatStyle {
    /// Returns a format style to format experience points.
    static var experiencePoints: Self {
        Self()
    }
}

public extension ProficiencyBonus {
    /// Converts between ``ProficiencyBonus`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: ProficiencyBonus) -> String {
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

public extension ProficiencyBonus.FormatStyle {
    /// Converts between ``ProficiencyBonus`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: ProficiencyBonus.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: ProficiencyBonus) -> AttributedString {
            var attributed = switch value {
            case let .bonus(bonus):
                bonus.formatted(.number.sign(strategy: .always()).locale(style.locale).attributed)
            case let .special(special):
                AttributedString(special)
            }

            attributed.proficiencyBonus = value
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

public extension FormatStyle where Self == ProficiencyBonus.FormatStyle {
    /// Returns a format style to format a proficiency bonus.
    static var proficiencyBonus: Self {
        Self()
    }
}
