//
//  Senses+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.Sense: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string we parse.
        let container = try decoder.singleValueContainer()
        self = try Self(string: container.decode(String.self))
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
