//
//  Corpus+StringTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

import Testing
@testable import FifthEdition

struct CorpusContentsHeaderStringTests {
    @Test
    func `init(stringLiteral:) sets header`() {
        let header: CorpusContents.Header = "Introduction"
        #expect(header.header == "Introduction")
    }
}

struct CorpusContentsOrdinalIdentifierStringTests {
    @Test
    func `init(integerLiteral:) sets .integer`() {
        let identifier: CorpusContents.Ordinal.Identifier = 1
        #expect(identifier == .integer(1))
    }

    @Test
    func `init(stringLiteral:) sets .string`() {
        let identifier: CorpusContents.Ordinal.Identifier = "A"
        #expect(identifier == .string("A"))
    }

    @Test
    func `description for integer`() {
        #expect(String(describing: CorpusContents.Ordinal.Identifier.integer(1)) == "1")
    }

    @Test
    func `description for string`() {
        #expect(String(describing: CorpusContents.Ordinal.Identifier.string("A")) == "A")
    }
}
