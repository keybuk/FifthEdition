//
//  Meta+StringTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/8/26.
//

import Testing
@testable import FifthEdition

struct MetaEntityStringTests {
    @Test
    func `init(stringLiteral:) sets rawValue`() {
        let entity: Meta.Entity = "monster"
        #expect(entity == .monster)
    }

    @Test
    func `init(stringLiteral:) sets rawValue for unknown`() {
        let entity: Meta.Entity = "userManual"
        #expect(entity == Meta.Entity(rawValue: "userManual"))
    }

    @Test
    func `description is rawValue`() {
        #expect(String(describing: Meta.Entity.monster) == "monster")
    }

    @Test
    func `description is rawValue for unknown`() {
        #expect(String(describing: Meta.Entity(rawValue: "userManual")) == "userManual")
    }
}
