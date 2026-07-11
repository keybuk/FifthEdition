//
//  Bestiary.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

/// Bestiary of monsters published in an adventure or source book.
///
/// Each monster in the bestiary is parsed as a ``Creature`` and available through the ``monster`` property.
///
/// ## Parsing
/// The collection of bestiaries in the 5etools data can be iterated by parsing ``jsonIndexPath`` using ``Index``. Each
/// entry in the index maps a source identifier to the filename under ``jsonBasePath`` for the individual bestiary.
///
/// ```swift
/// let decoder = JSONDecoder()
///
/// let bestiaryIndexURL = sourceURL.appending(path: Bestiary.jsonIndexPath)
/// let bestiaryIndexData = try Data(contentsOf: bestiaryIndexURL)
/// let bestiaryIndex = try decoder.decode(Index.self, from: bestiaryIndexData)
///
/// for (_, path) in bestiaryIndex.entries {
///     // Parse bestiary.
///     let bestiaryURL = bestiaryIndexURL
///         .deletingLastPathComponent()
///         .appending(path)
///     let bestiaryData = try Data(contentsOf: bestiaryURL)
///     let bestiary = try decoder.decode(Bestiary.self, from: bestiaryData)
///
///     // ...
/// }
/// ```
public struct Bestiary: Codable, Equatable, Sendable {
    /// Relative path of the directory within the 5etools source archive containing the per-source data files.
    public static let jsonBasePath: String = "data/bestiary"

    /// Relative path of the index data file within the 5etools source archive.
    public static let jsonIndexPath: String = "\(jsonBasePath)/index.json"

    /// Collection of creatures.
    public var monster: [Creature]

    /// Metadata.
    public var meta: Meta?

    /// Initialize bestiary.
    /// - Parameters:
    ///   - monster: Collection of creatures.
    ///   - meta: Metadata.
    public init(_ monster: [Creature] = [],
                meta: Meta? = nil)
    {
        self.monster = monster
        self.meta = meta
    }
}

extension Bestiary: ExpressibleByArrayLiteral {
    /// Initialize ``monster`` from an array literal.
    public init(arrayLiteral elements: Creature...) {
        self.init(elements)
    }
}
