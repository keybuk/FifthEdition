//
//  EntityTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/25/26.
//

import Testing
@testable import FifthEdition

struct EntityCodableTests {
    @Test(arguments: Entity.allCases)
    func entities(_ entity: Entity) throws {
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
            value: Entity(rawValue: "userManual"),
        )
    }

    @Test(arguments: Entity.allCases)
    func `Entity can be used as dictionary key`(_ entity: Entity) throws {
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
                Entity(rawValue: "userManual"): 42,
            ],
        )
    }
}

struct EntityInitTests {
    @Test
    func `init(stringLiteral:) sets rawValue`() {
        let entity: Entity = "monster"
        #expect(entity == .monster)
    }

    @Test
    func `init(stringLiteral:) sets rawValue for unknown`() {
        let entity: Entity = "userManual"
        #expect(entity == Entity(rawValue: "userManual"))
    }
}

struct EntityStringTests {
    @Test(arguments: Entity.allCases)
    func `description is rawValue`(_ entity: Entity) {
        #expect(String(describing: entity) == entity.rawValue)
    }

    @Test
    func `description is rawValue for unknown`() {
        let entity = Entity(rawValue: "userManual")
        #expect(String(describing: entity) == entity.rawValue)
    }
}
