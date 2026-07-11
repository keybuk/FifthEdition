//
//  Entry.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

import Foundation

public struct Entry: Codable, Equatable, Hashable, Sendable {
    // TODO:
}

public struct Spellcasting: Codable, Equatable, Hashable, Sendable {
    // TODO:
}

/// Link to media.
public enum MediaHref: Equatable, Hashable, Sendable {
    /// Relative path with 5etools image archive.
    case path(String)

    /// External URL.
    case url(URL)
}
