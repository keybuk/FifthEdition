//
//  BestiaryTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Testing
@testable import FifthEdition

struct CreatureCodableTests {

    @Test("Minimal creature")
    func minimal() throws {
        try testCodable(
            json: """
            {
                "name": "Gremlin",
                "source": "XDMG",
                "size": [
                    "S"
                ],
                "type": "monstrosity"
            }
            """,
            value: Creature(
                name: "Gremlin",
                source: "XDMG",
                size: [.small],
                type: .init(.type(.monstrosity)),
            )
        )
    }

    @Test("Typical creature")
    func typical() throws {
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
                        "condition": "(hover)"
                    },
                    "canHover": true
                },
                "str": 16,
                "dex": 16,
                "con": 16,
                "int": 16,
                "wis": 16,
                "cha": 16,
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
                "familiar": true,
                "hasToken": true,
                "hasFluff": true,
                "hasFluffImages": true,
            }
            """,
            value: Creature(
                name: "Evil Monkey",
                source: "XMM",
                page: .number(42),
                otherSources: [.init(source: "MM", page: .number(38))],
                size: [.huge],
                type: .init(.type(.undead)),
                alignment: .alignment([.chaotic, .evil]),
                armorClass: [.ac(20)],
                hitPoints: .hp(.init(.d8, count: 10, modifier: 10)),
                speed: .init(
                    [
                        .walk: .speed(60),
                        .fly: .conditional(60, condition: "(hover)"),
                    ],
                    canHover: true,
                ),
                initiative: .init(proficiency: .proficient),
                str: .score(16),
                dex: .score(16),
                con: .score(16),
                int: .score(16),
                wis: .score(16),
                cha: .score(16),
                save: .init(str: "+4", cha: "+5"),
                skill: .init([
                    .arcana: "+3",
                    .nature: "+5",
                    .perception: "+7",
                ]),
                senses: ["darkvision 60 ft."],
                passive: .score(16),
                languages: ["Common", "Undercommon"],
                challengeRating: .init("5"),
                damageImmunity: [
                    .damage(.cold),
                    .damage(.poison),
                    .conditional(
                        [
                            .damage(.bludgeoning),
                            .damage(.piercing),
                            .damage(.slashing),
                        ],
                        note: "from nonmagical attacks",
                        conditional: true,
                    )
                ],
                conditionImmunity: [
                    .condition(.charmed),
                    .condition(.frightened),
                ],
                conditionInflict: [
                    .frightened
                ],
                savingThrowForced: [
                    .wisdom
                ],
                damageDealt: [
                    .bludgeoning,
                ],
                damageDealtSpell: [
                    .psychic,
                ],
                environment: [
                    .underdark,
                    .planarLower
                ],
                actionTags: [
                    .frightfulPresence,
                ],
                languageTags: [
                    .common,
                ],
                miscTags: [
                    .inflictsCurse,
                    .inflictsDisease,
                ],
                senseTags: [
                    .darkvision,
                ],
                spellcastingTags: [
                    .innate,
                ],
                traitTags: [
                    .falseAppearance,
                    .unusualNature,
                ],
                gear: [
                    .init("dagger|xphb", quantity: 6),
                    .init("studded leather armor|xphb"),
                ],
                treasure: [.arcana],
                canBeFamiliar: true,
                hasToken: true,
                hasFluff: true,
                hasFluffImages: true,
            )
        )
    }

    @Test("Sidekick")
    func sidekick() throws {
        try testCodable(
            // Test unusual combinations of properties.
            json: """
            {
                "name": "Fat Stig",
                "shortName": "Stig",
                "source": "TG",
                "level": 9,
                "size": [
                    "L"
                ],
                "sizeNote": "from eating",
                "type": {
                    "type": "humanoid",
                    "tags": [
                        "human"
                    ],
                    "sidekickType": "expert",
                    "sidekickTags": [
                        "driver"
                    ]
                },
                "alignment": [
                    "N"
                ],
                "alignmentPrefix": "usually",
                "ac": [
                    {
                        "ac": 16,
                        "from": [
                            "racing suit"
                        ]
                    }
                ],
                "hp": {
                    "special": "some say he is immortal"
                },
                "speed": "Varies",
                "initiative": {
                    "advantageMode": "adv"
                },
                "tool": {
                    "vehicles": "proficient",
                    "vehicles (land)": "expertise"
                },
                "passive": "10 + (PB × 2)",
                "pbNote": "+10",
                "vulnerable": [
                    "poison",
                ],
                "resist": [
                    {
                        "resist": [
                            "acid",
                            "cold",
                            "fire"
                        ],
                        "preNote": "While wearing racing suit:"
                    }
                ],
                "attachedItems": [
                    "racing suit|TG"
                ],
                "isNamedCreature": true,
                "isNPC": true,
                "hasToken": true,
                "tokenCustom": true,
                "tokenCredit": "BBC",
                "token": {
                    "name": "The Stig",
                    "source": "TG"
                }
            }
            """,
            value: Creature(
                name: "Fat Stig",
                shortName: .name("Stig"),
                source: "TG",
                level: 9,
                size: [.large],
                sizeNote: "from eating",
                type: .init(
                    .type(.humanoid),
                    tags: [.tag("human")],
                    sidekickType: .expert,
                    sidekickTags: [.tag("driver")],
                ),
                alignment: .alignment([.neutral]),
                alignmentPrefix: "usually",
                armorClass: [.obtained(16, from: ["racing suit"])],
                hitPoints: .special("some say he is immortal"),
                speed: .varies,
                initiative: .init(advantage: .advantage),
                tool: .init([
                    .vehicles: "proficient",
                    .vehiclesLand: "expertise",
                ]),
                passive: .special("10 + (PB × 2)"),
                proficiencyBonus: "+10",
                damageVulnerability: [
                    .damage(.poison),
                ],
                damageResistance: [
                    .conditional(
                        [
                            .damage(.acid),
                            .damage(.cold),
                            .damage(.fire),
                        ],
                        preNote: "While wearing racing suit:",
                    ),
                ],
                attachedItems: [
                    "racing suit|TG",
                ],
                isNamedCreature: true,
                isNPC: true,
                hasToken: true,
                token: .init(name: "The Stig", source: "TG"),
                tokenCredit: "BBC",
                isTokenCustom: true,
            )
        )
    }

    @Test("Summoned creature")
    func summoned() throws {
        try testCodable(
            json: """
            {
                "name": "Talkie Toaster",
                "source": "RD",
                "size": [
                    "T"
                ],
                "type": "construct",
                "alignment": [
                    "C", "E",
                ],
                "ac": [
                    15
                ],
                "hp": {
                    "average": 17,
                    "formula": "2d6 + 10"
                },
                "speed": 0,
                "languages": [
                    "Common"
                ],
                "summonedBySpell": "Animate Toaster|RD",
                "summonedBySpellLevel": 6,
                "summonedByClass": "Artificer|EFA",
                "summonedScaleByPlayerLevel": true,
                "isNamedCreature": true,
                "isNPC": true
            }
            """,
            value: Creature(
                name: "Talkie Toaster",
                source: "RD",
                size: [.tiny],
                type: .init(.type(.construct)),
                alignment: .alignment([.chaotic, .evil]),
                armorClass: [.ac(15)],
                hitPoints: .hp(.init(.d6, count: 2, modifier: 10)),
                speed: .init([.walk: .speed(0)]),
                languages: ["Common"],
                summonedBySpell: "Animate Toaster|RD",
                summonedBySpellLevel: 6,
                summonedByClass: "Artificer|EFA",
                summonedScaleByPlayerLevel: true,
                isNamedCreature: true,
                isNPC: true,
            )
        )
    }

}

struct CreatureAbilityScoreCodableTests {

    @Test("Ability score")
    func score() throws {
        try testCodable(
            json: """
            16
            """,
            value: Creature.AbilityScore.score(16),
        )
    }

    @Test("Special ability score")
    func special() throws {
        // This doesn't appear anywhere in the bestiary, but is valid in the schema.
        try testCodable(
            json: """
            {
                "special": "same as player"
            }
            """,
            value: Creature.AbilityScore.special("same as player"),
        )
    }

}

struct CreatureAlignmentCodableTests {

    @Test("Simple alignment")
    func common() throws {
        try testCodable(
            json: """
            [
                "C",
                "G"
            ]
            """,
            value: Creature.Alignment.alignment([.chaotic, .good])
        )
    }

    @Test("Alignment in object")
    func object() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [
                        "L",
                        "G"
                    ]
                }
            ]
            """,
            value: Creature.Alignment.choice([
                .init(alignment: [.lawful, .good]),
            ]),
        )
    }

    @Test("Alignment with note")
    func note() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [
                        "C",
                        "G"
                    ],
                    "note": "chaotic evil when hungry"
                }
            ]
            """,
            value: Creature.Alignment.choice([
                .init(
                    alignment: [.chaotic, .good],
                    note: "chaotic evil when hungry"
                ),
            ]),
        )
    }

    @Test("Choice of alignment")
    func choice() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [
                        "L",
                        "G"
                    ]
                },
                {
                    "alignment": [
                        "C",
                        "E"
                    ]
                }
            ]
            """,
            value: Creature.Alignment.choice([
                .init(alignment: [.lawful, .good]),
                .init(alignment: [.chaotic, .evil]),
            ]),
        )
    }

    @Test("Alignments with random chance")
    func chance() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [
                        "L",
                        "G"
                    ],
                    "chance": 60
                },
                {
                    "alignment": [
                        "C",
                        "E"
                    ],
                    "chance": 40
                }
            ]
            """,
            value: Creature.Alignment.choice([
                .init(alignment: [.lawful, .good], chance: 60),
                .init(alignment: [.chaotic, .evil], chance: 40),
            ]),
        )
    }

    @Test("Special alignment")
    func special() throws {
        try testCodable(
            json: """
            [
                {
                    "special": "player's alignment"
                }
            ]
            """,
            value: Creature.Alignment.special("player's alignment"),
        )
    }

}

struct CreatureArmorClassCodableTests {

    @Test("Armor class")
    func object() throws {
        try testCodable(
            json: """
            [
                15
            ]
            """,
            value: [
                Creature.ArmorClass.ac(15)
            ],
        )
    }

    @Test("Obtained armor class")
    func obtained() throws {
        try testCodable(
            json: """
            [
                {
                    "ac": 16,
                    "from": [
                        "natural armor"
                    ]
                }
            ]
            """,
            value: [
                Creature.ArmorClass.obtained(
                    16,
                    from: ["natural armor"]
                )
            ],
        )
    }

    @Test("Conditional armor class")
    func conditional() throws {
        try testCodable(
            json: """
            [
                13,
                {
                    "ac": 17,
                    "condition": "with {@spell mage armor}",
                    "braces": true
                }
            ]
            """,
            value: [
                Creature.ArmorClass.ac(13),
                Creature.ArmorClass.obtained(
                    17,
                    condition: "with {@spell mage armor}",
                    braces: true
                )
            ],
        )
    }

    @Test("Special armor class")
    func special() throws {
        try testCodable(
            json: """
            [
                {
                    "special": "12 + your Intelligence modifier"
                }
            ]
            """,
            value: [
                Creature.ArmorClass.special("12 + your Intelligence modifier")
            ],
        )
    }

}

struct CreatureChallengeRatingCodableTests {

    @Test("Challenge rating")
    func cr() throws {
        try testCodable(
            json: """
            "17"
            """,
            value: Creature.ChallengeRating("17"),
        )
    }

    @Test("Challenge rating with XP")
    func xp() throws {
        try testCodable(
            json: """
            {
                "cr": "1",
                "xp": 100
            }
            """,
            value: Creature.ChallengeRating(
                "1",
                xp: 100
            ),
        )
    }

    @Test("Challenge rating with lair")
    func lair() throws {
        try testCodable(
            json: """
            {
                "cr": "5",
                "lair": "6"
            }
            """,
            value: Creature.ChallengeRating(
                "5",
                lair: "6",
            ),
        )
    }

    @Test("Challenge rating with lair XP")
    func lairXP() throws {
        try testCodable(
            json: """
            {
                "cr": "14",
                "xpLair": 13000
            }
            """,
            value: Creature.ChallengeRating(
                "14",
                xpLair: 13000,
            ),
        )
    }

    @Test("Challenge rating with coven")
    func coven() throws {
        try testCodable(
            json: """
            {
                "cr": "5",
                "coven": "6"
            }
            """,
            value: Creature.ChallengeRating(
                "5",
                coven: "6",
            ),
        )
    }

}

struct CreatureConditionImmunityCodableTests {

    @Test("Condition immunity")
    func conditionImmunity() throws {
        try testCodable(
            json: """
            "blinded"
            """,
            value: Creature.ConditionImmunity.condition(.blinded),
        )
    }

    @Test("Special condition immunity")
    func specialConditionImmunity() throws {
        try testCodable(
            json: """
            {
                "special": "immune to hungry"
            }
            """,
            value: Creature.ConditionImmunity.special("immune to hungry"),
        )
    }

    @Test("Conditional immunity")
    func conditionalImmunity() throws {
        try testCodable(
            json: """
            {
                "conditionImmune": [
                    "charmed",
                    "frightened"
                ],
                "note": "while raging",
                "cond": true
            }
            """,
            value: Creature.ConditionImmunity.conditional(
                [
                    .condition(.charmed),
                    .condition(.frightened),
                ],
                note: "while raging",
                conditional: true,
            ),
        )
    }

    @Test("Conditional immunity with pre-note")
    func conditionalImmunityPreNote() throws {
        try testCodable(
            json: """
            {
                "conditionImmune": [
                    "blinded",
                    "deafened"
                ],
                "preNote": "While hooded:"
            }
            """,
            value: Creature.ConditionImmunity.conditional(
                [
                    .condition(.blinded),
                    .condition(.deafened),
                ],
                preNote: "While hooded:",
            ),
        )
    }

    @Test("Recursive conditional immunity")
    func recursiveConditionalImmunity() throws {
        try testCodable(
            json: """
            {
                "conditionImmune": [
                    "blinded",
                    "deafened",
                    {
                        "conditionImmune": [
                            "charmed",
                            "frightened"
                        ],
                        "note": "when sight or hearing required",
                        "cond": true
                    }
                ],
                "preNote": "While hooded:"
            }
            """,
            value: Creature.ConditionImmunity.conditional(
                [
                    .condition(.blinded),
                    .condition(.deafened),
                    .conditional(
                        [
                            .condition(.charmed),
                            .condition(.frightened),
                        ],
                        note: "when sight or hearing required",
                        conditional: true,
                    ),
                ],
                preNote: "While hooded:",
            ),
        )
    }

}

struct CreatureCreatureTypeCodableTests {

    @Test("Creature type")
    func type() throws {
        try testCodable(
            json: """
            "undead"
            """,
            value: Creature.CreatureType(.type(.undead)),
        )
    }

    @Test("Creature type in object")
    func object() throws {
        // This doesn't appear anywhere in the bestiary, but is valid in the schema.
        try testCodable(
            json: """
            {
                "type": "undead"
            }
            """,
            value: Creature.CreatureType(.type(.undead)),
        )
    }

    @Test("Choice of creature type")
    func choice() throws {
        try testCodable(
            json: """
            {
                "type": {
                    "choose": [
                        "celestial",
                        "fiend"
                    ]
                }
            }
            """,
            value: Creature.CreatureType(
                .choice([.celestial, .fiend])
            )
        )
    }

    @Test("Tagged creature type")
    func tagged() throws {
        try testCodable(
            json: """
            {
                "type": "undead",
                "tags": [
                    "wizard",
                    {
                        "tag": "elf",
                        "prefix": "Dusk"
                    }
                ]
            }
            """,
            value: Creature.CreatureType(
                .type(.undead),
                tags: [
                    .tag("wizard"),
                    .prefixed("elf", prefix: "Dusk")
                ]
            )
        )
    }

    @Test("Creature with swarm size")
    func swarm() throws {
        try testCodable(
            json: """
            {
                "type": "aberration",
                "swarmSize": "T"
            }
            """,
            value: Creature.CreatureType(
                .type(.aberration),
                swarmSize: .tiny
            )
        )
    }

    @Test("Sidekick")
    func sidekick() throws {
        try testCodable(
            json: """
            {
                "type": "humanoid",
                "tags": [
                    "dwarf"
                ],
                "sidekickType": "spellcaster",
                "sidekickTags": [
                    "attacker"
                ],
                "sidekickHidden": true
            }
            """,
            value: Creature.CreatureType(
                .type(.humanoid),
                tags: [.tag("dwarf")],
                sidekickType: .spellcaster,
                sidekickTags: [.tag("attacker")],
                sidekickHidden: true
            )
        )
    }

    @Test("Creature type with note")
    func note() throws {
        // Doesn't appear in the bestiary, but implement/test anyway.
        try testCodable(
            json: """
            {
                "type": "fiend",
                "note": "only when hungry"
            }
            """,
            value: Creature.CreatureType(
                .type(.fiend),
                note: "only when hungry"
            )
        )
    }

}

struct CreatureDamageImmunityCodableTests {

    @Test("Damage immunity")
    func damageImmunity() throws {
        try testCodable(
            json: """
            "necrotic"
            """,
            value: Creature.DamageImmunity.damage(.necrotic),
        )
    }

    @Test("Special damage immunity")
    func specialDamageImmunity() throws {
        try testCodable(
            json: """
            {
                "special": "immune to custard damage"
            }
            """,
            value: Creature.DamageImmunity.special("immune to custard damage"),
        )
    }

    @Test("Conditional immunity")
    func conditionalImmunity() throws {
        try testCodable(
            json: """
            {
                "immune": [
                    "bludgeoning",
                    "piercing",
                    "slashing"
                ],
                "note": "from nonmagical attacks that aren't silvered",
                "cond": true
            }
            """,
            value: Creature.DamageImmunity.conditional(
                [
                    .damage(.bludgeoning),
                    .damage(.piercing),
                    .damage(.slashing),
                ],
                note: "from nonmagical attacks that aren't silvered",
                conditional: true,
            ),
        )
    }

    @Test("Conditional immunity with pre-note")
    func conditionalImmunityPreNote() throws {
        try testCodable(
            json: """
            {
                "immune": [
                    "psychic",
                ],
                "preNote": "While wearing tin foil hat:"
            }
            """,
            value: Creature.DamageImmunity.conditional(
                [
                    .damage(.psychic),
                ],
                preNote: "While wearing tin foil hat:",
            ),
        )
    }

    @Test("Recursive conditional immunity")
    func recursiveConditionalImmunity() throws {
        try testCodable(
            json: """
            {
                "immune": [
                    "psychic",
                    {
                        "immune": [
                            "lightning"
                        ],
                        "note": "when grounded",
                        "cond": true
                    }
                ],
                "preNote": "While wearing tin foil hat:"
            }
            """,
            value: Creature.DamageImmunity.conditional(
                [
                    .damage(.psychic),
                    .conditional(
                        [
                            .damage(.lightning),
                        ],
                        note: "when grounded",
                        conditional: true,
                    ),
                ],
                preNote: "While wearing tin foil hat:",
            ),
        )
    }

}

struct CreatureDamageResistanceCodableTests {

    @Test("Damage resistance")
    func damageResistance() throws {
        try testCodable(
            json: """
            "necrotic"
            """,
            value: Creature.DamageResistance.damage(.necrotic),
        )
    }

    @Test("Special damage resistance")
    func specialDamageResistance() throws {
        try testCodable(
            json: """
            {
                "special": "resistant to custard damage"
            }
            """,
            value: Creature.DamageResistance.special("resistant to custard damage"),
        )
    }

    @Test("Conditional resistance")
    func conditionalResistance() throws {
        try testCodable(
            json: """
            {
                "resist": [
                    "bludgeoning",
                    "piercing",
                    "slashing"
                ],
                "note": "from nonmagical attacks that aren't silvered",
                "cond": true
            }
            """,
            value: Creature.DamageResistance.conditional(
                [
                    .damage(.bludgeoning),
                    .damage(.piercing),
                    .damage(.slashing),
                ],
                note: "from nonmagical attacks that aren't silvered",
                conditional: true,
            ),
        )
    }

    @Test("Conditional resistance with pre-note")
    func conditionalResistancePreNote() throws {
        try testCodable(
            json: """
            {
                "resist": [
                    "psychic",
                ],
                "preNote": "While wearing tin foil hat:"
            }
            """,
            value: Creature.DamageResistance.conditional(
                [
                    .damage(.psychic),
                ],
                preNote: "While wearing tin foil hat:",
            ),
        )
    }

    @Test("Recursive conditional resistance")
    func recursiveConditionalResistance() throws {
        try testCodable(
            json: """
            {
                "resist": [
                    "psychic",
                    {
                        "resist": [
                            "lightning"
                        ],
                        "note": "when grounded",
                        "cond": true
                    }
                ],
                "preNote": "While wearing tin foil hat:"
            }
            """,
            value: Creature.DamageResistance.conditional(
                [
                    .damage(.psychic),
                    .conditional(
                        [
                            .damage(.lightning),
                        ],
                        note: "when grounded",
                        conditional: true,
                    ),
                ],
                preNote: "While wearing tin foil hat:",
            ),
        )
    }

}

struct CreatureDamageVulnerabilityCodableTests {

    @Test("Damage vulnerability")
    func damageVulnerability() throws {
        try testCodable(
            json: """
            "necrotic"
            """,
            value: Creature.DamageVulnerability.damage(.necrotic),
        )
    }

    @Test("Special damage vulnerability")
    func specialDamageVulnerability() throws {
        try testCodable(
            json: """
            {
                "special": "vulnerable to custard damage"
            }
            """,
            value: Creature.DamageVulnerability.special("vulnerable to custard damage"),
        )
    }

    @Test("Conditional vulnerability")
    func conditionalVulnerability() throws {
        try testCodable(
            json: """
            {
                "vulnerable": [
                    "piercing"
                ],
                "note": "from magic weapons wielded by good creatures",
                "cond": true
            }
            """,
            value: Creature.DamageVulnerability.conditional(
                [
                    .damage(.piercing),
                ],
                note: "from magic weapons wielded by good creatures",
                conditional: true,
            ),
        )
    }

    @Test("Conditional vulnerability with pre-note")
    func conditionalVulnerabilityPreNote() throws {
        try testCodable(
            json: """
            {
                "vulnerable": [
                    "cold",
                ],
                "preNote": "While not wearing pants:"
            }
            """,
            value: Creature.DamageVulnerability.conditional(
                [
                    .damage(.cold),
                ],
                preNote: "While not wearing pants:"
            ),
        )
    }

    @Test("Recursive conditional vulnerability")
    func recursiveConditionalVulnerability() throws {
        try testCodable(
            json: """
            {
                "vulnerable": [
                    "piercing",
                    {
                        "vulnerable": [
                            "psychic"
                        ],
                        "note": "while charmed by the attacker",
                        "cond": true
                    }
                ],
                "note": "from magic weapons wielded by good creatures",
                "cond": true
            }
            """,
            value: Creature.DamageVulnerability.conditional(
                [
                    .damage(.piercing),
                    .conditional(
                        [
                            .damage(.psychic),
                        ],
                        note: "while charmed by the attacker",
                        conditional: true
                    ),
                ],
                note: "from magic weapons wielded by good creatures",
                conditional: true,
            ),
        )
    }

}

struct CreatureGearCodableTests {

    @Test("Gear")
    func gear() throws {
        try testCodable(
            json: """
            "chain mail|xphb"
            """,
            value: Creature.Gear("chain mail|xphb"),
        )
    }

    @Test("Gear with quantity")
    func gearWithQuantity() throws {
        try testCodable(
            json: """
            {
                "item": "dagger|xphb",
                "quantity": 4
            }
            """,
            value: Creature.Gear("dagger|xphb", quantity: 4),
        )
    }

}

struct CreatureHitPointsCodableTests {

    @Test("Hit points")
    func hitPoints() throws {
        try testCodable(
            json: """
            {
                "formula": "2d8 + 3",
                "average": 12
            }
            """,
            value: Creature.HitPoints.hp(DiceNotation(.d8, count: 2, modifier: 3)),
        )
    }

    @Test("Hit points with wrong average")
    func wrongAverage() throws {
        try testCodable(
            json: """
            {
                "formula": "2d8 + 3",
                "average": 14
            }
            """,
            value: Creature.HitPoints.hp(
                DiceNotation(.d8, count: 2, modifier: 3),
                givenAverage: 14
            ),
        )
    }

    @Test("Hit points with unparseable formula")
    func invalidFormula() throws {
        try testCodable(
            json: """
            {
                "formula": "fixed",
                "average": 50
            }
            """,
            value: Creature.HitPoints.unrollable(formula: "fixed", average: 50),
        )
    }

    @Test("Special")
    func special() throws {
        try testCodable(
            json: """
            {
                "special": "as summoner"
            }
            """,
            value: Creature.HitPoints.special("as summoner"),
        )
    }

}

struct CreatureInitiativeCodableTests {

    @Test("Initiative value")
    func initiative() throws {
        try testCodable(
            json: """
            {
                "initiative": 12
            }
            """,
            value: Creature.Initiative(
                initiative: 12,
            ),
        )
    }

    @Test("Proficiency value")
    func proficient() throws {
        try testCodable(
            json: """
            {
                "proficiency": 1
            }
            """,
            value: Creature.Initiative(
                proficiency: .proficient,
            ),
        )
    }

    @Test("Advantage")
    func advantage() throws {
        try testCodable(
            json: """
            {
                "advantageMode": "adv"
            }
            """,
            value: Creature.Initiative(
                advantage: .advantage,
            ),
        )
    }

    @Test("Disadvantage")
    func disadvantage() throws {
        try testCodable(
            json: """
            {
                "advantageMode": "dis"
            }
            """,
            value: Creature.Initiative(
                advantage: .disadvantage,
            ),
        )
    }

    @Test("Raw value")
    func rawInitiative() throws {
        // This doesn't appear anywhere in the bestiary, but is valid in the schema.
        try testCodable(
            json: """
            12
            """,
            value: Creature.Initiative(
                initiative: 12,
            ),
        )
    }

}

class CreaturePassiveCodableTests {

    @Test("Passive score")
    func score() throws {
        try testCodable(
            json: """
            16
            """,
            value: Creature.Passive.score(16),
        )
    }

    @Test("Special passive score")
    func special() throws {
        // Unlike other specials, this is just a string instead of an integer.
        try testCodable(
            json: """
            "can't see"
            """,
            value: Creature.Passive.special("can't see"),
        )
    }

}

struct CreatureSaveCodableTests {

    @Test("Saving throws")
    func save() throws {
        try testCodable(
            json: """
            {
                "str": "+5",
                "con": "+3",
            }
            """,
            value: Creature.Save(
                str: "+5",
                con: "+3",
            ),
        )
    }

}

struct CreatureShortNameCodableTests {

    @Test("Name")
    func name() throws {
        try testCodable(
            json: """
            "name"
            """,
            value: Creature.ShortName.name("name")
        )
    }

    @Test("Use (full) name")
    func useName() throws {
        try testCodable(
            json: """
            true
            """,
            value: Creature.ShortName.useName
        )
    }

}

struct CreatureSkillSetCodableTests {

    @Test("Skill set")
    func skill() throws {
        try testCodable(
            json: """
            {
                "deception": "+5",
                "perception": "+4",
                "stealth": "+3"
            }
            """,
            value: Creature.SkillSet([
                .deception: "+5",
                .perception: "+4",
                .stealth: "+3",
            ]),
        )
    }

    @Test("Skill set with choices")
    func otherOneOf() throws {
        try testCodable(
            json: """
            {
                "deception": "+5",
                "perception": "+4",
                "other": [
                    {
                        "oneOf": {
                            "arcana": "+7",
                            "history": "+7",
                            "nature": "+7",
                            "religion": "+7"
                        }
                    }
                ]
            }
            """,
            value: Creature.SkillSet(
                [
                    .deception: "+5",
                    .perception: "+4",
                ],
                other: [
                    [
                        .arcana: "+7",
                        .history: "+7",
                        .nature: "+7",
                        .religion: "+7",
                    ]
                ],
            )
        )
    }

}

struct CreatureSkillSetSubscriptTests {

    @Test("Get skill by subscript")
    func getSubscript() {
        let skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        #expect(skill[.deception] == "+5")
    }

    @Test("Get unset skill by subscript")
    func getSubscriptUnset() {
        let skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        #expect(skill[.nature] == nil)
    }

    @Test("Set skill by subscript")
    func setSubscript() {
        var skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        skill[.nature] = "+2"

        #expect(skill.skills == [
            .deception: "+5",
            .perception: "+4",
            .nature: "+2",
        ])
    }

    @Test("Change skill by subscript")
    func changeSubscript() {
        var skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        skill[.perception] = "+2"

        #expect(skill.skills == [
            .deception: "+5",
            .perception: "+2",
        ])
    }

}

struct CreatureToolSetTests {

    @Test("Tool set")
    func tool() throws {
        try testCodable(
            json: """
            {
                "cobbler's tools": "+1",
                "smith's tools": "+2"
            }
            """,
            value: Creature.ToolSet([
                .cobblersTools: "+1",
                .smithsTools: "+2",
            ]),
        )
    }

}

struct CreatureToolSetSubscriptTests {

    @Test("Get tool by subscript")
    func getSubscript() {
        let tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        #expect(tool[.smithsTools] == "+2")
    }

    @Test("Get unset tool by subscript")
    func getSubscriptUnset() {
        let tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        #expect(tool[.brewersSupplies] == nil)
    }

    @Test("Set tool by subscript")
    func setSubscript() {
        var tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        tool[.brewersSupplies] = "+3"

        #expect(tool.tools == [
            .cobblersTools: "+1",
            .smithsTools: "+2",
            .brewersSupplies: "+3",
        ])
    }

    @Test("Change tool by subscript")
    func changeSubscript() {
        var tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        tool[.smithsTools] = "+3"

        #expect(tool.tools == [
            .cobblersTools: "+1",
            .smithsTools: "+3",
        ])
    }

}
