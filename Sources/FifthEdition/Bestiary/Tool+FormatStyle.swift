//
//  Tool+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/24/26.
//

import Foundation

public extension Gear {
    /// Converts between ``Gear`` values and their textual representations.
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

public extension Gear.FormatStyle {
    /// Converts between ``Gear`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Gear.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Gear) -> AttributedString {
            var name = AttributedString(value.displayName ?? value.name)
            var attributed: AttributedString
            if value.quantity > 1 {
                var morphology = Morphology()
                morphology.number = .plural

                name.inflect = InflectionRule(morphology: morphology)

                attributed = AttributedString(
                    localized: "\(name.inflected(locale: style.locale)) (\(value.quantity, format: .number.attributed))",
                    locale: style.locale,
                )
            } else {
                attributed = name
            }

            attributed.gear = value
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
    func format(_ value: Gear) -> String {
        String(attributed.format(value).characters)
    }
}

public extension FormatStyle where Self == Gear.FormatStyle {
    /// Returns a format style to format gear.
    static var gear: Self {
        Self()
    }
}

public extension Gear {
    /// Converts between collections of ``Gear`` values and their textual representations.
    struct ListFormatStyle<Base: Collection>: Foundation.FormatStyle, Sendable
        where Base.Element == Gear
    {
        /// Format style to use for values.
        public private(set) var memberStyle: Gear.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(memberStyle: Gear.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            self.memberStyle = memberStyle
            self.locale = locale
        }

        public init(locale: Locale = .autoupdatingCurrent) {
            memberStyle = Gear.FormatStyle()
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

public extension Gear.ListFormatStyle {
    /// Converts between collections of ``Gear`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Gear.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            value
                .sorted()
                .map { gear in
                    gear.formatted(style.memberStyle.locale(style.locale).attributed)
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
    /// Returns a format style to format collections of gear.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func gears<Base>(memberStyle: Gear.FormatStyle) -> Self where Self == Gear.ListFormatStyle<Base> {
        Self(memberStyle: memberStyle)
    }

    /// Returns a format style to format collections of gear.
    /// - Returns: Format style.
    static func gears<Base>() -> Self where Self == Gear.ListFormatStyle<Base> {
        Self(memberStyle: Gear.FormatStyle())
    }
}

public extension Tool {
    /// Converts between ``Tool`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Tool.playingCardSet
        ///     .formatted(.tool(case: .lowercased))
        /// // "Playing Card Set"
        ///
        /// Tool.playingCardSet
        ///     .formatted(.tool(case: .lowercased))
        /// // "playing card set"
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

public extension Tool.FormatStyle {
    /// Converts between ``Tool`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Tool.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Tool) -> AttributedString {
            let rawValue = switch value {
            case let .item(name, source: _): name
            default: value.rawValue
            }

            var attributed = switch style.case {
            case .capitalized: AttributedString(rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(rawValue.lowercased(with: style.locale))
            }

            attributed.tool = value
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
    func format(_ value: Tool) -> String {
        String(attributed.format(value).characters)
    }
}

public extension FormatStyle where Self == Tool.FormatStyle {
    /// Returns a format style to format a tool.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func tool(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}
