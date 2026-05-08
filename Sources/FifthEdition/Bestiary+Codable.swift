//
//  Bestiary+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

extension Bestiary {
    enum CodingKeys: String, CodingKey {
        case monster
        case meta = "_meta"
    }
}
