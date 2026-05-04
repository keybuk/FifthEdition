//
//  Bestiary.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//
//  Derived from schema-template/bestiary/bestiary.json
//  Version: 1.21.61

import MemberwiseInit

/// Bestiary.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Bestiary: Equatable, Sendable {
    /// Relative path of the directory within the 5etools source archive containing the per-source data files.
    public static let jsonBasePath: String = "data/bestiary"

    /// Relative path of the index data file within the 5etools source archive.
    public static let jsonIndexPath: String = "\(jsonBasePath)/index.json"

    /// List of monsters.
    public var monster: [Creature] = []

    /// Metadata.
    public var meta: MetaBlock?
}
