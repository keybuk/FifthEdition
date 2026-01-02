//
//  Token+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

@testable import FifthEdition
import Testing

struct ArtItemCodableTests {
    @Test("Art item")
    func artItem() throws {
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

    @Test("Art item with page")
    func artItemWithPage() throws {
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

    @Test("Art item with custom token and credit")
    func artItemWithCustom() throws {
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

    @Test("Art item with tag")
    func artItemWithTag() throws {
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
    @Test("Token")
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

    @Test("Token with page")
    func tokenWithPage() throws {
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
