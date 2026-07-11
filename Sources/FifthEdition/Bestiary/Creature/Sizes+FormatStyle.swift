//
//  Sizes+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Sizes {
    /// Converts between ``Creature/Sizes`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the size.
        public var size: Size.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Size.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            size = style
            self.locale = locale
        }

        public init(case: Size.FormatStyle.Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            size = Size.FormatStyle(case: `case`)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Sizes) -> String {
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

public extension Creature.Sizes.FormatStyle {
    /// Converts between ``Creature/Sizes`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Sizes.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Sizes) -> AttributedString {
            var attributed = value.sizes
                .sorted()
                .map { size in
                    size.formatted(style.size.locale(style.locale).attributed)
                }
                .formatted(.list(type: .or).locale(style.locale))

            if let note = value.note {
                attributed += " "
                attributed += AttributedString(note)
            }

            attributed.creature.sizes = value
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

public extension FormatStyle where Self == Creature.Sizes.FormatStyle {
    /// Returns a format style to format a creature's size.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted size.
    /// - Returns: Formatted value.
    static func sizes(case: Size.FormatStyle.Case = .capitalized) -> Self {
        Self(style: Size.FormatStyle(case: `case`))
    }
}
