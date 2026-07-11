//
//  LanguagesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureLanguagesCodableTests {
    @Test
    func `Languages encodes strings`() throws {
        try testCodable(
            json: """
            [
                "Celestial; understands common",
                "elvish",
                "and sylvan but can't speak them; telepathy 60 ft."
            ]
            """,
            value: Creature.Languages([.celestial],
                                      understood: [.common, .elvish, .sylvan],
                                      telepathy: .telepathy(range: 60)),
        )
    }
}

struct CreatureLanguagesCollectionTests {
    @Test
    func `isEmpty returns true if no languages known`() {
        let languages = Creature.Languages([])
        #expect(languages.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if languages spoken`() {
        let languages = Creature.Languages([.common, .draconic])
        #expect(languages.isEmpty == false)
    }

    @Test
    func `isEmpty returns false if languages understood`() {
        let languages = Creature.Languages(understood: [.abyssal, .infernal])
        #expect(languages.isEmpty == false)
    }

    @Test
    func `isEmpty returns false if creature has telepathy`() {
        let languages = Creature.Languages(telepathy: .telepathy(range: 60))
        #expect(languages.isEmpty == false)
    }
}

struct CreatureLanguagesFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `languages() formats sorted capitalized spoken languages`() throws {
        let languages = Creature.Languages([.common, .draconic])

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Common, Draconic")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "Draconic"))
        #expect(attributed[range].language == .draconic)
    }

    @Test
    func `languages(case:) formats sorted lowercased spoken languages`() throws {
        let languages = Creature.Languages([.common, .draconic])

        let formatter = Creature.Languages.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "common, draconic")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "draconic"))
        #expect(attributed[range].language == .draconic)
    }

    @Test
    func `languages() formats sorted capitalized understood languages`() throws {
        let languages = Creature.Languages(understood: [.common, .draconic])

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Understands Common and Draconic but can't speak")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "Draconic"))
        #expect(attributed[range].language == .draconic)
    }

    @Test
    func `languages(case:) formats sorted lowercased understood languages`() throws {
        let languages = Creature.Languages(understood: [.common, .draconic])

        let formatter = Creature.Languages.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "understands common and draconic but can't speak")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "draconic"))
        #expect(attributed[range].language == .draconic)
    }

    @Test
    func `languages() formats sorted capitalized spoken and understood language`() throws {
        let languages = Creature.Languages([.common, .draconic], understood: [.thievesCant])

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Common, Draconic; Understands Thieves' Cant but can't speak it")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "Draconic"))
        #expect(attributed[range].language == .draconic)

        range = try #require(attributed.range(of: "Thieves' Cant"))
        #expect(attributed[range].language == .thievesCant)
    }

    @Test
    func `languages(case:) formats sorted capitalized spoken and understood language`() throws {
        let languages = Creature.Languages([.common, .draconic], understood: [.thievesCant])

        let formatter = Creature.Languages.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "common, draconic; understands thieves' cant but can't speak it")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "draconic"))
        #expect(attributed[range].language == .draconic)

        range = try #require(attributed.range(of: "thieves' cant"))
        #expect(attributed[range].language == .thievesCant)
    }

    @Test
    func `languages() formats sorted capitalized spoken and understood languages`() throws {
        let languages = Creature.Languages([.common, .draconic], understood: [.abyssal, .infernal])

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Common, Draconic; Understands Abyssal and Infernal but can't speak them")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "Draconic"))
        #expect(attributed[range].language == .draconic)

        range = try #require(attributed.range(of: "Abyssal"))
        #expect(attributed[range].language == .abyssal)

        range = try #require(attributed.range(of: "Infernal"))
        #expect(attributed[range].language == .infernal)
    }

    @Test
    func `languages(case:) formats sorted capitalized spoken and understood languages`() throws {
        let languages = Creature.Languages([.common, .draconic], understood: [.abyssal, .infernal])

        let formatter = Creature.Languages.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "common, draconic; understands abyssal and infernal but can't speak them")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "draconic"))
        #expect(attributed[range].language == .draconic)

        range = try #require(attributed.range(of: "abyssal"))
        #expect(attributed[range].language == .abyssal)

        range = try #require(attributed.range(of: "infernal"))
        #expect(attributed[range].language == .infernal)
    }

    @Test
    func `languages() formats additional spoken count after languages`() throws {
        let languages = Creature.Languages([.common], plus: 2)

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Common plus two other languages")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        let range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)
    }

    @Test
    func `languages() formats additional spoken count with note`() throws {
        let languages = Creature.Languages([.draconic], plus: 1, note: "usually Common")

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Draconic plus one other language (usually Common)")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        let range = try #require(attributed.range(of: "Draconic"))
        #expect(attributed[range].language == .draconic)
    }

    @Test
    func `languages() formats spoken count on own`() {
        let languages = Creature.Languages(spoken: 2)

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "any two languages")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)
    }

    @Test
    func `languages() formats additional understood count after languages`() throws {
        let languages = Creature.Languages(understood: [.common], plus: 1)

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Understands Common plus one other language but can't speak")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        let range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)
    }

    @Test
    func `languages() formats additional understood count with note`() throws {
        let languages = Creature.Languages(understood: [.common], plus: 2, note: "usually Draconic")

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Understands Common plus two other languages (usually Draconic) but can't speak")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        let range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)
    }

    @Test
    func `languages() formats understood count on own`() {
        let languages = Creature.Languages(understood: 2)

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Understands any two languages but can't speak")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)
    }

    @Test
    func `languages() formats telepathy`() throws {
        let languages = Creature.Languages([.common], telepathy: .telepathy(range: 60))

        let formatter = Creature.Languages.FormatStyle().locale(Self.locale)
        let description = formatter.format(languages)
        #expect(description == "Common; telepathy 60 ft.")

        let attributed = formatter.attributed.format(languages)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.languages == languages)

        var range = try #require(attributed.range(of: "Common"))
        #expect(attributed[range].language == .common)

        range = try #require(attributed.range(of: "telepathy 60 ft."))
        #expect(attributed[range].telepathy == .telepathy(range: 60))
    }
}

struct CreatureLanguagesInitTests {
    @Test
    func `init(_:) sets languages spoken`() {
        let languages = Creature.Languages([.common, .draconic])
        #expect(languages.spoken == [.common, .draconic])
    }

    @Test
    func `init(_:plus:note:) sets languages spoken and additional`() {
        let languages = Creature.Languages([.common, .draconic], plus: 1, note: "usually Celestial")
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.additionalSpokenCount == 1)
        #expect(languages.additionalSpokenNote == "usually Celestial")
    }

    @Test
    func `init(_:understood:) sets languages spoken and number understood`() {
        let languages = Creature.Languages([.common, .draconic], understood: 3)
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.additionalUnderstoodCount == 3)
    }

    @Test
    func `init(understood:...) sets languages understood`() {
        let languages = Creature.Languages(understood: [.common, .draconic])
        #expect(languages.understood == [.common, .draconic])
    }

    @Test
    func `init(understood:plus:note:) sets languages understood and additional`() {
        let languages = Creature.Languages(understood: [.common, .draconic], plus: 1, note: "usually Celestial")
        #expect(languages.understood == [.common, .draconic])
        #expect(languages.additionalUnderstoodCount == 1)
        #expect(languages.additionalUnderstoodNote == "usually Celestial")
    }

    @Test
    func `init(spoken:understood:...) sets languages understood and number spoken`() {
        let languages = Creature.Languages(spoken: 3, understood: [.common, .draconic])
        #expect(languages.additionalSpokenCount == 3)
        #expect(languages.understood == [.common, .draconic])
    }

    @Test
    func `init(_:understood) sets languages spoken and understood`() {
        let languages = Creature.Languages([.common, .draconic], understood: [.abyssal, .infernal])
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.understood == [.abyssal, .infernal])
    }

    @Test
    func `init(_:plus:note:understood:) sets languages spoken, additional, and understood`() {
        let languages = Creature.Languages([.common, .draconic],
                                           plus: 1,
                                           note: "usually Celestial",
                                           understood: [.abyssal, .infernal])
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.additionalSpokenCount == 1)
        #expect(languages.additionalSpokenNote == "usually Celestial")
        #expect(languages.understood == [.abyssal, .infernal])
    }

    @Test
    func `init(_:understood:plus:note:) sets languages spoken, understood and additional`() {
        let languages = Creature.Languages([.common, .draconic],
                                           understood: [.abyssal, .infernal],
                                           plus: 1,
                                           note: "usually Celestial")
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.understood == [.abyssal, .infernal])
        #expect(languages.additionalUnderstoodCount == 1)
        #expect(languages.additionalUnderstoodNote == "usually Celestial")
    }

    @Test
    func `init(_:plus:note:understood:plus:note:) sets languages spoken, understood and additional for both`() {
        let languages = Creature.Languages([.common, .draconic],
                                           plus: 2,
                                           note: "usually Elvish and Sylvan",
                                           understood: [.abyssal, .infernal],
                                           plus: 1,
                                           note: "usually Celestial")
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.additionalSpokenCount == 2)
        #expect(languages.additionalSpokenNote == "usually Elvish and Sylvan")
        #expect(languages.understood == [.abyssal, .infernal])
        #expect(languages.additionalUnderstoodCount == 1)
        #expect(languages.additionalUnderstoodNote == "usually Celestial")
    }

    @Test
    func `init(_:telepathy:) sets languages spoken and telepathy`() {
        let languages = Creature.Languages([.common, .draconic], telepathy: .telepathy(range: 60))
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(understood:telepathy:) sets languages understood and telepathy`() {
        let languages = Creature.Languages(understood: [.common, .draconic], telepathy: .telepathy(range: 60))
        #expect(languages.understood == [.common, .draconic])
        #expect(languages.telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(spoken:understood:telepathy:) sets languages spoken, understood and telepathy`() {
        let languages = Creature.Languages([.common, .draconic],
                                           understood: [.abyssal, .infernal],
                                           telepathy: .telepathy(range: 60))
        #expect(languages.spoken == [.common, .draconic])
        #expect(languages.understood == [.abyssal, .infernal])
        #expect(languages.telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(arrayLiteral:) sets languages spoken`() {
        let languages: Creature.Languages = [.common, .draconic]
        #expect(languages.spoken == [.common, .draconic])
    }
}

struct CreatureLanguagesInitStringsTests {
    @Test
    func `init(strings:) sets spoken languages`() {
        let languageStrings: [String] = [
            "common",
            "draconic",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common, .draconic])
    }

    @Test
    func `init(strings:) works with capitalized languages`() {
        let languageStrings: [String] = [
            "Common",
            "Draconic",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common, .draconic])
    }

    @Test
    func `init(strings:) works with unknown language`() {
        let languageStrings = [
            "klingon",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.other("klingon")])
    }

    @Test
    func `init(strings:) sets spoken languages joined with and`() {
        let languageStrings: [String] = [
            "common and draconic",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common, .draconic])
    }

    @Test
    func `init(strings:) sets spoken languages joined with commas`() {
        let languageStrings: [String] = [
            "common, draconic and elvish",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common, .draconic, .elvish])
    }

    @Test
    func `init(strings:) sets spoken languages joined with oxford comma`() {
        let languageStrings: [String] = [
            "common, draconic, and elvish",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common, .draconic, .elvish])
    }

    @Test
    func `init(strings:) sets additional count`() {
        let languageStrings = [
            "any five languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [])
        #expect(languages.additionalSpokenCount == 5)
    }

    @Test
    func `init(strings:) sets additional count and note`() {
        let languageStrings = [
            "any one language (usually Common)",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [])
        #expect(languages.additionalSpokenCount == 1)
        #expect(languages.additionalSpokenNote == "usually Common")
    }

    @Test
    func `init(strings:) sets additional count with "plus" prefix`() {
        let languageStrings = [
            "plus any five languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [])
        #expect(languages.additionalSpokenCount == 5)
    }

    @Test
    func `init(strings:) sets additional count with "and" prefix`() {
        let languageStrings = [
            "and any five languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [])
        #expect(languages.additionalSpokenCount == 5)
    }

    @Test
    func `init(strings:) extracts additional count from language`() {
        let languageStrings = [
            "common plus two other languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.additionalSpokenCount == 2)
    }

    @Test
    func `init(strings:) extracts additional count in "any" style from language`() {
        let languageStrings = [
            "common plus any two languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.additionalSpokenCount == 2)
    }

    @Test
    func `init(strings:) extracts additional count in "more" style from language`() {
        let languageStrings = [
            "common plus two more languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.additionalSpokenCount == 2)
    }

    @Test
    func `init(strings:) extracts additional count with "more" suffix from language`() {
        let languageStrings = [
            "common plus two more",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.additionalSpokenCount == 2)
    }

    @Test
    func `init(strings:) extracts additional count with "your choice" suffix from language`() {
        let languageStrings = [
            "common plus two of your choice",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.additionalSpokenCount == 2)
    }

    @Test
    func `init(strings:) extracts additional count with "and" prefix from language`() {
        let languageStrings = [
            "common and any two languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.additionalSpokenCount == 2)
    }

    @Test
    func `init(strings:) sets additional count and note with and`() {
        let languageStrings = [
            "any two languages (usually Draconic and Elvish)",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [])
        #expect(languages.additionalSpokenCount == 2)
        #expect(languages.additionalSpokenNote == "usually Draconic and Elvish")
    }

    @Test
    func `init(strings:) extracts additional count and note from language`() {
        let languageStrings = [
            "common and any two languages (usually Draconic and Elvish)",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.additionalSpokenCount == 2)
        #expect(languages.additionalSpokenNote == "usually Draconic and Elvish")
    }

    // TODO: test for language but... - want this to still work - or make but special
    //    🧌 Kenku
    //      Language understood: 'auran`
    //      Language understood OTHER: 'common but speaks only through the use of its mimicry trait`
    //    "languages": [
    //        "understands Auran and Common but speaks only through the use of its Mimicry trait"
    //    ],

    // FIXME: MM & XMM/Shield Guardian
    //      Language understood OTHER: 'commands given in`
    // "languages": [
    //     "understands commands given in any language but can't speak"
    // ],

    // FIXME: JttRC/Nene
    //      Language understood OTHER: 'simple phrases`
    //      Language understood OTHER: 'concepts in common`
    // "languages": [
    //     "Understands simple phrases and concepts in Common"
    // ],

    // FIXME: NPP/Vargouille Reflection
    //      Language understood OTHER: 'but it can't speak`
    //      Language understood OTHER: 'any languages it knew before becoming a vargouille`
    //      Language understood: 'infernal`
    //      Language understood: 'abyssal`
    // "languages": [
    //     "understands Abyssal",
    //     "Infernal",
    //     "and any languages it knew before becoming a vargouille",
    //     "but it can't speak"
    // ],

    // FIXME: WDMM/Nester
    //      Language spoken: 'dwarvish`
    //      Language spoken: 'giant`
    //      Language spoken: 'common`
    //      Language spoken OTHER: 'but can't speak (he uses {@spell rary's telepathic bond} to communicate)`
    //      Language spoken: 'terran`
    //      Language spoken: 'auran`
    //      Language spoken: 'draconic`
    // "languages": [
    //     "Auran",
    //     "Common",
    //     "Draconic",
    //     "Dwarvish",
    //     "Giant",
    //     "Terran",
    //     "but can't speak (he uses {@spell Rary's telepathic bond} to communicate)"
    // ],

    // FIXME: Pidlwick II CoS
    //    Language understood OTHER: 'common but doesn't speak`
    //    Language understood OTHER: 'can't read or write`
    // "languages": [
    //     "understands Common but doesn't speak and can't read or write"
    // ],

    // FIXME: PSI/Creepy Doll
    //      Language spoken OTHER: 'speaks`
    //      Language spoken OTHER: 'understands the languages known by its creator`
    // "languages": [
    //     "speaks and understands the languages known by its creator"
    // ],

    // FIXME: MPM/Dabus
    //      Language spoken OTHER: 'communicates via symbol speech`
    //      Language understood OTHER: 'all languages`
    // "languages": [
    //     "understands all languages but can't speak; communicates via Symbol Speech"
    // ],

    // FIXME: "telepathy 120 ft. Common plus two other languages" - RHW/Necrichor
    //    "languages": [
    //        "telepathy 120 ft. Common plus two other languages"
    //    ],

    // FIXME: "telepathy 120 ft. but can't speak" - GoS/Juvenile Kraken
    //    "languages": [
    //        "Abyssal",
    //        "Celestial",
    //        "Infernal",
    //        "Primordial",
    //        "telepathy 60 ft. but can't speak"
    //    ],
    // FIXME: MM/Kraken
    //    "languages": [
    //        "Abyssal",
    //        "Celestial",
    //        "Infernal",
    //        "Primordial",
    //        "telepathy 120 ft. but can't speak"
    //    ],
    // FIXME: LR/Young Kraken
    //    "languages": [
    //        "Abyssal",
    //        "Celestial",
    //        "Infernal",
    //        "Primordial",
    //        "telepathy 60 ft. but can't speak"
    //    ],

    // FIXME: FTD/Gem stalker
    //    Language telepathy 60 ft. understands Draconic but can't speak
    //    "languages": [
    //        "telepathy 60 ft. understands Draconic but can't speak"
    //    ],
    // FIXME: NF/Phaerimm Elder & Scout
    //      Language telepathy 120 ft. understands Common and Deep Speech but can't speak
    //    "languages": [
    //        "telepathy 120 ft. understands Common and Deep Speech but can't speak"
    //    ],

    // TODO: "up to N other languages"
    // TODO: "telepathy 120 ft"
    // TODO: "telepathy 1,000 ft."

    @Test
    func `init(strings:) extracts additional count from multiword language`() {
        let languageStrings = [
            "deep crow plus two other languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.deepCrow])
        #expect(languages.additionalSpokenCount == 2)
    }

    @Test
    func `init(strings:) extracts additional count from unknown language`() {
        let languageStrings = [
            "klingon plus five other languages",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.other("klingon")])
        #expect(languages.additionalSpokenCount == 5)
    }

    @Test
    func `init(strings:) sets single understood language`() {
        let languageStrings = [
            "understands draconic but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.draconic])
    }

    @Test
    func `init(strings:) sets single multiword understood language`() {
        let languageStrings = [
            "understands common sign language but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.commonSignLanguage])
    }

    @Test
    func `init(strings:) sets single unknown understood language`() {
        let languageStrings = [
            "understands klingon but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.other("klingon")])
    }

    @Test
    func `init(strings:) sets pair of understood languages`() {
        let languageStrings = [
            "understands elvish and sylvan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.elvish, .sylvan])
    }

    @Test
    func `init(strings:) works with pair of multiword understood languages`() {
        let languageStrings = [
            "understands deep speech and primordial (ignan) but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.deepSpeech, .primordialIgnan])
    }

    @Test
    func `init(strings:) works with pair of unknown understood languages`() {
        let languageStrings = [
            "understands klingon and vulcan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.other("klingon"), .other("vulcan")])
    }

    @Test
    func `init(strings:) sets list of understood languages`() {
        let languageStrings = [
            "understands common, elvish and sylvan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .elvish, .sylvan])
    }

    @Test
    func `init(strings:) sets oxford-comma list of understood languages`() {
        let languageStrings = [
            "understands common, elvish, and sylvan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .elvish, .sylvan])
    }

    @Test
    func `init(strings:) sets pair of understood languages when missing prefix`() {
        let languageStrings = [
            "elvish and sylvan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.elvish, .sylvan])
    }

    @Test
    func `init(strings:) sets single understood language with "doesn't" style`() {
        let languageStrings = [
            "understands draconic but doesn't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.draconic])
    }

    @Test
    func `init(strings:) sets single understood language with "cannot" style`() {
        let languageStrings = [
            "understands draconic but cannot speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.draconic])
    }

    @Test
    func `init(strings:) sets understood languages from broken list`() {
        let languageStrings: [String] = [
            "understands common",
            "elvish",
            "and sylvan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .elvish, .sylvan])
    }

    @Test
    func `init(strings:) sets understood languages from broken list when missing prefix`() {
        let languageStrings: [String] = [
            "common",
            "elvish",
            "and sylvan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .elvish, .sylvan])
    }

    @Test
    func `init(strings:) sets understood languages from broken list with final pair`() {
        let languageStrings: [String] = [
            "common",
            "elvish and sylvan but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .elvish, .sylvan])
    }

    @Test
    func `init(strings:) extracts understood languages from last spoken`() {
        let languageStrings: [String] = [
            "Celestial; understands common",
            "elvish",
            "and sylvan but can't speak them",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.celestial])
        #expect(languages.understood == [.common, .elvish, .sylvan])
    }

    @Test
    func `init(strings:) extracts additional count from understood language`() {
        let languageStrings = [
            "understands common plus one other language but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common])
        #expect(languages.additionalUnderstoodCount == 1)
    }

    @Test
    func `init(strings:) extracts additional count and note from understood language`() {
        let languageStrings = [
            "understands common plus one other language (usually Common) but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common])
        #expect(languages.additionalUnderstoodCount == 1)
        #expect(languages.additionalUnderstoodNote == "usually Common")
    }

    @Test
    func `init(strings:) extracts additional count from understood language pair`() {
        let languageStrings = [
            "understands common and draconic plus three other languages but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .draconic])
        #expect(languages.additionalUnderstoodCount == 3)
    }

    @Test
    func `init(strings:) extracts additional count from broken understood languages`() {
        let languageStrings: [String] = [
            "understands common",
            "and draconic plus one other language but can't speak them",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .draconic])
        #expect(languages.additionalUnderstoodCount == 1)
    }

    @Test
    func `init(strings:) extracts additional count from broken understood language final pair`() {
        let languageStrings: [String] = [
            "understands common",
            "draconic and elvish plus one other language but can't speak them",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .draconic, .elvish])
        #expect(languages.additionalUnderstoodCount == 1)
    }

    @Test
    func `init(strings:) extracts additional count from broken understood languages when missing prefix`() {
        let languageStrings: [String] = [
            "common",
            "elvish",
            "and sylvan plus one other language but can't speak",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.understood == [.common, .elvish, .sylvan])
        #expect(languages.additionalUnderstoodCount == 1)
    }

    @Test
    func `init(strings:) extracts telepathy from language`() {
        let languageStrings = [
            "common; telepathy 60 ft.",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.common])
        #expect(languages.telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(strings:) extracts telepathy from multiword language`() {
        let languageStrings = [
            "common sign language; telepathy 60 ft.",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.commonSignLanguage])
        #expect(languages.telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(strings:) extracts telepathy from unknown language`() {
        let languageStrings = [
            "klingon; telepathy 60 ft.",
        ]
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [.other("klingon")])
        #expect(languages.telepathy == .telepathy(range: 60))
    }

    @Test
    func `init(strings:) returns empty set for empty list`() {
        let languageStrings: [String] = []
        let languages = Creature.Languages(strings: languageStrings)
        #expect(languages.spoken == [])
    }
}

struct CreatureLanguagesStringsTests {
    @Test
    func `strings returns sorted capitalized spoken languages`() {
        let languages = Creature.Languages([.common, .draconic])
        #expect(languages.strings == [
            "Common",
            "Draconic",
        ])
    }

    @Test
    func `strings returns includes unknown spoken language`() {
        let languages = Creature.Languages([.common, .draconic, .other("klingon")])
        #expect(languages.strings == [
            "Common",
            "Draconic",
            "Klingon",
        ])
    }

    @Test
    func `strings returns additional count appended to last spoken language`() {
        let languages = Creature.Languages([.common], plus: 2)
        #expect(languages.strings == [
            "Common plus two other languages",
        ])
    }

    @Test
    func `strings returns additional count and note`() {
        let languages = Creature.Languages([.common], plus: 2, note: "usually Draconic and Elvish")
        #expect(languages.strings == [
            "Common plus two other languages (usually Draconic and Elvish)",
        ])
    }

    @Test
    func `strings returns additional count as own entry`() {
        let languages = Creature.Languages(spoken: 2)
        #expect(languages.strings == [
            "any two languages",
        ])
    }

    @Test
    func `strings returns capitalized understood language`() {
        let languages = Creature.Languages(understood: [.draconic])
        #expect(languages.strings == [
            "understands Draconic but can't speak",
        ])
    }

    @Test
    func `strings returns capitalized understood language appended to last spoken language`() {
        let languages = Creature.Languages([.common], understood: [.draconic])
        #expect(languages.strings == [
            "Common; understands Draconic but can't speak it",
        ])
    }

    @Test
    func `strings returns unknown understood language`() {
        let languages = Creature.Languages(understood: [.other("klingon")])
        #expect(languages.strings == [
            "understands Klingon but can't speak",
        ])
    }

    @Test
    func `strings returns capitalized pair of understood languages`() {
        let languages = Creature.Languages(understood: [.elvish, .sylvan])
        #expect(languages.strings == [
            "understands Elvish and Sylvan but can't speak",
        ])
    }

    @Test
    func `strings returns capitalized pair of understood languages appended to last spoken language`() {
        let languages = Creature.Languages([.common], understood: [.elvish, .sylvan])
        #expect(languages.strings == [
            "Common; understands Elvish and Sylvan but can't speak them",
        ])
    }

    @Test
    func `strings returns capitalized broken list of understood languages`() {
        let languages = Creature.Languages(understood: [.common, .elvish, .sylvan])
        #expect(languages.strings == [
            "understands Common",
            "Elvish",
            "and Sylvan but can't speak",
        ])
    }

    @Test
    func `strings returns first understood language appended to last spoken language`() {
        let languages = Creature.Languages([.celestial], understood: [.common, .elvish, .sylvan])
        #expect(languages.strings == [
            "Celestial; understands Common",
            "Elvish",
            "and Sylvan but can't speak them",
        ])
    }

    @Test
    func `strings returns additional understood count appended to last understood language`() {
        let languages = Creature.Languages(understood: [.draconic], plus: 1)
        #expect(languages.strings == [
            "understands Draconic plus one other language but can't speak",
        ])
    }

    @Test
    func `strings returns additional understood count and note`() {
        let languages = Creature.Languages(understood: [.draconic], plus: 1, note: "usually Common")
        #expect(languages.strings == [
            "understands Draconic plus one other language (usually Common) but can't speak",
        ])
    }

    @Test
    func
        `strings returns additional understood count and language appended to last spoken language `()
    {
        let languages = Creature.Languages([.common], understood: [.draconic], plus: 1)
        #expect(languages.strings == [
            "Common; understands Draconic plus one other language but can't speak them",
        ])
    }

    @Test
    func `strings returns telepathy appended to last spoken language`() {
        let languages = Creature.Languages([.common, .draconic], telepathy: .telepathy(range: 60))
        #expect(languages.strings == [
            "Common",
            "Draconic; telepathy 60 ft.",
        ])
    }

    @Test
    func `strings returns telepathy appended to last understood language`() {
        let languages = Creature.Languages(understood: [.draconic], telepathy: .telepathy(range: 60))
        #expect(languages.strings == [
            "understands Draconic but can't speak; telepathy 60 ft.",
        ])
    }

    @Test
    func `strings returns telepathy appended to last spoken and understood language`() {
        let languages = Creature.Languages([.common], understood: [.draconic], telepathy: .telepathy(range: 60))
        #expect(languages.strings == [
            "Common; understands Draconic but can't speak it; telepathy 60 ft.",
        ])
    }

    @Test
    func `strings returns empty list for no languages`() {
        let languages: Creature.Languages = []
        #expect(languages.strings == [])
    }
}
