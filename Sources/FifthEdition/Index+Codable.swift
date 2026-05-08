//
//  Index+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

extension Index: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        entries = try container.decode([String: String].self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(entries)
    }
}
