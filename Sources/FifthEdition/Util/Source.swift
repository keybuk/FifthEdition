//
//  Source.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/13/26.
//

/// Reference to page or chapter.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``Page`` values to be
/// specified as integer and string literals.
public enum Page: Equatable, Hashable, Sendable {
    case number(Int)
    case numeral(String)
}

extension Page: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``number(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .number(value)
    }

    /// Initialize ``numeral(_:)`` from a string literal.
    public init(stringLiteral value: String) {
        self = .numeral(value)
    }
}

extension Page: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .number(number): number.formatted(.number)
        case let .numeral(numeral): numeral
        }
    }
}

extension Page: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.number(lhsNumber), .number(rhsNumber)):
            lhsNumber < rhsNumber
        case let (.numeral(lhsNumeral), .numeral(rhsNumeral)):
            lhsNumeral < rhsNumeral
        case (.numeral, .number): true
        default: false
        }
    }
}

/// Reference in SRD or Basic Rules.
public enum Reference: Equatable, Hashable, Sendable {
    case present
    case presentAs(String)
}

/// Source that reprints this entity.
public struct Reprint: Equatable, Hashable, Sendable {
    /// Name of the entity in the reprinting source.
    public var name: String

    /// Source identifier that reprints the entity.
    public var source: String

    /// Alternate name to use for display.
    public var displayName: String?

    /// Entity type for linking.
    public var entity: Entity?

    /// Edition of reference.
    public var edition: Edition?

    /// Initialize a reprint.
    /// - Parameters:
    ///   - name: Name of the entity in the reprinting source.
    ///   - source: Source identifier that reprints the entity.
    ///   - displayName: Alternate name to use for display.
    ///   - entity: Entity type for linking.
    ///   - edition: Edition of reference.
    public init(name: String,
                source: String,
                displayName: String? = nil,
                entity: Entity? = nil,
                edition: Edition? = nil)
    {
        self.name = name
        self.source = source
        self.displayName = displayName
        self.entity = entity
        self.edition = edition
    }
}

extension Reprint: ExpressibleByStringLiteral {
    /// Initialize by parsing string literal as UID.
    public init(stringLiteral value: String) {
        self.init(uid: value)
    }

    /// Initialize from a uid.
    /// - Parameters:
    ///   - uid: Name and source in uid format.
    ///   - entity: Entity type for linking.
    ///   - edition: Edition of reference.
    init(uid: String, entity: Entity? = nil, edition: Edition? = nil) {
        var uidParts = uid.split(separator: "|", maxSplits: 2)

        name = String(uidParts.removeFirst())
        source = !uidParts.isEmpty ? String(uidParts.removeFirst()) : ""
        if !uidParts.isEmpty {
            displayName = String(uidParts.removeFirst())
        }

        self.entity = entity
        self.edition = edition
    }

    /// Returns the reprint in uid format.
    var uid: String {
        [name, source, displayName]
            .compactMap(\.self)
            .joined(separator: "|")
    }
}

/// Source reference.
///
/// For convenience, ``init(stringLiteral:)`` permits ``Source`` values to be specified as string literals.
public struct Source: Codable, Equatable, Hashable, Sendable {
    /// Source identifier.
    public var source: String

    /// Page number.
    public var page: Page?

    /// Initialize source reference.
    /// - Parameters:
    ///   - source: Source identifier.
    ///   - page: Page number.
    public init(_ source: String,
                page: Page? = nil)
    {
        self.source = source
        self.page = page
    }
}

extension Source: ExpressibleByStringLiteral {
    /// Initialize ``source`` from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
