//
//  DiceNotation+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/28/26.
//

extension DiceNotation: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let notation = DiceNotation(stringValue) else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Could not parse dice notation: \(stringValue)")
        }

        self = notation
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
