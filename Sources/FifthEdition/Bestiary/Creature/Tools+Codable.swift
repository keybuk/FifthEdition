//
//  Tools+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.Tools: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a dictionary of tool to modifier.
        let container = try decoder.singleValueContainer()
        tools = try container.decode([Tool: AbilityModifier].self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(tools)
    }
}
