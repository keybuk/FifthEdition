//
//  Meta+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/25/26.
//

extension Meta: Codable {
    enum CodingKeys: String, CodingKey {
        case dependencies
        case internalCopies
        case otherSources
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dependencies = try container.decodeIfPresent([Entity: Set<String>].self, forKey: .dependencies) ?? [:]
        internalCopies = try container.decodeIfPresent(Set<Entity>.self, forKey: .internalCopies) ?? []
        otherSources = try container.decodeIfPresent([Entity: [String: String]].self, forKey: .otherSources) ?? [:]
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(!dependencies.isEmpty ? dependencies : nil, forKey: .dependencies)
        try container.encode(!internalCopies.isEmpty ? internalCopies : nil, forKey: .internalCopies)
        try container.encode(!otherSources.isEmpty ? otherSources : nil, forKey: .otherSources)
    }
}
