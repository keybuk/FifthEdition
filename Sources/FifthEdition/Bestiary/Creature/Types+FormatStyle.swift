//
//  Types+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Types {
    /// Converts between ``Creature/Types`` values and their  textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Creature.Types(.dragon, tags: "chromatic")
        ///     .formatted(.types(case: .capitalized))
        /// // "Dragon (Chromatic)"
        ///
        /// Creature.Types(.dragon, tags: "chromatic")
        ///     .formatted(.types(case: .lowercased))
        /// // "dragon (chromatic)"
        /// ```
        public enum Case: String, CaseIterable, Codable, Sendable {
            case capitalized
            case lowercased
        }

        /// How to capitalize the formatted value.
        public var `case`: Case

        /// How to format the swarm size.
        public var size: Size.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(case: Case = .capitalized,
                    size: Size.FormatStyle,
                    locale: Locale = .autoupdatingCurrent)
        {
            self.case = `case`
            self.size = size
            self.locale = locale
        }

        public init(case: Case = .capitalized,
                    size: Size.FormatStyle.Case = .capitalized,
                    locale: Locale = .autoupdatingCurrent)
        {
            self.case = `case`
            self.size = Size.FormatStyle(case: size)
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: Creature.Types) -> String {
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

        /// Returns the matching style for formatting ``CreatureType``.
        fileprivate var creatureType: CreatureType.FormatStyle {
            switch `case` {
            case .capitalized: .creatureType(case: .capitalized)
            case .lowercased: .creatureType(case: .lowercased)
            }
        }

        /// Returns the matching style for formatting ``Tag``.
        fileprivate var tag: Tag.FormatStyle {
            switch `case` {
            case .capitalized: .tag(case: .capitalized)
            case .lowercased: .tag(case: .lowercased)
            }
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

public extension Creature.Types.FormatStyle {
    /// Converts between ``Creature/Types`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Types.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Types) -> AttributedString {
            var attributed = AttributedString()

            if let swarmSize = value.swarmSize {
                attributed +=
                    AttributedString(
                        localized: "swarm of \(swarmSize, format: style.size.attributed) ",
                        locale: style.locale,
                    )
            }

            var typeStyle = style.creatureType
            typeStyle.form = value.swarmSize != nil ? .plural : .normal

            attributed += value.types
                .sorted()
                .map { type in
                    type.formatted(typeStyle.attributed)
                }
                .formatted(.list(type: .or).locale(style.locale))

            if !value.tags.isEmpty {
                attributed += " "
                attributed += value.tags
                    .formatted(.group(style: .tags(memberStyle: style.tag).attributed).locale(style.locale))
            }

            if let note = value.note {
                attributed += " "
                attributed += AttributedString(note)
            }

            attributed.creature.types = value
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

public extension FormatStyle where Self == Creature.Types.FormatStyle {
    /// Returns a format style to format creature types.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    ///   - size: How to capitalize the formatted swarm size.
    /// - Returns: Formatted value.
    static func types(case: Self.Case = .capitalized, size: Size.FormatStyle.Case = .capitalized) -> Self {
        Self(case: `case`, size: size)
    }
}

public extension Creature.Sidekick {
    /// Converts between ``Creature/Sidekick`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Sidekick(level: 4, type: .spellcaster, tags: "Wizard")
        ///     .formatted(.sidekick(case: .capitalized))
        /// // "4th-Level Spellcaster (Wizard)"
        ///
        /// Sidekick(level: 4, type: .spellcaster, tags: "Wizard")
        ///     .formatted(.sidekick(case: .lowercased))
        /// // "4th-level spellcaster (wizard)"
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
        public func format(_ value: Creature.Sidekick) -> String {
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

        /// Returns the matching style for formatting ``SidekickType``.
        fileprivate var sidekickType: SidekickType.FormatStyle {
            switch `case` {
            case .capitalized: .sidekickType(case: .capitalized)
            case .lowercased: .sidekickType(case: .lowercased)
            }
        }

        /// Returns the matching style for formatting ``Tag``.
        fileprivate var tag: Tag.FormatStyle {
            switch `case` {
            case .capitalized: .tag(case: .capitalized)
            case .lowercased: .tag(case: .lowercased)
            }
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

public extension Creature.Sidekick.FormatStyle {
    /// Converts between ``Creature/Sidekick`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Creature.Sidekick.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Creature.Sidekick) -> AttributedString {
            var attributed = AttributedString()
            if let level = value.level {
                let formatter = NumberFormatter()
                formatter.numberStyle = .ordinal
                formatter.locale = style.locale

                let ordinal = formatter.string(from: level as NSNumber) ?? level.formatted(.number)
                var attributedLevel = switch style.case {
                case .capitalized: AttributedString(localized: "\(ordinal)-Level", locale: style.locale)
                case .lowercased: AttributedString(localized: "\(ordinal)-level", locale: style.locale)
                }
                attributedLevel.creature.sidekickLevel = level
                attributed += attributedLevel
            }

            if let type = value.type, !value.isHidden {
                if value.level != nil {
                    attributed += " "
                }

                attributed += AttributedString(
                    localized: "\(type, format: style.sidekickType.attributed)",
                    locale: style.locale,
                )
                if !value.tags.isEmpty {
                    attributed += " "
                    attributed += value.tags
                        .formatted(.group(style: .tags(memberStyle: style.tag).attributed).locale(style.locale))
                }
            }

            attributed.creature.sidekick = value
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

public extension FormatStyle where Self == Creature.Sidekick.FormatStyle {
    /// Returns a format style to format a sidekick.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func sidekick(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}
