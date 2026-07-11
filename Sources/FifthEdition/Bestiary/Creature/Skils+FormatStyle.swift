//
//  Skils+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Skills {
    /// Converts between ``Creature/Skills`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the skill.
        public var skill: Skill.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Skill.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            skill = style
            self.locale = locale
        }

        public init(case: Skill.FormatStyle.Case = .capitalized,
                    locale: Locale = .autoupdatingCurrent)
        {
            skill = Skill.FormatStyle(case: `case`, locale: locale)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Skills) -> String {
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

public extension Creature.Skills.FormatStyle {
    /// Converts between ``Creature/Skills`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Skills.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Skills) -> AttributedString {
            var attributedSkills = value.skills
                .sorted { $0.key < $1.key }
                .map { skill, abilityModifier in
                    AttributedString(
                        localized: "\(skill, format: style.skill.attributed) \(abilityModifier, format: .abilityModifier.attributed)",
                        locale: style.locale,
                    )
                }

            attributedSkills.append(contentsOf: value.other
                .map { other in
                    let attributed = other
                        .sorted { $0.key < $1.key }
                        .map { skill, abilityModifier in
                            AttributedString(
                                localized: "\(skill, format: style.skill.attributed) \(abilityModifier, format: .abilityModifier.attributed)",
                                locale: style.locale,
                            )
                        }
                        .formatted(.list(type: .or, width: .standard).locale(style.locale))

                    return AttributedString(localized: "plus one of the following: \(attributed)",
                                            locale: style.locale)
                })

            if let special = value.special {
                // FIXME: MARKUP: Entry
                attributedSkills.append(AttributedString(special))
            }

            var attributed = attributedSkills.formatted(.list(type: .and, width: .narrow).locale(style.locale))
            attributed.creature.skills = value
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

public extension FormatStyle where Self == Creature.Skills.FormatStyle {
    /// Returns a format style to format skills.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted skill.
    /// - Returns: Formatted value.
    static func skills(case: Skill.FormatStyle.Case = .capitalized) -> Self {
        Self(style: Skill.FormatStyle(case: `case`))
    }
}
