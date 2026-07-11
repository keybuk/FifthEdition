//
//  Alignments+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.Alignment: Codable {
    enum CodingKeys: String, CodingKey {
        case alignment
        case chance
        case note
        case special
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object, or a special object.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let special = try container.decodeIfPresent(String.self, forKey: .special) {
            self = .special(special)
        } else {
            try self.init(strings: container.decode(Set<String>.self, forKey: .alignment),
                          chance: container.decodeIfPresent(Int.self, forKey: .chance),
                          note: container.decodeIfPresent(String.self, forKey: .note))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .alignment(_, chance: chance, note: note):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(strings, forKey: .alignment)
            try container.encodeIfPresent(chance, forKey: .chance)
            try container.encodeIfPresent(note, forKey: .note)
        case let .special(special):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(special, forKey: .special)
        }
    }
}

extension Creature.Alignments: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is an array of alignments, or an array of strings for a single alignment.
        let container = try decoder.singleValueContainer()
        if let strings = try? container.decode(Set<String>.self) {
            alignments = [Creature.Alignment(strings: strings)]
        } else {
            alignments = try container.decode([Creature.Alignment].self)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if alignments.count == 1, case .alignment(_, chance: nil, note: nil) = alignments.first {
            try container.encode(alignments.first!.strings)
        } else {
            try container.encode(alignments)
        }
    }
}
