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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        alias = try container.decodeIfPresent([String].self, forKey: .alias) ?? []
        id = try container.decode(String.self, forKey: .id)
        source = try container.decode(String.self, forKey: .source)
        parentSource = try container.decodeIfPresent(String.self, forKey: .parentSource)
        group = try container.decode(Group.self, forKey: .group)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        alAveragePlayerLevel = try container.decodeIfPresent(Int.self, forKey: .alAveragePlayerLevel)
        alLength = try container.decodeIfPresent(LengthCoding.self, forKey: .alLength)?.value
        alId = try container.decodeIfPresent(String.self, forKey: .alId)
        contents = try container.decode([CorpusContents].self, forKey: .contents)
        level = try container.decode(Level.self, forKey: .level)

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

        publishedOrder = try container.decodeIfPresent(Int.self, forKey: .publishedOrder)
        cover = try container.decodeIfPresent(MediaHref.self, forKey: .cover)
        storyline = try container.decode(String.self, forKey: .storyline)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if !alias.isEmpty {
            try container.encode(alias, forKey: .alias)
        }
        try container.encode(id, forKey: .id)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(parentSource, forKey: .parentSource)
        try container.encode(group, forKey: .group)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encodeIfPresent(alAveragePlayerLevel, forKey: .alAveragePlayerLevel)
        try container.encodeIfPresent(alLength.map { LengthCoding($0) }, forKey: .alLength)
        try container.encodeIfPresent(alId, forKey: .alId)
        try container.encode(contents, forKey: .contents)
        try container.encode(level, forKey: .level)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        try container.encode(dateFormatter.string(from: published), forKey: .published)
        if let revised {
            try container.encode(dateFormatter.string(from: revised), forKey: .revised)
        }

        try container.encodeIfPresent(publishedOrder, forKey: .publishedOrder)
        try container.encodeIfPresent(cover, forKey: .cover)
        try container.encode(storyline, forKey: .storyline)
    }
}

extension Adventure {
    struct LengthCoding: Codable {
        enum CodingKeys: String, CodingKey {
            case exact
            case min
            case max
        }

        var value: ClosedRange<Int>

        init(_ value: ClosedRange<Int>) {
            self.value = value
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let exactValue = try? container.decode(Int.self, forKey: .exact) {
                value = exactValue...exactValue
            } else {
                value = try container.decode(Int.self, forKey: .min)...container.decode(Int.self, forKey: .max)
            }
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if value.count == 1 {
                try container.encode(value.lowerBound, forKey: .exact)
            } else {
                try container.encode(value.lowerBound, forKey: .min)
                try container.encode(value.upperBound, forKey: .max)
            }
        }
    }
}

extension Adventure.Level: Codable {
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
                container.decode(Int.self, forKey: .start)...container.decode(Int.self, forKey: .end),
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
