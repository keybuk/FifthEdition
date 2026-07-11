//
//  DiceNotation+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

import Foundation

public extension Die {
    /// Converts between ``Die`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Die) -> String {
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

public extension Die.FormatStyle {
    /// Converts between ``Die`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Die.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Die) -> AttributedString {
            var attributed = AttributedString(
                localized: "d\(value.rawValue, format: .number.attributed)",
                locale: style.locale,
            )
            attributed.die = value
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

public extension FormatStyle where Self == Die.FormatStyle {
    /// Returns a format style to format a die.
    static var die: Self {
        Self()
    }
}

public extension Dice {
    /// Converts between ``Dice`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        typealias SignDisplayStrategy = IntegerFormatStyle<Int>.Configuration.SignDisplayStrategy

        /// Sign strategy to use.
        fileprivate var signStrategy: SignDisplayStrategy

        /// The locale of the format style.
        public var locale: Locale

        fileprivate init(sign signStrategy: SignDisplayStrategy = .automatic, locale: Locale = .autoupdatingCurrent) {
            self.signStrategy = signStrategy
            self.locale = locale
        }

        public init(locale: Locale = .autoupdatingCurrent) {
            signStrategy = .automatic
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Dice) -> String {
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

public extension Dice.FormatStyle {
    /// Converts between ``Dice`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Dice.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Dice) -> AttributedString {
            var attributed = switch value {
            case let .die(die, count):
                AttributedString(
                    localized: "\(count, format: .number.sign(strategy: style.signStrategy).attributed)\(die, format: .die.attributed)",
                    locale: style.locale,
                )
            case let .modifier(modifier):
                modifier.formatted(.number.sign(strategy: style.signStrategy).locale(style.locale).attributed)
            }

            attributed.dice = value
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

public extension FormatStyle where Self == Dice.FormatStyle {
    /// Returns a format style to format dice.
    static func dice() -> Self {
        Self()
    }

    /// Returns a format style to format dice.
    fileprivate static func dice(sign signStrategy: Self.SignDisplayStrategy = .automatic) -> Self {
        Self(sign: signStrategy)
    }
}

public extension DiceNotation {
    /// Converts between ``DiceNotation`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// The locale of the format style.
        public var locale: Locale

        public init(locale: Locale = .autoupdatingCurrent) {
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: DiceNotation) -> String {
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

public extension DiceNotation.FormatStyle {
    /// Converts between ``DiceNotation`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: DiceNotation.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: DiceNotation) -> AttributedString {
            var attributed = value.dice.reduce(AttributedString()) { partialResult, dice in
                switch dice {
                case let .die(_, count):
                    if partialResult.characters.isEmpty {
                        dice.formatted(.dice().attributed)
                    } else if count < 0 {
                        AttributedString(
                            localized: "\(partialResult) - \(dice, format: .dice(sign: .never).attributed)",
                            locale: style.locale,
                        )
                    } else {
                        AttributedString(
                            localized: "\(partialResult) + \(dice, format: .dice().attributed)",
                            locale: style.locale,
                        )
                    }
                case let .modifier(modifier):
                    if partialResult.characters.isEmpty {
                        dice.formatted(.dice().attributed)
                    } else if modifier < 0 {
                        AttributedString(
                            localized: "\(partialResult) - \(dice, format: .dice(sign: .never).attributed)",
                            locale: style.locale,
                        )
                    } else {
                        AttributedString(
                            localized: "\(partialResult) + \(dice, format: .dice().attributed)",
                            locale: style.locale,
                        )
                    }
                }
            }

            attributed.diceNotation = value
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

public extension FormatStyle where Self == DiceNotation.FormatStyle {
    /// Returns a format style to format a dice notation.
    static var diceNotation: Self {
        Self()
    }
}
