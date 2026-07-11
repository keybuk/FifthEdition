//
//  SavingThrows+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.SavingThrows {
    /// Converts between ``Creature/SavingThrows`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the ability.
        public var ability: Ability.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Ability.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            ability = style
            self.locale = locale
        }

        public init(case: Ability.FormatStyle.Case = .capitalized,
                    width: Ability.FormatStyle.Width = .short,
                    locale: Locale = .autoupdatingCurrent)
        {
            ability = Ability.FormatStyle(case: `case`, width: width)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.SavingThrows) -> String {
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

public extension Creature.SavingThrows.FormatStyle {
    /// Converts between ``Creature/SavingThrows`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.SavingThrows.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.SavingThrows) -> AttributedString {
            var attributedSavingThrows = value.savingThrows
                .sorted { $0.key < $1.key }
                .map { ability, abilityModifier in
                    AttributedString(
                        localized: "\(ability, format: style.ability.attributed) \(abilityModifier, format: .abilityModifier.attributed)",
                        locale: style.locale,
                    )
                }

            if let special = value.special {
                // FIXME: MARKUP: Entry
                attributedSavingThrows.append(AttributedString(special))
            }

            var attributed = attributedSavingThrows.formatted(.list(type: .and, width: .narrow).locale(style.locale))
            attributed.creature.savingThrows = value
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

public extension FormatStyle where Self == Creature.SavingThrows.FormatStyle {
    /// Returns a format style to format saving throws.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted ability.
    ///   - width: Width of the formatted ability.
    /// - Returns: Formatted value.
    static func savingThrows(case: Ability.FormatStyle.Case = .capitalized,
                             width: Ability.FormatStyle.Width = .short)
        -> Self
    {
        Self(style: Ability.FormatStyle(case: `case`, width: width))
    }
}
