//
//  Resource+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/24/26.
//

import Foundation

public extension Habitat {
    /// Converts between ``Habitat`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.locale = locale
            return new
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

public extension Habitat.FormatStyle {
    /// Converts between ``Habitat`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Habitat.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Habitat) -> AttributedString {
            var attributed = AttributedString(value.rawValue.capitalized(with: style.locale))

            attributed.habitat = value
            return attributed
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.style = style.locale(locale)
            return new
        }
    }

    /// Returns an equivalent attributed format style.
    var attributed: Attributed {
        Attributed(style: self)
    }

    /// Formats a value, using this style.
    func format(_ value: Habitat) -> String {
        String(attributed.format(value).characters)
    }
}

public extension FormatStyle where Self == Habitat.FormatStyle {
    /// Returns a format style to format a habitat.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static var habitat: Self {
        Self()
    }
}

public extension Habitat {
    /// Converts between collections of ``Habitat`` values and their textual representations.
    struct ListFormatStyle<Base: Collection>: Foundation.FormatStyle, Sendable
        where Base.Element == Habitat
    {
        /// Format style to use for values.
        public private(set) var memberStyle: Habitat.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(memberStyle: Habitat.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            self.memberStyle = memberStyle
            self.locale = locale
        }

        public init(locale: Locale = .autoupdatingCurrent) {
            memberStyle = Habitat.FormatStyle()
            self.locale = locale
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.locale = locale
            return new
        }
    }
}

public extension Habitat.ListFormatStyle {
    /// Converts between collections of ``Habitat`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Habitat.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            value
                .sorted()
                .map { habitat in
                    habitat.formatted(style.memberStyle.locale(style.locale).attributed)
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

    /// Returns an equivalent attributed format style.
    var attributed: Attributed {
        Attributed(style: self)
    }

    /// Formats a value, using this style.
    func format(_ value: Base) -> String {
        String(attributed.format(value).characters)
    }
}

public extension FormatStyle {
    /// Returns a format style to format collections of habitats.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func habitats<Base>(memberStyle: Habitat.FormatStyle) -> Self where Self == Habitat.ListFormatStyle<Base> {
        Self(memberStyle: memberStyle)
    }

    /// Returns a format style to format collections of habitats.
    /// - Returns: Format style.
    static func habitats<Base>() -> Self where Self == Habitat.ListFormatStyle<Base> {
        Self(memberStyle: Habitat.FormatStyle())
    }
}

public extension Resource {
    /// Converts between ``Resource`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.locale = locale
            return new
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

public extension Resource.FormatStyle {
    /// Converts between ``Resource`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Resource.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Resource) -> AttributedString {
            var attributed = switch value {
            case let .resource(notation, value):
                AttributedString(
                    localized: "\(value ?? notation.average, format: .number.attributed) (\(notation, format: .diceNotation.attributed))",
                    locale: style.locale,
                )
            case let .value(value, nil):
                value.formatted(.number.locale(style.locale).attributed)
            case let .value(value, formula):
                AttributedString(localized: "\(value, format: .number.attributed) (\(formula!))",
                                 locale: style.locale)
            }

            attributed.resource = value
            return attributed
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.style = style.locale(locale)
            return new
        }
    }

    /// Returns an equivalent attributed format style.
    var attributed: Attributed {
        Attributed(style: self)
    }

    /// Formats a value, using this style.
    func format(_ value: Resource) -> String {
        String(attributed.format(value).characters)
    }
}

public extension FormatStyle where Self == Resource.FormatStyle {
    /// Returns a format style to format a resource.
    static var resource: Self {
        Self()
    }
}

public extension Treasure {
    /// Converts between ``Treasure`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.locale = locale
            return new
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

public extension Treasure.FormatStyle {
    /// Converts between ``Treasure`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Treasure.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Treasure) -> AttributedString {
            var attributed = AttributedString(value.rawValue.capitalized(with: style.locale))

            attributed.treasure = value
            return attributed
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.style = style.locale(locale)
            return new
        }
    }

    /// Returns an equivalent attributed format style.
    var attributed: Attributed {
        Attributed(style: self)
    }

    /// Formats a value, using this style.
    func format(_ value: Treasure) -> String {
        String(attributed.format(value).characters)
    }
}

public extension FormatStyle where Self == Treasure.FormatStyle {
    /// Returns a format style to format treasure.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static var treasure: Self {
        Self()
    }
}

public extension Treasure {
    /// Converts between collections of ``Treasure`` values and their textual representations.
    struct ListFormatStyle<Base: Collection>: Foundation.FormatStyle, Sendable
        where Base.Element == Treasure
    {
        /// Format style to use for values.
        public private(set) var memberStyle: Treasure.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(memberStyle: Treasure.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            self.memberStyle = memberStyle
            self.locale = locale
        }

        public init(locale: Locale = .autoupdatingCurrent) {
            memberStyle = Treasure.FormatStyle()
            self.locale = locale
        }

        /// Modifies the format style to use the specified locale.
        public func locale(_ locale: Locale) -> Self {
            var new = self
            new.locale = locale
            return new
        }
    }
}

public extension Treasure.ListFormatStyle {
    /// Converts between collections of ``Treasure`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Treasure.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            value
                .sorted()
                .map { treasure in
                    treasure.formatted(style.memberStyle.locale(style.locale).attributed)
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

    /// Returns an equivalent attributed format style.
    var attributed: Attributed {
        Attributed(style: self)
    }

    /// Formats a value, using this style.
    func format(_ value: Base) -> String {
        String(attributed.format(value).characters)
    }
}

public extension FormatStyle {
    /// Returns a format style to format collections of treasure.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func treasures<Base>(memberStyle: Treasure.FormatStyle) -> Self
        where Self == Treasure.ListFormatStyle<Base>
    {
        Self(memberStyle: memberStyle)
    }

    /// Returns a format style to format collections of treasure.
    /// - Returns: Format style.
    static func treasures<Base>() -> Self where Self == Treasure.ListFormatStyle<Base> {
        Self(memberStyle: Treasure.FormatStyle())
    }
}
