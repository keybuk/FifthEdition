//
//  UtilTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Testing
@testable import FifthEdition

struct PageCodableTests: CodableTest {

    @Test("Numeric page")
    func number() throws {
        try testCodable(
            json: """
            42
            """,
            value: Page.number(42)
        )
    }

    @Test("Roman numeral page")
    func numeral() throws {
        try testCodable(
            json: """
            "xxxxii"
            """,
            value: Page.numeral("xxxxii")
        )
    }

}

struct SourceCodableTests: CodableTest {

    @Test("Source")
    func source() throws {
        try testCodable(
            json: """
            {
                "source": "XMM"
            }
            """,
            value: Source(source: "XMM")
        )
    }

    @Test("Source with page")
    func sourceWithPage() throws {
        try testCodable(
            json: """
            {
                "source": "XPHB",
                "page": 346
            }
            """,
            value: Source(
                source: "XPHB",
                page: .number(346)
            )
        )
    }
}

struct ReprintCodableTests: CodableTest {

    @Test("Reprint")
    func reprint() throws {
        try testCodable(
            json: """
            "Adult Black Dragon|XMM"
            """,
            value: Reprint(uid: "Adult Black Dragon|XMM")
        )
    }

    @Test("Reprint with tag")
    func reprintWithTag() throws {
        try testCodable(
            json: """
            {
                "uid": "Net|XPHB",
                "tag": "item"
            }
            """,
            value: Reprint(
                uid: "Net|XPHB",
                tag: "item",
            )
        )
    }

    @Test("Reprint with edition")
    func reprintWithEdition() throws {
        try testCodable(
            json: """
            {
                "uid": "Amethyst|XDMG",
                "edition": "one"
            }
            """,
            value: Reprint(
                uid: "Amethyst|XDMG",
                edition: .one,
            )
        )
    }

}

struct TagCodableTests: CodableTest {

    @Test("Tag")
    func tag() throws {
        try testCodable(
            json: """
            "tag"
            """,
            value: Tag.tag("tag")
        )
    }

    @Test("Prefixed tag")
    func prefixed() throws {
        try testCodable(
            json: """
            {
                "tag": "tag",
                "prefix": "prefix"
            }
            """,
            value: Tag.prefixed("tag", prefix: "prefix")
        )
    }

}

struct SpeedCodableTests: CodableTest {

    @Test("Walk speed")
    func walk() throws {
        try testCodable(
            json: """
            {
                "walk": 30
            }
            """,
            value: Speed([
                .walk: .speed(30),
            ]),
        )
    }

    @Test("Burrow speed")
    func burrow() throws {
        try testCodable(
            json: """
            {
                "burrow": 30
            }
            """,
            value: Speed([
                .burrow: .speed(30)
            ]),
        )
    }

    @Test("Climb speed")
    func climb() throws {
        try testCodable(
            json: """
            {
                "climb": 30
            }
            """,
            value: Speed([
                .climb: .speed(30)
            ]),
        )
    }

    @Test("Fly speed")
    func fly() throws {
        try testCodable(
            json: """
            {
                "fly": 30
            }
            """,
            value: Speed([
                .fly: .speed(30),
            ]),
        )
    }

    @Test("Swim speed")
    func swim() throws {
        try testCodable(
            json: """
            {
                "swim": 30
            }
            """,
            value: Speed([
                .swim: .speed(30)
            ]),
        )
    }

    @Test("Conditional speed")
    func conditional() throws {
        try testCodable(
            json: """
            {
                "walk": 30,
                "fly": {
                    "number": 60,
                    "condition": "(hover)"
                },
                "canHover": true
            }
            """,
            value: Speed(
                [
                    .walk: .speed(30),
                    .fly: .conditional(60, condition: "(hover)"),
                ],
                canHover: true,
            ),
        )
    }

    @Test("Choice of speed")
    func choice() throws {
        try testCodable(
            json: """
            {
                "walk": 20,
                "choose": {
                    "amount": 20,
                    "from": [
                        "climb",
                        "fly"
                    ],
                    "note": "(DM's choice)"
                }
            }
            """,
            value: Speed(
                [
                    .walk: .speed(20)
                ],
                choose: .init(
                    from: [.climb, .fly],
                    amount: 20,
                    note: "(DM's choice)"
                )
            ),
        )
    }

    @Test("Alternate speed")
    func alternate() throws {
        try testCodable(
            json: """
            {
                "walk": 30,
                "alternate": {
                    "climb": [
                        {
                            "number": 50,
                            "condition": "in serpent form"
                        }
                    ],
                    "walk": [
                        {
                            "number": 50,
                            "condition": "in serpent form"
                        }
                    ]
                }
            }
            """,
            value: Speed(
                [
                    .walk: .speed(30)
                ],
                alternate: .init([
                    .walk: [.conditional(50, condition: "in serpent form")],
                    .climb: [.conditional(50, condition: "in serpent form")],
                ]),
            ),
        )
    }

    @Test("Hidden speed")
    func hidden() throws {
        try testCodable(
            json: """
            {
                "walk": 30,
                "burrow": 45,
                "climb": 45,
                "hidden": [
                    "burrow",
                    "climb"
                ]
            }
            """,
            value: Speed(
                [
                    .walk: .speed(30),
                    .burrow: .speed(45),
                    .climb: .speed(45),
                ],
                hidden: [.burrow, .climb],
            ),
        )
    }

    @Test("Constant speed")
    func constant() throws {
        // This doesn't appear anywhere in the bestiary, so we'll decode it as a walk speed and not worry about encoding identically.
        try testCodable(
            json: """
            100
            """,
            value: Speed([
                .walk: .speed(100),
            ]),
        )
    }

    @Test("Speed varies")
    func varies() throws {
        // This doesn't appear anywhere in the bestiary, so we'll use an object with all-empty properties.
        try testCodable(
            json: """
            "Varies"
            """,
            value: Speed.varies,
        )
    }

}

struct SpeedSubscriptTests {

    @Test("Get speed by subscript")
    func getSubscript() {
        let speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        #expect(speed[.walk] == .speed(30))
    }

    @Test("Get unset speed by subscript")
    func getSubscriptUnset() {
        let speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        #expect(speed[.burrow] == nil)
    }

    @Test("Set speed by subscript")
    func setSubscript() {
        var speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        speed[.burrow] = .speed(10)

        #expect(speed.speeds == [
            .walk: .speed(30),
            .climb: .speed(60),
            .burrow: .speed(10),
        ])
    }

    @Test("Change speed by subscript")
    func changeSubscript() {
        var speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        speed[.climb] = .speed(120)

        #expect(speed.speeds == [
            .walk: .speed(30),
            .climb: .speed(120),
        ])
    }

    @Test("Get alternate speed by subscript")
    func getAlternateSubscript() {
        let speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        #expect(speed.alternate?[.climb] == [.speed(60), .speed(90)])
    }

    @Test("Get unset alternate speed by subscript")
    func getAlternateSubscriptUnset() {
        let speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
                .burrow: .speed(10),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        #expect(speed.alternate?[.burrow] == nil)
    }

    @Test("Set alternate speed by subscript")
    func setAlternateSubscript() {
        var speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
                .burrow: .speed(10),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        speed.alternate?[.burrow] = [.speed(10), .speed(20)]

        #expect(speed.alternate?.speeds == [
            .climb: [.speed(60), .speed(90)],
            .burrow: [.speed(10), .speed(20)],
        ])
    }

    @Test("Change alternate speed by subscript")
    func changeAlternateSubscript() {
        var speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        speed.alternate?[.climb] = [.speed(60), .speed(120)]

        #expect(speed.alternate?.speeds == [
            .climb: [.speed(60), .speed(120)],
        ])
    }

}

struct CreatureTypeCodableTests: CodableTest {

    @Test("Creature types", arguments: CreatureType.allCases)
    func creatureType(_ creatureType: CreatureType) throws {
        try testCodable(
            json: """
            "\(creatureType.rawValue)"
            """,
            value: creatureType
        )
    }

}

struct AlignmentCodableTests: CodableTest {

    static let encodedAlignments: [Alignment: [String]] = [
        [.lawful, .good]: ["L", "G"],
        [.lawful, .neutral]: ["L", "N"],
        [.lawful, .evil]: ["L", "E"],
        [.neutral]: ["N"],
        [.chaotic, .good]: ["C", "G"],
        [.chaotic, .neutral]: ["C", "N"],
        [.chaotic, .evil]: ["C", "E"],
        [.lawful, .neutralLawfulChaotic, .chaotic]: ["L", "NX", "C"],
        [.neutralGoodEvil, .good, .evil]: ["NY", "G", "E"],
        [.lawful, .neutralLawfulChaotic, .chaotic, .evil]: ["L", "NX", "C", "E"],
        [.lawful, .neutralLawfulChaotic, .chaotic, .neutralGoodEvil, .evil]: ["L", "NX", "C", "NY", "E"],
        [.neutralLawfulChaotic, .neutralGoodEvil, .neutral]: ["NX", "NY", "N"],
    ]

    @Test("Alignment", arguments: encodedAlignments)
    func alignment(_ alignment: Alignment, strings: [String]) throws {
        try testCodable(
            json: "[\"" + strings.joined(separator: "\",\"") + "\"]",
            value: alignment
        )
    }

    @Test("Unaligned")
    func unaligned() throws {
        try testCodable(
            json: """
            [
                "U"
            ]
            """,
            value: Alignment.unaligned
        )
    }

    @Test("Any")
    func any() throws {
        try testCodable(
            json: """
            [
                "A"
            ]
            """,
            value: Alignment.any
        )
    }

}

struct SizeCodableTests: CodableTest {

    static let encodedSizes: [Size: String] = [
        .tiny:       "T",
        .small:      "S",
        .medium:     "M",
        .large:      "L",
        .huge:       "H",
        .gargantuan: "G",
    ]

    @Test("Sizes", arguments: encodedSizes)
    func common(_ size: Size, string: String) throws {
        try testCodable(
            json: """
            "\(string)"
            """,
            value: size
        )
    }

}

struct ProficiencyCodableTests: CodableTest {

    @Test("Proficient")
    func proficient() throws {
        try testCodable(
            json: """
            1
            """,
            value: Proficiency.proficient
        )
    }

    @Test("Expertise")
    func expertise() throws {
        try testCodable(
            json: """
            2
            """,
            value: Proficiency.expertise
        )
    }

}

struct SkillCodableTests: CodableTest {

    @Test("Skills", arguments: Skill.allCases)
    func skill(_ skill: Skill) throws {
        try testCodable(
            json: """
            "\(skill.rawValue)"
            """,
            value: skill
        )
    }

}

struct ToolCodableTests: CodableTest {

    @Test("Tools", arguments: Tool.allCases)
    func tool(_ tool: Tool) throws {
        try testCodable(
            json: """
            "\(tool.rawValue)"
            """,
            value: tool
        )
    }

}
