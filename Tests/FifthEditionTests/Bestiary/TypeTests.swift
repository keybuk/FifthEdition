//
//  TypeTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct AlignmentComparableTests {
    @Test(arguments: zip(Alignment.allCases, Alignment.allCases.dropFirst()))
    func `Alignment smaller than next`(a: Alignment, b: Alignment) {
        #expect(a < b)
    }
}

struct AlignmentFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Alignment.allCases)
    func `alignment() formats capitalized name`(alignment: Alignment) {
        let formatter = Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == alignment.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.alignment == alignment)
    }

    @Test(arguments: Alignment.allCases)
    func `alignment(case:) formats lowercased name`(alignment: Alignment) {
        let formatter = Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == alignment.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.alignment == alignment)
    }
}

struct AlignmentListFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    static let expectedValues: [(Set<Alignment>, String)] = [
        (.unaligned, "unaligned"),
        (.any, "any alignment"),
        (.anyLawful, "any lawful alignment"),
        (.anyNonLawful, "any non-lawful alignment"),
        (.anyChaotic, "any chaotic alignment"),
        (.anyNonChaotic, "any non-chaotic alignment"),
        (.anyGood, "any good alignment"),
        (.anyNonGood, "any non-good alignment"),
        (.anyEvil, "any evil alignment"),
        (.anyNonEvil, "any non-evil alignment"),
        (.anyNeutral, "any neutral alignment"),
    ]

    @Test(arguments: Alignment.allCases)
    func `alignments() formats capitalized single alignment`(alignment: Alignment) {
        let alignments: Set<Alignment> = [alignment]

        let formatter = Alignment.ListFormatStyle<Set<Alignment>>.alignments().locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == alignment.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)
        #expect(attributed.alignment == alignment)
    }

    @Test(arguments: Alignment.allCases)
    func `alignments(case:) formats lowercased single alignment`(alignment: Alignment) {
        let alignments: Set<Alignment> = [alignment]

        let formatter = Alignment.ListFormatStyle<Set<Alignment>>.alignments(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == alignment.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)
        #expect(attributed.alignment == alignment)
    }

    @Test(arguments: Self.expectedValues)
    func `alignments() formats capitalized known alignment set`(alignments: Set<Alignment>, string: String) {
        let formatter = Alignment.ListFormatStyle<Set<Alignment>>.alignments().locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == string.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)
    }

    @Test(arguments: Self.expectedValues)
    func `alignments(case:) formats lowercased known alignment set`(alignments: Set<Alignment>, string: String) {
        let formatter = Alignment.ListFormatStyle<Set<Alignment>>.alignments(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == string.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)
    }

    @Test
    func `alignments() formats capitalized multiple alignments`() throws {
        let alignments: Set<Alignment> = [.lawfulGood, .lawfulEvil]

        let formatter = Alignment.ListFormatStyle<Set<Alignment>>.alignments().locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == "Lawful Good or Lawful Evil")

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "Lawful Evil"))
        #expect(attributed[range].alignment == .lawfulEvil)
    }

    @Test
    func `alignments(case:) formats lowercased multiple alignments`() throws {
        let alignments: Set<Alignment> = [.lawfulGood, .lawfulEvil]

        let formatter = Alignment.ListFormatStyle<Set<Alignment>>.alignments(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == "lawful good or lawful evil")

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "lawful good"))
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "lawful evil"))
        #expect(attributed[range].alignment == .lawfulEvil)
    }
}

struct AlignmentRawRepresentableTests {
    static let expectedValues: [(Alignment, String)] = [
        (.lawfulGood, "lawful good"),
        (.lawfulNeutral, "lawful neutral"),
        (.lawfulEvil, "lawful evil"),
        (.neutralGood, "neutral good"),
        (.neutral, "neutral"),
        (.neutralEvil, "neutral evil"),
        (.chaoticGood, "chaotic good"),
        (.chaoticNeutral, "chaotic neutral"),
        (.chaoticEvil, "chaotic evil"),
    ]

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(alignment: Alignment, rawValue: String) {
        #expect(alignment.rawValue == rawValue)
    }
}

struct CreatureTypeCodableTests {
    @Test(arguments: CreatureType.allCases)
    func `CreatureType is encoded as rawValue`(creatureType: CreatureType) throws {
        try testCodable(
            json: """
            "\(creatureType.rawValue)"
            """,
            value: creatureType,
        )
    }

    @Test
    func `Unknown CreatureType is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "dolphin"
            """,
            value: CreatureType(rawValue: "dolphin"),
        )
    }
}

struct CreatureTypeFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    static let expectedPlurals: [(CreatureType, String)] = [
        (.aberration, "aberrations"),
        (.beast, "beasts"),
        (.celestial, "celestials"),
        (.construct, "constructs"),
        (.dragon, "dragons"),
        (.elemental, "elementals"),
        (.fey, "fey"),
        (.fiend, "fiends"),
        (.giant, "giants"),
        (.humanoid, "humanoids"),
        (.monstrosity, "monstrosities"),
        (.ooze, "oozes"),
        (.plant, "plants"),
        (.undead, "undead"),
        (.vehicle, "vehicles"),
    ]

    @Test(arguments: CreatureType.allCases)
    func `creatureType() formats capitalized name`(creatureType: CreatureType) {
        let formatter = CreatureType.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == creatureType.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test(arguments: CreatureType.allCases)
    func `creatureType(case:) formats lowercased name`(creatureType: CreatureType) {
        let formatter = CreatureType.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == creatureType.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test
    func `creatureType() formats capitalized unknown name`() {
        let creatureType = CreatureType(rawValue: "dolphin")

        let formatter = CreatureType.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "Dolphin")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test
    func `creatureType(case:) formats lowercased unknown name`() {
        let creatureType = CreatureType(rawValue: "dolphin")

        let formatter = CreatureType.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "dolphin")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test(arguments: Self.expectedPlurals)
    func `creatureType(form:) formats plural name`(creatureType: CreatureType, pluralValue: String) {
        let formatter = CreatureType.FormatStyle(form: .plural).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == pluralValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test(arguments: Self.expectedPlurals)
    func `creatureType(case:form:) formats lowercased plural name`(creatureType: CreatureType, pluralValue: String) {
        let formatter = CreatureType.FormatStyle(case: .lowercased, form: .plural).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == pluralValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test
    func `creatureType(form:) formats plural unknown name`() {
        let creatureType = CreatureType(rawValue: "dolphin")

        let formatter = CreatureType.FormatStyle(form: .plural).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "Dolphins")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test
    func `creatureType(case:form:) formats lowercased plural unknown name`() {
        let creatureType = CreatureType(rawValue: "dolphin")

        let formatter = CreatureType.FormatStyle(case: .lowercased, form: .plural).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "dolphins")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }
}

struct CreatureTypeRawRepresentableTests {
    static let expectedValues: [(CreatureType, String)] = [
        (.aberration, "aberration"),
        (.beast, "beast"),
        (.celestial, "celestial"),
        (.construct, "construct"),
        (.dragon, "dragon"),
        (.elemental, "elemental"),
        (.fey, "fey"),
        (.fiend, "fiend"),
        (.giant, "giant"),
        (.humanoid, "humanoid"),
        (.monstrosity, "monstrosity"),
        (.ooze, "ooze"),
        (.plant, "plant"),
        (.undead, "undead"),
        (.vehicle, "vehicle"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(creatureType: CreatureType, rawValue: String) {
        #expect(CreatureType(rawValue: rawValue) == creatureType)
    }

    @Test
    func `init(rawValue:) sets unknown case`() {
        #expect(CreatureType(rawValue: "dolphin") == CreatureType(rawValue: "dolphin"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(creatureType: CreatureType, rawValue: String) {
        #expect(creatureType.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let creatureType = CreatureType(rawValue: "dolphin")
        #expect(creatureType.rawValue == "dolphin")
    }
}

struct DragonAgeCodableTests {
    @Test(arguments: DragonAge.allCases)
    func `DragonAge is encoded as rawValue`(dragonAge: DragonAge) throws {
        try testCodable(
            json: """
            "\(dragonAge.rawValue)"
            """,
            value: dragonAge,
        )
    }

    @Test
    func `Unknown DragonAge is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "geriatric"
            """,
            value: DragonAge(rawValue: "geriatric"),
        )
    }
}

struct DragonAgeRawRepresentableTests {
    static let expectedValues: [(DragonAge, String)] = [
        (.young, "young"),
        (.adult, "adult"),
        (.wyrmling, "wyrmling"),
        (.greatwyrm, "greatwyrm"),
        (.ancient, "ancient"),
        (.aspect, "aspect"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(dragonAge: DragonAge, rawValue: String) {
        #expect(DragonAge(rawValue: rawValue) == dragonAge)
    }

    @Test
    func `init(rawValue:) sets unknown case`() {
        #expect(DragonAge(rawValue: "geriatric") == DragonAge(rawValue: "geriatric"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(dragonAge: DragonAge, rawValue: String) {
        #expect(dragonAge.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let dragonAge = DragonAge(rawValue: "geriatric")
        #expect(dragonAge.rawValue == "geriatric")
    }
}

struct DragonColorCodableTests {
    @Test(arguments: DragonColor.allCases)
    func `DragonColor is encoded as rawValue`(dragonColor: DragonColor) throws {
        try testCodable(
            json: """
            "\(dragonColor.rawValue)"
            """,
            value: dragonColor,
        )
    }

    @Test
    func `Unknown DragonColor is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "octarine"
            """,
            value: DragonColor(rawValue: "octarine"),
        )
    }
}

struct DragonColorRawRepresentableTests {
    static let expectedValues: [(DragonColor, String)] = [
        (.black, "black"),
        (.blue, "blue"),
        (.green, "green"),
        (.red, "red"),
        (.white, "white"),
        (.brass, "brass"),
        (.bronze, "bronze"),
        (.copper, "copper"),
        (.gold, "gold"),
        (.silver, "silver"),
        (.deep, "deep"),
        (.spirit, "spirit"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(dragonColor: DragonColor, rawValue: String) {
        #expect(DragonColor(rawValue: rawValue) == dragonColor)
    }

    @Test
    func `init(rawValue:) sets unknown case`() {
        #expect(DragonColor(rawValue: "octarine") == DragonColor(rawValue: "octarine"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(dragonColor: DragonColor, rawValue: String) {
        #expect(dragonColor.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let dragonColor = DragonColor(rawValue: "octarine")
        #expect(dragonColor.rawValue == "octarine")
    }
}

struct SidekickTypeCodableTests {
    @Test(arguments: SidekickType.allCases)
    func `Sidekick type is encoded as rawValue`(sidekickType: SidekickType) throws {
        try testCodable(
            json: """
            "\(sidekickType.rawValue)"
            """,
            value: sidekickType,
        )
    }

    @Test
    func `Unknown sidekick type is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "lawyer"
            """,
            value: SidekickType(rawValue: "lawyer"),
        )
    }
}

struct SidekickTypeFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: SidekickType.allCases)
    func `sidekickType() formats capitalized name`(sidekickType: SidekickType) {
        let formatter = SidekickType.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekickType)
        #expect(description == sidekickType.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(sidekickType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.sidekickType == sidekickType)
    }

    @Test(arguments: SidekickType.allCases)
    func `sidekickType(case:) formats lowercased name`(sidekickType: SidekickType) {
        let formatter = SidekickType.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sidekickType)
        #expect(description == sidekickType.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(sidekickType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.sidekickType == sidekickType)
    }

    @Test
    func `sidekickType() formats capitalized unknown name`() {
        let sidekickType = SidekickType(rawValue: "lawyer")

        let formatter = SidekickType.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekickType)
        #expect(description == "Lawyer")

        let attributed = formatter.attributed.format(sidekickType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.sidekickType == sidekickType)
    }

    @Test
    func `sidekickType(case:) formats lowercased unknown name`() {
        let sidekickType = SidekickType(rawValue: "lawyer")

        let formatter = SidekickType.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sidekickType)
        #expect(description == "lawyer")

        let attributed = formatter.attributed.format(sidekickType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.sidekickType == sidekickType)
    }
}

struct SidekickTypeRawRepresentableTests {
    static let expectedValues: [(SidekickType, String)] = [
        (.expert, "expert"),
        (.spellcaster, "spellcaster"),
        (.warrior, "warrior"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(sidekickType: SidekickType, rawValue: String) {
        #expect(SidekickType(rawValue: rawValue) == sidekickType)
    }

    @Test
    func `init(rawValue:) sets unknown case`() {
        #expect(SidekickType(rawValue: "lawyer") == SidekickType(rawValue: "lawyer"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(sidekickType: SidekickType, rawValue: String) {
        #expect(sidekickType.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let sidekickType = SidekickType(rawValue: "lawyer")
        #expect(sidekickType.rawValue == "lawyer")
    }
}

struct SizeCodableTests {
    static let expectedCoding: [(Size, String)] = [
        (.fine, "F"),
        (.diminutive, "D"),
        (.tiny, "T"),
        (.small, "S"),
        (.medium, "M"),
        (.large, "L"),
        (.huge, "H"),
        (.gargantuan, "G"),
        (.colossal, "C"),
        (.varies, "V"),
    ]

    @Test(arguments: expectedCoding)
    func `Size encodes as string`(size: Size, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: size,
        )
    }
}

struct SizeComparableTests {
    @Test(arguments: zip(Size.allCases, Size.allCases.dropFirst()))
    func `Size smaller than next`(a: Size, b: Size) {
        #expect(a < b)
    }
}

struct SizeFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Size.allCases)
    func `size() formats capitalized name`(size: Size) {
        let formatter = Size.FormatStyle().locale(Self.locale)
        let description = formatter.format(size)
        #expect(description == size.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(size)
        #expect(String(attributed.characters) == description)
        #expect(attributed.size == size)
    }

    @Test(arguments: Size.allCases)
    func `size(case:) formats lowercased name`(size: Size) {
        let formatter = Size.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(size)
        #expect(description == size.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(size)
        #expect(String(attributed.characters) == description)
        #expect(attributed.size == size)
    }
}

struct TagCodableTests {
    @Test
    func `Tag encoded as raw string`() throws {
        try testCodable(
            json: """
            "devil"
            """,
            value: Tag("devil"),
        )
    }

    @Test
    func `Tag with prefix encoded as object`() throws {
        try testCodable(
            json: """
            {
                "tag": "human",
                "prefix": "chondathan"
            }
            """,
            value: Tag("human", prefix: "chondathan"),
        )
    }

    @Test
    func `Tag with hidden prefix encoded as object`() throws {
        try testCodable(
            json: """
            {
                "tag": "elf",
                "prefix": "drow",
                "prefixHidden": true,
            }
            """,
            value: Tag("elf", prefix: "drow", isHidden: true),
        )
    }
}

struct TagComparableTests {
    @Test
    func `Tag compare by value`() {
        #expect(Tag("devil") < Tag("fiend"))
    }

    @Test
    func `Tag compare including prefix`() {
        #expect(Tag("human", prefix: "chondathan") < Tag("devil"))
    }

    @Test
    func `Tag compare ignoring hidden prefix`() {
        #expect(Tag("devil") < Tag("elf", prefix: "drow", isHidden: true))
    }
}

struct TagFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `tag() formats capitalized tag`() {
        let tag = Tag("devil")

        let formatter = Tag.FormatStyle().locale(Self.locale)
        let description = formatter.format(tag)
        #expect(description == "Devil")

        let attributed = formatter.attributed.format(tag)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tag == tag)
    }

    @Test
    func `tag() formats capitalized tag with prefix`() {
        let tag = Tag("human", prefix: "chondathan")

        let formatter = Tag.FormatStyle().locale(Self.locale)
        let description = formatter.format(tag)
        #expect(description == "Chondathan Human")

        let attributed = formatter.attributed.format(tag)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tag == tag)
    }

    @Test
    func `tag() formats only name for hidden prefix`() {
        let tag = Tag("elf", prefix: "dusk", isHidden: true)

        let formatter = Tag.FormatStyle().locale(Self.locale)
        let description = formatter.format(tag)
        #expect(description == "Elf")

        let attributed = formatter.attributed.format(tag)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tag == tag)
    }

    @Test
    func `tag(case:) formats lowercased tag`() {
        let tag = Tag("Devil")

        let formatter = Tag.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(tag)
        #expect(description == "devil")

        let attributed = formatter.attributed.format(tag)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tag == tag)
    }

    @Test
    func `tag(case:) formats lowercased tag with prefix`() {
        let tag = Tag("Human", prefix: "Chondathan")

        let formatter = Tag.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(tag)
        #expect(description == "chondathan human")

        let attributed = formatter.attributed.format(tag)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tag == tag)
    }
}

struct TagInitTests {
    @Test
    func `init(_:) sets tag`() {
        let tag = FifthEdition.Tag("devil")
        #expect(tag.tag == "devil")
    }

    @Test
    func `init(_:prefix:) sets tag and prefix`() {
        let tag = FifthEdition.Tag("elf", prefix: "dusk")
        #expect(tag.tag == "elf")
        #expect(tag.prefix == "dusk")
    }

    @Test
    func `init(_:prefix:isHidden:) sets tag, prefix and hidden`() {
        let tag = FifthEdition.Tag("elf", prefix: "dusk", isHidden: true)
        #expect(tag.tag == "elf")
        #expect(tag.prefix == "dusk")
        #expect(tag.isPrefixHidden == true)
    }

    @Test
    func `init(stringLiteral:) sets tag`() {
        let tag: FifthEdition.Tag = "devil"
        #expect(tag == Tag("devil"))
    }
}

struct TagListFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `tags() formats sorted list of capitalized tag`() throws {
        let tags: [FifthEdition.Tag] = [
            Tag("elf", prefix: "dusk", isHidden: true),
            Tag("devil"),
            Tag("human", prefix: "chondathan"),
        ]

        let formatter: FifthEdition.Tag.ListFormatStyle<[FifthEdition.Tag]> = .tags().locale(Self.locale)
        let description = formatter.format(tags)
        #expect(description == "Chondathan Human, Devil, Elf")

        let attributed = formatter.attributed.format(tags)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "Chondathan Human"))
        #expect(attributed[range].tag == tags[2])

        range = try #require(attributed.range(of: "Devil"))
        #expect(attributed[range].tag == tags[1])

        range = try #require(attributed.range(of: "Elf"))
        #expect(attributed[range].tag == tags[0])
    }

    @Test
    func `tags(case:) formats sorted list of lowercased tags`() throws {
        let tags: [FifthEdition.Tag] = [
            Tag("Elf", prefix: "Dusk", isHidden: true),
            Tag("Devil"),
            Tag("Human", prefix: "Chondathan"),
        ]

        let formatter: FifthEdition.Tag.ListFormatStyle<[FifthEdition.Tag]> = .tags(case: .lowercased)
            .locale(Self.locale)
        let description = formatter.format(tags)
        #expect(description == "chondathan human, devil, elf")

        let attributed = formatter.attributed.format(tags)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "chondathan human"))
        #expect(attributed[range].tag == tags[2])

        range = try #require(attributed.range(of: "devil"))
        #expect(attributed[range].tag == tags[1])

        range = try #require(attributed.range(of: "elf"))
        #expect(attributed[range].tag == tags[0])
    }
}
