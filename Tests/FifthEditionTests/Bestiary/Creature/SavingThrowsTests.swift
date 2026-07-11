//
//  SavingThrowsTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureSavingThrowsCodableTests {
    @Test
    func `SavingThrows encodes as object`() throws {
        try testCodable(
            json: """
            {
                "str": "+2",
                "dex": "+4"
            }
            """,
            value: Creature.SavingThrows([
                .strength: .modifier(2),
                .dexterity: .modifier(4),
            ]),
        )
    }

    @Test
    func `SavingThrows encodes special`() throws {
        try testCodable(
            json: """
            {
                "str": "+2",
                "dex": "+4",
                "special": "advantage against humanoids",
            }
            """,
            value: Creature.SavingThrows([
                .strength: .modifier(2),
                .dexterity: .modifier(4),
            ],
            special: "advantage against humanoids"),
        )
    }
}

struct CreatureSavingThrowsCollectionTests {
    @Test
    func `subscript(_:)`() {
        let savingThrows: Creature.SavingThrows = [
            .strength: .modifier(2),
            .dexterity: .modifier(4),
        ]
        #expect(savingThrows[.strength] == .modifier(2))
        #expect(savingThrows[.dexterity] == .modifier(4))
        #expect(savingThrows[.wisdom] == nil)
    }

    @Test
    func `isEmpty returns true for empty saving throws`() {
        let savingThrows = Creature.SavingThrows([:])
        #expect(savingThrows.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if saving throws`() {
        let savingThrows = Creature.SavingThrows([
            .strength: .modifier(2),
            .dexterity: .modifier(4),
        ])
        #expect(savingThrows.isEmpty == false)
    }

    @Test
    func `isEmpty returns false if special`() {
        let savingThrows = Creature.SavingThrows([:],
                                                 special: "advantage against humanoids")
        #expect(savingThrows.isEmpty == false)
    }
}

struct CreatureSavingThrowsFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `savingThrows() formats sorted list of capitalized short name and modifier`() throws {
        let savingThrows = Creature.SavingThrows([
            .charisma: AbilityModifier.modifier(3),
            .wisdom: AbilityModifier.modifier(2),
        ])

        let formatter = Creature.SavingThrows.FormatStyle().locale(Self.locale)
        let description = formatter.format(savingThrows)
        #expect(description == "Wis +2, Cha +3")

        let attributed = formatter.attributed.format(savingThrows)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.savingThrows == savingThrows)

        var range = try #require(attributed.range(of: "Wis"))
        #expect(attributed[range].ability == .wisdom)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == savingThrows[.wisdom])

        range = try #require(attributed.range(of: "Cha"))
        #expect(attributed[range].ability == .charisma)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == savingThrows[.charisma])
    }

    @Test
    func `savingThrows(case:) formats sorted list of lowercased short name and modifier`() throws {
        let savingThrows = Creature.SavingThrows([
            .charisma: AbilityModifier.modifier(3),
            .wisdom: AbilityModifier.modifier(2),
        ])

        let formatter = Creature.SavingThrows.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(savingThrows)
        #expect(description == "wis +2, cha +3")

        let attributed = formatter.attributed.format(savingThrows)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.savingThrows == savingThrows)

        var range = try #require(attributed.range(of: "wis"))
        #expect(attributed[range].ability == .wisdom)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == savingThrows[.wisdom])

        range = try #require(attributed.range(of: "cha"))
        #expect(attributed[range].ability == .charisma)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == savingThrows[.charisma])
    }

    @Test
    func `savingThrows(width:) formats sorted list of capitalized name and modifier`() throws {
        let savingThrows = Creature.SavingThrows([
            .charisma: AbilityModifier.modifier(3),
            .wisdom: AbilityModifier.modifier(2),
        ])

        let formatter = Creature.SavingThrows.FormatStyle(width: .standard).locale(Self.locale)
        let description = formatter.format(savingThrows)
        #expect(description == "Wisdom +2, Charisma +3")

        let attributed = formatter.attributed.format(savingThrows)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.savingThrows == savingThrows)

        var range = try #require(attributed.range(of: "Wisdom"))
        #expect(attributed[range].ability == .wisdom)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == savingThrows[.wisdom])

        range = try #require(attributed.range(of: "Charisma"))
        #expect(attributed[range].ability == .charisma)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == savingThrows[.charisma])
    }

    @Test
    func `savingThrows(case:width:) formats sorted list of lowercased name name and modifier`() throws {
        let savingThrows = Creature.SavingThrows([
            .charisma: AbilityModifier.modifier(3),
            .wisdom: AbilityModifier.modifier(2),
        ])

        let formatter = Creature.SavingThrows.FormatStyle(case: .lowercased, width: .standard).locale(Self.locale)
        let description = formatter.format(savingThrows)
        #expect(description == "wisdom +2, charisma +3")

        let attributed = formatter.attributed.format(savingThrows)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.savingThrows == savingThrows)

        var range = try #require(attributed.range(of: "wisdom"))
        #expect(attributed[range].ability == .wisdom)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == savingThrows[.wisdom])

        range = try #require(attributed.range(of: "charisma"))
        #expect(attributed[range].ability == .charisma)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == savingThrows[.charisma])
    }

    @Test
    func `savingThrows() formats special at end`() throws {
        let savingThrows = Creature.SavingThrows(
            [
                .charisma: AbilityModifier.modifier(3),
                .wisdom: AbilityModifier.modifier(2),
            ],
            special: "advantage against humanoids",
        )

        let formatter = Creature.SavingThrows.FormatStyle().locale(Self.locale)
        let description = formatter.format(savingThrows)
        #expect(description == "Wis +2, Cha +3, advantage against humanoids")

        let attributed = formatter.attributed.format(savingThrows)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.savingThrows == savingThrows)

        var range = try #require(attributed.range(of: "Wis"))
        #expect(attributed[range].ability == .wisdom)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == savingThrows[.wisdom])

        range = try #require(attributed.range(of: "Cha"))
        #expect(attributed[range].ability == .charisma)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == savingThrows[.charisma])
    }

    @Test
    func `savingThrows() formats special only`() {
        let savingThrows = Creature.SavingThrows([:],
                                                 special: "advantage against humanoids")

        let formatter = Creature.SavingThrows.FormatStyle().locale(Self.locale)
        let description = formatter.format(savingThrows)
        #expect(description == "advantage against humanoids")

        let attributed = formatter.attributed.format(savingThrows)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.savingThrows == savingThrows)
    }
}

struct CreatureSavingThrowsInitTests {
    @Test
    func `init(_:) sets savingThrows`() {
        let savingThrows = Creature.SavingThrows([
            .strength: .modifier(2),
            .dexterity: .modifier(4),
        ])
        #expect(savingThrows.savingThrows == [
            .strength: .modifier(2),
            .dexterity: .modifier(4),
        ])
    }

    @Test
    func `init(_:special:) sets savingThrows and special`() {
        let savingThrows = Creature.SavingThrows([.strength: .modifier(2)],
                                                 special: "advantage against humanoids")
        #expect(savingThrows.savingThrows == [.strength: .modifier(2)])
        #expect(savingThrows.special == "advantage against humanoids")
    }

    @Test
    func `init(dictionaryLiteral:) sets savingThrows`() {
        let savingThrows: Creature.SavingThrows = [
            .strength: .modifier(2),
            .dexterity: .modifier(4),
        ]
        #expect(savingThrows.savingThrows == [
            .strength: .modifier(2),
            .dexterity: .modifier(4),
        ])
    }
}
