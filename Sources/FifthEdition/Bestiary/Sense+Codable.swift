//
//  Sense+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/19/26.
//

extension Sense: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string tag mapping to the enum.
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = switch value {
        case "B": .blindsight
        case "D": .darkvision
        case "SD": .superiorDarkvision
        case "T": .tremorsense
        case "U": .truesight
        default:
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Could not parse sense: \(value)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        let value = switch self {
        case .blindsight: "B"
        case .darkvision: "D"
        case .superiorDarkvision: "SD"
        case .tremorsense: "T"
        case .truesight: "U"
        }
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
