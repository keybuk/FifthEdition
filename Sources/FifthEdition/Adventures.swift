//
//  Adventures.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//
//  Derived from schema-template/adventures.json
//  Version: 1.10.34

import MemberwiseInit

public typealias Adventure = Book

@MemberwiseInit(.public)
public struct Adventures: Codable, Equatable, Sendable {
    public static let entryPath: String = "data/adventures.json"

    public var adventure: [Adventure] = []
}
