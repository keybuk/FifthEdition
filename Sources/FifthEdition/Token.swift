//
//  Token.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//
//  Derived from schema/site/util-token.json
//  Version: 1.0.3

import MemberwiseInit

@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct ArtItem: Codable, Equatable, Sendable {
    public enum TokenTag: String, Codable, Equatable, Sendable {
        case topDown
    }

    public var name: String
    public var source: String
    public var page: Page?
    public var tokenCredit: String?
    public var isTokenCustom: Bool?
    public var tokenTags: Set<TokenTag>?
}

@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Token: Codable, Equatable, Sendable {
    public var name: String
    public var source: String
    public var page: Page?
}
