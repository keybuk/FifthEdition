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
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2014, month: 7, day: 15).date),
                level: .range(1...5),
                storyline: "Starter Set",
                contents: [],
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
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2019, month: 6, day: 24).date),
                publishedOrder: 0,
                author: "Wizards RPG Team",
                level: .range(1...6),
                storyline: "Essentials Kit",
                cover: .path("covers/DIP.webp"),
                contents: [
                    CorpusContents("Running the Adventure",
                                   headers: [
                                       CorpusContents.Header("Overview"),
                                       CorpusContents.Header("The Forgotten Realms"),
                                       CorpusContents.Header("First Session: Character Creation"),
                                       CorpusContents.Header("The Adventure Begins"),
                                   ]),
                ],
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
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2023, month: 10, day: 7).date),
                level: .range(3...18),
                storyline: "Planescape",
                contents: [],
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
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2014, month: 7, day: 15).date),
                revised: DateComponents(calendar: Calendar(identifier: .iso8601),
                                        year: 2023, month: 9, day: 19).date,
                level: .range(1...5),
                storyline: "Starter Set",
                contents: [],
            ),
        )
    }

    @Test
    func `Adventure with adventures league`() throws {
        try testCodable(
            json: """
            {
                "name": "Defiance in Phlan",
                "id": "DDEX1-01",
                "source": "DDEX1-01",
                "group": "other",
                "alAveragePlayerLevel": 1,
                "alLength": {
                    "exact": 5
                },
                "alId": "DDEX1-01",
                "contents": [],
                "level": {
                    "start": 1,
                    "end": 1
                },
                "published": "2014-09-01",
                "storyline": "Tyranny of Dragons"
            }
            """,
            value: Adventure(
                name: "Defiance in Phlan",
                id: "DDEX1-01",
                source: "DDEX1-01",
                group: .other,
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2014, month: 9, day: 1).date),
                level: .range(1...1),
                alAveragePlayerLevel: 1,
                alLength: 5...5,
                alId: "DDEX1-01",
                storyline: "Tyranny of Dragons",
                contents: [],
            ),
        )
    }

    @Test
    func `Adventure with adventures league length range`() throws {
        try testCodable(
            json: """
            {
                "name": "Rrakkma",
                "id": "AL-RKM",
                "source": "AL-RKM",
                "group": "other",
                "alAveragePlayerLevel": 9,
                "alLength": {
                    "min": 6,
                    "max": 8
                },
                "alId": "DDIA-MORD",
                "contents": [],
                "level": {
                    "start": 9,
                    "end": 9
                },
                "published": "2018-05-18",
                "storyline": "Fifth Edition"
            }
            """,
            value: Adventure(
                name: "Rrakkma",
                id: "AL-RKM",
                source: "AL-RKM",
                group: .other,
                published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                   year: 2018, month: 5, day: 18).date),
                level: .range(9...9),
                alAveragePlayerLevel: 9,
                alLength: 6...8,
                alId: "DDIA-MORD",
                storyline: "Fifth Edition",
                contents: [],
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
