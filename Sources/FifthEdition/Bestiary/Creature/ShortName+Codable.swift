//
//  ShortName+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/23/26.
//

extension Creature.ShortName: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = if let value = try? container.decode(Bool.self), value {
            .name
        } else {
            try .custom(container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .name: try container.encode(true)
        case let .custom(value): try container.encode(value)
        }
    }
}
