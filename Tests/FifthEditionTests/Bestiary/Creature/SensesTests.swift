//
//  SensesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureSenseCodableTests {
    @Test
    func `Creature sense encodes as string`() throws {
        try testCodable(
            json: """
            "blindsight 60 ft."
            """,
            value: Creature.Sense.sense(.blindsight, range: 60),
        )
    }

    @Test
    func `Creature sense encodes note in description`() throws {
        try testCodable(
            json: """
            "blindsight 60 ft. (blind beyond this radius)"
            """,
            value: Creature.Sense.sense(.blindsight, range: 60, note: "(blind beyond this radius)"),
        )
    }

    @Test
    func `Creature sense encodes special`() throws {
        try testCodable(
            json: """
            "custardsense 60 ft."
            """,
            value: Creature.Sense.special("custardsense 60 ft."),
        )
    }
}

struct CreatureSenseComparableTests {
    @Test
    func `sense(:_) compare by value`() {
        #expect(Creature.Sense.sense(.blindsight, range: 60, note: nil) < Creature.Sense.sense(
            .darkvision,
            range: 60,
            note: nil,
        ))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(Creature.Sense.special("a") < Creature.Sense.special("b"))
    }

    @Test
    func `sense(:_) compares less than special(:_)`() {
        #expect(Creature.Sense.sense(.blindsight, range: 60, note: nil) < Creature.Sense.special("a"))
    }
}

struct CreatureSenseFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `sense() formats capitalized name and range`() throws {
        let creatureSense = Creature.Sense.sense(.blindsight, range: 60)

        let formatter = Creature.Sense.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureSense)
        #expect(description == "Blindsight 60 ft.")

        let attributed = formatter.attributed.format(creatureSense)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sense == creatureSense)

        let range = try #require(attributed.range(of: "Blindsight"))
        #expect(attributed[range].sense == .blindsight)
    }

    @Test
    func `sense(case:) formats lowercased name and range`() throws {
        let creatureSense = Creature.Sense.sense(.blindsight, range: 60)

        let formatter = Creature.Sense.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(creatureSense)
        #expect(description == "blindsight 60 ft.")

        let attributed = formatter.attributed.format(creatureSense)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sense == creatureSense)

        let range = try #require(attributed.range(of: "blindsight"))
        #expect(attributed[range].sense == .blindsight)
    }

    @Test
    func `sense() formats capitalized name and range with note`() throws {
        let creatureSense = Creature.Sense.sense(.darkvision, range: 300, note: "(including magical darkness)")

        let formatter = Creature.Sense.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureSense)
        #expect(description == "Darkvision 300 ft. (including magical darkness)")

        let attributed = formatter.attributed.format(creatureSense)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sense == creatureSense)

        let range = try #require(attributed.range(of: "Darkvision"))
        #expect(attributed[range].sense == .darkvision)
    }

    @Test
    func `sense() formats special`() {
        let creatureSense = Creature.Sense.special("custardsense 60 ft.")

        let formatter = Creature.Sense.FormatStyle().locale(Self.locale)
        let description = formatter.format(creatureSense)
        #expect(description == "custardsense 60 ft.")

        let attributed = formatter.attributed.format(creatureSense)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sense == creatureSense)
    }
}

struct CreatureSenseInitTests {
    @Test(arguments: Sense.allCases.filter { $0 != .superiorDarkvision })
    func `init(string:) parses sense with range`(sense: Sense) {
        let creatureSense = Creature.Sense(string: "\(sense.rawValue) 60 ft.")
        #expect(creatureSense == .sense(sense, range: 60))
    }

    @Test(arguments: Sense.allCases.filter { $0 != .superiorDarkvision })
    func `init(string:) parses capitalized sense`(sense: Sense) {
        let creatureSense = Creature.Sense(string: "\(sense.rawValue.capitalized) 60 ft.")
        #expect(creatureSense == .sense(sense, range: 60))
    }

    @Test
    func `init(string:) parses sense without whitespace`() {
        let creatureSense = Creature.Sense(string: "blindsight 60ft.")
        #expect(creatureSense == .sense(.blindsight, range: 60))
    }

    @Test
    func `init(string:) parses sense with capitalized unit`() {
        let creatureSense = Creature.Sense(string: "Blindsight 60 Ft.")
        #expect(creatureSense == .sense(.blindsight, range: 60))
    }

    @Test
    func `init(string:) parses sense with verbose unit`() {
        let creatureSense = Creature.Sense(string: "blindsight 60 feet")
        #expect(creatureSense == .sense(.blindsight, range: 60))
    }

    @Test
    func `init(string:) parses sense without unit`() {
        let creatureSense = Creature.Sense(string: "blindsight 60")
        #expect(creatureSense == .sense(.blindsight, range: 60))
    }

    @Test
    func `init(string:) parses additional text after sense as note`() {
        let creatureSense = Creature.Sense(string: "blindsight 120 ft. (blind beyond this radius)")
        #expect(creatureSense == .sense(.blindsight, range: 120, note: "(blind beyond this radius)"))
    }

    @Test
    func `init(string:) parses unknown text as special`() {
        let creatureSense = Creature.Sense(string: "custardsense 60 ft.")
        #expect(creatureSense == .special("custardsense 60 ft."))
    }
}

struct CreatureSenseListFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `senses() returns sorted list of capitalized names`() throws {
        let creatureSense: [Creature.Sense] = [
            .sense(.darkvision, range: 300, note: "(including magical darkness)"),
            .sense(.blindsight, range: 60),
        ]

        let formatter: Creature.Sense.ListFormatStyle<[Creature.Sense]> = .senses().locale(Self.locale)
        let description = formatter.format(creatureSense)
        #expect(description == "Blindsight 60 ft., Darkvision 300 ft. (including magical darkness)")

        let attributed = formatter.attributed.format(creatureSense)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "Blindsight"))
        #expect(attributed[range].creature.sense == creatureSense[1])
        #expect(attributed[range].sense == .blindsight)

        range = try #require(attributed.range(of: "Darkvision"))
        #expect(attributed[range].creature.sense == creatureSense[0])
        #expect(attributed[range].sense == .darkvision)
    }

    @Test
    func `senses(case:) returns sorted list of lowercased names`() throws {
        let creatureSense: [Creature.Sense] = [
            .sense(.darkvision, range: 300, note: "(including magical darkness)"),
            .sense(.blindsight, range: 60),
        ]

        let formatter: Creature.Sense.ListFormatStyle<[Creature.Sense]> = .senses(case: .lowercased).locale(Self.locale)
        let description = formatter.format(creatureSense)
        #expect(description == "blindsight 60 ft., darkvision 300 ft. (including magical darkness)")

        let attributed = formatter.attributed.format(creatureSense)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "blindsight"))
        #expect(attributed[range].creature.sense == creatureSense[1])
        #expect(attributed[range].sense == .blindsight)

        range = try #require(attributed.range(of: "darkvision"))
        #expect(attributed[range].creature.sense == creatureSense[0])
        #expect(attributed[range].sense == .darkvision)
    }
}
