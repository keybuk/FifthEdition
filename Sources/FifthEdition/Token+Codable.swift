//
//  Token+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//
//  Derived from schema/site/util-token.json
//  Version: 1.0.3

extension ArtItem {
    enum CodingKeys: String, CodingKey {
        case name
        case source
        case page
        case tokenCredit
        case isTokenCustom = "tokenCustom"
        case tokenTags
    }
}
