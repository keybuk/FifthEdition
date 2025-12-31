//
//  Util+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Testing
@testable import FifthEdition

struct AlignmentCodableTests {

    static let testAlignments: [Alignment: [String]] = [
        [.lawful, .good]:
            ["L", "G"],
        [.lawful, .neutral]:
            ["L", "N"],
        [.lawful, .evil]:
            ["L", "E"],
        [.neutral]:
            ["N"],
        [.chaotic, .good]:
            ["C", "G"],
        [.chaotic, .neutral]:
            ["C", "N"],
        [.chaotic, .evil]:
            ["C", "E"],
        [.lawful, .neutralLawfulChaotic, .chaotic]:
            ["L", "NX", "C"],
        [.neutralGoodEvil, .good, .evil]:
            ["NY", "G", "E"],
        [.lawful, .neutralLawfulChaotic, .chaotic, .evil]:
            ["L", "NX", "C", "E"],
        [.lawful, .neutralLawfulChaotic, .chaotic, .neutralGoodEvil, .evil]:
            ["L", "NX", "C", "NY", "E"],
        [.neutralLawfulChaotic, .neutralGoodEvil, .neutral]:
            ["NX", "NY", "N"],
    ]

    @Test("Alignment", arguments: testAlignments)
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

struct IndexFileCodableTests {

    @Test("Index file")
    func index() throws {
        try testCodable(
            json: """
            {
              "XDMG" : "foo-xdmg.json",
              "XMM" : "foo-xmm.json",
              "XPHB" : "foo-xphb.json"
            }
            """,
            value: IndexFile(
                entries: [
                    "XDMG": "foo-xdmg.json",
                    "XMM": "foo-xmm.json",
                    "XPHB": "foo-xphb.json",
                ],
            )
        )

    }

}

struct PageCodableTests {

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

struct ProficiencyCodableTests {

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

struct ReprintCodableTests {

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

struct SourceCodableTests {

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

struct SpeedCodableTests {

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

struct SrdReferenceCodableTests {

    @Test("In SRD")
    func srd() throws {
        try testCodable(
            json: """
            true
            """,
            value: SrdReference.present(true)
        )
    }

    @Test("In SRD with alternate name")
    func srdAlteranteName() throws {
        try testCodable(
            json: """
            "Generic Monster"
            """,
            value: SrdReference.presentAs("Generic Monster")
        )
    }

}

struct TagCodableTests {

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

