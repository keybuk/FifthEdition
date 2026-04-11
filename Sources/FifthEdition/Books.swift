//
//  Books.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//
//  Derived from schema-template/books.json
//  Version: 1.2.19

import MemberwiseInit

@MemberwiseInit(.public)
public struct Books: Equatable, Codable, Sendable {
    public static let entryPath: String = "data/books.json"

    public var book: [Book] = []
}
