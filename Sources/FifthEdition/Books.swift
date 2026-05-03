//
//  Books.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//
//  Derived from schema-template/books.json
//  Version: 1.2.19

import MemberwiseInit

/// Books.
@MemberwiseInit(.public)
public struct Books: Codable, Equatable, Sendable {
    /// Relative path of the data file within the 5etools source archive.
    public static let jsonPath: String = "data/books.json"

    /// List of books.
    public var book: [Book] = []
}
