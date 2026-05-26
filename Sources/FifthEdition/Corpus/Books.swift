//
//  Books.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//
//  Derived from schema-template/books.json
//  Version: 1.2.19

import MemberwiseInit

/// Source books.
///
/// Each book is parsed as a ``Book`` and available through the ``book`` property
///
/// ## Parsing
/// The collection of books in the 5etools data can be obtained by parsing ``jsonPath``.
///
/// ```swift
/// let decoder = JSONDecoder()
///
/// let booksURL = sourceURL.appending(path: Books.jsonPath)
/// let booksData = try Data(contentsOf: booksURL)
/// let books = try decoder.decode(Books.self, from: booksData)
/// ```
@MemberwiseInit(.public)
public struct Books: Codable, Equatable, Sendable {
    /// Relative path of the data file within the 5etools source archive.
    public static let jsonPath: String = "data/books.json"

    /// Collection of source books.
    public var book: [Book] = []
}

/// Kinds of source book publications, used for grouping.
public enum BookGroup: String, CaseIterable, Codable, Sendable {
    case core
    case supplement
    case supplementAlt = "supplement-alt"
    case setting
    case settingAlt = "setting-alt"
    case prerelease
    case homebrew
    case screen
    case organizedPlay = "organized-play"
    case recipe
    case homecraft
    case other
}
