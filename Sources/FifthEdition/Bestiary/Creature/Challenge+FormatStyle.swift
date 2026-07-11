//
//  Challenge+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Challenge {
    /// Converts between ``Creature/Challenge`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to combine the formatted values.
        ///
        /// For example:
        /// ```swift
        /// Challenge(.cr(5), lair: .xp(2300))
        ///     .formatted(.challenge(detail: .compact))
        /// // "5 (XP 1,800 or 2,300 in lair); PB +3"
        ///
        /// Challenge(.cr(5), lair: .cr(6))
        ///     .formatted(.challenge(detail: .expanded))
        /// // "5 (1,800 XP) or 6 (2,300 XP) when encountered in lair"
        /// ```
        public enum Detail: String, CaseIterable, Codable, Sendable {
            case compact
            case expanded
        }

        /// How to combine the formatted values.
        public var detail: Detail

        /// The locale of the format style.
        public var locale: Locale

        public init(detail: Detail = .compact, locale: Locale = .autoupdatingCurrent) {
            self.detail = detail
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Challenge) -> String {
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

        /// Returns the matching style for formatting ``Creature/Challenge/Encounter``.
        fileprivate var encounter: Encounter.FormatStyle {
            switch detail {
            case .compact: .challengeEncounter(width: .narrow)
            case .expanded: .challengeEncounter(width: .wide)
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

public extension Creature.Challenge.FormatStyle {
    /// Converts between ``Creature/Challenge`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Challenge.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Challenge) -> AttributedString {
            var attributed: AttributedString
            switch style.detail {
            case .compact:
                attributed = if let challengeRating = value.encounter?.challengeRating {
                    challengeRating.formatted(.challengeRating.locale(style.locale).attributed)
                } else {
                    AttributedString(localized: "None", locale: style.locale)
                }

                let encounterXP = value.encounter.flatMap(ExperiencePoints.init) ?? 0
                let xpPart = [
                    AttributedString(localized: "XP \(encounterXP, format: .experiencePoints.attributed)",
                                     locale: style.locale),
                    value.lair.map { xp in
                        AttributedString(
                            localized: "\(xp, format: style.encounter.attributed) in lair",
                            locale: style.locale,
                        )
                    },
                    value.coven
                        .map { xp in
                            AttributedString(
                                localized: "\(xp, format: style.encounter.attributed) when part of a coven",
                                locale: style.locale,
                            )
                        },
                ]
                .compactMap(\.self)
                .formatted(.list(type: .or).locale(style.locale))

                let pbPart = if let proficiencyBonus = value.proficiencyBonus ?? value.encounter
                    .flatMap(ProficiencyBonus.init)
                {
                    AttributedString(localized: "; PB \(proficiencyBonus, format: .proficiencyBonus.attributed)",
                                     locale: style.locale)
                } else {
                    AttributedString()
                }

                attributed += AttributedString(localized: " (\(xpPart)\(pbPart))", locale: style.locale)
            case .expanded:
                attributed = [
                    value.encounter
                        .map { cr in
                            AttributedString(
                                localized: "\(cr, format: style.encounter.attributed)",
                                locale: style.locale,
                            )
                        },
                    value.lair
                        .map { cr in
                            AttributedString(
                                localized: "\(cr, format: style.encounter.attributed) when encountered in lair",
                                locale: style.locale,
                            )
                        },
                    value.coven
                        .map { cr in
                            AttributedString(
                                localized: "\(cr, format: style.encounter.attributed) when part of a coven",
                                locale: style.locale,
                            )
                        },
                ]
                .compactMap(\.self)
                .formatted(.list(type: .or).locale(style.locale))
            }

            attributed.creature.challenge = value
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

public extension FormatStyle where Self == Creature.Challenge.FormatStyle {
    /// Returns a format style to format a challenge.
    ///
    /// - Parameters:
    ///   - detail: How to combine the formatted values.
    /// - Returns: Formatted value.
    static func challenge(detail: Self.Detail = .compact) -> Self {
        Self(detail: detail)
    }
}

public extension Creature.Challenge.Encounter {
    /// Converts between ``Creature/Challenge/Encounter`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// Width of the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Challenge.Encounter(challengeRating: 5)
        ///     .formatted(.challengeEncounter(width: .narrow))
        /// // "1,800"
        ///
        /// Challenge.Encounter(challengeRating: 5)
        ///     .formatted(.challengeEncounter(width: .wide))
        /// // "5 (1,800 XP)"
        /// ```
        public enum Width: String, CaseIterable, Codable, Sendable {
            case narrow
            case wide
        }

        /// Width of the formatted value.
        public var width: Width

        /// The locale of the format style.
        public var locale: Locale

        public init(width: Width = .narrow, locale: Locale = .autoupdatingCurrent) {
            self.width = width
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Challenge.Encounter) -> String {
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

public extension Creature.Challenge.Encounter.FormatStyle {
    /// Converts between ``Creature/Challenge/Encounter`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Challenge.Encounter.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Challenge.Encounter) -> AttributedString {
            var attributed: AttributedString
            if style.width == .narrow, let experiencePoints = ExperiencePoints(value) {
                attributed = experiencePoints.formatted(.experiencePoints.locale(style.locale).attributed)
            } else {
                if let challengeRating = value.challengeRating {
                    attributed = challengeRating.formatted(.challengeRating.locale(style.locale).attributed)
                } else {
                    attributed = AttributedString()
                }

                if let experiencePoints = ExperiencePoints(value) {
                    if value.challengeRating != nil {
                        attributed += " "
                    }

                    attributed += AttributedString(
                        localized: "(\(experiencePoints, format: .experiencePoints.attributed) XP)",
                        locale: style.locale,
                    )
                }
            }

            attributed.creature.challengeEncounter = value
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

public extension FormatStyle where Self == Creature.Challenge.Encounter.FormatStyle {
    /// Returns a format style to format a challenge encounter.
    ///
    /// - Parameters:
    ///   - width: Width of the formatted value.
    /// - Returns: Formatted value.
    static func challengeEncounter(width: Self.Width = .narrow) -> Self {
        Self(width: width)
    }
}
