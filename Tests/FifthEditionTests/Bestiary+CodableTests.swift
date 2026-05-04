//
//  Bestiary+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct BestiaryCodableTests {
    @Test
    func `Bestiary with monsters`() throws {
        try testCodable(
            json: """
            {
                "monster": [
                    {
                        "name": "Amber Golem",
                        "source": "CoS",
                        "page": 186,
                    },
                    {
                        "name": "Anastrasya Karelova",
                        "source": "CoS",
                        "page": 93,
                        "isNPC": true,
                        "isNamedCreature": true,
                    }
                ]
            }
            """,
            value: Bestiary(
                monster: [
                    Creature(
                        name: "Amber Golem",
                        source: "CoS",
                        page: .number(186),
                    ),
                    Creature(
                        name: "Anastrasya Karelova",
                        source: "CoS",
                        page: .number(93),
                        isNamedCreature: true,
                        isNPC: true,
                    ),
                ],
            ),
        )
    }

    @Test
    func `Bestiary with meta block`() throws {
        try testCodable(
            json: """
            {
                "_meta": {
                    "dependencies": {
                        "monster": [
                            "MM",
                            "VRGR"
                        ]
                    },
                    "otherSources": {
                        "monster": {
                            "MM": "CoS",
                            "VRGR": "CoS"
                        }
                    }
                },
                "monster": [
                    {
                        "name": "Amber Golem",
                        "source": "CoS",
                        "page": 186,
                    }
                ]
            }
            """,
            value: Bestiary(
                monster: [
                    Creature(
                        name: "Amber Golem",
                        source: "CoS",
                        page: .number(186),
                    ),
                ],
                meta: MetaBlock(
                    dependencies: ["monster": ["MM", "VRGR"]],
                    otherSources: ["monster": ["MM": "CoS", "VRGR": "CoS"]],
                ),
            ),
        )
    }
}
