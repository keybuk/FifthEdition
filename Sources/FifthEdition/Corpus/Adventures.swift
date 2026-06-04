//
//  Adventures.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//
//  Implements schema-template/adventures.json
//  Version: 1.10.34

import MemberwiseInit

/// Adventures.
///
/// Each adventure is parsed as an ``Adventure`` and available through the ``adventure`` property.
///
/// ## Parsing
/// The collection of adventures in the 5etools data can be obtained by parsing ``jsonPath``.
///
/// ```swift
/// let decoder = JSONDecoder()
///
/// let adventuresURL = sourceURL.appending(path: Adventures.jsonPath)
/// let adventuresData = try Data(contentsOf: adventuresURL)
/// let adventures = try decoder.decode(Adventures.self, from: adventuresData)
/// ```
@MemberwiseInit(.public)
public struct Adventures: Codable, Equatable, Sendable {
    /// Relative path of the data file within the 5etools source archive.
    public static let jsonPath: String = "data/adventures.json"

    /// Collection of adventures.
    public var adventure: [Adventure] = []
}
