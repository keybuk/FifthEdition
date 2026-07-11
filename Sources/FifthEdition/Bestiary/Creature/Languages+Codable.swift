//
//  Languages+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/20/26.
//

extension Creature.Languages: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string array.
        let container = try decoder.singleValueContainer()
        try self.init(strings: container.decode([String].self))
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(strings)
    }
}
