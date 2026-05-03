//
//  Book+CodableTests.swift
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
    func `Book with alias and parentSource`() throws {
        try testCodable(
            json: """
            {
                "name": "Sigil and the Outlands",
                "alias": [
                    "Planescape: Adventures in the Multiverse"
                ],
                "id": "SatO",
                "source": "SatO",
                "parentSource": "PAitM",
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
                parentSource: "PAitM",
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
}

struct BookGroupCodableTests {
    @Test(arguments: Book.Group.allCases)
    func `book groups`(_ bookGroup: Book.Group) throws {
        try testCodable(
            json: """
            "\(bookGroup.rawValue)"
            """,
            value: bookGroup,
        )
    }
}
