//
//  Tools+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Tools {
    /// Converts between ``Creature/Tools`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the tool.
        public var tool: Tool.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Tool.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            tool = style
            self.locale = locale
        }

        public init(case: Tool.FormatStyle.Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            tool = Tool.FormatStyle(case: `case`)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Tools) -> String {
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

public extension Creature.Tools.FormatStyle {
    /// Converts between ``Tools`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Tools.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Tools) -> AttributedString {
            var attributed = value.tools
                .sorted { $0.key < $1.key }
                .map { tool, abilityModifier in
                    AttributedString(
                        localized: "\(tool, format: style.tool.attributed) \(abilityModifier, format: .abilityModifier.attributed)",
                        locale: style.locale,
                    )
                }
                .formatted(.list(type: .and, width: .narrow).locale(style.locale))

            attributed.creature.tools = value
            return attributed
        }

        public func locale(_ locale: Locale) -> Self {
            Attributed(style: style.locale(locale))
        }
    }
}

public extension FormatStyle where Self == Creature.Tools.FormatStyle {
    /// Returns a format style to format tools.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted tool.
    /// - Returns: Formatted value.
    static func tools(case: Tool.FormatStyle.Case = .capitalized) -> Self {
        Self(style: Tool.FormatStyle(case: `case`))
    }
}
