//
//  GroupFormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/28/26.
//

import Foundation

/// Formats values within grouping characters.
public struct GroupFormatStyle<Style: FormatStyle, Base>: FormatStyle
    where Base == Style.FormatInput, Style.FormatOutput == String
{
    /// Format style to use for value.
    public private(set) var style: Style

    /// How to group the formatted value.
    ///
    /// For example:
    /// ```swift
    /// "value".formatted(.group(type: .parens))
    /// // "(value)"
    ///
    /// "value".formatted(.group(type: .braces))
    /// // "{value}"
    ///
    /// "value".formatted(.group(type: .brackets))
    /// // "[value]"
    ///
    /// "value".formatted(.group(type: .none))
    /// // "value"
    /// ```
    public enum GroupType: String, Codable, Sendable {
        case parens
        case braces
        case brackets
        case none
    }

    /// How to group the formatted value.
    public var groupType: GroupType

    /// The locale of the format style.
    public var locale: Locale

    public init(style: Style, type: GroupType = .parens, locale: Locale = .autoupdatingCurrent) {
        self.style = style
        groupType = type
        self.locale = locale
    }

    /// Formats a value, using this style.
    public func format(_ value: Base) -> String {
        let formattedValue = style.format(value)
        return switch groupType {
        case .parens: String(localized: "(\(formattedValue))", locale: locale)
        case .braces: String(localized: "{\(formattedValue)}", locale: locale)
        case .brackets: String(localized: "[\(formattedValue)]", locale: locale)
        case .none: formattedValue
        }
    }

    /// Modifies the format style to use the specified locale.
    public func locale(_ locale: Locale) -> Self {
        var new = self
        new.locale = locale
        return new
    }
}

extension GroupFormatStyle: Sendable where Style: Sendable {}

/// Formats attributed values within grouping characters.
public struct AttributedGroupFormatStyle<Style: FormatStyle, Base>: FormatStyle
    where Base == Style.FormatInput, Style.FormatOutput == AttributedString
{
    /// Format style to use for value.
    public private(set) var style: Style

    public typealias GroupType = GroupFormatStyle<StringStyle, String>.GroupType

    /// How to group the formatted value.
    public var groupType: GroupType

    /// The locale of the format style.
    public var locale: Locale

    public init(style: Style, type: GroupType = .parens, locale: Locale = .autoupdatingCurrent) {
        self.style = style
        groupType = type
        self.locale = locale
    }

    /// Formats a value, using this style.
    public func format(_ value: Base) -> AttributedString {
        let formattedValue = style.format(value)
        return switch groupType {
        case .parens: AttributedString(localized: "(\(formattedValue))", locale: locale)
        case .braces: AttributedString(localized: "{\(formattedValue)}", locale: locale)
        case .brackets: AttributedString(localized: "[\(formattedValue)]", locale: locale)
        case .none: formattedValue
        }
    }

    /// Modifies the format style to use the specified locale.
    public func locale(_ locale: Locale) -> Self {
        var new = self
        new.locale = locale
        return new
    }
}

extension AttributedGroupFormatStyle: Sendable where Style: Sendable {}

public extension FormatStyle {
    /// Returns a format style to format values within grouping characters.
    /// - Parameters:
    ///   - style: Format style to use for values.
    ///   - type: How to group the formatted values.
    /// - Returns: Format style.
    static func group<Style, Base>(style: Style, type: Self.GroupType = .parens) -> Self
        where Self == GroupFormatStyle<Style, Base>
    {
        Self(style: style, type: type)
    }

    /// Returns a format style to format attributed values within grouping characters.
    /// - Parameters:
    ///   - style: Format style to use for values.
    ///   - type: How to group the formatted values.
    /// - Returns: Format style.
    static func group<Style, Base>(style: Style, type: Self.GroupType = .parens) -> Self
        where Self == AttributedGroupFormatStyle<Style, Base>
    {
        Self(style: style, type: type)
    }

    /// Returns a format style to format values within grouping characters.
    /// - Parameters:
    ///   - type: How to group the formatted values.
    /// - Returns: Format style.
    static func group(type: Self.GroupType = .parens) -> Self
        where Self == GroupFormatStyle<StringStyle, String>
    {
        Self(style: StringStyle(), type: type)
    }

    /// Returns a format style to format values within grouping characters.
    /// - Parameters:
    ///   - type: How to group the formatted values.
    /// - Returns: Format style.
    static func group(type: Self.GroupType = .parens) -> Self
        where Self == AttributedGroupFormatStyle<AttributedStringStyle, AttributedString>
    {
        Self(style: AttributedStringStyle(), type: type)
    }
}
