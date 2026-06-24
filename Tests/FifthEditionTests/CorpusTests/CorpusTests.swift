//
//  CorpusTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Foundation
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
                                      CorpusHeader("What Does a DM Do?"),
                                      CorpusHeader("Things You Need"),
                                      CorpusHeader("Preparing a Session"),
                                      CorpusHeader("How to Run a Session"),
                                      CorpusHeader("Example of Play"),
                                      CorpusHeader("Every DM Is Unique"),
                                      CorpusHeader("Ensuring Fun for All"),
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
                                      CorpusHeader("Company Positions"),
                                      CorpusHeader("Cartographer", depth: 1),
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
                                      CorpusHeader("Trade Goods", index: 1),
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

struct CorpusHeaderInitTests {
    @Test
    func `init(stringLiteral:) sets header`() {
        let header: CorpusHeader = "Introduction"
        #expect(header.header == "Introduction")
    }
}

struct EditionCodableTests {
    @Test(arguments: Edition.allCases)
    func editions(_ edition: Edition) throws {
        try testCodable(
            json: """
            "\(edition.rawValue)"
            """,
            value: edition,
        )
    }
}

struct PublishedCorpusEditionTests {
    @Test
    func `edition for 2014 5e book`() throws {
        let book = try Book(name: "Player's Handbook (2014)",
                            id: "PHB",
                            source: "PHB",
                            group: .core,
                            published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                               year: 2014,
                                                               month: 8,
                                                               day: 19).date),
                            contents: [])
        #expect(book.edition == .legacy)
    }

    @Test
    func `edition for 2024 5.5e book`() throws {
        let book = try Book(name: "Player's Handbook (2024)",
                            id: "XPHB",
                            source: "XPHB",
                            group: .core,
                            published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                               year: 2024,
                                                               month: 9,
                                                               day: 17).date),
                            contents: [])
        #expect(book.edition == .modern)
    }
}
