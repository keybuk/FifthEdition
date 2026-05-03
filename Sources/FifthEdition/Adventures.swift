//
//  Adventures.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//
//  Derived from schema-template/adventures.json
//  Version: 1.10.34

import MemberwiseInit

/// Adventures.
@MemberwiseInit(.public)
public struct Adventures: Codable, Equatable, Sendable {
    /// Relative path of the data file within the 5etools source archive.
    public static let jsonPath: String = "data/adventures.json"

    /// List of adventures.
    public var adventure: [Adventure] = []
}
