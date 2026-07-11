//
//  AlignmentsTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureAlignmentCodableTests {
    @Test
    func `Creature alignment encodes alignment as array`() throws {
        try testCodable(
            json: """
            [ "C", "G" ]
            """,
            value: Creature.Alignment(.chaoticGood),
        )
    }

    @Test
    func `Creature alignment encodes choice in object`() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [ "L", "N" ],
                },
                {
                    "alignment": [ "L", "E" ]
                }
            ]
            """,
            value: Creature.Alignment([.lawfulNeutral, .lawfulEvil]),
        )
    }
}

struct CreatureAlignmentCollectionTests {
    @Test
    func `isEmpty returns true for empty alignment`() {
        let alignment = Creature.Alignment([])
        #expect(alignment.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if alignment not empty`() {
        let alignment = Creature.Alignment([.lawfulGood, .lawfulEvil])
        #expect(alignment.isEmpty == false)
    }
}

struct CreatureAlignmentFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `alignment() formats list of capitalized alignment`() throws {
        let alignment = Creature.Alignment([
            .alignment(.lawfulGood, note: "before midnight"),
            .alignment(.chaoticEvil, note: "after midnight"),
        ])

        let formatter = Creature.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good (Before Midnight) or Chaotic Evil (After Midnight)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)

        var range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].creature.alignmentAlignment == alignment.alignment[0])
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "Chaotic Evil"))
        #expect(attributed[range].creature.alignmentAlignment == alignment.alignment[1])
        #expect(attributed[range].alignment == .chaoticEvil)
    }

    @Test
    func `alignment(case:) formats list of lowercased alignment`() throws {
        let alignment = Creature.Alignment([
            .alignment(.lawfulGood, note: "Before Midnight"),
            .alignment(.chaoticEvil, note: "After Midnight"),
        ])

        let formatter = Creature.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful good (before midnight) or chaotic evil (after midnight)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)

        var range = try #require(attributed.range(of: "lawful good"))
        #expect(attributed[range].creature.alignmentAlignment == alignment.alignment[0])
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "chaotic evil"))
        #expect(attributed[range].creature.alignmentAlignment == alignment.alignment[1])
        #expect(attributed[range].alignment == .chaoticEvil)
    }
}

struct CreatureAlignmentInitTests {
    @Test
    func `init(_:) sets single alignment`() {
        let alignment = Creature.Alignment(.chaoticNeutral)
        #expect(alignment.alignment == [.chaoticNeutral])
    }

    @Test
    func `init(_:) sets multiple alignments`() {
        let alignment = Creature.Alignment([.lawfulGood, .lawfulEvil])
        #expect(alignment.alignment == [.lawfulGood, .lawfulEvil])
    }

    @Test
    func `init(_:prefix:) sets alignment and prefix`() {
        let alignment = Creature.Alignment(.lawfulNeutral, prefix: "Typically ")
        #expect(alignment.alignment == [.lawfulNeutral])
        #expect(alignment.prefix == "Typically ")
    }

    @Test
    func `init(_:prefix:) sets multiple alignments and prefix`() {
        let alignment = Creature.Alignment([.lawfulGood, .lawfulNeutral], prefix: "Typically ")
        #expect(alignment.alignment == [.lawfulGood, .lawfulNeutral])
        #expect(alignment.prefix == "Typically ")
    }

    @Test
    func `init(arrayLiteral:) sets alignment`() {
        let alignment: Creature.Alignment = [.lawfulGood, .lawfulEvil]
        #expect(alignment.alignment == [.lawfulGood, .lawfulEvil])
    }
}

struct CreatureAlignmentAlignmentCodableTests {
    @Test
    func `Alignment option encodes as object`() throws {
        try testCodable(
            json: """
            {
                "alignment": [
                    "L",
                    "G"
                ]
            }
            """,
            value: Creature.Alignment.Alignment.alignment(.lawfulGood),
        )
    }

    @Test
    func `Alignment option with note`() throws {
        try testCodable(
            json: """
            {
                "alignment": [
                    "C",
                    "G"
                ],
                "note": "chaotic evil when hungry"
            }
            """,
            value: Creature.Alignment.Alignment.alignment(.chaoticGood,
                                                          note: "chaotic evil when hungry"),
        )
    }

    @Test
    func `Alignment option with chance`() throws {
        try testCodable(
            json: """
            {
                "alignment": [
                    "L",
                    "E"
                ],
                "chance": 60
            }
            """,
            value: Creature.Alignment.Alignment.alignment(.lawfulEvil, chance: 60),
        )
    }

    @Test
    func `Alignment option encodes special`() throws {
        try testCodable(
            json: """
            {
                "special": "player's alignment"
            }
            """,
            value: Creature.Alignment.Alignment.special("player's alignment"),
        )
    }
}

struct CreatureAlignmentAlignmentFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `alignment() formats capitalized alignment`() {
        let alignment = Creature.Alignment.Alignment.alignment(.lawfulGood)

        let formatter = Creature.Alignment.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignmentAlignment == alignment)
        #expect(attributed.alignment == .lawfulGood)
    }

    @Test
    func `alignment(case:) formats lowercased alignment`() {
        let alignment = Creature.Alignment.Alignment.alignment(.lawfulGood)

        let formatter = Creature.Alignment.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful good")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignmentAlignment == alignment)
        #expect(attributed.alignment == .lawfulGood)
    }

    @Test
    func `alignment() formats chance as percent`() throws {
        let alignment = Creature.Alignment.Alignment.alignment(.lawfulGood, chance: 75)

        let formatter = Creature.Alignment.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good (75%)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignmentAlignment == alignment)

        let range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].alignment == .lawfulGood)
    }

    @Test
    func `alignment() formats capitalized note`() throws {
        let alignment = Creature.Alignment.Alignment.alignment(.lawfulGood,
                                                               note:
                                                               "before midnight")

        let formatter = Creature.Alignment.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good (Before Midnight)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignmentAlignment == alignment)

        let range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].alignment == .lawfulGood)
    }

    @Test
    func `alignment(case:) formats lowercased note`() throws {
        let alignment = Creature.Alignment.Alignment.alignment(.lawfulGood, note: "Before Midnight")

        let formatter = Creature.Alignment.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful good (before midnight)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignmentAlignment == alignment)

        let range = try #require(attributed.range(of: "lawful good"))
        #expect(attributed[range].alignment == .lawfulGood)
    }

    @Test
    func `alignment() formats capitalized special`() {
        let alignment = Creature.Alignment.Alignment.special("lawful grumpy")

        let formatter = Creature.Alignment.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Grumpy")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignmentAlignment == alignment)
    }

    @Test
    func `alignment(case:) formats lowercased special`() {
        let alignment = Creature.Alignment.Alignment.special("Lawful Grumpy")

        let formatter = Creature.Alignment.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful grumpy")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignmentAlignment == alignment)
    }
}

struct CreatureAlignmentAlignmentInitTests {
    static let expectedValues: [(Creature.Alignment.Alignment, Alignment)] = [
        (.unaligned, .unaligned),
        (.any, .any),
        (.lawful, .lawful),
        (.chaotic, .chaotic),
        (.neutral, .neutral),
        (.good, .good),
        (.evil, .evil),
        (.lawfulGood, .lawfulGood),
        (.lawfulNeutral, .lawfulNeutral),
        (.lawfulEvil, .lawfulEvil),
        (.neutralGood, .neutralGood),
        (.neutralEvil, .neutralEvil),
        (.chaoticGood, .chaoticGood),
        (.chaoticNeutral, .chaoticNeutral),
        (.chaoticEvil, .chaoticEvil),
        (.anyNeutral, .anyNeutral),
        (.anyLawful, .anyLawful),
        (.anyChaotic, .anyChaotic),
        (.anyGood, .anyGood),
        (.anyEvil, .anyEvil),
        (.anyNonLawful, .anyNonLawful),
        (.anyNonChaotic, .anyNonChaotic),
        (.anyNonGood, .anyNonGood),
        (.anyNonEvil, .anyNonEvil),
    ]

    @Test(arguments: expectedValues)
    func `Static alignment`(alignnentOption: Creature.Alignment.Alignment, alignment: Alignment) {
        #expect(alignnentOption == .alignment(alignment))
    }

    @Test
    func `init(stringLiteral:) sets special`() {
        let alignnentOption: Creature.Alignment.Alignment = "lawful grumpy"
        #expect(alignnentOption == Creature.Alignment.Alignment.special("lawful grumpy"))
    }
}
