//
//  Adventure+StringTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Testing
@testable import FifthEdition

struct AdventureLevelStringTests {
    @Test
    func `description for range`() {
        #expect(String(describing: Adventure.Level.range(3...15)) == "3–15")
    }

    @Test
    func `description for custom`() {
        #expect(String(describing: Adventure.Level.custom("Players use monster stat blocks")) ==
            "Players use monster stat blocks")
    }
}
