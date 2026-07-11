//
//  Homebrew+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/5/26.
//

import Foundation

extension Homebrew: Codable {
    enum CodingKeys: String, CodingKey {
        case meta = "_meta"
        // TODO: _test
        // TODO: $schema
        // TODO: blocklist
        case adventure
        // TODO: adventureData
        case monster
        // TODO: monsterFluff
        // TODO: legendaryGroup
        case book
        // TODO: bookData
        // TODO: <lots of things>
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(Meta.self, forKey: .meta)
        adventure = try container.decodeIfPresent([Adventure].self, forKey: .adventure) ?? []
        monster = try container.decodeIfPresent([Creature].self, forKey: .monster) ?? []
        book = try container.decodeIfPresent([Book].self, forKey: .book) ?? []
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(meta, forKey: .meta)
        try container.encodeIfPresent(!adventure.isEmpty ? adventure : nil, forKey: .adventure)
        try container.encodeIfPresent(!monster.isEmpty ? monster : nil, forKey: .monster)
        try container.encodeIfPresent(!book.isEmpty ? book : nil, forKey: .book)
    }
}

extension Homebrew.Meta: Codable {
    enum CodingKeys: String, CodingKey {
        case sources
        // TODO: spellSchools
        // TODO: spellDistanceUnits
        // TODO: optionalFeatureTypes
        // TODO: featCategories
        // TODO: psionicTypes
        // TODO: currencyConversions
        case added = "dateAdded"
        case lastModified = "dateLastModified"
        case lastModifiedHash = "_dateLastModifiedHash"
        case dependencies
        case includes
        case internalCopies
        // TODO: fonts
        case isUnlisted = "unlisted"
        case status
        case edition
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sources = try container.decode(Set<Source>.self, forKey: .sources)
        added = try Date(timeIntervalSince1970: container.decode(TimeInterval.self, forKey: .added))
        lastModified = try Date(timeIntervalSince1970: container.decode(TimeInterval.self, forKey: .lastModified))
        lastModifiedHash = try container.decodeIfPresent(String.self, forKey: .lastModifiedHash)
        dependencies = try container.decodeIfPresent([Entity: Set<String>].self, forKey: .dependencies) ?? [:]
        includes = try container.decodeIfPresent([Entity: Set<String>].self, forKey: .includes) ?? [:]
        internalCopies = try container.decodeIfPresent(Set<Entity>.self, forKey: .internalCopies) ?? []
        isUnlisted = try container.decodeIfPresent(Bool.self, forKey: .isUnlisted) ?? false
        status = try container.decodeIfPresent(Status.self, forKey: .status)
        edition = try container.decode(Edition.self, forKey: .edition)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sources, forKey: .sources)
        try container.encode(added.timeIntervalSince1970, forKey: .added)
        try container.encode(lastModified.timeIntervalSince1970, forKey: .lastModified)
        try container.encodeIfPresent(lastModifiedHash, forKey: .lastModifiedHash)
        try container.encodeIfPresent(!dependencies.isEmpty ? dependencies : nil, forKey: .dependencies)
        try container.encode(!includes.isEmpty ? includes : nil, forKey: .includes)
        try container.encode(!internalCopies.isEmpty ? internalCopies : nil, forKey: .internalCopies)
        try container.encode(isUnlisted ? true : nil, forKey: .isUnlisted)
        try container.encode(status, forKey: .status)
        try container.encode(edition, forKey: .edition)
    }
}

extension Homebrew.Meta.Source: Codable {
    enum CodingKeys: String, CodingKey {
        case source = "json"
        case abbreviation
        case color
        case colorNight
        case name = "full"
        case authors
        case convertedBy
        case released = "dateReleased"
        case version
        case url
        case isPartnered = "partnered"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(String.self, forKey: .source)
        abbreviation = try container.decode(String.self, forKey: .abbreviation)
        color = try container.decodeIfPresent(String.self, forKey: .color)
        colorNight = try container.decodeIfPresent(String.self, forKey: .colorNight)
        name = try container.decode(String.self, forKey: .name)
        authors = try container.decodeIfPresent([String].self, forKey: .authors) ?? []
        convertedBy = try container.decodeIfPresent([String].self, forKey: .convertedBy) ?? []
        released = try container.decodeIfPresent(Date.self, forKey: .released, configuration: .iso8601)
        version = try container.decode(String.self, forKey: .version)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        isPartnered = try container.decodeIfPresent(Bool.self, forKey: .isPartnered) ?? false
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(source, forKey: .source)
        try container.encode(abbreviation, forKey: .abbreviation)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(colorNight, forKey: .colorNight)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(!authors.isEmpty ? authors : nil, forKey: .authors)
        try container.encodeIfPresent(!convertedBy.isEmpty ? convertedBy : nil, forKey: .convertedBy)
        try container.encodeIfPresent(released, forKey: .released, configuration: .iso8601)
        try container.encode(version, forKey: .version)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encode(isPartnered ? true : nil, forKey: .isPartnered)
    }
}
