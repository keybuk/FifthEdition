//
//  Speeds+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Speeds {
    /// Converts between ``Creature/Speeds`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the movement.
        public var movement: Movement.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Movement.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            movement = style
            self.locale = locale
        }

        public init(case: Movement.FormatStyle.Case = .capitalized,
                    locale: Locale = .autoupdatingCurrent)
        {
            movement = Movement.FormatStyle(case: `case`, locale: locale)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Speeds) -> String {
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

public extension Creature.Speeds.FormatStyle {
    /// Converts between ``Creature/Speeds`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Speeds.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Speeds) -> AttributedString {
            var attributedSpeeds = value.speeds
                .filter { !value.hidden.contains($0.key) }
                .sorted { $0.key < $1.key }
                .map { movement, speeds in
                    if movement == .walk {
                        speeds.formatted(.list(
                            memberStyle: .speed.locale(style.locale).attributed,
                            type: .and,
                            width: .narrow,
                        ))
                    } else {
                        AttributedString(
                            localized: "\(movement, format: style.movement.attributed) \(speeds, format: .list(memberStyle: .speed.attributed, type: .and, width: .narrow))",
                            locale: style.locale,
                        )
                    }
                }

            if !value.chooseMovement.isEmpty, let choiceSpeed = value.choiceSpeed {
                attributedSpeeds.append(AttributedString(
                    localized: "\(value.chooseMovement.sorted(), format: .list(memberStyle: style.movement.attributed, type: .or)) \(choiceSpeed, format: .speed.attributed)",
                    locale: style.locale,
                ))
            }

            var attributed = attributedSpeeds.formatted(.list(type: .and, width: .narrow).locale(style.locale))
            attributed.creature.speeds = value
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

public extension FormatStyle where Self == Creature.Speeds.FormatStyle {
    /// Returns a format style to format speeds.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted movement.
    /// - Returns: Formatted value.
    static func speeds(case: Movement.FormatStyle.Case = .capitalized) -> Self {
        Self(style: Movement.FormatStyle(case: `case`))
    }
}
