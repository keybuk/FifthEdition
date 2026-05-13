//
//  Corpus+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Testing
@testable import FifthEdition

struct CorpusContentsCodableTests {
    @Test
    func `Contents with name only`() throws {
        try testCodable(
            json: """
            {
                "name": "The Basics"
            }
            """,
            value: CorpusContents("The Basics"),
        )
    }

    @Test
    func `Contents with headers`() throws {
        try testCodable(
            json: """
            {
                "name": "The Basics",
                "headers": [
                    "What Does a DM Do?",
                    "Things You Need",
                    "Preparing a Session",
                    "How to Run a Session",
                    "Example of Play",
                    "Every DM Is Unique",
                    "Ensuring Fun for All"
                ]
            }
            """,
            value: CorpusContents("The Basics",
                                  headers: [
                                      CorpusContents.Header("What Does a DM Do?"),
                                      CorpusContents.Header("Things You Need"),
                                      CorpusContents.Header("Preparing a Session"),
                                      CorpusContents.Header("How to Run a Session"),
                                      CorpusContents.Header("Example of Play"),
                                      CorpusContents.Header("Every DM Is Unique"),
                                      CorpusContents.Header("Ensuring Fun for All"),
                                  ]),
        )
    }

    @Test
    func `Contents with header at depth`() throws {
        try testCodable(
            json: """
            {
                "name": "Growing Your Franchise",
                "headers": [
                    "Company Positions",
                    {
                        "depth": 1,
                        "header": "Cartographer"
                    },
                ]
            }
            """,
            value: CorpusContents("Growing Your Franchise",
                                  headers: [
                                      CorpusContents.Header("Company Positions"),
                                      CorpusContents.Header("Cartographer", depth: 1),
                                  ]),
        )
    }

    @Test
    func `Contents with header at index`() throws {
        try testCodable(
            json: """
            {
                "name": "Equipment",
                "headers": [
                    {
                        "index": 1,
                        "header": "Trade Goods"
                    },
                ]
            }
            """,
            value: CorpusContents("Equipment",
                                  headers: [
                                      CorpusContents.Header("Trade Goods", index: 1),
                                  ]),
        )
    }

    @Test
    func `Contents with ordinal`() throws {
        try testCodable(
            json: """
            {
                "name": "The Colors of Magic",
                "ordinal": {
                    "type": "appendix"
                }
            }
            """,
            value: CorpusContents("The Colors of Magic",
                                  ordinal: .appendix()),
        )
    }

    @Test
    func `Contents with ordinal and integer identifier`() throws {
        try testCodable(
            json: """
            {
                "name": "Backgrounds",
                "ordinal": {
                    "type": "chapter",
                    "identifier": 5
                }
            }
            """,
            value: CorpusContents("Backgrounds",
                                  ordinal: .chapter(.number(5))),
        )
    }

    @Test
    func `Contents with ordinal and string identifier`() throws {
        try testCodable(
            json: """
            {
                "name": "Miscellaneous Creatures",
                "ordinal": {
                    "type": "appendix",
                    "identifier": "A"
                }
            }
            """,
            value: CorpusContents("Miscellaneous Creatures",
                                  ordinal: .appendix(.numeral("A"))),
        )
    }
}
