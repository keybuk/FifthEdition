//
//  Index.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//
//  Derived from schema-template/bestiary/index.json
//  Version: 1.0.0
//
//  Derived from schema-template/spells/index.json
//  Version: 1.0.0
//
//  Derived from schema-template/class/index.json
//  Version: 1.0.0

import MemberwiseInit

/// Index of files.
///
/// Used for the index of ``Bestiary`` files.
///
/// ## Parsing
/// Each entry in the ``Index`` maps a source identifier to a filename relative to the index.
///
/// ```swift
/// let decoder = JSONDecoder()
///
/// let indexURL = sourceURL.appending(indexPath)
/// let indexData = try Data(contentsOf: indexURL)
/// let index = try decoder.decode(Index.self, from: indexData)
///
/// for (source, path) in index.entries {
///     // Parse file.
///     let fileURL = indexURL
///         .deletingLastPathComponent()
///         .appending(path)
/// }
/// ```
@MemberwiseInit(.public)
public struct Index: Equatable, Sendable {
    /// Index entries.
    ///
    /// Maps source identifiers to a filename relative to this index.
    public var entries: [String: String] = [:]
}
