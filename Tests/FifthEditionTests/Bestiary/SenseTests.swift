//
//  SenseTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/19/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct LanguageCodableTests {
    @Test(arguments: Language.allCases)
    func `Language is encoded as rawValue`(language: Language) throws {
        try testCodable(
            json: """
            "\(language.rawValue)"
            """,
            value: language,
        )
    }

    @Test
    func `Unknown language is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "klingon"
            """,
            value: Language.other("klingon"),
        )
    }
}

struct LanguageComparableTests {
    @Test(arguments: zip(Language.allCases, Language.allCases.dropFirst()))
    func `Language smaller than next`(a: Language, b: Language) {
        #expect(a < b)
    }

    @Test(arguments: Language.allCases)
    func `Language smaller than unknown`(language: Language) {
        #expect(language < Language.other("klingon"))
    }
}

struct LanguageFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Language.allCases)
    func `language() formats capitalized name`(language: Language) {
        let formatter = Language.FormatStyle().locale(Self.locale)
        let description = formatter.format(language)
        #expect(description == language.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(language)
        #expect(String(attributed.characters) == description)
        #expect(attributed.language == language)
    }

    @Test(arguments: Language.allCases)
    func `language(case:) formats lowercased name`(language: Language) {
        let formatter = Language.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(language)
        #expect(description == language.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(language)
        #expect(String(attributed.characters) == description)
        #expect(attributed.language == language)
    }

    @Test(arguments: Language.FormatStyle.Case.allCases)
    func `language(case:) formats unmodified unknown language`(case: Language.FormatStyle.Case) {
        let language = Language.other("klingon")

        let formatter = Language.FormatStyle(case: `case`).locale(Self.locale)
        let description = formatter.format(language)
        #expect(description == "klingon")

        let attributed = formatter.attributed.format(language)
        #expect(String(attributed.characters) == description)
        #expect(attributed.language == language)
    }
}

struct LanguageRawRepresentableTests {
    static let expectedValues: [(Language, String)] = [
        (.all, "all"),
        (.aarakocra, "aarakocra"),
        (.aartuk, "aartuk"),
        (.abyssal, "abyssal"),
        (.aquan, "aquan"),
        (.auran, "auran"),
        (.blinkDog, "blink dog"),
        (.bothii, "bothii"),
        (.bullywug, "bullywug"),
        (.celestial, "celestial"),
        (.common, "common"),
        (.commonSignLanguage, "common sign language"),
        (.deepCrow, "deep crow"),
        (.deepSpeech, "deep speech"),
        (.demodand, "demodand"),
        (.dohwar, "dohwar"),
        (.draconic, "draconic"),
        (.druidic, "druidic"),
        (.dwarvish, "dwarvish"),
        (.elvish, "elvish"),
        (.endspeech, "endspeech"),
        (.formian, "formian"),
        (.giant, "giant"),
        (.giantEagle, "giant eagle"),
        (.giantElk, "giant elk"),
        (.giantOwl, "giant owl"),
        (.gibberling, "gibberling"),
        (.gith, "gith"),
        (.gnoll, "gnoll"),
        (.gnomish, "gnomish"),
        (.goblin, "goblin"),
        (.grell, "grell"),
        (.grung, "grung"),
        (.hadozee, "hadozee"),
        (.halfling, "halfling"),
        (.homarid, "homarid"),
        (.hookHorror, "hook horror"),
        (.iceToad, "ice toad"),
        (.ignan, "ignan"),
        (.infernal, "infernal"),
        (.ixitxachitl, "ixitxachitl"),
        (.kenderspeak, "kenderspeak"),
        (.kraul, "kraul"),
        (.kruthik, "kruthik"),
        (.leonin, "leonin"),
        (.maelephant, "maelephant"),
        (.merfolk, "merfolk"),
        (.modron, "modron"),
        (.netherese, "netherese"),
        (.orc, "orc"),
        (.otyugh, "otyugh"),
        (.primordial, "primordial"),
        (.primordialAquan, "primordial (aquan)"),
        (.primordialAuran, "primordial (auran)"),
        (.primordialIgnan, "primordial (ignan)"),
        (.primordialTerran, "primordial (terran)"),
        (.quori, "quori"),
        (.sahuagin, "sahuagin"),
        (.skitterwidget, "skitterwidget"),
        (.slaad, "slaad"),
        (.solamnic, "solamnic"),
        (.sphinx, "sphinx"),
        (.sylvan, "sylvan"),
        (.tasloi, "tasloi"),
        (.terran, "terran"),
        (.thayan, "thayan"),
        (.thievesCant, "thieves' cant"),
        (.thriKreen, "thri-kreen"),
        (.tletlahtolli, "tletlahtolli"),
        (.tlincalli, "tlincalli"),
        (.troglodyte, "troglodyte"),
        (.umberHulk, "umber hulk"),
        (.undercommon, "undercommon"),
        (.vegepygmy, "vegepygmy"),
        (.winterWolf, "winter wolf"),
        (.worg, "worg"),
        (.yeti, "yeti"),
        (.yikaria, "yikaria"),
        (.ziklight, "ziklight"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(language: Language, rawValue: String) {
        #expect(Language(rawValue: rawValue) == language)
    }

    @Test
    func `init(rawValue:) sets other for unknown case`() {
        #expect(Language(rawValue: "klingon") == .other("klingon"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(language: Language, rawValue: String) {
        #expect(language.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let language = Language.other("klingon")
        #expect(language.rawValue == "klingon")
    }
}

struct SenseCodableTests {
    static let expectedCoding: [(Sense, String)] = [
        (.blindsight, "B"),
        (.darkvision, "D"),
        (.superiorDarkvision, "SD"),
        (.tremorsense, "T"),
        (.truesight, "U"),
    ]

    @Test(arguments: expectedCoding)
    func `Sense encodes as string`(sense: Sense, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: sense,
        )
    }
}

struct SenseComparableTests {
    @Test(arguments: zip(Sense.allCases, Sense.allCases.dropFirst()))
    func `Sense smaller than next`(a: Sense, b: Sense) {
        #expect(a < b)
    }
}

struct SenseFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Sense.allCases)
    func `sense() formats capitalized name`(sense: Sense) {
        let formatter = Sense.FormatStyle().locale(Self.locale)
        let description = formatter.format(sense)
        #expect(description == sense.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(sense)
        #expect(String(attributed.characters) == description)
        #expect(attributed.sense == sense)
    }

    @Test(arguments: Sense.allCases)
    func `sense(case:) formats lowercased name`(sense: Sense) {
        let formatter = Sense.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sense)
        #expect(description == sense.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(sense)
        #expect(String(attributed.characters) == description)
        #expect(attributed.sense == sense)
    }
}

struct TelepathyFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `telepathy() formats range`() {
        let telepathy = Telepathy.telepathy(range: 60)

        let formatter = Telepathy.FormatStyle().locale(Self.locale)
        let description = formatter.format(telepathy)
        #expect(description == "telepathy 60 ft.")

        let attributed = formatter.attributed.format(telepathy)
        #expect(String(attributed.characters) == description)
        #expect(attributed.telepathy == telepathy)
    }

    @Test
    func `telepathy() formats range with note`() {
        let telepathy = Telepathy.telepathy(range: 60, note: "(other goblins only)")

        let formatter = Telepathy.FormatStyle().locale(Self.locale)
        let description = formatter.format(telepathy)
        #expect(description == "telepathy 60 ft. (other goblins only)")

        let attributed = formatter.attributed.format(telepathy)
        #expect(String(attributed.characters) == description)
        #expect(attributed.telepathy == telepathy)
    }

    @Test
    func `telepathy() formats special`() {
        let telepathy = Telepathy.special("telepathy 1 mile")

        let formatter = Telepathy.FormatStyle().locale(Self.locale)
        let description = formatter.format(telepathy)
        #expect(description == "telepathy 1 mile")

        let attributed = formatter.attributed.format(telepathy)
        #expect(String(attributed.characters) == description)
        #expect(attributed.telepathy == telepathy)
    }
}

struct TelepathyInitTests {
    @Test
    func `init(integerLiteral:) sets telepathy`() {
        let telepathy: Telepathy = 60
        #expect(telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(stringLiteral:) sets special`() {
        let telepathy: Telepathy = "telepathy 1 mile"
        #expect(telepathy == .special("telepathy 1 mile"))
    }
}

struct TelepathyInitStringTests {
    @Test
    func `init(string:) parses telepathy with range`() {
        let telepathy = Telepathy(string: "telepathy 60 ft.")
        #expect(telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(string:) parses capitalized telepathy`() {
        let telepathy = Telepathy(string: "Telepathy 60 ft.")
        #expect(telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(string:) parses telepathy without whitespace`() {
        let telepathy = Telepathy(string: "telepathy 60ft.")
        #expect(telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(string:) parses telepathy with capitalized unit`() {
        let telepathy = Telepathy(string: "Telepathy 60 Ft.")
        #expect(telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(string:) parses telepathy with verbose unit`() {
        let telepathy = Telepathy(string: "telepathy 60 feet")
        #expect(telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(string:) parses telepathy without unit`() {
        let telepathy = Telepathy(string: "telepathy 60")
        #expect(telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(string:) parses additional text after telepathy as note`() {
        let telepathy = Telepathy(string: "telepathy 60 ft. (other goblins only)")
        #expect(telepathy == .telepathy(range: 60, note: "(other goblins only)"))
    }

    @Test
    func `init(string:) parses special rule`() {
        let telepathy = Telepathy(string: "telepathy 1 mile")
        #expect(telepathy == .special("telepathy 1 mile"))
    }
}
