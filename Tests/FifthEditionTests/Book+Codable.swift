//
//  Book+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/8/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct BookCodableTests {
    @Test
    func `Book with required fields`() throws {
        try testCodable(
            json: """
            {
                "name": "Player's Handbook",
                "id": "PHB",
                "source": "PHB",
                "group": "core",
                "published": "2014-08-19",
                "contents": []
            }
            """,
            value: Book(
                name: "Player's Handbook",
                id: "PHB",
                source: "PHB",
                group: .core,
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2014, month: 8, day: 19).date),
                contents: [],
            ),
        )
    }

    @Test
    func `Book with required fields for Adventure`() throws {
        try testCodable(
            json: """
            {
                "name": "Lost Mine of Phandelver",
                "id": "LMoP",
                "source": "LMoP",
                "group": "supplement",
                "published": "2014-07-15",
                "storyline": "Starter Set",
                "level": {
                    "start": 1,
                    "end": 5
                },
                "contents": []
            }
            """,
            value: Book(
                name: "Lost Mine of Phandelver",
                id: "LMoP",
                source: "LMoP",
                group: .supplement,
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2014, month: 7, day: 15).date),
                level: .range(1 ... 5),
                storyline: .starterSet,
                contents: [],
            ),
        )
    }

    @Test
    func `Book with standard fields`() throws {
        try testCodable(
            json: """
            {
                "name": "Dungeon Master's Guide (2024)",
                "id": "XDMG",
                "source": "XDMG",
                "group": "core",
                "cover": {
                    "type": "internal",
                    "path": "covers/XDMG.webp"
                },
                "published": "2024-11-12",
                "author": "Wizards RPG Team",
                "contents": [
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
                ]
            }
            """,
            value: Book(
                name: "Dungeon Master's Guide (2024)",
                id: "XDMG",
                source: "XDMG",
                group: .core,
                author: "Wizards RPG Team",
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2024, month: 11, day: 12).date),
                cover: .path("covers/XDMG.webp"),
                contents: [
                    .init("The Basics", headers: [
                        .init("What Does a DM Do?"),
                        .init("Things You Need"),
                        .init("Preparing a Session"),
                        .init("How to Run a Session"),
                        .init("Example of Play"),
                        .init("Every DM Is Unique"),
                        .init("Ensuring Fun for All"),
                    ]),
                ],
            ),
        )
    }

    @Test
    func `Book with alias`() throws {
        try testCodable(
            json: """
            {
                "name": "Sigil and the Outlands",
                "alias": [
                    "Planescape: Adventures in the Multiverse"
                ],
                "id": "SatO",
                "source": "SatO",
                "group": "setting",
                "published": "2023-10-07",
                "contents": []
            }
            """,
            value: Book(
                name: "Sigil and the Outlands",
                alias: ["Planescape: Adventures in the Multiverse"],
                id: "SatO",
                source: "SatO",
                group: .setting,
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2023, month: 10, day: 7).date),
                contents: [],
            ),
        )
    }

    @Test
    func `Book with revised date`() throws {
        try testCodable(
            json: """
            {
                "name": "Sage Advice Compendium (2025)",
                "id": "XSAC",
                "source": "XSAC",
                "group": "other",
                "published": "2025-04-30",
                "revised": "2025-04-30",
                "contents": [],
            }
            """,
            value: Book(
                name: "Sage Advice Compendium (2025)",
                id: "XSAC",
                source: "XSAC",
                group: .other,
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2025, month: 4, day: 30).date),
                revised: DateComponents(calendar: Calendar(identifier: .iso8601),
                                        year: 2025, month: 4, day: 30).date,
                contents: [],
            ),
        )
    }

    @Test
    func `Book with fields for a compendium Adventure`() throws {
        try testCodable(
            json: """
            {
                "name": "Essentials Kit: Dragon of Icespire Peak",
                "id": "DIP",
                "source": "DIP",
                "parentSource": "ESK",
                "group": "supplement",
                "published": "2019-06-24",
                "publishedOrder": 0,
                "storyline": "Essentials Kit",
                "level": {
                    "start": 1,
                    "end": 6
                },
                "contents": []
            }
            """,
            value: Book(
                name: "Essentials Kit: Dragon of Icespire Peak",
                id: "DIP",
                source: "DIP",
                parentSource: "ESK",
                group: .supplement,
                publishedOrder: 0,
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2019, month: 6, day: 24).date),
                level: .range(1 ... 6),
                storyline: .essentialsKit,
                contents: [],
            ),
        )
    }
}

struct BookContentsCodableTests {
    @Test
    func `Contents with name only`() throws {
        try testCodable(
            json: """
            {
                "name": "The Basics"
            }
            """,
            value: Book.Contents("The Basics"),
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
            value: Book.Contents("The Basics", headers: [
                .init("What Does a DM Do?"),
                .init("Things You Need"),
                .init("Preparing a Session"),
                .init("How to Run a Session"),
                .init("Example of Play"),
                .init("Every DM Is Unique"),
                .init("Ensuring Fun for All"),
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
            value: Book.Contents("Growing Your Franchise", headers: [
                .init("Company Positions"),
                .init("Cartographer", depth: 1),
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
            value: Book.Contents("Equipment", headers: [
                .init("Trade Goods", index: 1),
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
            value: Book.Contents("The Colors of Magic", ordinal: .init(.appendix)),
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
            value: Book.Contents("Backgrounds", ordinal: .init(.chapter, identifier: .integer(5))),
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
            value: Book.Contents("Miscellaneous Creatures", ordinal: .init(.appendix, identifier: .string("A"))),
        )
    }
}

struct BookLevelCodableTests {
    @Test
    func `Level with range`() throws {
        try testCodable(
            json: """
            {
                "start": 1,
                "end": 5
            }
            """,
            value: Book.Level.range(1 ... 5),
        )
    }

    @Test
    func `Level with custom`() throws {
        try testCodable(
            json: """
            {
                "custom": "Players use monster stat blocks",
            }
            """,
            value: Book.Level.custom("Players use monster stat blocks"),
        )
    }
}
