//
//  Susceptible+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/30/26.
//

import Foundation

extension Susceptible: CodableWithConfiguration {
    public enum CodingConfiguration {
        case conditionImmunity
        case damageImmunity
        case damageResistance
        case damageVulnerability
    }

    enum CodingKeys: String, CodingKey {
        case conditionImmune
        case immune
        case resist
        case vulnerable

        case preNote
        case note
        case isConditional = "cond"
        case special
    }

    static func codingKey(for configuration: CodingConfiguration) -> CodingKeys {
        switch configuration {
        case .conditionImmunity: .conditionImmune
        case .damageImmunity: .immune
        case .damageResistance: .resist
        case .damageVulnerability: .vulnerable
        }
    }

    public init(from decoder: any Decoder, configuration: CodingConfiguration) throws {
        // Value is a single condition or damage type, or an object, or a a special object.
        if configuration == .conditionImmunity,
           let condition = try? decoder.singleValueContainer().decode(Condition.self)
        {
            self = .condition(condition)
        } else if configuration != .conditionImmunity,
                  let damage = try? decoder.singleValueContainer().decode(Damage.self)
        {
            self = .damage(damage)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let special = try container.decodeIfPresent(String.self, forKey: .special) {
                self = .special(special)
            } else {
                self = try .susceptible(
                    container.decode(Set<Susceptible>.self,
                                     forKey: Self.codingKey(for: configuration),
                                     configuration: configuration),
                    preNote: container.decodeIfPresent(String.self, forKey: .preNote),
                    note: container.decodeIfPresent(String.self, forKey: .note),
                    isConditional: container.decodeIfPresent(Bool.self, forKey: .isConditional) ?? false,
                )
            }
        }
    }

    public func encode(to encoder: any Encoder, configuration: CodingConfiguration) throws {
        switch self {
        case let .condition(condition):
            var container = encoder.singleValueContainer()
            try container.encode(condition)
        case let .damage(damage):
            var container = encoder.singleValueContainer()
            try container.encode(damage)
        case let .special(value):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(value, forKey: .special)
        case let .susceptible(susceptible, preNote, note, isConditional):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(susceptible, forKey: Self.codingKey(for: configuration), configuration: configuration)
            try container.encodeIfPresent(preNote, forKey: .preNote)
            try container.encodeIfPresent(note, forKey: .note)
            try container.encodeIfPresent(isConditional ? true : nil, forKey: .isConditional)
        }
    }
}
