//
//  Meta+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

import Testing
@testable import FifthEdition

struct MetaCodableTests {
    @Test
    func `Meta with dependencies`() throws {
        try testCodable(
            json: """
            {
                "dependencies": {
                    "monster": [
                        "MM",
                        "VRGR"
                    ]
                }
            }
            """,
            value: Meta(
                dependencies: [.monster: ["MM", "VRGR"]],
            ),
        )
    }

    @Test
    func `Meta with internalCopies`() throws {
        try testCodable(
            json: """
            {
                "internalCopies": [
                    "monster",
                    "monsterFluff"
                ]
            }
            """,
            value: Meta(
                internalCopies: [.monster, .monsterFluff],
            ),
        )
    }

    @Test
    func `Meta with otherSources`() throws {
        try testCodable(
            json: """
            {
                "otherSources": {
                    "monster": {
                        "MM": "CoS",
                        "VRGR": "CoS"
                    }
                }
            }
            """,
            value: Meta(
                otherSources: [.monster: ["MM": "CoS", "VRGR": "CoS"]],
            ),
        )
    }
}

struct MetaEntityCodableTests {
    static let testValues = [
        Meta.Entity.monster,
        Meta.Entity.monsterFluff,
    ]

    @Test(arguments: testValues)
    func entities(_ entity: Meta.Entity) throws {
        try testCodable(
            json: """
            "\(entity.rawValue)"
            """,
            value: entity,
        )
    }

    @Test
    func `Unknown entity`() throws {
        try testCodable(
            json: """
            "userManual"
            """,
            value: Meta.Entity(rawValue: "userManual"),
        )
    }
}

struct MetaEntityCodingKeyTests {
    static let testValues = [
        Meta.Entity.monster,
        Meta.Entity.monsterFluff,
    ]

    @Test(arguments: testValues)
    func `Entity can be used as dictionary key`(_ entity: Meta.Entity) throws {
        try testCodable(
            json: """
            {
                "\(entity.rawValue)": 42
            }
            """,
            value: [
                entity: 42,
            ],
        )
    }

    @Test
    func `Unknown entity can be used as dictionary key`() throws {
        try testCodable(
            json: """
            {
                "userManual": 42
            }
            """,
            value: [
                Meta.Entity(rawValue: "userManual"): 42,
            ],
        )
    }
}
