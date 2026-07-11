//
//  ToolTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/24/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct GearCodableTests {
    @Test
    func `Gear encodes as uid string`() throws {
        try testCodable(
            json: """
            "chain mail|xphb"
            """,
            value: Gear(name: "Chain Mail", source: "XPHB"),
        )
    }

    @Test
    func `Gear encodes quantity in object`() throws {
        try testCodable(
            json: """
            {
                "item": "dagger|xphb",
                "quantity": 4
            }
            """,
            value: Gear(name: "Dagger", source: "XPHB", quantity: 4),
        )
    }

    @Test
    func `Gear encodes displayName in object`() throws {
        try testCodable(
            json: """
            {
                "item": "dagger|xphb",
                "displayName": "Unsilvered Dagger"
            }
            """,
            value: Gear(name: "Dagger", source: "XPHB", displayName: "Unsilvered Dagger"),
        )
    }
}

struct GearComparableTests {
    @Test
    func `Gear compare by name`() {
        #expect(Gear(name: "Breastplate", source: "XPHB") < Gear(name: "Longbow", source: "XPHB"))
    }

    @Test
    func `Gear compare by displayName`() {
        #expect(Gear(name: "Manacles", source: "XPHB", displayName: "Leather Cuffs") < Gear(
            name: "Longbow",
            source: "XPHB",
        ))
    }
}

struct GearFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `gear() formats name`() {
        let gear = Gear(name: "Manacles", source: "XPHB")

        let formatter = Gear.FormatStyle().locale(Self.locale)
        let description = formatter.format(gear)
        #expect(description == "Manacles")

        let attributed = formatter.attributed.format(gear)
        #expect(String(attributed.characters) == description)
        #expect(attributed.gear == gear)
    }

    @Test
    func `gear() formats display name`() {
        let gear = Gear(name: "Manacles",
                        source: "XPHB",
                        displayName: "Leather Cuffs")

        let formatter = Gear.FormatStyle().locale(Self.locale)
        let description = formatter.format(gear)
        #expect(description == "Leather Cuffs")

        let attributed = formatter.attributed.format(gear)
        #expect(String(attributed.characters) == description)
        #expect(attributed.gear == gear)
    }

    @Test
    func `gear() formats quantity with plural name`() {
        let gear = Gear(name: "Longbow",
                        source: "XPHB",
                        quantity: 2)

        let formatter = Gear.FormatStyle().locale(Self.locale)
        let description = formatter.format(gear)
        #expect(description == "Longbows (2)")

        let attributed = formatter.attributed.format(gear)
        #expect(String(attributed.characters) == description)
        #expect(attributed.gear == gear)
    }
}

struct GearInitTests {
    @Test
    func `init(name:source:) initializes name and source`() {
        let gear = Gear(name: "Manacles", source: "XPHB")
        #expect(gear.name == "Manacles")
        #expect(gear.source == "XPHB")
    }

    @Test
    func `init(name:source:displayName:) initializes display name`() {
        let gear = Gear(name: "Manacles",
                        source: "XPHB",
                        displayName: "Leather Cuffs")
        #expect(gear.displayName == "Leather Cuffs")
    }

    @Test
    func `init(name:source:quantity:) initializes quantity`() {
        let gear = Gear(name: "Manacles", source: "XPHB", quantity: 2)
        #expect(gear.quantity == 2)
    }

    @Test
    func `init(name:source:) defaults quantity to 1`() {
        let gear = Gear(name: "Manacles", source: "XPHB")
        #expect(gear.quantity == 1)
    }

    @Test
    func `init(uid:) sets capitalized name and uppercase source`() {
        let gear = Gear(uid: "manacles|xphb")
        #expect(gear != nil)
        #expect(gear?.name == "Manacles")
        #expect(gear?.source == "XPHB")
    }

    @Test
    func `init(uid:displayName:quantity") sets properties`() {
        let gear = Gear(uid: "manacles|xphb",
                        displayName: "Leather Cuffs",
                        quantity: 2)
        #expect(gear?.displayName == "Leather Cuffs")
        #expect(gear?.quantity == 2)
    }

    @Test
    func `init(uid:) returns nil if incorrectly formatted`() {
        let gear = Gear(uid: "wrong format")
        #expect(gear == nil)
    }
}

struct GearUidTests {
    @Test
    func `uid returns name and lowercased source`() {
        let gear = Gear(name: "Manacles", source: "XPHB")
        #expect(gear.uid == "manacles|xphb")
    }
}

struct ToolCodableTests {
    @Test(arguments: Tool.allCases)
    func `Tool encodes rawValue`(tool: Tool) throws {
        try testCodable(
            json: """
            "\(tool.rawValue)"
            """,
            value: tool,
        )
    }

    @Test
    func `Tool encodes item in uid format`() throws {
        try testCodable(
            json: """
            "manacles|xphb"
            """,
            value: Tool.item(name: "Manacles", source: "XPHB"),
        )
    }

    @Test
    func `Tool encodes rawValue of unknown tool`() throws {
        try testCodable(
            json: """
            "sonic screwdriver"
            """,
            value: Tool(rawValue: "sonic screwdriver"),
        )
    }
}

struct ToolCodingKeyTests {
    @Test(arguments: Tool.allCases)
    func `Tool encodes rawValue as dictionary key`(tool: Tool) throws {
        try testCodable(
            json: """
            {
                "\(tool.rawValue)": 42
            }
            """,
            value: [
                tool: 42,
            ],
        )
    }

    @Test
    func `Tool encodes item as dictionary key`() throws {
        try testCodable(
            json: """
            {
                "manacles|xphb": 42
            }
            """,
            value: [
                Tool.item(name: "Manacles", source: "XPHB"): 42,
            ],
        )
    }

    @Test
    func `Tool encodes unknown tool rawValue as dictionary key`() throws {
        try testCodable(
            json: """
            {
                "sonic screwdriver": 42
            }
            """,
            value: [
                Tool(rawValue: "sonic screwdriver"): 42,
            ],
        )
    }
}

struct ToolComparableTests {
    @Test(arguments: zip(Tool.allCases, Tool.allCases.dropFirst()))
    func `Tool smaller than next`(a: Tool, b: Tool) {
        #expect(a < b)
    }

    @Test(arguments: Tool.allCases)
    func `Tool smaller than item`(tool: Tool) {
        #expect(tool < Tool.item(name: "Manacles", source: "XPHB"))
    }

    @Test(arguments: Tool.allCases)
    func `Tool smaller than unknown`(tool: Tool) {
        #expect(tool < Tool.other("sonic screwdriver"))
    }

    @Test
    func `item smaller than unknown`() {
        #expect(Tool.item(name: "Manacles", source: "XPHB") < Tool.other("sonic screwdriver"))
    }
}

struct ToolFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Tool.allCases)
    func `tool() formats capitalized rawValue for common tools`(tool: Tool) {
        let formatter = Tool.FormatStyle().locale(Self.locale)
        let description = formatter.format(tool)
        #expect(description == tool.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(tool)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tool == tool)
    }

    @Test(arguments: Tool.allCases)
    func `tool(case:) formats lowercased rawValue for common tools`(tool: Tool) {
        let formatter = Tool.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(tool)
        #expect(description == tool.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(tool)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tool == tool)
    }

    @Test
    func `tool() formats capitalized name for item`() {
        let tool = Tool.item(name: "Manacles", source: "XPHB")

        let formatter = Tool.FormatStyle().locale(Self.locale)
        let description = formatter.format(tool)
        #expect(description == "Manacles")

        let attributed = formatter.attributed.format(tool)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tool == tool)
    }

    @Test
    func `tool(case:) formats lowercased name for item`() {
        let tool = Tool.item(name: "Manacles", source: "XPHB")

        let formatter = Tool.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(tool)
        #expect(description == "manacles")

        let attributed = formatter.attributed.format(tool)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tool == tool)
    }

    @Test
    func `tool() formats capitalized name for unknown case`() {
        let tool = Tool.other("sonic screwdriver")

        let formatter = Tool.FormatStyle().locale(Self.locale)
        let description = formatter.format(tool)
        #expect(description == "Sonic Screwdriver")

        let attributed = formatter.attributed.format(tool)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tool == tool)
    }

    @Test
    func `tool(case:) formats lowercased name for unknown case`() {
        let tool = Tool.other("sonic screwdriver")

        let formatter = Tool.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(tool)
        #expect(description == "sonic screwdriver")

        let attributed = formatter.attributed.format(tool)
        #expect(String(attributed.characters) == description)
        #expect(attributed.tool == tool)
    }
}

struct ToolRawRepresentableTests {
    static let expectedValues: [(Tool, String)] = [
        (.artisansTools, "artisan's tools"),

        (.alchemistsSupplies, "alchemist's supplies"),
        (.brewersSupplies, "brewer's supplies"),
        (.calligraphersSupplies, "calligrapher's supplies"),
        (.carpentersTools, "carpenter's tools"),
        (.cartographersTools, "cartographer's tools"),
        (.cobblersTools, "cobbler's tools"),
        (.cooksUtensils, "cook's utensils"),
        (.glassblowersTools, "glassblower's tools"),
        (.jewelersTools, "jeweler's tools"),
        (.leatherworkersTools, "leatherworker's tools"),
        (.masonsTools, "mason's tools"),
        (.paintersSupplies, "painter's supplies"),
        (.pottersTools, "potter's tools"),
        (.smithsTools, "smith's tools"),
        (.tinkersTools, "tinker's tools"),
        (.weaversTools, "weaver's tools"),
        (.woodcarversTools, "woodcarver's tools"),

        (.disguiseKit, "disguise kit"),
        (.forgeryKit, "forgery kit"),

        (.gamingSet, "gaming set"),
        (.dragonchessSet, "dragonchess set"),
        (.diceSet, "dice set"),
        (.playingCardSet, "playing card set"),
        (.playingCards, "playing cards"),
        (.threeDragonAnteSet, "three-dragon ante set"),

        (.herbalismKit, "herbalism kit"),

        (.musicalInstrument, "musical instrument"),
        (.bagpipes, "bagpipes"),
        (.drum, "drum"),
        (.dulcimer, "dulcimer"),
        (.flute, "flute"),
        (.horn, "horn"),
        (.lute, "lute"),
        (.lyre, "lyre"),
        (.panFlute, "pan flute"),
        (.shawm, "shawm"),
        (.viol, "viol"),

        (.navigatorsTools, "navigator's tools"),
        (.thievesTools, "thieves' tools"),
        (.poisonersKit, "poisoner's kit"),

        (.vehicles, "vehicles"),
        (.vehiclesAir, "vehicles (air)"),
        (.vehiclesLand, "vehicles (land)"),
        (.vehiclesWater, "vehicles (water)"),
        (.vehiclesSpace, "vehicles (space)"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(tool: Tool, rawValue: String) {
        #expect(Tool(rawValue: rawValue) == tool)
    }

    @Test
    func `init(rawValue:) sets item with capitalized name and uppercased source for reference`() {
        #expect(Tool(rawValue: "manacles|xphb") == .item(name: "Manacles", source: "XPHB"))
    }

    @Test
    func `init(rawValue:) sets other for unknown case`() {
        #expect(Tool(rawValue: "sonic screwdriver") == .other("sonic screwdriver"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(tool: Tool, rawValue: String) {
        #expect(tool.rawValue == rawValue)
    }

    @Test
    func `rawValue for item is uid format`() {
        let tool = Tool.item(name: "Manacles", source: "XPHB")
        #expect(tool.rawValue == "manacles|xphb")
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let tool = Tool.other("sonic screwdriver")
        #expect(tool.rawValue == "sonic screwdriver")
    }
}
