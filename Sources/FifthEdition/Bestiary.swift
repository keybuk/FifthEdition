//
//  Bestiary.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//
//  Derived from schema/site/bestiary/bestiary.json
//  Version: 1.21.56

import MemberwiseInit

@MemberwiseInit(.public)
public struct Bestiary: Equatable, Codable, Sendable {
    public static let entryBasePath: String = "data/bestiary"
    public static let indexEntryPath: String = "\(entryBasePath)/index.json"

    public var monster: [Creature] = []
}
