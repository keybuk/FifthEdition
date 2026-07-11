//
//  EnumTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

import Testing
@testable import FifthEdition

struct DragonAgeInitTests {
    @Test
    func `init(stringLiteral:) sets rawValue`() {
        let dragonAge: DragonAge = "adult"
        #expect(dragonAge == .adult)
    }

    @Test
    func `init(stringLiteral:) sets rawValue for unknown`() {
        let dragonAge: DragonAge = "geriatric"
        #expect(dragonAge == DragonAge(rawValue: "geriatric"))
    }
}

struct DragonAgeStringTests {
    @Test(arguments: DragonAge.allCases)
    func `description is rawValue`(dragonAge: DragonAge) {
        #expect(String(describing: dragonAge) == dragonAge.rawValue)
    }

    @Test
    func `description is rawValue for unknown`() {
        let dragonAge = DragonAge(rawValue: "geriatric")
        #expect(String(describing: dragonAge) == dragonAge.rawValue)
    }
}

struct DragonColorInitTests {
    @Test
    func `init(stringLiteral:) sets rawValue`() {
        let dragonColor: DragonColor = "copper"
        #expect(dragonColor == .copper)
    }

    @Test
    func `init(stringLiteral:) sets rawValue for unknown`() {
        let dragonColor: DragonColor = "octarine"
        #expect(dragonColor == DragonColor(rawValue: "octarine"))
    }
}

struct DragonColorStringTests {
    @Test(arguments: DragonColor.allCases)
    func `description is rawValue`(dragonColor: DragonColor) {
        #expect(String(describing: dragonColor) == dragonColor.rawValue)
    }

    @Test
    func `description is rawValue for unknown`() {
        let dragonColor = DragonColor(rawValue: "octarine")
        #expect(String(describing: dragonColor) == dragonColor.rawValue)
    }
}
