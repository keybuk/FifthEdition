//
//  TagTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

import Testing
@testable import FifthEdition

struct ActionTagCodableTests {

    @Test("Action tags", arguments: ActionTag.allCases)
    func actionTag(_ actionTag: ActionTag) throws {
        try testCodable(
            json: """
            "\(actionTag.rawValue)"
            """,
            value: actionTag
        )
    }

}

struct LanguageTagCodableTests {

    @Test("Language tags", .serialized, arguments: LanguageTag.codingMap)
    func languageTag(key: String, languageTag: LanguageTag) throws {
        try testCodable(
            json: """
            "\(key)"
            """,
            value: languageTag
        )
    }

}

struct MiscTagCodableTests {

    @Test("Misc tags", .serialized, arguments: MiscTag.codingMap)
    func miscTag(key: String, miscTag: MiscTag) throws {
        try testCodable(
            json: """
            "\(key)"
            """,
            value: miscTag
        )
    }

}

struct SenseTagCodableTests {

    @Test("Sense tags", .serialized, arguments: SenseTag.codingMap)
    func senseTag(key: String, senseTag: SenseTag) throws {
        try testCodable(
            json: """
            "\(key)"
            """,
            value: senseTag
        )
    }

}

struct SpellcastingTagCodableTests {

    @Test("Spellcasting tags", arguments: SpellcastingTag.codingMap)
    func spellcastingTag(key: String, spellcastingTag: SpellcastingTag) throws {
        try testCodable(
            json: """
            "\(key)"
            """,
            value: spellcastingTag
        )
    }

}

struct TraitTagCodableTests {

    @Test("Trait tag", arguments: TraitTag.allCases)
    func traitTag(_ traitTag: TraitTag) throws {
        try testCodable(
            json: """
            "\(traitTag.rawValue)"
            """,
            value: traitTag
        )
    }

}

