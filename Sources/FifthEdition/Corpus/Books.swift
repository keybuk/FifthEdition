//
//  Books.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//

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
public struct Books: Codable, Equatable, Sendable {
    /// Relative path of the data file within the 5etools source archive.
    public static let jsonPath: String = "data/books.json"

    /// Collection of source books.
    public var book: [Book] = []

    /// Initialize books.
    public init(_ book: [Book]) {
        self.book = book
    }
}

extension Books: ExpressibleByArrayLiteral {
    /// Initialize ``book`` from an array literal.
    public init(arrayLiteral elements: Book...) {
        self.init(elements)
    }
}
