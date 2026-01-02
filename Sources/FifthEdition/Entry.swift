//
//  Entry.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//
//  Derived from schema/site/entry.json
//  Version: 1.9.16

import Foundation

public struct Entry: Codable, Equatable, Sendable {
    // TODO:
}

public struct Spellcasting: Codable, Equatable, Sendable {
    // TODO:
}

public enum MediaHref: Equatable, Sendable {
    case path(String)
    case url(URL)
}
