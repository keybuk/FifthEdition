//
//  Enum+StringTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/8/26.
//

import Testing
@testable import FifthEdition

struct EntityStringTests {
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

    @Test
    func `description is rawValue`() {
        #expect(String(describing: Entity.monster) == "monster")
    }

    @Test
    func `description is rawValue for unknown`() {
        #expect(String(describing: Entity(rawValue: "userManual")) == "userManual")
    }
}
