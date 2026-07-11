//
//  AttributedListFormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/5/26.
//

import Foundation

/// Formats lists of attributed items with a separator and conjunction appropriate for a given locale.
public struct AttributedListFormatStyle<Style: FormatStyle, Base: Sequence>: FormatStyle
    where Style.FormatInput == Base.Element, Style.FormatOutput == AttributedString
{
    /// Format style to use for values.
    public private(set) var memberStyle: Style

    public typealias Width = ListFormatStyle<Foundation.StringStyle, [String]>.Width
    public typealias ListType = ListFormatStyle<Foundation.StringStyle, [String]>.ListType

    /// The size of the list.
    public var width: Width

    /// The type of the list.
    public var listType: ListType

    /// The locale of the format style.
    public var locale: Locale

    public init(memberStyle: Style, type: ListType, width: Width = .standard, locale: Locale = .autoupdatingCurrent) {
        self.memberStyle = memberStyle
        listType = type
        self.width = width
        self.locale = locale
    }

    /// Formats a value, using this style.
    public func format(_ value: Base) -> AttributedString {
        var formattedValues = value.map(memberStyle.format(_:))
        let marker = "@<#!>@"
        return value
            .map { _ in marker }
            .formatted(.list(type: listType, width: width))
            .split(separator: marker, omittingEmptySubsequences: false)
            .reduce(into: AttributedString()) { partialResult, part in
                partialResult.append(AttributedString(part))
                if !formattedValues.isEmpty {
                    partialResult.append(formattedValues.removeFirst())
                }
            }
    }

    /// Modifies the format style to use the specified locale.
    public func locale(_ locale: Locale) -> Self {
        var new = self
        new.locale = locale
        return new
    }
}

extension AttributedListFormatStyle: Sendable where Style: Sendable {}

public extension FormatStyle {
    /// Returns a formst style to format lists of attributed items with a separator and approriate conjunction.
    /// - Parameters:
    ///   - memberStyle: Format style to use for values.
    ///   - type: The type of the list.
    ///   - width: The width of the list.
    /// - Returns: Format style.
    static func list<MemberStyle, Base>(memberStyle: MemberStyle,
                                        type: Self.ListType,
                                        width: Self.Width = .standard)
        -> Self
        where Self == AttributedListFormatStyle<MemberStyle, Base>
    {
        Self(memberStyle: memberStyle, type: type, width: width)
    }

    /// Returns a formst style to format lists of attributed strings with a separator and approriate conjunction.
    /// - Parameters:
    ///   - type: The type of the list.
    ///   - width: The width of the list.
    /// - Returns: Format style.
    static func list<Base>(type: Self.ListType, width: Self.Width = .standard) -> Self
        where Self == AttributedListFormatStyle<AttributedStringStyle, Base>
    {
        Self(memberStyle: AttributedStringStyle(), type: type, width: width)
    }
}
