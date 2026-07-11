//
//  Resource+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/24/26.
//

extension Gear: Codable {
    enum CodingKeys: String, CodingKey {
        case item
        case quantity
        case displayName
    }

    public init(from decoder: any Decoder) throws {
        // Value is an string item reference, or an object.
        if let container = try? decoder.singleValueContainer(),
           let item = try? container.decode(String.self)
        {
            if let gear = Self(uid: item) {
                self = gear
            } else {
                throw DecodingError.dataCorruptedError(in: container,
                                                       debugDescription: "Could not parse gear: \(item)")
            }
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let item = try container.decode(String.self, forKey: .item)
            if let gear = try Self(uid: item,
                                   displayName: container.decodeIfPresent(String.self, forKey: .displayName),
                                   quantity: container.decodeIfPresent(Int.self, forKey: .quantity) ?? 1)
            {
                self = gear
            } else {
                throw DecodingError.dataCorruptedError(forKey: .item,
                                                       in: container,
                                                       debugDescription: "Could not parse gear: \(item)")
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if quantity == 1, displayName == nil {
            var container = encoder.singleValueContainer()
            try container.encode(uid)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(uid, forKey: .item)
            try container.encodeIfPresent(quantity != 1 ? quantity : nil, forKey: .quantity)
            try container.encodeIfPresent(displayName, forKey: .displayName)
        }
    }
}
