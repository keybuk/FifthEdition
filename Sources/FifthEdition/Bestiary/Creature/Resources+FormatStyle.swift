//
//  Resources+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 8/22/26.
//

import Foundation

public extension Creature.Resources {
    /// Converts between ``Creature/Resources`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to format the resource.
        public var resource: Resource.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(style: Resource.FormatStyle, locale: Locale = .autoupdatingCurrent) {
            resource = style
            self.locale = locale
        }

        public init(locale: Locale = .autoupdatingCurrent) {
            resource = Resource.FormatStyle()
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Resources) -> String {
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

public extension Creature.Resources.FormatStyle {
    /// Converts between ``Resources`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Resources.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Resources) -> AttributedString {
            var attributed = value.resources
                .sorted { $0.key < $1.key }
                .map { name, resource in
                    AttributedString(
                        localized: "\(name) \(resource, format: .resource.attributed)",
                        locale: style.locale,
                    )
                }
                .formatted(.list(type: .and, width: .narrow).locale(style.locale))

            attributed.creature.resources = value
            return attributed
        }

        public func locale(_ locale: Locale) -> Self {
            Attributed(style: style.locale(locale))
        }
    }
}

public extension FormatStyle where Self == Creature.Resources.FormatStyle {
    /// Returns a format style to format resources.
    static var resources: Self {
        Self(style: Resource.FormatStyle())
    }
}
