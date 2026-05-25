//
//  BestiaryTests.swift
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
                        "type": "construct",
                        "page": 186,
                    },
                    {
                        "name": "Anastrasya Karelova",
                        "source": "CoS",
                        "type": "undead",
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
                        type: Creature.CreatureType(.type(.construct)),
                    ),
                    Creature(
                        name: "Anastrasya Karelova",
                        source: "CoS",
                        page: .number(93),
                        type: Creature.CreatureType(.type(.undead)),
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
                        "type": "construct",
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
                        type: Creature.CreatureType(.type(.construct)),
                    ),
                ],
                meta: Meta(
                    dependencies: [.monster: ["MM", "VRGR"]],
                    otherSources: [.monster: ["MM": "CoS", "VRGR": "CoS"]],
                ),
            ),
        )
    }
}
