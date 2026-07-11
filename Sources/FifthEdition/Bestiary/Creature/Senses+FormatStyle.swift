//
//  Senses+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Sense {
    /// Converts between ``Creature/Sense`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the sense.
        public var sense: Sense.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Sense.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            sense = style
            self.locale = locale
        }

        public init(case: Sense.FormatStyle.Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            sense = Sense.FormatStyle(case: `case`)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Sense) -> String {
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

    func formatted() -> String {
        formatted(FormatStyle())
    }

    /// Returns a value formatted using the specified style.
    func formatted<S: Foundation.FormatStyle>(_ style: S) -> S.FormatOutput where S.FormatInput == Self {
        style.format(self)
    }
}

public extension Creature.Sense.FormatStyle {
    /// Converts between ``Creature/Sense`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Sense.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Sense) -> AttributedString {
            var attributed: AttributedString
            switch value {
            case let .sense(sense, range, note):
                attributed = AttributedString(
                    localized: "\(sense, format: style.sense.attributed) \(range, format: .number.attributed) ft.",
                    locale: style.locale,
                )

                if let note {
                    attributed += " "
                    attributed += AttributedString(note)
                }
            case let .special(special):
                attributed = AttributedString(special)
            }

            attributed.creature.sense = value
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

public extension FormatStyle where Self == Creature.Sense.FormatStyle {
    /// Returns a format style to format a creature's senses.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted sense.
    /// - Returns: Formatted value.
    static func sense(case: Sense.FormatStyle.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Creature.Sense {
    /// Converts between collections of ``Creature/Sense`` values and their textual representations.
    struct ListFormatStyle<Base: Collection>: Foundation.FormatStyle, Sendable
        where Base.Element == Creature.Sense
    {
        /// Format style to use for values.
        private(set) var memberStyle: Creature.Sense.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(memberStyle: Creature.Sense.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            self.memberStyle = memberStyle
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

public extension Creature.Sense.ListFormatStyle {
    /// Converts between collections of ``Creature/Sense`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Sense.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            value
                .sorted()
                .map { sense in
                    sense.formatted(style.memberStyle.locale(style.locale).attributed)
                }
                .formatted(.list(type: .and, width: .narrow).locale(style.locale))
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
    /// Returns a format style to format collections of creature senses.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func senses<Base>(memberStyle: Creature.Sense.FormatStyle) -> Self
        where Self == Creature.Sense.ListFormatStyle<Base>
    {
        Self(memberStyle: memberStyle)
    }

    static func senses<Base>(case: Sense.FormatStyle.Case = .capitalized) -> Self
        where Self == Creature.Sense.ListFormatStyle<Base>
    {
        Self(memberStyle: Creature.Sense.FormatStyle(case: `case`))
    }
}
