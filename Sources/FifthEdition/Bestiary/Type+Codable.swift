//
//  Type+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/30/26.
//

extension Alignment: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is an array of string tags combined to form alignment sets; but in practice it ends up being easier to
        // treat it as a set of constants.
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Set<String>.self)
        self = switch values {
        case ["U"]: .unaligned
        case ["A"]: .any
        case ["L"]: .lawful
        case ["C"]: .chaotic
        case ["N"]: .neutral
        case ["G"]: .good
        case ["E"]: .evil
        case ["L", "G"]: .lawfulGood
        case ["L", "N"]: .lawfulNeutral
        case ["L", "E"]: .lawfulEvil
        case ["N", "G"]: .neutralGood
        case ["N", "E"]: .neutralEvil
        case ["C", "G"]: .chaoticGood
        case ["C", "N"]: .chaoticNeutral
        case ["C", "E"]: .chaoticEvil
        case ["N", "NX", "NY"]: .anyNeutral
        case ["L", "NY", "G", "E"]: .anyLawful
        case ["C", "NY", "G", "E"]: .anyChaotic
        case ["L", "C", "NX", "G"]: .anyGood
        case ["L", "C", "NX", "E"]: .anyEvil
        case ["C", "NX", "NY", "G", "E"]: .anyNonLawful
        case ["L", "NX", "NY", "G", "E"]: .anyNonChaotic
        case ["L", "C", "NX", "NY", "E"]: .anyNonGood
        case ["L", "C", "NX", "NY", "G"]: .anyNonEvil
        default:
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Could not parse alignment: \(values)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        let values = switch self {
        case .unaligned: ["U"]
        case .any: ["A"]
        case .lawful: ["L"]
        case .chaotic: ["C"]
        case .neutral: ["N"]
        case .good: ["G"]
        case .evil: ["E"]
        case .lawfulGood: ["L", "G"]
        case .lawfulNeutral: ["L", "N"]
        case .lawfulEvil: ["L", "E"]
        case .neutralGood: ["N", "G"]
        case .neutralEvil: ["N", "E"]
        case .chaoticGood: ["C", "G"]
        case .chaoticNeutral: ["C", "N"]
        case .chaoticEvil: ["C", "E"]
        case .anyNeutral: ["N", "NX", "NY"]
        case .anyLawful: ["L", "NY", "G", "E"]
        case .anyChaotic: ["C", "NY", "G", "E"]
        case .anyGood: ["L", "C", "NX", "G"]
        case .anyEvil: ["L", "C", "NX", "E"]
        case .anyNonLawful: ["C", "NX", "NY", "G", "E"]
        case .anyNonChaotic: ["L", "NX", "NY", "G", "E"]
        case .anyNonGood: ["L", "C", "NX", "NY", "E"]
        case .anyNonEvil: ["L", "C", "NX", "NY", "G"]
        }
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
}

extension Size: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string tag mapping to the enum.
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = switch string {
        case "F": .fine
        case "D": .diminutive
        case "T": .tiny
        case "S": .small
        case "M": .medium
        case "L": .large
        case "H": .huge
        case "G": .gargantuan
        case "C": .colossal
        case "V": .varies
        default:
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Could not parse size: \(string)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        let string = switch self {
        case .fine: "F"
        case .diminutive: "D"
        case .tiny: "T"
        case .small: "S"
        case .medium: "M"
        case .large: "L"
        case .huge: "H"
        case .gargantuan: "G"
        case .colossal: "C"
        case .varies: "V"
        }
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}

extension Tag: Codable {
    enum CodingKeys: String, CodingKey {
        case tag
        case prefix
        case isPrefixHidden = "prefixHidden"
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object or a string.
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            tag = value
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            tag = try container.decode(String.self, forKey: .tag)
            prefix = try container.decode(String.self, forKey: .prefix)
            isPrefixHidden = try container.decodeIfPresent(Bool.self, forKey: .isPrefixHidden) ?? false
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if prefix == nil, !isPrefixHidden {
            var container = encoder.singleValueContainer()
            try container.encode(tag)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(tag, forKey: .tag)
            try container.encode(prefix, forKey: .prefix)
            try container.encodeIfPresent(isPrefixHidden ? true : nil, forKey: .isPrefixHidden)
        }
    }
}
