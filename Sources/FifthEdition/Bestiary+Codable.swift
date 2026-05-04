//
//  Bestiary+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

extension Bestiary: Codable {
    enum CodingKeys: String, CodingKey {
        case monster
        case meta = "_meta"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        monster = try container.decode([Creature].self, forKey: .monster)
        meta = try container.decodeIfPresent(MetaBlock.self, forKey: .meta)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(monster, forKey: .monster)
        try container.encodeIfPresent(meta, forKey: .meta)
    }
}
