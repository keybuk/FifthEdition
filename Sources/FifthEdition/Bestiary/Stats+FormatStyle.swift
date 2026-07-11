//
//  Stats+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/12/26.
//

import Foundation

public extension ArmorClass {
    /// Converts between ``ArmorClass`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: ArmorClass) -> String {
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

public extension ArmorClass.FormatStyle {
    /// Converts between ``ArmorClass`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: ArmorClass.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: ArmorClass) -> AttributedString {
            var attributed: AttributedString
            switch value {
            case let .ac(ac, from, condition, inParens):
                attributed = ac.formatted(.number.locale(style.locale).attributed)

                if let from {
                    attributed += " "
                    attributed += from
                        .map { AttributedString($0) }
                        .formatted(.group(style: .list(type: .and, width: .narrow).locale(style.locale)))
                }

                if let condition {
                    // FIXME: MARKUP
                    attributed += " "
                    attributed += AttributedString(condition)
                }

                if inParens {
                    attributed = attributed.formatted(.group(type: .parens))
                }
            case let .special(special):
                attributed = AttributedString(special)
            }

            attributed.armorClass = value
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

public extension FormatStyle where Self == ArmorClass.FormatStyle {
    /// Returns a format style to format an armor class.
    static var armorClass: Self {
        Self()
    }
}

public extension ArmorClass {
    /// Converts between sequences of ``ArmorClass`` values and their textual representations.
    struct ListFormatStyle<Base: Sequence>: Foundation.FormatStyle, Sendable
        where Base.Element == ArmorClass
    {
        /// Format style to use for values.
        private(set) var memberStyle: ArmorClass.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(memberStyle: ArmorClass.FormatStyle, locale: Locale = .autoupdatingCurrent) {
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

public extension ArmorClass.ListFormatStyle {
    /// Converts between sequences of ``ArmorClass`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: ArmorClass.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            value
                .map { armorClass in
                    armorClass.formatted(style.memberStyle.locale(style.locale).attributed)
                }
                .reduce(into: AttributedString()) { partialResult, attributedArmorClass in
                    if partialResult.characters.isEmpty {
                        partialResult += attributedArmorClass
                    } else if String(partialResult.characters).hasSuffix(")"),
                              String(attributedArmorClass.characters).hasPrefix("(")
                    {
                        partialResult.characters.removeLast()
                        partialResult += "; "

                        var attributedArmorClass = attributedArmorClass
                        attributedArmorClass.characters.removeFirst()

                        partialResult += attributedArmorClass
                    } else if String(attributedArmorClass.characters).hasPrefix("(") {
                        partialResult += " "
                        partialResult += attributedArmorClass
                    } else {
                        partialResult += ", "
                        partialResult += attributedArmorClass
                    }
                }
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
    /// Returns a format style to format sequences of armor classes.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func armorClasses<Base>(memberStyle: ArmorClass.FormatStyle) -> Self
        where Self == ArmorClass.ListFormatStyle<Base>
    {
        Self(memberStyle: memberStyle)
    }

    /// Returns a format style to format sequences of armor classes.
    /// - Returns: Format style.
    static func armorClasses<Base>() -> Self where Self == ArmorClass.ListFormatStyle<Base> {
        Self(memberStyle: ArmorClass.FormatStyle())
    }
}

public extension HitPoints {
    /// Converts between ``HitPoints`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: HitPoints) -> String {
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

public extension HitPoints.FormatStyle {
    /// Converts between ``HitPoints`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: HitPoints.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: HitPoints) -> AttributedString {
            var attributed = switch value {
            case let .hp(notation, given):
                AttributedString(
                    localized: "\(given ?? notation.average, format: .number.attributed) (\(notation, format: .diceNotation.attributed))",
                    locale: style.locale,
                )
            case let .other(average, formula):
                AttributedString(localized: "\(average, format: .number.attributed) (\(formula))",
                                 locale: style.locale)
            case let .special(special):
                // FIXME: MARKUP
                AttributedString(special)
            }

            attributed.hitPoints = value
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

public extension FormatStyle where Self == HitPoints.FormatStyle {
    /// Returns a format style to format hit points.
    static var hitPoints: Self {
        Self()
    }
}

public extension Movement {
    /// Converts between ``Movement`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Movement.fly
        ///     .formatted(.movement(case: .capitalized))
        /// // "Fly"
        ///
        /// Movement.fly
        ///     .formatted(.movement(case: .lowercased))
        /// // "fly"
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
        public func format(_ value: Movement) -> String {
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

public extension Movement.FormatStyle {
    /// Converts between ``Movement`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Movement.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Movement) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.movement = value
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

public extension FormatStyle where Self == Movement.FormatStyle {
    /// Returns a format style to format an movement.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func movement(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Speed {
    /// Converts between ``Speed`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Speed) -> String {
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

public extension Speed.FormatStyle {
    /// Converts between ``Speed`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Speed.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Speed) -> AttributedString {
            var attributed: AttributedString
            switch value {
            case let .speed(speed, condition):
                attributed = AttributedString(
                    localized: "\(speed, format: .number.attributed) ft.",
                    locale: style.locale,
                )

                if let condition {
                    // FIXME: MARKUP
                    attributed += " "
                    attributed += AttributedString(condition)
                }
            case .walkingSpeed:
                attributed = AttributedString(localized: "equal to your walking speed", locale: style.locale)
            }

            attributed.speed = value
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

public extension FormatStyle where Self == Speed.FormatStyle {
    /// Returns a format style to format a speed.
    static var speed: Self {
        Self()
    }
}
