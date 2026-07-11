//
//  Alignments+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.Alignment: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let _ = try? container.decode(Set<String>.self) {
            alignment = try [.alignment(container.decode(FifthEdition.Alignment.self))]
        } else {
            alignment = try container.decode([Alignment].self)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if alignment.count == 1, case let .alignment(value, nil, nil) = alignment.first {
            try container.encode(value)
        } else {
            try container.encode(alignment)
        }
    }
}

extension Creature.Alignment.Alignment: Codable {
    enum CodingKeys: String, CodingKey {
        case alignment
        case chance
        case note
        case special
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object or a special object.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(String.self, forKey: .special) {
            self = .special(value)
        } else {
            self = try .alignment(container.decode(FifthEdition.Alignment.self, forKey: .alignment),
                                  chance: container.decodeIfPresent(Int.self, forKey: .chance),
                                  note: container.decodeIfPresent(String.self, forKey: .note))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .alignment(alignment, chance, note):
            try container.encode(alignment, forKey: .alignment)
            try container.encodeIfPresent(chance, forKey: .chance)
            try container.encodeIfPresent(note, forKey: .note)
        case let .special(special):
            try container.encode(special, forKey: .special)
        }
    }
}
