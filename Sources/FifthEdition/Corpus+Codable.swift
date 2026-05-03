//
//  Corpus+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Foundation

extension CorpusContents: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case headers
        case ordinal
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        headers = try container.decodeIfPresent([Header].self, forKey: .headers) ?? []
        ordinal = try container.decodeIfPresent(Ordinal.self, forKey: .ordinal)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if !headers.isEmpty {
            try container.encode(headers, forKey: .headers)
        }
        try container.encodeIfPresent(ordinal, forKey: .ordinal)
    }
}

extension CorpusContents.Header: Codable {
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

extension CorpusContents.Ordinal: Codable {
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
        self = switch try container.decode(TypeCodingValues.self, forKey: .type) {
        case .chapter:
            .chapter(integer: try? container.decode(Int.self, forKey: .identifier),
                     string: try? container.decode(String.self, forKey: .identifier))
        case .appendix:
            .appendix(integer: try? container.decode(Int.self, forKey: .identifier),
                      string: try? container.decode(String.self, forKey: .identifier))
        case .part:
            .part(integer: try? container.decode(Int.self, forKey: .identifier),
                  string: try? container.decode(String.self, forKey: .identifier))
        case .episode:
            .episode(integer: try? container.decode(Int.self, forKey: .identifier),
                     string: try? container.decode(String.self, forKey: .identifier))
        case .level:
            .level(integer: try? container.decode(Int.self, forKey: .identifier),
                   string: try? container.decode(String.self, forKey: .identifier))
        case .section:
            .section(integer: try? container.decode(Int.self, forKey: .identifier),
                     string: try? container.decode(String.self, forKey: .identifier))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .chapter(integerValue, nil):
            try container.encode(TypeCodingValues.chapter, forKey: .type)
            try container.encode(integerValue, forKey: .identifier)
        case let .chapter(nil, stringValue):
            try container.encode(TypeCodingValues.chapter, forKey: .type)
            try container.encode(stringValue, forKey: .identifier)
        case .chapter:
            try container.encode(TypeCodingValues.chapter, forKey: .type)
        case let .appendix(integerValue, nil):
            try container.encode(TypeCodingValues.appendix, forKey: .type)
            try container.encode(integerValue, forKey: .identifier)
        case let .appendix(nil, stringValue):
            try container.encode(TypeCodingValues.appendix, forKey: .type)
            try container.encode(stringValue, forKey: .identifier)
        case .appendix:
            try container.encode(TypeCodingValues.appendix, forKey: .type)
        case let .part(integerValue, nil):
            try container.encode(TypeCodingValues.part, forKey: .type)
            try container.encode(integerValue, forKey: .identifier)
        case let .part(nil, stringValue):
            try container.encode(TypeCodingValues.part, forKey: .type)
            try container.encode(stringValue, forKey: .identifier)
        case .part:
            try container.encode(TypeCodingValues.part, forKey: .type)
        case let .episode(integerValue, nil):
            try container.encode(TypeCodingValues.episode, forKey: .type)
            try container.encode(integerValue, forKey: .identifier)
        case let .episode(nil, stringValue):
            try container.encode(TypeCodingValues.episode, forKey: .type)
            try container.encode(stringValue, forKey: .identifier)
        case .episode:
            try container.encode(TypeCodingValues.episode, forKey: .type)
        case let .level(integerValue, nil):
            try container.encode(TypeCodingValues.level, forKey: .type)
            try container.encode(integerValue, forKey: .identifier)
        case let .level(nil, stringValue):
            try container.encode(TypeCodingValues.chapter, forKey: .type)
            try container.encode(stringValue, forKey: .identifier)
        case .level:
            try container.encode(TypeCodingValues.level, forKey: .type)
        case let .section(integerValue, nil):
            try container.encode(TypeCodingValues.section, forKey: .type)
            try container.encode(integerValue, forKey: .identifier)
        case let .section(nil, stringValue):
            try container.encode(TypeCodingValues.section, forKey: .type)
            try container.encode(stringValue, forKey: .identifier)
        case .section:
            try container.encode(TypeCodingValues.section, forKey: .type)
        }
    }
}
