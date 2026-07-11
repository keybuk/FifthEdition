//
//  Contents.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

/// Table of contents.
public struct Contents: Equatable, Sendable {
    /// Name of the entry in the table of contents.
    public var name: String

    /// Type and ordinal of the entry.
    public var ordinal: Ordinal?

    /// Headings within the entry.
    public var headers: [Header]

    /// Initialize corpus contents.
    /// - Parameters:
    ///   - name: Name of the entry in the table of contents.
    ///   - ordinal: Type and ordinal of the entry.
    ///   - headers: Headings within the entry.
    public init(_ name: String,
                ordinal: Ordinal? = nil,
                headers: Header...)
    {
        self.name = name
        self.ordinal = ordinal
        self.headers = headers
    }
}

/// Sub-headings of the table of contents
public struct Header: Equatable, Sendable {
    /// Heading.
    public var header: String

    /// Depth of heading.
    public var depth: Int?

    /// Relative index of heading.
    ///
    /// For example, if there are two `"Treasure"` headings with a table of contents entry, and you wish the entry to
    /// link to the second instance, set ``index`` to `1`.
    public var index: Int?

    /// Initialize corups header.
    /// - Parameters:
    ///   - header: Heading.
    ///   - depth: Depth of heading.
    ///   - index: Relative index of heading.
    public init(_ header: String,
                depth: Int? = nil,
                index: Int? = nil)
    {
        self.header = header
        self.depth = depth
        self.index = index
    }
}

extension Header: ExpressibleByStringLiteral {
    /// Initialize ``header`` from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Type and ordinal of an entry in the table of contents.
public enum Ordinal: Equatable, Sendable {
    case chapter(Page? = nil)
    case appendix(Page? = nil)
    case part(Page? = nil)
    case episode(Page? = nil)
    case level(Page? = nil)
    case section(Page? = nil)
}
