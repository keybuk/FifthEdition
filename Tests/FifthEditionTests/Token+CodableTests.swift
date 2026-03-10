//
//  Token+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

import Testing
@testable import FifthEdition

struct ArtItemCodableTests {
    @Test
    func `Art item`() throws {
        try testCodable(
            json: """
            {
                "name": "Adult Red Dragon",
                "source": "MM",
            }
            """,
            value: ArtItem(
                name: "Adult Red Dragon",
                source: "MM",
            ),
        )
    }

    @Test
    func `Art item with page`() throws {
        try testCodable(
            json: """
            {
                "name": "Acererak",
                "source": "MM",
                "page": 49
            }
            """,
            value: ArtItem(
                name: "Acererak",
                source: "MM",
                page: .number(49),
            ),
        )
    }

    @Test
    func `Art item with custom token and credit`() throws {
        try testCodable(
            json: """
            {
                "name": "Spellcaster",
                "source": "ESK",
                "tokenCredit": "Bob",
                "tokenCustom": true
            }
            """,
            value: ArtItem(
                name: "Spellcaster",
                source: "ESK",
                tokenCredit: "Bob",
                isTokenCustom: true,
            ),
        )
    }

    @Test
    func `Art item with tag`() throws {
        try testCodable(
            json: """
            {
                "name": "Myconid Adult",
                "source": "XMM",
                "tokenTags": [
                    "topDown"
                ]
            }
            """,
            value: ArtItem(
                name: "Myconid Adult",
                source: "XMM",
                tokenTags: [.topDown],
            ),
        )
    }
}

struct TokenCodableTests {
    @Test
    func token() throws {
        try testCodable(
            json: """
            {
                "name": "Adult Red Dragon",
                "source": "MM"
            }
            """,
            value: Token(
                name: "Adult Red Dragon",
                source: "MM",
            ),
        )
    }

    @Test
    func `Token with page`() throws {
        try testCodable(
            // While not in the schema, the sole use of this in the bestiary has a page reference.
            json: """
            {
                "name": "Acererak",
                "source": "MM",
                "page": 49
            }
            """,
            value: Token(
                name: "Acererak",
                source: "MM",
                page: .number(49),
            ),
        )
    }
}
