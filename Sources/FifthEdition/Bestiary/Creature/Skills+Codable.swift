//
//  Skills+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.Skills: Codable {
    enum CodingKeys: String, CodingKey {
        case special
        case other
    }

    enum OtherCodingKeys: String, CodingKey {
        case oneOf
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object that may contain a special entry.
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        skills = [:]
        other = []
        for codingKey in container.allKeys {
            if let skill = Skill(codingKey: codingKey) {
                skills[skill] = try container.decode(AbilityModifier.self, forKey: codingKey)
            } else if codingKey.stringValue == CodingKeys.special.stringValue {
                // FIXME: actually Entry
                special = try container.decode(String.self, forKey: codingKey)
            } else if codingKey.stringValue == CodingKeys.other.stringValue {
                var arrayContainer = try container.nestedUnkeyedContainer(forKey: codingKey)
                while !arrayContainer.isAtEnd {
                    let nestedContainer = try arrayContainer.nestedContainer(keyedBy: OtherCodingKeys.self)
                    try other.insert(nestedContainer.decode([Skill: AbilityModifier].self, forKey: .oneOf))
                }
            } else {
                throw DecodingError.dataCorruptedError(forKey: codingKey,
                                                       in: container,
                                                       debugDescription: "Unknown skill: \(codingKey.stringValue)")
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        for (skill, abilityModifier) in skills {
            try container.encode(abilityModifier,
                                 forKey: DynamicCodingKey(stringValue: skill.codingKey.stringValue))
        }

        try container.encodeIfPresent(special,
                                      forKey: DynamicCodingKey(stringValue: CodingKeys.special.stringValue))

        if !other.isEmpty {
            var arrayContainer = container.nestedUnkeyedContainer(
                forKey: DynamicCodingKey(stringValue: CodingKeys.other.stringValue),
            )
            for otherSkills in other {
                var otherContainer = arrayContainer.nestedContainer(keyedBy: OtherCodingKeys.self)
                try otherContainer.encode(otherSkills, forKey: .oneOf)
            }
        }
    }
}
