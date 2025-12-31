//
//  Token.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//
//  Derived from schema/site/util-token.json
//  Version: 1.0.3

import MemberwiseInit

@MemberwiseInit(.public)
public struct ArtItem: Codable, Equatable, Sendable {
    public enum TokenTag: String, Codable, Equatable, Sendable {
        case topDown
    }

    public var name: String
    public var source: String
    public var page: Page? = nil
    public var tokenCredit: String? = nil
    public var isTokenCustom: Bool? = nil
    public var tokenTags: Set<TokenTag>? = nil
}

@MemberwiseInit(.public)
public struct Token: Codable, Equatable, Sendable {
    public var name: String
    public var source: String
    public var page: Page? = nil
}
