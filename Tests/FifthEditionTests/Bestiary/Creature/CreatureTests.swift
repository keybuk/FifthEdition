//
//  CreatureTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureCodableTests {
    @Test
    func `Creature encodes minimal fields`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": "monstrosity"
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity)),
        )
    }

    @Test
    func `Creature encodes typical fields`() throws {
        try testCodable(
            json: """
            {
                "name": "Evil Monkey",
                "source": "XMM",
                "page": 42,
                "otherSources": [
                    {
                        "source": "MM",
                        "page": 38
                    }
                ],
                "additionalSources": [
                    {
                        "source": "EFA",
                        "page": 69
                    }
                ],
                "referenceSources": [ "XMM" ],
                "size": [
                    "H"
                ],
                "type": "undead",
                "alignment": [
                    "C",
                    "E"
                ],
                "ac": [
                    20
                ],
                "hp": {
                    "average": 55,
                    "formula": "10d8 + 10"
                },
                "speed": {
                    "walk": 60,
                    "fly": {
                        "number": 60,
                        "condition": "(while dancing)"
                    },
                    "canHover": true
                },
                "str": 15,
                "dex": 14,
                "con": 13,
                "int": 12,
                "wis": 10,
                "cha": 8,
                "save": {
                    "str": "+4",
                    "cha": "+5"
                },
                "skill": {
                    "arcana": "+3",
                    "nature": "+5",
                    "perception": "+7"
                },
                "gear": [
                    {
                      "item": "dagger|xphb",
                      "quantity": 6
                    },
                    "studded leather armor|xphb"
                ],
                "senses": [
                    "darkvision 60 ft."
                ],
                "passive": 16,
                "languages": [
                    "Common",
                    "Undercommon"
                ],
                "cr": "5",
                "initiative": {
                    "proficiency": 1
                },
                "immune": [
                    "cold",
                    "poison",
                    {
                        "immune": [
                            "bludgeoning",
                            "piercing",
                            "slashing"
                        ],
                        "note": "from nonmagical attacks",
                        "cond": true
                    }
                ],
                "conditionImmune": [
                    "charmed",
                    "frightened"
                ],
                "conditionInflict": [
                    "frightened"
                ],
                "savingThrowForced": [
                    "wisdom"
                ],
                "damageTags": [
                    "B"
                ],
                "damageTagsSpell": [
                    "Y"
                ],
                "environment": [
                    "underdark",
                    "planar, lower"
                ],
                "actionTags": [
                    "Frightful Presence"
                ],
                "languageTags": [
                    "C"
                ],
                "miscTags": [
                    "CUR",
                    "DIS"
                ],
                "senseTags": [
                    "D"
                ],
                "spellcastingTags": [
                    "I"
                ],
                "traitTags": [
                    "False Appearance",
                    "Unusual Nature"
                ],
                "treasure": [
                    "arcana"
                ],
                "hasToken": true,
                "hasFluff": true,
                "hasFluffImages": true,
            }
            """,
            value: Creature(name: "Evil Monkey",
                            source: "XMM",
                            page: .number(42),
                            otherSources: [Source("MM", page: .number(38))],
                            additionalSources: [Source("EFA", page: .number(69))],
                            referenceSources: ["XMM"],
                            size: Creature.Sizes(.huge),
                            type: Creature.Types(.undead),
                            alignment: Creature.Alignment(.chaoticEvil),
                            armorClass: [.ac(20)],
                            hitPoints: .hp(DiceNotation(.d8, count: 10, modifier: 10)),
                            speeds: Creature.Speeds(
                                [
                                    .walk: [60],
                                    .fly: [.speed(60, condition: "(while dancing)")],
                                ],
                                canHover: true,
                            ),
                            abilities: [
                                .strength: .score(15),
                                .dexterity: .score(14),
                                .constitution: .score(13),
                                .intelligence: .score(12),
                                .wisdom: .score(10),
                                .charisma: .score(8),
                            ],
                            savingThrows: Creature.SavingThrows([
                                .strength: AbilityModifier.modifier(4),
                                .charisma: AbilityModifier.modifier(5),
                            ]),
                            skills: Creature.Skills([
                                .arcana: AbilityModifier.modifier(3),
                                .nature: AbilityModifier.modifier(5),
                                .perception: AbilityModifier.modifier(7),
                            ]),
                            initiative: .proficiency(.proficient),
                            damageImmunities: [
                                .damage(.cold),
                                .damage(.poison),
                                .susceptible([
                                    .damage(.bludgeoning),
                                    .damage(.piercing),
                                    .damage(.slashing),
                                ],
                                note: "from nonmagical attacks",
                                isConditional: true),
                            ],
                            conditionImmunities: [
                                .condition(.charmed),
                                .condition(.frightened),
                            ],
                            gear: [
                                Gear(name: "Dagger", source: "XPHB", quantity: 6),
                                Gear(name: "Studded Leather Armor", source: "XPHB"),
                            ],
                            senses: [.sense(.darkvision, range: 60)],
                            passivePerception: .passive(16),
                            languages: Creature.Languages([.common, .undercommon]),
                            challenge: Creature.Challenge(.cr(5)),
                            habitat: [
                                .underdark,
                                .planarLower,
                            ],
                            treasure: [.arcana],
                            spellcastingTags: [
                                .innate,
                            ],
                            traitTags: [
                                .falseAppearance,
                                .unusualNature,
                            ],
                            actionTags: [
                                .frightfulPresence,
                            ],
                            senseTags: [
                                .darkvision,
                            ],
                            languageTags: [
                                .common,
                            ],
                            miscTags: [
                                .inflictsCurse,
                                .inflictsDisease,
                            ],
                            damageDealt: [
                                .bludgeoning,
                            ],
                            damageDealtSpell: [
                                .psychic,
                            ],
                            conditionInflict: [
                                .frightened,
                            ],
                            savingThrowForced: [
                                .wisdom,
                            ],
                            hasToken: true,
                            hasFluff: true,
                            hasFluffImages: true),
        )
    }

    @Test
    func `Creature encodes NPC`() throws {
        try testCodable(
            json: """
            {
                "name": "Gizmo",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": "monstrosity",
                "isNamedCreature": true,
                "isNPC": true,
                "familiar": true
            }
            """,
            value: Creature(name: "Gizmo",
                            isNamedCreature: true,
                            isNPC: true,
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity),
                            canBeFamiliar: true),
        )
    }

    @Test
    func `Creature encodes group array`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": "monstrosity",
                "group": ["Spielberg"]
            }
            """,
            value: Creature(name: "Gremlin",
                            group: ["Spielberg"],
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity)),
        )
    }

    @Test
    func `Creature decodes null group as empty array`() throws {
        let json = """
        {
            "name": "Gremlin",
            "source": "XMM",
            "size": [
                "S"
            ],
            "type": "humanoid",
            "group": null
        }
        """
        let creature = try JSONDecoder().decode(Creature.self, from: #require(json.data(using: .utf8)))
        #expect(creature.group == [])
    }

    @Test
    func `Creature encodes multiple sizes in array`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S",
                    "M"
                ],
                "type": "monstrosity"
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes([.small, .medium]),
                            type: Creature.Types(.monstrosity)),
        )
    }

    @Test
    func `Creature encodes size note`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "sizeNote": "or larger",
                "type": "monstrosity"
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes(.small,
                                                 note: "or larger"),
                            type: Creature.Types(.monstrosity)),
        )
    }

    @Test
    func `Creature encodes choice of type in object`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": {
                    "type": {
                        "choose": [
                            "fiend",
                            "monstrosity"
                        ]
                    }
                }
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types([.fiend, .monstrosity])),
        )
    }

    @Test
    func `Creature encodes type tags in object`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": {
                    "type": "monstrosity",
                    "tags": [
                        "mogwai"
                    ]
                }
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity,
                                                 tags: [Tag("mogwai")])),
        )
    }

    @Test
    func `Creature encodes type note in object`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": {
                    "type": "fiend",
                    "note": "only when hungry"
                }
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.fiend,
                                                 note: "only when hungry")),
        )
    }

    @Test
    func `Creature encodes sidekick level and type together`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "level": 2,
                "size": [
                    "S"
                ],
                "type": {
                    "type": "monstrosity",
                    "sidekickType": "expert",
                }
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            sidekick: Creature.Sidekick(level: 2,
                                                        type: .expert),
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity)),
        )
    }

    @Test
    func `Creature encodes sidekick level without sidekick`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "level": 2,
                "size": [
                    "S"
                ],
                "type": "monstrosity",
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            sidekick: Creature.Sidekick(level: 2),
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity)),
        )
    }

    @Test
    func `Creature encodes sidekick in type`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": {
                    "type": "monstrosity",
                    "sidekickType": "spellcaster",
                    "sidekickTags": [
                        "attacker"
                    ],
                    "sidekickHidden": true
                }
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            sidekick: Creature.Sidekick(type: .spellcaster,
                                                        tags: Tag("attacker"),
                                                        isHidden: true),
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity)),
        )
    }

    @Test
    func `Creature encodes proficiency bonus in challenge`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": "monstrosity",
                "cr": "5",
                "pbNote": "+2",
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity),
                            challenge: Creature.Challenge(.cr(5),
                                                          proficiencyBonus: .bonus(2))),
        )
    }

    @Test
    func `Creature encodes proficiency bonus without challenge`() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XMM",
                "size": [
                    "S"
                ],
                "type": "monstrosity",
                "pbNote": "+2",
            }
            """,
            value: Creature(name: "Gremlin",
                            source: "XMM",
                            size: Creature.Sizes(.small),
                            type: Creature.Types(.monstrosity),
                            challenge: Creature.Challenge(proficiencyBonus: .bonus(2))),
        )
    }
}
