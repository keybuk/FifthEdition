//
//  TypeTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct AlignmentCodableTests {
    static let expectedCoding: [(Alignment, [String])] = [
        (.unaligned, ["U"]),
        (.any, ["A"]),
        (.lawful, ["L"]),
        (.chaotic, ["C"]),
        (.neutral, ["N"]),
        (.good, ["G"]),
        (.evil, ["E"]),
        (.lawfulGood, ["L", "G"]),
        (.lawfulNeutral, ["L", "N"]),
        (.lawfulEvil, ["L", "E"]),
        (.neutralGood, ["N", "G"]),
        (.neutralEvil, ["N", "E"]),
        (.chaoticGood, ["C", "G"]),
        (.chaoticNeutral, ["C", "N"]),
        (.chaoticEvil, ["C", "E"]),
        (.anyNeutral, ["NX", "NY", "N"]),
        (.anyLawful, ["L", "NY", "G", "E"]),
        (.anyChaotic, ["C", "NY", "G", "E"]),
        (.anyGood, ["L", "C", "NX", "G"]),
        (.anyEvil, ["L", "C", "NX", "E"]),
        (.anyNonLawful, ["C", "NX", "NY", "G", "E"]),
        (.anyNonChaotic, ["L", "NX", "NY", "G", "E"]),
        (.anyNonGood, ["L", "C", "NX", "NY", "E"]),
        (.anyNonEvil, ["L", "C", "NX", "NY", "G"]),
    ]

    @Test(arguments: expectedCoding)
    func `Alignment encodes as string array`(alignment: Alignment, codingValue: [String]) throws {
        try testCodable(
            json: """
            [ \(codingValue.map { "\"\($0)\"" }.joined(separator: ", ")) ]
            """,
            value: alignment,
        )
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

struct AlignmentRawRepresentableTests {
    static let expectedValues: [(Alignment, String)] = [
        (.unaligned, "unaligned"),
        (.any, "any alignment"),
        (.lawful, "lawful"),
        (.chaotic, "chaotic"),
        (.neutral, "neutral"),
        (.good, "good"),
        (.evil, "evil"),
        (.lawfulGood, "lawful good"),
        (.lawfulNeutral, "lawful neutral"),
        (.lawfulEvil, "lawful evil"),
        (.neutralGood, "neutral good"),
        (.neutralEvil, "neutral evil"),
        (.chaoticGood, "chaotic good"),
        (.chaoticNeutral, "chaotic neutral"),
        (.chaoticEvil, "chaotic evil"),
        (.anyNeutral, "any neutral alignment"),
        (.anyLawful, "any lawful alignment"),
        (.anyChaotic, "any chaotic alignment"),
        (.anyGood, "any good alignment"),
        (.anyEvil, "any evil alignment"),
        (.anyNonLawful, "any non-lawful alignment"),
        (.anyNonChaotic, "any non-chaotic alignment"),
        (.anyNonGood, "any non-good alignment"),
        (.anyNonEvil, "any non-evil alignment"),
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
            value: CreatureType.other("dolphin"),
        )
    }
}

struct CreatureTypeComparableTests {
    @Test(arguments: zip(CreatureType.allCases, CreatureType.allCases.dropFirst()))
    func `CreatureType smaller than next`(a: CreatureType, b: CreatureType) {
        #expect(a < b)
    }

    @Test(arguments: CreatureType.allCases)
    func `CreatureType smaller than unknown`(creatureType: CreatureType) {
        #expect(creatureType < CreatureType.other("dolphin"))
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
        let creatureType = CreatureType.other("dolphin")

        let formatter = CreatureType.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "Dolphin")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test
    func `creatureType(case:) formats lowercased unknown name`() {
        let creatureType = CreatureType.other("dolphin")

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
        let creatureType = CreatureType.other("dolphin")

        let formatter = CreatureType.FormatStyle(form: .plural).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "Dolphins")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creatureType == creatureType)
    }

    @Test
    func `creatureType(case:form:) formats lowercased plural unknown name`() {
        let creatureType = CreatureType.other("dolphin")

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
    func `init(rawValue:) sets other for unknown case`() {
        #expect(CreatureType(rawValue: "dolphin") == .other("dolphin"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(creatureType: CreatureType, rawValue: String) {
        #expect(creatureType.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let creatureType = CreatureType.other("dolphin")
        #expect(creatureType.rawValue == "dolphin")
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
            value: SidekickType.other("lawyer"),
        )
    }
}

struct SidekickTypeComparableTests {
    @Test(arguments: zip(SidekickType.allCases, SidekickType.allCases.dropFirst()))
    func `Sidekick type smaller than next`(a: SidekickType, b: SidekickType) {
        #expect(a < b)
    }

    @Test(arguments: SidekickType.allCases)
    func `Sidekick type smaller than unknown`(sidekickType: SidekickType) {
        #expect(sidekickType < SidekickType.other("lawyer"))
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
        let sidekickType = SidekickType.other("lawyer")

        let formatter = SidekickType.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekickType)
        #expect(description == "Lawyer")

        let attributed = formatter.attributed.format(sidekickType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.sidekickType == sidekickType)
    }

    @Test
    func `sidekickType(case:) formats lowercased unknown name`() {
        let sidekickType = SidekickType.other("lawyer")

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
    func `init(rawValue:) sets other for unknown case`() {
        #expect(SidekickType(rawValue: "lawyer") == .other("lawyer"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(sidekickType: SidekickType, rawValue: String) {
        #expect(sidekickType.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let sidekickType = SidekickType.other("lawyer")
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
        let tag = FifthEdition::Tag("devil")
        #expect(tag.tag == "devil")
    }

    @Test
    func `init(_:prefix:) sets tag and prefix`() {
        let tag = FifthEdition::Tag("elf", prefix: "dusk")
        #expect(tag.tag == "elf")
        #expect(tag.prefix == "dusk")
    }

    @Test
    func `init(_:prefix:isHidden:) sets tag, prefix and hidden`() {
        let tag = FifthEdition::Tag("elf", prefix: "dusk", isHidden: true)
        #expect(tag.tag == "elf")
        #expect(tag.prefix == "dusk")
        #expect(tag.isPrefixHidden == true)
    }

    @Test
    func `init(stringLiteral:) sets tag`() {
        let tag: FifthEdition::Tag = "devil"
        #expect(tag == Tag("devil"))
    }
}

struct TagListFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `tags() formats sorted list of capitalized tag`() throws {
        let tags: [FifthEdition::Tag] = [
            Tag("elf", prefix: "dusk", isHidden: true),
            Tag("devil"),
            Tag("human", prefix: "chondathan"),
        ]

        let formatter: FifthEdition::Tag.ListFormatStyle < [FifthEdition::Tag]> = .tags().locale(Self.locale)
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
        let tags: [FifthEdition::Tag] = [
            Tag("Elf", prefix: "Dusk", isHidden: true),
            Tag("Devil"),
            Tag("Human", prefix: "Chondathan"),
        ]

        let formatter: FifthEdition::Tag.ListFormatStyle < [FifthEdition::Tag]> = .tags(case: .lowercased)
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
