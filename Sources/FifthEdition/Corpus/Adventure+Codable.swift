//
//  Adventure+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Foundation

extension Adventure: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case alias
        case id
        case source
        case parentSource
        case group
        case author
        case alAveragePlayerLevel
        case alLength
        case alId
        case contents
        case level
        case published
        case revised
        case publishedOrder
        case cover
        case storyline
    }

    enum LengthCodingKeys: String, CodingKey {
        case exact
        case min
        case max
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        alias = try container.decodeIfPresent([String].self, forKey: .alias) ?? []
        id = try container.decode(String.self, forKey: .id)
        source = try container.decode(String.self, forKey: .source)
        parentSource = try container.decodeIfPresent(String.self, forKey: .parentSource)
        group = try container.decode(AdventureGroup.self, forKey: .group)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        alAveragePlayerLevel = try container.decodeIfPresent(Int.self, forKey: .alAveragePlayerLevel)

        // alLength is an object we turn into a range.
        if container.contains(.alLength) {
            let nestedContainer = try container.nestedContainer(keyedBy: LengthCodingKeys.self, forKey: .alLength)
            if let exactValue = try nestedContainer.decodeIfPresent(Int.self, forKey: .exact) {
                alLength = exactValue...exactValue
            } else {
                alLength = try nestedContainer
                    .decode(Int.self, forKey: .min)...nestedContainer.decode(Int.self, forKey: .max)
            }
        }

        alId = try container.decodeIfPresent(String.self, forKey: .alId)
        contents = try container.decode([CorpusContents].self, forKey: .contents)
        level = try container.decode(AdventureLevel.self, forKey: .level)
        published = try container.decode(Date.self, forKey: .published, configuration: .iso8601)
        revised = try container.decodeIfPresent(Date.self, forKey: .revised, configuration: .iso8601)
        publishedOrder = try container.decodeIfPresent(Int.self, forKey: .publishedOrder)
        cover = try container.decodeIfPresent(MediaHref.self, forKey: .cover)
        storyline = try container.decode(String.self, forKey: .storyline)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(!alias.isEmpty ? alias : nil, forKey: .alias)
        try container.encode(id, forKey: .id)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(parentSource, forKey: .parentSource)
        try container.encode(group, forKey: .group)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encodeIfPresent(alAveragePlayerLevel, forKey: .alAveragePlayerLevel)

        // alLength is encoded as an object for the range.
        if let alLength {
            var nestedContainer = container.nestedContainer(keyedBy: LengthCodingKeys.self, forKey: .alLength)
            if alLength.count == 1 {
                try nestedContainer.encode(alLength.lowerBound, forKey: .exact)
            } else {
                try nestedContainer.encode(alLength.lowerBound, forKey: .min)
                try nestedContainer.encode(alLength.upperBound, forKey: .max)
            }
        }

        try container.encodeIfPresent(alId, forKey: .alId)
        try container.encode(contents, forKey: .contents)
        try container.encode(level, forKey: .level)
        try container.encode(published, forKey: .published, configuration: .iso8601)
        try container.encodeIfPresent(revised, forKey: .revised, configuration: .iso8601)
        try container.encodeIfPresent(publishedOrder, forKey: .publishedOrder)
        try container.encodeIfPresent(cover, forKey: .cover)
        try container.encode(storyline, forKey: .storyline)
    }
}

extension AdventureLevel: Codable {
    enum CodingKeys: String, CodingKey {
        case start
        case end
        case special = "custom"
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object we turn into a range, or a special string.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(String.self, forKey: .special) {
            self = .special(value)
        } else {
            self = try .range(container.decode(Int.self, forKey: .start)...container.decode(Int.self, forKey: .end))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .range(value):
            try container.encode(value.lowerBound, forKey: .start)
            try container.encode(value.upperBound, forKey: .end)
        case let .special(value):
            try container.encode(value, forKey: .special)
        }
    }
}
