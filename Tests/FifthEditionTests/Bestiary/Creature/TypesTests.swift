//
//  TypesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureTypesFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `types() formats sorted list of capitalized names`() throws {
        let types = Creature.Types([.dragon, .aberration])

        let formatter = Creature.Types.FormatStyle().locale(Self.locale)
        let description = formatter.format(types)
        #expect(description == "Aberration or Dragon")

        let attributed = formatter.attributed.format(types)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == types)

        var range = try #require(attributed.range(of: "Aberration"))
        #expect(attributed[range].creatureType == .aberration)

        range = try #require(attributed.range(of: "Dragon"))
        #expect(attributed[range].creatureType == .dragon)
    }

    @Test
    func `types(case:) formats sorted list of lowercased names`() throws {
        let types = Creature.Types([.dragon, .aberration])

        let formatter = Creature.Types.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(types)
        #expect(description == "aberration or dragon")

        let attributed = formatter.attributed.format(types)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == types)

        var range = try #require(attributed.range(of: "aberration"))
        #expect(attributed[range].creatureType == .aberration)

        range = try #require(attributed.range(of: "dragon"))
        #expect(attributed[range].creatureType == .dragon)
    }

    @Test
    func `types() formats sorted list of capitalized plural names for swarm`() throws {
        let types = Creature.Types([.dragon, .monstrosity, .undead], swarmSize: .medium)

        let formatter = Creature.Types.FormatStyle().locale(Self.locale)
        let description = formatter.format(types)
        #expect(description == "swarm of Medium Dragons, Monstrosities, or Undead")

        let attributed = formatter.attributed.format(types)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == types)

        var range = try #require(attributed.range(of: "Medium"))
        #expect(attributed[range].size == .medium)

        range = try #require(attributed.range(of: "Dragons"))
        #expect(attributed[range].creatureType == .dragon)

        range = try #require(attributed.range(of: "Monstrosities"))
        #expect(attributed[range].creatureType == .monstrosity)

        range = try #require(attributed.range(of: "Undead"))
        #expect(attributed[range].creatureType == .undead)
    }

    @Test
    func `types(case:) formats sorted list of lowercased plural names for swarm`() throws {
        let types = Creature.Types([.dragon, .monstrosity, .undead], swarmSize: .medium)

        let formatter = Creature.Types.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(types)
        #expect(description == "swarm of Medium dragons, monstrosities, or undead")

        let attributed = formatter.attributed.format(types)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == types)

        var range = try #require(attributed.range(of: "Medium"))
        #expect(attributed[range].size == .medium)

        range = try #require(attributed.range(of: "dragons"))
        #expect(attributed[range].creatureType == .dragon)

        range = try #require(attributed.range(of: "monstrosities"))
        #expect(attributed[range].creatureType == .monstrosity)

        range = try #require(attributed.range(of: "undead"))
        #expect(attributed[range].creatureType == .undead)
    }

    @Test
    func `types(case:size:) formats sorted list of lowercased plural names and swarm size`() throws {
        let creatureType = Creature.Types([.dragon, .monstrosity, .undead], swarmSize: .medium)

        let formatter = Creature.Types.FormatStyle(case: .lowercased, size: .lowercased).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "swarm of medium dragons, monstrosities, or undead")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == creatureType)

        var range = try #require(attributed.range(of: "medium"))
        #expect(attributed[range].size == .medium)

        range = try #require(attributed.range(of: "dragons"))
        #expect(attributed[range].creatureType == .dragon)

        range = try #require(attributed.range(of: "monstrosities"))
        #expect(attributed[range].creatureType == .monstrosity)

        range = try #require(attributed.range(of: "undead"))
        #expect(attributed[range].creatureType == .undead)
    }

    @Test
    func `types() formats capitalized tags`() throws {
        let creatureType = Creature.Types(.humanoid, tags: [Tag("elf", prefix: "dusk", isHidden: true)])

        let formatter = Creature.Types.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "Humanoid (Elf)")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == creatureType)

        var range = try #require(attributed.range(of: "Humanoid"))
        #expect(attributed[range].creatureType == .humanoid)

        range = try #require(attributed.range(of: "Elf"))
        #expect(attributed[range].tag == creatureType.tags.first!)
    }

    @Test
    func `types(case:) formats lowercased tags`() throws {
        let creatureType = Creature.Types(.humanoid, tags: [Tag("elf", prefix: "dusk", isHidden: true)])

        let formatter = Creature.Types.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "humanoid (elf)")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == creatureType)

        var range = try #require(attributed.range(of: "humanoid"))
        #expect(attributed[range].creatureType == .humanoid)

        range = try #require(attributed.range(of: "elf"))
        #expect(attributed[range].tag == creatureType.tags.first!)
    }

    @Test
    func `types() formats note`() throws {
        let creatureType = Creature.Types([.fey, .monstrosity], note: "depending on time-of-day")

        let formatter = Creature.Types.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureType)
        #expect(description == "Fey or Monstrosity depending on time-of-day")

        let attributed = formatter.attributed.format(creatureType)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.types == creatureType)

        var range = try #require(attributed.range(of: "Fey"))
        #expect(attributed[range].creatureType == .fey)

        range = try #require(attributed.range(of: "Monstrosity"))
        #expect(attributed[range].creatureType == .monstrosity)
    }
}

struct CreatureTypesInitTests {
    @Test
    func `init(_:) sets single type`() {
        let types = Creature.Types(.aberration)
        #expect(types.types == [.aberration])
    }

    @Test
    func `init(_:) sets multiple types`() {
        let types = Creature.Types([.fey, .monstrosity])
        #expect(types.types == [.fey, .monstrosity])
    }

    @Test
    func `init(_:tags:) sets type and tags`() {
        let types = Creature.Types(.humanoid, tags: [Tag("elf", prefix: "dusk", isHidden: true)])
        #expect(types.types == [.humanoid])
        #expect(types.tags == [Tag("elf", prefix: "dusk", isHidden: true)])
    }

    @Test
    func `init(_:tags:) sets types and tags`() {
        let types = Creature.Types([.humanoid, .fey], tags: [Tag("elf", prefix: "dusk", isHidden: true)])
        #expect(types.types == [.humanoid, .fey])
        #expect(types.tags == [Tag("elf", prefix: "dusk", isHidden: true)])
    }

    @Test
    func `init(_:note:) sets type and note`() {
        let types = Creature.Types(.monstrosity, note: "after midnight")
        #expect(types.types == [.monstrosity])
        #expect(types.note == "after midnight")
    }

    @Test
    func `init(_:note:) sets types and note`() {
        let types = Creature.Types([.fey, .monstrosity], note: "depending on feeding time")
        #expect(types.types == [.fey, .monstrosity])
        #expect(types.note == "depending on feeding time")
    }

    @Test
    func `init(_:swarmSize) sets type and swarmSize`() {
        let types = Creature.Types(.beast, swarmSize: .medium)
        #expect(types.types == [.beast])
        #expect(types.swarmSize == .medium)
    }

    @Test
    func `init(_:swarmSize) sets types and swarmSize`() {
        let types = Creature.Types([.beast, .monstrosity], swarmSize: .medium)
        #expect(types.types == [.beast, .monstrosity])
        #expect(types.swarmSize == .medium)
    }

    @Test
    func `init(arrayLiteral:) sets type`() {
        let types: Creature.Types = [.fey, .monstrosity]
        #expect(types.types == [.fey, .monstrosity])
    }
}

struct CreatureSidekickFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `sidekick() formats level as ordinal`() {
        let sidekick = Creature.Sidekick(level: 7)

        let formatter = Creature.Sidekick.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "7th-Level")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)
        #expect(attributed.creature.sidekickLevel == 7)
    }

    @Test
    func `sidekick(case:) formats lowercased level`() {
        let sidekick = Creature.Sidekick(level: 7)

        let formatter = Creature.Sidekick.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "7th-level")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)
        #expect(attributed.creature.sidekickLevel == 7)
    }

    @Test(arguments: SidekickType.allCases)
    func `sidekick() formats capitalized sidekick type`(sidekickType: SidekickType) {
        let sidekick = Creature.Sidekick(type: sidekickType)

        let formatter = Creature.Sidekick.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == sidekickType.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)
        #expect(attributed.sidekickType == sidekickType)
    }

    @Test(arguments: SidekickType.allCases)
    func `sidekick(case:) formats lowercased sidekick type`(sidekickType: SidekickType) {
        let sidekick = Creature.Sidekick(type: sidekickType)

        let formatter = Creature.Sidekick.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == sidekickType.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)
        #expect(attributed.sidekickType == sidekickType)
    }

    @Test
    func `sidekick() formats capitalized ordinal level and sidekick type`() throws {
        let sidekick = Creature.Sidekick(level: 7,
                                         type: .spellcaster)

        let formatter = Creature.Sidekick.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "7th-Level Spellcaster")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)

        var range = try #require(attributed.range(of: "7th-Level"))
        #expect(attributed[range].creature.sidekickLevel == 7)

        range = try #require(attributed.range(of: "Spellcaster"))
        #expect(attributed[range].sidekickType == .spellcaster)
    }

    @Test
    func `sidekick(case:) formats lowercased ordinal level and sidekick type`() throws {
        let sidekick = Creature.Sidekick(level: 7,
                                         type: .spellcaster)

        let formatter = Creature.Sidekick.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "7th-level spellcaster")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)

        var range = try #require(attributed.range(of: "7th-level"))
        #expect(attributed[range].creature.sidekickLevel == 7)

        range = try #require(attributed.range(of: "spellcaster"))
        #expect(attributed[range].sidekickType == .spellcaster)
    }

    @Test
    func `sidekick() formats sidekick type and tags`() throws {
        let sidekick = Creature.Sidekick(type: .spellcaster, tags: Tag("wizard"))

        let formatter = Creature.Sidekick.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "Spellcaster (Wizard)")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)

        var range = try #require(attributed.range(of: "Spellcaster"))
        #expect(attributed[range].sidekickType == .spellcaster)

        range = try #require(attributed.range(of: "Wizard"))
        #expect(attributed[range].tag == sidekick.tags.first!)
    }

    @Test
    func `sidekick(case:) formats lowercased sidekick type and tags`() throws {
        let sidekick = Creature.Sidekick(type: .spellcaster, tags: Tag("wizard"))

        let formatter = Creature.Sidekick.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "spellcaster (wizard)")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)

        var range = try #require(attributed.range(of: "spellcaster"))
        #expect(attributed[range].sidekickType == .spellcaster)

        range = try #require(attributed.range(of: "wizard"))
        #expect(attributed[range].tag == sidekick.tags.first!)
    }

    @Test
    func `sidekick() formats only level if hidden`() {
        let sidekick = Creature.Sidekick(level: 7,
                                         type: .spellcaster,
                                         tags: Tag("wizard"),
                                         isHidden: true)

        let formatter = Creature.Sidekick.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "7th-Level")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sidekick == sidekick)
        #expect(attributed.creature.sidekickLevel == 7)
    }

    @Test
    func `sidekick() formats empty string if no level and hidden`() {
        let sidekick = Creature.Sidekick(type: .spellcaster,
                                         tags: Tag("wizard"),
                                         isHidden: true)

        let formatter = Creature.Sidekick.FormatStyle().locale(Self.locale)
        let description = formatter.format(sidekick)
        #expect(description == "")

        let attributed = formatter.attributed.format(sidekick)
        #expect(String(attributed.characters) == description)
    }
}
