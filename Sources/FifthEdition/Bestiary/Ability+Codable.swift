//
//  Ability+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

extension Ability: CodingKeyRepresentable {
    public var codingKey: any CodingKey {
        DynamicCodingKey(stringValue: String(rawValue.prefix(3)))
    }

    public init?(codingKey: some CodingKey) {
        guard let ability = Ability.allCases.first(where: { codingKey.stringValue == $0.rawValue.prefix(3) })
        else { return nil }
        self = ability
    }
}

extension AbilityModifier: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string that may be parsed as an integer modifier or a special rule.
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let modifier = Int(string) {
            self = .modifier(modifier)
        } else {
            self = .special(string)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .modifier(modifier): try container.encode(modifier.formatted(.number.sign(strategy: .always())))
        case let .special(special): try container.encode(special)
        }
    }
}

extension AbilityScore: Codable {
    enum CodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        // Value is an integer, or a special object.
        if let special = try? decoder
            .container(keyedBy: CodingKeys.self)
            .decode(String.self, forKey: .special)
        {
            self = .special(special)
        } else {
            let container = try decoder.singleValueContainer()
            self = try .score(container.decode(Int.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .score(score):
            var container = encoder.singleValueContainer()
            try container.encode(score)
        case let .special(special):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(special, forKey: .special)
        }
    }
}

extension Advantage: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string mapping to the enum.
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = switch string {
        case "adv": .advantage
        case "dis": .disadvantage
        default:
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Could not parse advantage mode: \(string)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        let string = switch self {
        case .advantage: "adv"
        case .disadvantage: "dis"
        }
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}

extension Initiative: Codable {
    enum CodingKeys: String, CodingKey {
        case initiative
        case proficiency
        case advantage = "advantageMode"
    }

    public init(from decoder: any Decoder) throws {
        // Value is an integer modifier, or an object containing a single property.
        if let modifier = try? decoder.singleValueContainer().decode(Int.self) {
            self = .modifier(modifier)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard container.allKeys.count == 1 else {
                throw DecodingError.dataCorruptedError(forKey: container.allKeys[1],
                                                       in: container,
                                                       debugDescription: "Expected a single property")
            }

            if let proficiency = try container.decodeIfPresent(Proficiency.self, forKey: .proficiency) {
                self = .proficiency(proficiency)
            } else if let advantage = try container.decodeIfPresent(Advantage.self, forKey: .advantage) {
                self = .advantage(advantage)
            } else {
                self = try .modifier(container.decode(Int.self, forKey: .initiative))
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .modifier(modifier):
            var container = encoder.singleValueContainer()
            try container.encode(modifier)
        case let .proficiency(proficiency):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(proficiency, forKey: .proficiency)
        case let .advantage(advantage):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(advantage, forKey: .advantage)
        }
    }
}

extension Passive: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is an integer modifier, or a special string.
        let container = try decoder.singleValueContainer()
        if let special = try? container.decode(String.self) {
            self = .special(special)
        } else {
            self = try .passive(container.decode(Int.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .passive(passive):
            var container = encoder.singleValueContainer()
            try container.encode(passive)
        case let .special(special):
            var container = encoder.singleValueContainer()
            try container.encode(special)
        }
    }
}
