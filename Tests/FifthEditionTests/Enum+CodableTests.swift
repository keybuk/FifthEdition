//
//  Enum+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
//

import Testing
@testable import FifthEdition

struct ActionTagCodableTests {
    @Test(arguments: ActionTag.allCases)
    func `Action tags`(actionTag: ActionTag) throws {
        try testCodable(
            json: """
            "\(actionTag.rawValue)"
            """,
            value: actionTag,
        )
    }
}

struct DamageTagCodableTests {
    @Test(arguments: Damage.codingValues)
    func `Damage alternate coding`(damage: Damage, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: AlternateCoding(damage),
        )
    }

    @Test
    func `Damage set alternate coding`() throws {
        try testCodable(
            json: """
            [
                "B",
                "S"
            ]
            """,
            value: AlternateSetCoding<Damage>([
                .bludgeoning,
                .slashing,
            ]),
        )
    }
}

struct LanguageTagCodableTests {
    @Test(arguments: LanguageTag.allCases)
    func `Language tag`(languageTag: LanguageTag) throws {
        try testCodable(
            json: """
            "\(languageTag.rawValue)"
            """,
            value: languageTag,
        )
    }

    @Test(arguments: LanguageTag.codingValues)
    func `Language tag alternate coding`(languageTag: LanguageTag, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: AlternateCoding(languageTag),
        )
    }

    @Test
    func `Language tag set alternate coding`() throws {
        try testCodable(
            json: """
            [
                "LF",
                "TP"
            ]
            """,
            value: AlternateSetCoding<LanguageTag>([
                .languagesKnownInLife,
                .telepathy,
            ]),
        )
    }
}

struct MiscTagCodableTests {
    @Test(arguments: MiscTag.allCases)
    func `Misc tag`(miscTag: MiscTag) throws {
        try testCodable(
            json: """
            "\(miscTag.rawValue)"
            """,
            value: miscTag,
        )
    }

    @Test(arguments: MiscTag.codingValues)
    func `Misc tag alternate coding`(miscTag: MiscTag, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: AlternateCoding(miscTag),
        )
    }

    @Test
    func `Misc tag set alternate coding`() throws {
        try testCodable(
            json: """
            [
                "AOE",
                "CUR"
            ]
            """,
            value: AlternateSetCoding<MiscTag>([
                .hasAreasOfEffect,
                .inflictsCurse,
            ]),
        )
    }
}

struct SpellcastingTagCodableTests {
    @Test(arguments: SpellcastingTag.allCases)
    func `Spellcasting types`(spellcastingTag: SpellcastingTag) throws {
        try testCodable(
            json: """
            "\(spellcastingTag.rawValue)"
            """,
            value: spellcastingTag,
        )
    }

    @Test(arguments: SpellcastingTag.codingValues)
    func `Spellcasting type alternate coding`(spellcastingTag: SpellcastingTag, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: AlternateCoding(spellcastingTag),
        )
    }

    @Test
    func `Spellcasting type set alternate coding`() throws {
        try testCodable(
            json: """
            [
                "P",
                "I",
            ]
            """,
            value: AlternateSetCoding<SpellcastingTag>([
                .innate,
                .psionics,
            ]),
        )
    }
}

struct TraitTagCodableTests {
    @Test(arguments: TraitTag.allCases)
    func `Trait tags`(traitTag: TraitTag) throws {
        try testCodable(
            json: """
            "\(traitTag.rawValue)"
            """,
            value: traitTag,
        )
    }
}
