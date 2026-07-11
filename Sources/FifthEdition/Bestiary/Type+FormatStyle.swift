//
//  Type+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/8/26.
//

import Foundation

public extension Alignment {
    /// Converts between ``Alignment`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Alignment.chaoticGood
        ///     .formatted(.alignment(case: .capitalized))
        /// // "Chaotic Good"
        ///
        /// Alignment.chaoticGood
        ///     .formatted(.alignment(case: .lowercased))
        /// // "chaotic good"
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
        public func format(_ value: Alignment) -> String {
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

public extension Alignment.FormatStyle {
    /// Converts between ``Alignment`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Alignment.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Alignment) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.alignment = value
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

public extension FormatStyle where Self == Alignment.FormatStyle {
    /// Returns a format style to format an alignment.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func alignment(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Alignment {
    /// Converts between collections of ``Alignment`` values and their textual representations.
    struct ListFormatStyle<Base: Collection>: Foundation.FormatStyle, Sendable
        where Base.Element == Alignment
    {
        /// Format style to use for values.
        public private(set) var memberStyle: Alignment.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(memberStyle: Alignment.FormatStyle, locale: Locale = .autoupdatingCurrent) {
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

public extension Alignment.ListFormatStyle {
    /// Converts between sequences of ``Alignment`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Alignment.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            let rawValue: String? = switch Set(value) {
            case .unaligned: String(localized: "unaligned", locale: style.locale)
            case .any: String(localized: "any alignment", locale: style.locale)
            case .anyLawful: String(localized: "any lawful alignment", locale: style.locale)
            case .anyNonLawful: String(localized: "any non-lawful alignment", locale: style.locale)
            case .anyChaotic: String(localized: "any chaotic alignment", locale: style.locale)
            case .anyNonChaotic: String(localized: "any non-chaotic alignment", locale: style.locale)
            case .anyGood: String(localized: "any good alignment", locale: style.locale)
            case .anyNonGood: String(localized: "any non-good alignment", locale: style.locale)
            case .anyEvil: String(localized: "any evil alignment", locale: style.locale)
            case .anyNonEvil: String(localized: "any non-evil alignment", locale: style.locale)
            case .anyNeutral: String(localized: "any neutral alignment", locale: style.locale)
            default: nil
            }

            return if let rawValue {
                switch style.memberStyle.case {
                case .capitalized: AttributedString(rawValue.capitalized(with: style.locale))
                case .lowercased: AttributedString(rawValue.lowercased(with: style.locale))
                }
            } else {
                value
                    .sorted()
                    .formatted(.list(memberStyle: style.memberStyle.attributed, type: .or).locale(style.locale))
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
    /// Returns a format style to format collections of alignments.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func alignments<Base>(memberStyle: Alignment.FormatStyle) -> Self
        where Self == Alignment.ListFormatStyle<Base>
    {
        Self(memberStyle: memberStyle)
    }

    /// Returns a format style to format collections of alignments.
    /// - Returns: Format style.
    static func alignments<Base>(case: Alignment.FormatStyle.Case = .capitalized) -> Self
        where Self == Alignment.ListFormatStyle<Base>
    {
        Self(memberStyle: Alignment.FormatStyle(case: `case`))
    }
}

public extension CreatureType {
    /// Converts between ``CreatureType`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// CreatureType.dragon
        ///     .formatted(.creatureType(case: .capitalized))
        /// // "Dragon"
        ///
        /// CreatureType.dragon
        ///     .formatted(.creatureType(case: .lowercased))
        /// // "dragon"
        /// ```
        public enum Case: String, CaseIterable, Codable, Sendable {
            case capitalized
            case lowercased
        }

        /// How to inflect the formatted value.
        ///
        /// For example:
        /// ```swift
        /// CreatureType.dragon
        ///     .formatted(.creatureType(form: .normal))
        /// // "Dragon"
        ///
        /// CreatureType.dragon
        ///     .formatted(.creatureType(form: .plural))
        /// // "Dragons"
        /// ```
        public enum Form: String, CaseIterable, Codable, Sendable {
            case normal
            case plural
        }

        /// How to capitalize the formatted value.
        public var `case`: Case

        /// How to inflect the formatted value.
        public var form: Form

        /// The locale of the format style.
        public var locale: Locale

        public init(case: Case = .capitalized, form: Form = .normal, locale: Locale = .autoupdatingCurrent) {
            self.case = `case`
            self.form = form
            self.locale = locale
        }

        /// Formats a value, using this style.
        public func format(_ value: CreatureType) -> String {
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

public extension CreatureType.FormatStyle {
    /// Converts between ``CreatureType`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: CreatureType.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: CreatureType) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            switch style.form {
            case .normal: break
            case .plural:
                switch value {
                case .celestial:
                    // Morphology treats "celestial" as an adjective.
                    attributed = AttributedString(localized: "\(attributed)s", locale: style.locale)
                default:
                    var morphology = Morphology()
                    morphology.number = .plural

                    attributed.inflect = InflectionRule(morphology: morphology)
                    attributed = attributed.inflected(locale: style.locale)
                }
            }

            attributed.creatureType = value
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

public extension FormatStyle where Self == CreatureType.FormatStyle {
    /// Returns a format style to format a creature type.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    ///   - form: How to inflect the formatted value.
    /// - Returns: Formatted value.
    static func creatureType(case: Self.Case = .capitalized, form: Self.Form = .normal) -> Self {
        Self(case: `case`, form: form)
    }
}

public extension SidekickType {
    /// Converts between ``SidekickType`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// SidekickType.expert
        ///     .formatted(.sidekickType(case: .capitalized))
        /// // "Expert"
        ///
        /// SidekickType.expert
        ///     .formatted(.sidekickType(case: .lowercased))
        /// // "expert"
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
        public func format(_ value: SidekickType) -> String {
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

public extension SidekickType.FormatStyle {
    /// Converts between ``SidekickType`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: SidekickType.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: SidekickType) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.sidekickType = value
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

public extension FormatStyle where Self == SidekickType.FormatStyle {
    /// Returns a format style to format a sidekick type
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func sidekickType(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Size {
    /// Converts between ``Size`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Size.medium
        ///     .formatted(.size(case: .capitalized))
        /// // "Medium"
        ///
        /// Size.medium
        ///     .formatted(.size(case: .lowercased))
        /// // "medium"
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
        public func format(_ value: Size) -> String {
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

public extension Size.FormatStyle {
    /// Converts between ``Size`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Size.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Size) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.rawValue.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.rawValue.lowercased(with: style.locale))
            }

            attributed.size = value
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

public extension FormatStyle where Self == Size.FormatStyle {
    /// Returns a format style to format a size.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func size(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Tag {
    /// Converts between ``Tag`` values and their textual representations.
    struct FormatStyle: Foundation.FormatStyle, Sendable {
        /// How to capitalize the formatted value.
        ///
        /// For example:
        /// ```swift
        /// Tag("human")
        ///     .formatted(.tag(case: .capitalized))
        /// // "Human"
        ///
        /// Tag("human")
        ///     .formatted(.tag(case: .lowercased))
        /// // "strength"
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
        public func format(_ value: Tag) -> String {
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

public extension Tag.FormatStyle {
    /// Converts between ``Tag`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Tag.FormatStyle

        /// Formats a value, using this style.
        public func format(_ value: Tag) -> AttributedString {
            var attributed = switch style.case {
            case .capitalized: AttributedString(value.tag.capitalized(with: style.locale))
            case .lowercased: AttributedString(value.tag.lowercased(with: style.locale))
            }

            if let prefix = value.prefix, !value.isPrefixHidden {
                attributed = switch style.case {
                case .capitalized: AttributedString(prefix.capitalized(with: style.locale)) + " " + attributed
                case .lowercased: AttributedString(prefix.lowercased(with: style.locale)) + " " + attributed
                }
            }

            attributed.tag = value
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

public extension FormatStyle where Self == Tag.FormatStyle {
    /// Returns a format style to format a tag.
    ///
    /// - Parameters:
    ///   - case: How to capitalize the formatted value.
    /// - Returns: Formatted value.
    static func tag(case: Self.Case = .capitalized) -> Self {
        Self(case: `case`)
    }
}

public extension Tag {
    /// Converts between collections of ``Tag`` values and their textual representations.
    struct ListFormatStyle<Base: Collection>: Foundation.FormatStyle, Sendable
        where Base.Element == Tag
    {
        /// Format style to use for values.
        public private(set) var memberStyle: Tag.FormatStyle

        /// The locale of the format style.
        public var locale: Locale

        public init(memberStyle: Tag.FormatStyle,
                    locale: Locale = .autoupdatingCurrent)
        {
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

public extension Tag.ListFormatStyle {
    /// Converts between lists of ``Tag`` values and their attributed textual representations.
    struct Attributed: Foundation.FormatStyle, Sendable {
        /// Format style to use.
        public private(set) var style: Tag.ListFormatStyle<Base>

        /// Formats a value, using this style.
        public func format(_ value: Base) -> AttributedString {
            value
                .sorted()
                .map { tag in
                    tag.formatted(style.memberStyle.locale(style.locale).attributed)
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
    /// Returns a format style to format collections of tags.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    /// - Returns: Format style.
    static func tags<Base>(memberStyle: Tag.FormatStyle) -> Self where Self == Tag.ListFormatStyle<Base> {
        Self(memberStyle: memberStyle)
    }

    /// Returns a format style to format collections of tag.
    /// - Parameters:
    ///   - case: How to capitalize the formatted tag.
    /// - Returns: Format style.
    static func tags<Base>(case: Tag.FormatStyle.Case = .capitalized) -> Self where Self == Tag.ListFormatStyle<Base> {
        Self(memberStyle: Tag.FormatStyle(case: `case`))
    }
}
