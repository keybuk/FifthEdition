//
//  ResourcesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 8/22/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureResourcesCodableTests {
    @Test
    func `Resources encodes formula in object with average`() throws {
        try testCodable(
            json: """
            [
                {
                    "name": "Souls",
                    "value": 24,
                    "formula": "4d6 + 10"
                }
            ]
            """,
            value: Creature.Resources([
                "Souls": .resource(.init(.d6, count: 4, modifier: 10)),
            ]),
        )
    }

    @Test
    func `Resources encodes formula in object with given value`() throws {
        try testCodable(
            json: """
            [
                {
                    "name": "Souls",
                    "value": 30,
                    "formula": "4d6 + 10"
                }
            ]
            """,
            value: Creature.Resources([
                "Souls": .resource(.init(.d6, count: 4, modifier: 10), value: 30),
            ]),
        )
    }

    @Test
    func `Resources encodes value in object`() throws {
        try testCodable(
            json: """
            [
                {
                    "name": "Mana",
                    "value": 8
                }
            ]
            """,
            value: Creature.Resources([
                "Mana": .value(8),
            ]),
        )
    }

    @Test
    func `Resources encodes value with unparseable formula in object`() throws {
        try testCodable(
            json: """
            [
                {
                    "name": "Extra Life",
                    "value": 2,
                    "formula": "coin toss"
                }
            ]
            """,
            value: Creature.Resources([
                "Extra Life": .value(2, formula: "coin toss"),
            ]),
        )
    }
}

struct CreatureResourcesCollectionTests {
    @Test
    func `subscript(_:)`() {
        let resources = Creature.Resources([
            "Souls": "4d6 + 10",
            "Mana": 8,
        ])
        #expect(resources["Souls"] == "4d6 + 10")
        #expect(resources["Mana"] == 8)
    }

    @Test
    func `isEmpty returns true for empty resources`() {
        let resources = Creature.Resources([:])
        #expect(resources.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if resources`() {
        let resources = Creature.Resources([
            "Souls": "4d6 + 10",
            "Mana": 8,
        ])
        #expect(resources.isEmpty == false)
    }
}

struct CreatureResourcesFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `resources() formats sorted list of capitalized name and value`() throws {
        let resources = Creature.Resources([
            "Souls": "4d6 + 10",
            "Mana": 8,
        ])

        let formatter = Creature.Resources.FormatStyle().locale(Self.locale)
        let description = formatter.format(resources)
        #expect(description == "Mana 8, Souls 24 (4d6 + 10)")

        let attributed = formatter.attributed.format(resources)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.resources == resources)

        var range = try #require(attributed.range(of: "8"))
        #expect(attributed[range].resource == resources["Mana"])

        range = try #require(attributed.range(of: "24 (4d6 + 10)"))
        #expect(attributed[range].resource == resources["Souls"])

        range = try #require(attributed.range(of: "4d6 + 10"))
        #expect(attributed[range].diceNotation == .init(.d6, count: 4, modifier: 10))
    }
}

struct CreatureResourcesInitTests {
    @Test
    func `init(_:) sets resourcex`() {
        let resources = Creature.Resources([
            "Souls": "4d6 + 10",
            "Mana": 8,
        ])
        #expect(resources.resources == [
            "Souls": "4d6 + 10",
            "Mana": 8,
        ])
    }

    @Test
    func `init(dictionaryLiteral:) sets resources`() {
        let resources: Creature.Resources = [
            "Souls": "4d6 + 10",
            "Mana": 8,
        ]
        #expect(resources.resources == [
            "Souls": "4d6 + 10",
            "Mana": 8,
        ])
    }
}
