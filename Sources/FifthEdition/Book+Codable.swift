//
//  Book+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/8/26.
//

import Foundation

extension Book: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case alias
        case id
        case source
        case parentSource
        case isLegacy = "legacy"
        case group
        case publishedOrder
        case author
        case published
        case revised
        case level
        case storyline
        case cover
        case contents
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        alias = try container.decodeIfPresent([String].self, forKey: .alias)
        id = try container.decode(String.self, forKey: .id)
        source = try container.decode(String.self, forKey: .source)
        parentSource = try container.decodeIfPresent(String.self, forKey: .parentSource)
        isLegacy = try container.decodeIfPresent(Bool.self, forKey: .isLegacy)
        group = try container.decode(BookGroup.self, forKey: .group)
        publishedOrder = try container.decodeIfPresent(Int.self, forKey: .publishedOrder)
        author = try container.decodeIfPresent(String.self, forKey: .author)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let publishedDateStr = try container.decode(String.self, forKey: .published)
        if let publishedDate = dateFormatter.date(from: publishedDateStr) {
            published = publishedDate
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .published,
                in: container,
                debugDescription: "Invalid date: \(publishedDateStr)",
            )
        }

        if let revisedDateStr = try container.decodeIfPresent(String.self, forKey: .revised) {
            if let revisedDate = dateFormatter.date(from: revisedDateStr) {
                revised = revisedDate
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .revised,
                    in: container,
                    debugDescription: "Invalid date: \(publishedDateStr)",
                )
            }
        }

        level = try container.decodeIfPresent(Level.self, forKey: .level)
        storyline = try container.decodeIfPresent(Storyline.self, forKey: .storyline)
        cover = try container.decodeIfPresent(MediaHref.self, forKey: .cover)
        contents = try container.decode([Contents].self, forKey: .contents)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(alias, forKey: .alias)
        try container.encode(id, forKey: .id)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(parentSource, forKey: .parentSource)
        try container.encodeIfPresent(isLegacy, forKey: .isLegacy)
        try container.encode(group, forKey: .group)
        try container.encodeIfPresent(publishedOrder, forKey: .publishedOrder)
        try container.encodeIfPresent(author, forKey: .author)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        try container.encode(dateFormatter.string(from: published), forKey: .published)
        if let revised {
            try container.encode(dateFormatter.string(from: revised), forKey: .revised)
        }

        try container.encodeIfPresent(level, forKey: .level)
        try container.encodeIfPresent(storyline, forKey: .storyline)
        try container.encodeIfPresent(cover, forKey: .cover)
        try container.encode(contents, forKey: .contents)
    }
}

extension Book.Contents.Header: Codable {
    enum CodingKeys: String, CodingKey {
        case header
        case depth
        case index
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            header = value
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            header = try container.decode(String.self, forKey: .header)
            depth = try container.decodeIfPresent(Int.self, forKey: .depth)
            index = try container.decodeIfPresent(Int.self, forKey: .index)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if depth == nil, index == nil {
            var container = encoder.singleValueContainer()
            try container.encode(header)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(header, forKey: .header)
            try container.encodeIfPresent(depth, forKey: .depth)
            try container.encodeIfPresent(index, forKey: .index)
        }
    }
}

extension Book.Contents.Ordinal.Identifier: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            let value = try container.decode(Int.self)
            self = .integer(value)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(value): try container.encode(value)
        case let .integer(value): try container.encode(value)
        }
    }
}

extension Book.Level: Codable {
    enum CodingKeys: String, CodingKey {
        case start
        case end
        case custom
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(String.self, forKey: .custom) {
            self = .custom(value)
        } else {
            self = try .range(
                container.decode(Int.self, forKey: .start) ... container.decode(Int.self, forKey: .end),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .range(value):
            try container.encode(value.lowerBound, forKey: .start)
            try container.encode(value.upperBound, forKey: .end)
        case let .custom(value):
            try container.encode(value, forKey: .custom)
        }
    }
}
