//
//  Type+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/30/26.
//

import Foundation

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
