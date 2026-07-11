//
//  ToolsTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureToolsCodableTests {
    @Test
    func `Tools encodes as object`() throws {
        try testCodable(
            json: """
            {
                "brewer's supplies": "+2",
                "lute": "+4"
            }
            """,
            value: Creature.Tools([
                .brewersSupplies: .modifier(2),
                .lute: .modifier(4),
            ]),
        )
    }

    @Test
    func `Tools encodes items in uid format`() throws {
        try testCodable(
            json: """
            {
                "brewer's supplies": "+2",
                "lute": "+4",
                "manacles|phb": "-1"
            }
            """,
            value: Creature.Tools([
                .brewersSupplies: .modifier(2),
                .lute: .modifier(4),
                .item(name: "Manacles", source: "PHB"): .modifier(-1),
            ]),
        )
    }

    @Test
    func `Tools encodes unknown case`() throws {
        try testCodable(
            json: """
            {
                "brewer's supplies": "+2",
                "lute": "+4",
                "sonic screwdriver": "-1"
            }
            """,
            value: Creature.Tools([
                .brewersSupplies: .modifier(2),
                .lute: .modifier(4),
                .other("sonic screwdriver"): .modifier(-1),
            ]),
        )
    }
}

struct CreatureToolsCollectionTests {
    @Test
    func `subscript(_:)`() {
        let tools = Creature.Tools([
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ])
        #expect(tools[.brewersSupplies] == .modifier(2))
        #expect(tools[.lute] == .modifier(4))
        #expect(tools[.thievesTools] == nil)
    }

    @Test
    func `isEmpty returns true for empty tools`() {
        let tools = Creature.Tools([:])
        #expect(tools.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if tools`() {
        let tools = Creature.Tools([
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ])
        #expect(tools.isEmpty == false)
    }
}

struct CreatureToolsFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `tools() formats sorted list of capitalized name and modifier`() throws {
        let tools = Creature.Tools([
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ])

        let formatter = Creature.Tools.FormatStyle().locale(Self.locale)
        let description = formatter.format(tools)
        #expect(description == "Brewer's Supplies +2, Lute +4")

        let attributed = formatter.attributed.format(tools)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.tools == tools)

        var range = try #require(attributed.range(of: "Brewer's Supplies"))
        #expect(attributed[range].tool == .brewersSupplies)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == tools[.brewersSupplies])

        range = try #require(attributed.range(of: "Lute"))
        #expect(attributed[range].tool == .lute)

        range = try #require(attributed.range(of: "+4"))
        #expect(attributed[range].abilityModifier == tools[.lute])
    }

    @Test
    func `tools() formats sorted list of lowercased name and modifier`() throws {
        let tools = Creature.Tools([
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ])

        let formatter = Creature.Tools.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(tools)
        #expect(description == "brewer's supplies +2, lute +4")

        let attributed = formatter.attributed.format(tools)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.tools == tools)

        var range = try #require(attributed.range(of: "brewer's supplies"))
        #expect(attributed[range].tool == .brewersSupplies)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == tools[.brewersSupplies])

        range = try #require(attributed.range(of: "lute"))
        #expect(attributed[range].tool == .lute)

        range = try #require(attributed.range(of: "+4"))
        #expect(attributed[range].abilityModifier == tools[.lute])
    }
}

struct CreatureToolsInitTests {
    @Test
    func `init(_:) sets tools`() {
        let tools = Creature.Tools([
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ])
        #expect(tools.tools == [
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ])
    }

    @Test
    func `init(dictionaryLiteral:) sets tools`() {
        let tools: Creature.Tools = [
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ]
        #expect(tools.tools == [
            .brewersSupplies: .modifier(2),
            .lute: .modifier(4),
        ])
    }
}
