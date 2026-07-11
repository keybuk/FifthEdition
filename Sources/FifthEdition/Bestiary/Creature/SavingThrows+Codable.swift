//
//  SavingThrows+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.SavingThrows: Codable {
    enum CodingKeys: String, CodingKey {
        case str
        case dex
        case con
        case int
        case wis
        case cha
        case special
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object that may contain a special entry.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        savingThrows = [:]
        savingThrows[.strength] = try container.decodeIfPresent(AbilityModifier.self, forKey: .str)
        savingThrows[.dexterity] = try container.decodeIfPresent(AbilityModifier.self, forKey: .dex)
        savingThrows[.constitution] = try container.decodeIfPresent(AbilityModifier.self, forKey: .con)
        savingThrows[.intelligence] = try container.decodeIfPresent(AbilityModifier.self, forKey: .int)
        savingThrows[.wisdom] = try container.decodeIfPresent(AbilityModifier.self, forKey: .wis)
        savingThrows[.charisma] = try container.decodeIfPresent(AbilityModifier.self, forKey: .cha)
        special = try container.decodeIfPresent(String.self, forKey: .special) // FIXME: Entry
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(savingThrows[.strength], forKey: .str)
        try container.encodeIfPresent(savingThrows[.dexterity], forKey: .dex)
        try container.encodeIfPresent(savingThrows[.constitution], forKey: .con)
        try container.encodeIfPresent(savingThrows[.intelligence], forKey: .int)
        try container.encodeIfPresent(savingThrows[.wisdom], forKey: .wis)
        try container.encodeIfPresent(savingThrows[.charisma], forKey: .cha)
        try container.encodeIfPresent(special, forKey: .special)
    }
}
