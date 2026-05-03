//
//  Entry.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//
//  Derived from schema-template/entry.json
//  Version: 1.9.17

import Foundation

public struct Entry: Codable, Equatable, Sendable {
    // TODO:
}

public struct Spellcasting: Codable, Equatable, Sendable {
    // TODO:
}

/// Link to media.
public enum MediaHref: Equatable, Sendable {
    /// Relative path with 5etools image archive.
    case path(String)

    /// External URL.
    case url(URL)
}
