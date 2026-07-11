//
//  Resources+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 8/22/26.
//

extension Creature.Resources: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case value
        case formula
    }

    public init(from decoder: any Decoder) throws {
        // Value is an array of resource objects.
        resources = [:]
        var arrayContainer = try decoder.unkeyedContainer()
        while !arrayContainer.isAtEnd {
            let container = try arrayContainer.nestedContainer(keyedBy: CodingKeys.self)
            let name = try container.decode(String.self, forKey: .name)
            let value = try container.decode(Int.self, forKey: .value)

            if let formula = try container.decodeIfPresent(String.self, forKey: .formula) {
                if let diceNotation = DiceNotation(string: formula) {
                    resources[name] = .resource(diceNotation, value: value != diceNotation.average ? value : nil)
                } else {
                    resources[name] = .value(value, formula: formula)
                }
            } else {
                resources[name] = .value(value)
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var arrayContainer = encoder.unkeyedContainer()
        for (name, resource) in resources {
            var container = arrayContainer.nestedContainer(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            switch resource {
            case let .resource(diceNotation, value):
                try container.encode(value ?? diceNotation.average, forKey: .value)
                try container.encode(diceNotation.description, forKey: .formula)
            case let .value(value, formula: formula):
                try container.encode(value, forKey: .value)
                try container.encodeIfPresent(formula, forKey: .formula)
            }
        }
    }
}
