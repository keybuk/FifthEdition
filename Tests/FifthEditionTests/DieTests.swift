//
//  DieTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/8/26.
//

import Testing
@testable import FifthEdition

struct DieComparableTests {
    @Test(arguments: zip(Die.allCases, Die.allCases.dropFirst()))
    func `Die is comparable`(a: Die, b: Die) {
        #expect(a < b)
    }
}

struct DieRawValueTests {
    @Test
    func `rawValue is the number of sizes`() {
        #expect(Die.d20.rawValue == 20)
    }
}

struct DieStringTests {
    @Test
    func `description is the die name`() {
        #expect(String(describing: Die.d20) == "d20")
    }
}
