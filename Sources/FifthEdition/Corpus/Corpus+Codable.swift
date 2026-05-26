//
//  Corpus+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

extension CorpusContents: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case headers
        case ordinal
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        headers = try container.decodeIfPresent([CorpusHeader].self, forKey: .headers) ?? []
        ordinal = try container.decodeIfPresent(CorpusOrdinal.self, forKey: .ordinal)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(!headers.isEmpty ? headers : nil, forKey: .headers)
        try container.encodeIfPresent(ordinal, forKey: .ordinal)
    }
}

extension CorpusHeader: Codable {
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

extension CorpusOrdinal: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case identifier
    }

    enum TypeCodingValues: String, Codable {
        case chapter
        case appendix
        case part
        case episode
        case level
        case section
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decodeIfPresent(Ordinal.self, forKey: .identifier)

        self = switch try container.decode(TypeCodingValues.self, forKey: .type) {
        case .chapter: .chapter(identifier)
        case .appendix: .appendix(identifier)
        case .part: .part(identifier)
        case .episode: .episode(identifier)
        case .level: .level(identifier)
        case .section: .section(identifier)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .chapter(identifier):
            try container.encode(TypeCodingValues.chapter, forKey: .type)
            try container.encodeIfPresent(identifier, forKey: .identifier)
        case let .appendix(identifier):
            try container.encode(TypeCodingValues.appendix, forKey: .type)
            try container.encodeIfPresent(identifier, forKey: .identifier)
        case let .part(identifier):
            try container.encode(TypeCodingValues.part, forKey: .type)
            try container.encodeIfPresent(identifier, forKey: .identifier)
        case let .episode(identifier):
            try container.encode(TypeCodingValues.episode, forKey: .type)
            try container.encodeIfPresent(identifier, forKey: .identifier)
        case let .level(identifier):
            try container.encode(TypeCodingValues.level, forKey: .type)
            try container.encodeIfPresent(identifier, forKey: .identifier)
        case let .section(identifier):
            try container.encode(TypeCodingValues.section, forKey: .type)
            try container.encodeIfPresent(identifier, forKey: .identifier)
        }
    }
}
