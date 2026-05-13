//
//  UtilTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Testing
@testable import FifthEdition

struct OrdinalInitTests {
    @Test
    func `init(integerLiteral:) sets number`() {
        let ordinal: Ordinal = 1
        #expect(ordinal == .number(1))
    }

    @Test
    func `init(stringLiteral:) sets numeral`() {
        let ordinal: Ordinal = "A"
        #expect(ordinal == .numeral("A"))
    }
}

struct OrdinalStringTests {
    @Test
    func `description for number`() {
        let ordinal = Ordinal.number(1)
        #expect(String(describing: ordinal) == "1")
    }

    @Test
    func `description for numeral`() {
        let ordinal = Ordinal.numeral("A")
        #expect(String(describing: ordinal) == "A")
    }
}
