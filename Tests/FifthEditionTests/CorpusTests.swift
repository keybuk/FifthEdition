//
//  CorpusTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CorpusContentsHeaderInitTests {
    @Test
    func `init(stringLiteral:) sets header`() {
        let header: CorpusContents.Header = "Introduction"
        #expect(header.header == "Introduction")
    }
}

struct PublishedCorpusEditionTests {
    @Test
    func `edition for 2014 5e book`() throws {
        let book = try Book(name: "Player's Handbook (2014)",
                            id: "PHB",
                            source: "PHB",
                            group: .core,
                            published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                               year: 2014, month: 8, day: 19).date),
                            contents: [])
        #expect(book.edition == .legacy)
    }

    @Test
    func `edition for 2024 5.5e book`() throws {
        let book = try Book(name: "Player's Handbook (2024)",
                            id: "XPHB",
                            source: "XPHB",
                            group: .core,
                            published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                               year: 2024, month: 9, day: 17).date),
                            contents: [])
        #expect(book.edition == .modern)
    }
}
