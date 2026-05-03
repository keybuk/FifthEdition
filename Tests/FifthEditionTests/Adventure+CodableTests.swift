//
//  Adventure+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct AdventureCodableTests {
    @Test
    func `Adventure with required fields`() throws {
        try testCodable(
            json: """
            {
                "name": "Lost Mine of Phandelver",
                "id": "LMoP",
                "source": "LMoP",
                "group": "supplement",
                "contents": [],
                "level": {
                    "start": 1,
                    "end": 5
                },
                "published": "2014-07-15",
                "storyline": "Starter Set"
            }
            """,
            value: Adventure(
                name: "Lost Mine of Phandelver",
                id: "LMoP",
                source: "LMoP",
                group: .supplement,
                contents: [],
                level: .range(1...5),
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2014, month: 7, day: 15).date),
                storyline: "Starter Set",
            ),
        )
    }

    @Test
    func `Adventure with standard fields`() throws {
        try testCodable(
            json: """
            {
                "name": "Essentials Kit: Dragon of Icespire Peak",
                "id": "DIP",
                "source": "DIP",
                "parentSource": "ESK",
                "group": "supplement",
                "author": "Wizards RPG Team",
                "contents": [
                    {
                        "name": "Running the Adventure",
                        "headers": [
                            "Overview",
                            "The Forgotten Realms",
                            "First Session: Character Creation",
                            "The Adventure Begins"
                        ]
                    }
                ],
                "level": {
                    "start": 1,
                    "end": 6
                },
                "published": "2019-06-24",
                "publishedOrder": 0,
                "cover": {
                    "type": "internal",
                    "path": "covers/DIP.webp"
                },
                "storyline": "Essentials Kit"
            }
            """,
            value: Adventure(
                name: "Essentials Kit: Dragon of Icespire Peak",
                id: "DIP",
                source: "DIP",
                parentSource: "ESK",
                group: .supplement,
                author: "Wizards RPG Team",
                contents: [
                    .init("Running the Adventure", headers: [
                        .init("Overview"),
                        .init("The Forgotten Realms"),
                        .init("First Session: Character Creation"),
                        .init("The Adventure Begins"),
                    ]),
                ],
                level: .range(1...6),
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2019, month: 6, day: 24).date),
                publishedOrder: 0,
                cover: .path("covers/DIP.webp"),
                storyline: "Essentials Kit",
            ),
        )
    }

    @Test
    func `Adventure with alias and parentSource`() throws {
        try testCodable(
            json: """
            {
                "name": "Turn of Fortune's Wheel",
                "alias": [
                    "Planescape: Adventures in the Multiverse"
                ],
                "id": "ToFW",
                "source": "ToFW",
                "parentSource": "PAitM",
                "group": "supplement",
                "contents": [],
                "level": {
                    "start": 3,
                    "end": 18
                },
                "published": "2023-10-07",
                "storyline": "Planescape"
            }
            """,
            value: Adventure(
                name: "Turn of Fortune's Wheel",
                alias: ["Planescape: Adventures in the Multiverse"],
                id: "ToFW",
                source: "ToFW",
                parentSource: "PAitM",
                group: .supplement,
                contents: [],
                level: .range(3...18),
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2023, month: 10, day: 7).date),
                storyline: "Planescape",
            ),
        )
    }

    @Test
    func `Adventure with revised date`() throws {
        try testCodable(
            json: """
            {
                "name": "Lost Mine of Phandelver",
                "id": "LMoP",
                "source": "LMoP",
                "group": "supplement",
                "contents": [],
                "level": {
                    "start": 1,
                    "end": 5
                },
                "published": "2014-07-15",
                "revised": "2023-09-19",
                "storyline": "Starter Set"
            }
            """,
            value: Adventure(
                name: "Lost Mine of Phandelver",
                id: "LMoP",
                source: "LMoP",
                group: .supplement,
                contents: [],
                level: .range(1...5),
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2014, month: 7, day: 15).date),
                revised: DateComponents(calendar: Calendar(identifier: .iso8601),
                                        year: 2023, month: 9, day: 19).date,
                storyline: "Starter Set",
            ),
        )
    }
}

struct AdventureGroupCodableTests {
    @Test(arguments: Adventure.Group.allCases)
    func `adventure groups`(_ adventureGroup: Adventure.Group) throws {
        try testCodable(
            json: """
            "\(adventureGroup.rawValue)"
            """,
            value: adventureGroup,
        )
    }
}

struct AdventureLevelCodableTests {
    @Test
    func `Level with range`() throws {
        try testCodable(
            json: """
            {
                "start": 1,
                "end": 5
            }
            """,
            value: Adventure.Level.range(1...5),
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
            value: Adventure.Level.custom("Players use monster stat blocks"),
        )
    }
}
