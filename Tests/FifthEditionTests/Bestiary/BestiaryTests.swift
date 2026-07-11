//
//  BestiaryTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

import Testing
@testable import FifthEdition

struct BestiaryCodableTests {
    @Test
    func `Bestiary encoders monster list`() throws {
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
            value: Bestiary([
                Creature(name: "Amber Golem",
                         source: "CoS",
                         page: .number(186),
                         type: Creature.Types(.construct)),
                Creature(name: "Anastrasya Karelova",
                         isNamedCreature: true,
                         isNPC: true,
                         source: "CoS",
                         page: .number(93),
                         type: Creature.Types(.undead)),
            ]),
        )
    }

    @Test
    func `Bestiary encodes meta block`() throws {
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
                [
                    Creature(name: "Amber Golem",
                             source: "CoS",
                             page: .number(186),
                             type: Creature.Types(.construct)),
                ],
                meta: Meta(dependencies: [.monster: ["MM", "VRGR"]],
                           otherSources: [.monster: ["MM": "CoS", "VRGR": "CoS"]]),
            ),
        )
    }
}
