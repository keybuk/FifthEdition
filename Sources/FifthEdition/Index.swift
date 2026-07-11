//
//  Index.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

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
/// let indexURL = sourceURL.appending(path: indexPath)
/// let indexData = try Data(contentsOf: indexURL)
/// let index = try decoder.decode(Index.self, from: indexData)
///
/// for (source, path) in index.entries {
///     // Parse file.
///     let fileURL = indexURL
///         .deletingLastPathComponent()
///         .appending(path: path)
/// }
/// ```
@MemberwiseInit(.public)
public struct Index: Equatable, Sendable {
    /// Index entries.
    ///
    /// Maps source identifiers to a filename relative to this index.
    public var entries: [String: String] = [:]
}
