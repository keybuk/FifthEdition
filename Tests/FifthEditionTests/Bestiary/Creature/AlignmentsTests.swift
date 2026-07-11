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
    static let expectedCoding: [(Creature.Alignment, Set<String>)] = [
        (.lawfulGood, ["L", "G"]),
        (.lawfulNeutral, ["L", "N"]),
        (.lawfulEvil, ["L", "E"]),
        (.neutralGood, ["N", "G"]),
        (.neutral, ["N"]),
        (.neutralEvil, ["N", "E"]),
        (.chaoticGood, ["C", "G"]),
        (.chaoticNeutral, ["C", "N"]),
        (.chaoticEvil, ["C", "E"]),

        (.unaligned, ["U"]),
        (.any, ["A"]),

        (.anyLawful, ["L", "NY", "G", "E"]),
        (.anyNonLawful, ["C", "NX", "NY", "G", "E"]),
        (.anyChaotic, ["C", "NY", "G", "E"]),
        (.anyNonChaotic, ["L", "NX", "NY", "G", "E"]),
        (.anyGood, ["L", "C", "NX", "G"]),
        (.anyNonGood, ["L", "C", "NX", "NY", "E"]),
        (.anyEvil, ["L", "C", "NX", "E"]),
        (.anyNonEvil, ["L", "C", "NX", "NY", "G"]),

        (.anyNeutral, ["N", "NX", "NY"]),
    ]

    @Test(arguments: Self.expectedCoding)
    func `Creature alignment encodes as set of factors in object`(alignment: Creature.Alignment,
                                                                  codingValue: Set<String>)
        throws
    {
        try testCodable(
            json: """
            {
                "alignment": [ \(codingValue.map { "\"\($0)\"" }.joined(separator: ", ")) ]
            }
            """,
            value: alignment,
        )
    }

    @Test
    func `Creature alignment encodes note in object`() throws {
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
            value: Creature.Alignment.alignment(.chaoticGood, note: "chaotic evil when hungry"),
        )
    }

    @Test
    func `Creature alignment encodes change in object`() throws {
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
            value: Creature.Alignment.alignment(.lawfulEvil, chance: 60),
        )
    }

    @Test
    func `Creature alignment encodes special`() throws {
        try testCodable(
            json: """
            {
                "special": "player's alignment"
            }
            """,
            value: Creature.Alignment.special("player's alignment"),
        )
    }
}

struct CreatureAlignmentFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    static let expectedValues: [(Set<Alignment>, String)] = [
        (.unaligned, "unaligned"),
        (.any, "any alignment"),
        (.anyGood, "any good alignment"),
        (.anyNonGood, "any non-good alignment"),
        (.anyEvil, "any evil alignment"),
        (.anyNonEvil, "any non-evil alignment"),
        (.anyLawful, "any lawful alignment"),
        (.anyNonLawful, "any non-lawful alignment"),
        (.anyChaotic, "any chaotic alignment"),
        (.anyNonChaotic, "any non-chaotic alignment"),
        (.anyNeutral, "any neutral alignment"),
    ]

    @Test
    func `alignment() formats capitalized single alignment`() {
        let alignment = Creature.Alignment.alignment(.lawfulGood)

        let formatter = Creature.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)
        #expect(attributed.alignment == .lawfulGood)
    }

    @Test
    func `alignment(case:) formats lowercased single alignment`() {
        let alignment = Creature.Alignment.alignment(.lawfulGood)

        let formatter = Creature.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful good")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)
        #expect(attributed.alignment == .lawfulGood)
    }

    @Test(arguments: Self.expectedValues)
    func `alignment() formats capitalized known alignment set`(alignments: Set<Alignment>, string: String) {
        let alignment = Creature.Alignment.alignment(alignments)

        let formatter = Creature.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == string.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)
    }

    @Test(arguments: Self.expectedValues)
    func `alignment(case:) formats lowercased known alignment set`(alignments: Set<Alignment>, string: String) {
        let alignment = Creature.Alignment.alignment(alignments)

        let formatter = Creature.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == string.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)
    }

    @Test
    func `alignment() formats capitalized multiple alignments`() throws {
        let alignment = Creature.Alignment.alignment([.lawfulGood, .lawfulEvil])

        let formatter = Creature.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good or Lawful Evil")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)

        var range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "Lawful Evil"))
        #expect(attributed[range].alignment == .lawfulEvil)
    }

    @Test
    func `alignment(case:) formats lowercased multiple alignments`() throws {
        let alignment = Creature.Alignment.alignment([.lawfulGood, .lawfulEvil])

        let formatter = Creature.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful good or lawful evil")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)

        var range = try #require(attributed.range(of: "lawful good"))
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "lawful evil"))
        #expect(attributed[range].alignment == .lawfulEvil)
    }

    @Test
    func `alignment() formats chance as percent`() throws {
        let alignment = Creature.Alignment.alignment(.lawfulGood, chance: 75)

        let formatter = Creature.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good (75%)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)

        let range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].alignment == .lawfulGood)
    }

    @Test
    func `alignment() formats capitalized note`() throws {
        let alignment = Creature.Alignment.alignment(.lawfulGood,
                                                     note:
                                                     "before midnight")

        let formatter = Creature.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Good (Before Midnight)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)

        let range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].alignment == .lawfulGood)
    }

    @Test
    func `alignment(case:) formats lowercased note`() throws {
        let alignment = Creature.Alignment.alignment(.lawfulGood, note: "Before Midnight")

        let formatter = Creature.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful good (before midnight)")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)

        let range = try #require(attributed.range(of: "lawful good"))
        #expect(attributed[range].alignment == .lawfulGood)
    }

    @Test
    func `alignment() formats capitalized special`() {
        let alignment = Creature.Alignment.special("lawful grumpy")

        let formatter = Creature.Alignment.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "Lawful Grumpy")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)
    }

    @Test
    func `alignment(case:) formats lowercased special`() {
        let alignment = Creature.Alignment.special("Lawful Grumpy")

        let formatter = Creature.Alignment.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignment)
        #expect(description == "lawful grumpy")

        let attributed = formatter.attributed.format(alignment)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignment == alignment)
    }
}

struct CreatureAlignmentInitTests {
    static let expectedValues: [(Creature.Alignment, Set<Alignment>)] = [
        (.lawfulGood, [.lawfulGood]),
        (.lawfulNeutral, [.lawfulNeutral]),
        (.lawfulEvil, [.lawfulEvil]),
        (.neutralGood, [.neutralGood]),
        (.neutralEvil, [.neutralEvil]),
        (.chaoticGood, [.chaoticGood]),
        (.chaoticNeutral, [.chaoticNeutral]),
        (.chaoticEvil, [.chaoticEvil]),

        (.unaligned, .unaligned),
        (.any, .any),
        (.anyLawful, .anyLawful),
        (.anyNonLawful, .anyNonLawful),
        (.anyNeutralOrder, .anyNeutralOrder),
        (.anyChaotic, .anyChaotic),
        (.anyNonChaotic, .anyNonChaotic),
        (.anyGood, .anyGood),
        (.anyNonGood, .anyNonGood),
        (.anyNeutralMorality, .anyNeutralMorality),
        (.anyEvil, .anyEvil),
        (.anyNonEvil, .anyNonEvil),
        (.anyNeutral, .anyNeutral),
    ]

    @Test(arguments: expectedValues)
    func `Static alignment`(creatureAlignment: Creature.Alignment, alignments: Set<Alignment>) {
        #expect(creatureAlignment == .alignment(alignments))
    }

    @Test
    func `init(stringLiteral:) sets special`() {
        let creatureAlignment: Creature.Alignment = "lawful grumpy"
        #expect(creatureAlignment == .special("lawful grumpy"))
    }
}

struct CreatureAlignmentInitStringsTests {
    static let expectedIntersections: [(Set<String>, Creature.Alignment)] = [
        (["L", "G"], .lawfulGood),
        (["L", "E"], .lawfulEvil),
        (["C", "G"], .chaoticGood),
        (["C", "E"], .chaoticEvil),
    ]

    static let expectedNeutrals: [(Set<String>, Creature.Alignment)] = [
        (["L", "N"], .lawfulNeutral),
        (["C", "N"], .chaoticNeutral),
        (["N", "G"], .neutralGood),
        (["N", "E"], .neutralEvil),
    ]

    static let expectedUnions: [(Set<String>, Creature.Alignment)] = [
        (["L", "NY", "G", "E"], .anyLawful),
        (["C", "NX", "NY", "G", "E"], .anyNonLawful),
        (["C", "NY", "G", "E"], .anyChaotic),
        (["L", "NX", "NY", "G", "E"], .anyNonChaotic),
        (["L", "C", "NX", "G"], .anyGood),
        (["L", "C", "NX", "NY", "E"], .anyNonGood),
        (["L", "C", "NX", "E"], .anyEvil),
        (["L", "C", "NX", "NY", "G"], .anyNonEvil),
    ]

    @Test
    func `init(strings:) returns empty set for unaligned`() {
        let creatureAlignment = Creature.Alignment(strings: ["U"])
        #expect(creatureAlignment == .unaligned)
    }

    @Test
    func `init(strings:) ignores extra elements if unaligned`() {
        let creatureAlignment = Creature.Alignment(strings: ["U", "L"])
        #expect(creatureAlignment == .unaligned)
    }

    @Test
    func `init(strings:) returns full set for any`() {
        let creatureAlignment = Creature.Alignment(strings: ["A"])
        #expect(creatureAlignment == .any)
    }

    @Test
    func `init(strings:) ignores extra elements if any`() {
        let creatureAlignment = Creature.Alignment(strings: ["A", "L"])
        #expect(creatureAlignment == .any)
    }

    @Test(arguments: Self.expectedIntersections)
    func `init(strings:) returns intersection of axes`(strings: Set<String>, expectedAlignment: Creature.Alignment) {
        let creatureAlignment = Creature.Alignment(strings: strings)
        #expect(creatureAlignment == expectedAlignment)
    }

    @Test(arguments: Self.expectedNeutrals)
    func `init(strings:) replaces neutral with neutral in opposite axis`(
        strings: Set<String>,
        expectedAlignment: Creature.Alignment,
    ) {
        let creatureAlignment = Creature.Alignment(strings: strings)
        #expect(creatureAlignment == expectedAlignment)
    }

    @Test
    func `init(strings:) returns neutral for true neutral`() {
        let creatureAlignment = Creature.Alignment(strings: ["N"])
        #expect(creatureAlignment == .neutral)
    }

    @Test
    func `init(strings:) returns any neutral`() {
        let creatureAlignment = Creature.Alignment(strings: ["N", "NX", "NY"])
        #expect(creatureAlignment == .anyNeutral)
    }

    @Test(arguments: Self.expectedUnions)
    func `init(strings:) returns union of axes`(strings: Set<String>, expectedAlignment: Creature.Alignment) {
        let creatureAlignment = Creature.Alignment(strings: strings)
        #expect(creatureAlignment == expectedAlignment)
    }

    @Test
    func `init(strings:) ignores unknown elements`() {
        let creatureAlignment = Creature.Alignment(strings: ["L", "G", "Z"])
        #expect(creatureAlignment == .lawfulGood)
    }

    @Test
    func `init(strings:chance:) sets chance`() {
        let creatureAlignment = Creature.Alignment(strings: ["L", "G"], chance: 60)
        #expect(creatureAlignment == .alignment(.lawfulGood, chance: 60, note: nil))
    }

    @Test
    func `init(strings:note:) sets note`() {
        let creatureAlignment = Creature.Alignment(strings: ["C", "G"], note: "chaotic evil when hungry")
        #expect(creatureAlignment == .alignment(.chaoticGood, chance: nil, note: "chaotic evil when hungry"))
    }
}

struct CreatureAlignmentStringsTests {
    static let expectedIntersections: [(Creature.Alignment, Set<String>)] = [
        (.lawfulGood, ["L", "G"]),
        (.lawfulEvil, ["L", "E"]),
        (.chaoticGood, ["C", "G"]),
        (.chaoticEvil, ["C", "E"]),
    ]

    static let expectedNeutrals: [(Creature.Alignment, Set<String>)] = [
        (.lawfulNeutral, ["L", "N"]),
        (.chaoticNeutral, ["C", "N"]),
        (.neutralGood, ["N", "G"]),
        (.neutralEvil, ["N", "E"]),
    ]

    static let expectedUnions: [(Creature.Alignment, Set<String>)] = [
        (.anyLawful, ["L", "NY", "G", "E"]),
        (.anyNonLawful, ["C", "NX", "NY", "G", "E"]),
        (.anyChaotic, ["C", "NY", "G", "E"]),
        (.anyNonChaotic, ["L", "NX", "NY", "G", "E"]),
        (.anyGood, ["L", "C", "NX", "G"]),
        (.anyNonGood, ["L", "C", "NX", "NY", "E"]),
        (.anyEvil, ["L", "C", "NX", "E"]),
        (.anyNonEvil, ["L", "C", "NX", "NY", "G"]),
    ]

    @Test
    func `init(strings:) returns unaligned for empty set`() {
        let creatureAlignment: Creature.Alignment = .unaligned
        #expect(creatureAlignment.strings == ["U"])
    }

    @Test
    func `init(strings:) returns any for full set`() {
        let creatureAlignment: Creature.Alignment = .any
        #expect(creatureAlignment.strings == ["A"])
    }

    @Test(arguments: Self.expectedIntersections)
    func `strings returns intersection of axes`(creatureAlignment: Creature.Alignment, expectedStrings: Set<String>) {
        #expect(creatureAlignment.strings == expectedStrings)
    }

    @Test(arguments: Self.expectedNeutrals)
    func `strings returns neutral for opposite axis`(
        creatureAlignment: Creature.Alignment,
        expectedStrings: Set<String>,
    ) {
        #expect(creatureAlignment.strings == expectedStrings)
    }

    @Test
    func `strings returns true neutral`() {
        let creatureAlignment: Creature.Alignment = .neutral
        #expect(creatureAlignment.strings == ["N"])
    }

    @Test
    func `strings returns any neutral`() {
        let creatureAlignment: Creature.Alignment = .anyNeutral
        #expect(creatureAlignment.strings == ["N", "NX", "NY"])
    }

    @Test(arguments: Self.expectedUnions)
    func `strings returns union of axes`(creatureAlignment: Creature.Alignment, expectedStrings: Set<String>) {
        #expect(creatureAlignment.strings == expectedStrings)
    }

    @Test
    func `strings returns empty set for special`() {
        let creatureAlignment: Creature.Alignment = .special("lawful grumpy")
        #expect(creatureAlignment.strings == [])
    }
}

struct CreatureAlignmentsCodableTests {
    @Test
    func `Creature alignments encodes single alignment as array of strings`() throws {
        try testCodable(
            json: """
            [
                "L",
                "G"
            ]
            """,
            value: Creature.Alignments([.lawfulGood]),
        )
    }

    @Test
    func `Creature alignments encodes single alignment as object`() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [
                        "L",
                        "G"
                    ]
                }
            ]
            """,
            value: Creature.Alignments([.lawfulGood]),
        )
    }

    @Test
    func `Creature alignments encodes single alignment with chance as object`() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [
                        "L",
                        "E"
                    ],
                    "chance": 60
                }
            ]
            """,
            value: Creature.Alignments([.alignment(.lawfulEvil, chance: 60)]),
        )
    }

    @Test
    func `Creature alignments encodes single alignment with note as object`() throws {
        try testCodable(
            json: """
            [
                {
                    "alignment": [
                        "C",
                        "G"
                    ],
                    "note": "chaotic evil when hungry"
                }
            ]
            """,
            value: Creature.Alignments([.alignment(.chaoticGood, note: "chaotic evil when hungry")]),
        )
    }

    @Test
    func `Creature alignments encodes multiple alignments as array of objects`() throws {
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
            value: Creature.Alignments([.lawfulNeutral, .lawfulEvil]),
        )
    }
}

struct CreatureAlignmentsCollectionTests {
    @Test
    func `isEmpty returns true for empty alignment`() {
        let alignments = Creature.Alignments([])
        #expect(alignments.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if alignment not empty`() {
        let alignments = Creature.Alignments([.lawfulGood, .lawfulEvil])
        #expect(alignments.isEmpty == false)
    }
}

struct CreatureAlignmentsFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `alignments() formats list of capitalized alignment`() throws {
        let alignments = Creature.Alignments([
            .alignment(.lawfulGood, note: "before midnight"),
            .alignment(.chaoticEvil, note: "after midnight"),
        ])

        let formatter = Creature.Alignments.FormatStyle().locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == "Lawful Good (Before Midnight) or Chaotic Evil (After Midnight)")

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignments == alignments)

        var range = try #require(attributed.range(of: "Lawful Good"))
        #expect(attributed[range].creature.alignment == alignments.alignments[0])
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "Chaotic Evil"))
        #expect(attributed[range].creature.alignment == alignments.alignments[1])
        #expect(attributed[range].alignment == .chaoticEvil)
    }

    @Test
    func `alignments(case:) formats list of lowercased alignments`() throws {
        let alignments = Creature.Alignments([
            .alignment(.lawfulGood, note: "Before Midnight"),
            .alignment(.chaoticEvil, note: "After Midnight"),
        ])

        let formatter = Creature.Alignments.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(alignments)
        #expect(description == "lawful good (before midnight) or chaotic evil (after midnight)")

        let attributed = formatter.attributed.format(alignments)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.alignments == alignments)

        var range = try #require(attributed.range(of: "lawful good"))
        #expect(attributed[range].creature.alignment == alignments.alignments[0])
        #expect(attributed[range].alignment == .lawfulGood)

        range = try #require(attributed.range(of: "chaotic evil"))
        #expect(attributed[range].creature.alignment == alignments.alignments[1])
        #expect(attributed[range].alignment == .chaoticEvil)
    }
}

struct CreatureAlignmentsInitTests {
    @Test
    func `init(_:) sets single alignment`() {
        let alignments = Creature.Alignments(.chaoticNeutral)
        #expect(alignments.alignments == [.chaoticNeutral])
    }

    @Test
    func `init(_:) sets multiple alignments`() {
        let alignments = Creature.Alignments([.lawfulGood, .lawfulEvil])
        #expect(alignments.alignments == [.lawfulGood, .lawfulEvil])
    }

    @Test
    func `init(_:prefix:) sets alignment and prefix`() {
        let alignments = Creature.Alignments(.lawfulNeutral, prefix: "Typically ")
        #expect(alignments.alignments == [.lawfulNeutral])
        #expect(alignments.prefix == "Typically ")
    }

    @Test
    func `init(_:prefix:) sets multiple alignments and prefix`() {
        let alignments = Creature.Alignments([.lawfulGood, .lawfulNeutral], prefix: "Typically ")
        #expect(alignments.alignments == [.lawfulGood, .lawfulNeutral])
        #expect(alignments.prefix == "Typically ")
    }

    @Test
    func `init(arrayLiteral:) sets alignment`() {
        let alignment: Creature.Alignments = [.lawfulGood, .lawfulEvil]
        #expect(alignment.alignments == [.lawfulGood, .lawfulEvil])
    }
}
