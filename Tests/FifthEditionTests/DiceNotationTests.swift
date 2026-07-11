//
//  DiceNotationTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct DieComparableTests {
    @Test(arguments: zip(Die.allCases, Die.allCases.dropFirst()))
    func `Die compares smaller by next`(a: Die, b: Die) {
        #expect(a < b)
    }
}

struct DieDescriptionTests {
    @Test(arguments: Die.allCases)
    func `description returns sides`(die: Die) {
        #expect(die.description == "d\(die.rawValue)")
    }
}

struct DieFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Die.allCases)
    func `die() formats die name with sides`(die: Die) {
        let formatter = Die.FormatStyle().locale(Self.locale)
        let description = formatter.format(die)
        #expect(description == "d\(die.rawValue.formatted(.number))")

        let attributed = formatter.attributed.format(die)
        #expect(String(attributed.characters) == description)
        #expect(attributed.die == die)
    }
}

struct DieRawRepresentableTests {
    static let expectedSides: [(Die, Int)] = [
        (.d1, 1),
        (.d2, 2),
        (.d3, 3),
        (.d4, 4),
        (.d6, 6),
        (.d8, 8),
        (.d12, 12),
        (.d20, 20),
        (.d100, 100),
    ]

    @Test(arguments: expectedSides)
    func `rawValue is number of sides`(die: Die, sides: Int) {
        #expect(die.rawValue == sides)
    }
}

struct DieRollableTests {
    static let expectedAverages: [(Die, Int)] = [
        (.d1, 1),
        (.d2, 1),
        (.d3, 2),
        (.d4, 2),
        (.d6, 3),
        (.d8, 4),
        (.d12, 6),
        (.d20, 10),
        (.d100, 50),
    ]

    @Test(arguments: expectedAverages)
    func `average has expected values`(die: Die, average: Int) {
        #expect(die.average == average)
    }

    @Test(arguments: Die.allCases)
    func `range is 1 to number of sides`(die: Die) {
        #expect(die.range == 1...die.rawValue)
    }

    @Test(arguments: Die.allCases)
    func `roll()`(die: Die) {
        for _ in 0..<100 {
            #expect(die.range.contains(die.roll()))
        }
    }

    struct CheatingRandomNumberGenerator: RandomNumberGenerator {
        mutating func next() -> UInt64 {
            UInt64.max
        }
    }

    @Test(arguments: Die.allCases)
    func `roll(using:)`(die: Die) {
        var generator = CheatingRandomNumberGenerator()
        #expect(die.roll(using: &generator) == die.rawValue)
    }
}

struct DiceDescriptionTests {
    @Test
    func `description returns count and die`() {
        let dice = Dice.die(.d6, count: 4)
        #expect(dice.description == "4d6")
    }

    @Test
    func `description returns negative count and die`() {
        let dice = Dice.die(.d6, count: -4)
        #expect(dice.description == "-4d6")
    }

    @Test
    func `description returns positive modifier without sign`() {
        let dice = Dice.modifier(10)
        #expect(dice.description == "10")
    }

    @Test
    func `description reutrns negative modifier with sign`() {
        let dice = Dice.modifier(-10)
        #expect(dice.description == "-10")
    }
}

struct DiceFormatStringTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `dice() formats count and die`() throws {
        let dice = Dice.die(.d6, count: 4)

        let formatter = Dice.FormatStyle().locale(Self.locale)
        let description = formatter.format(dice)
        #expect(description == "4d6")

        let attributed = formatter.attributed.format(dice)
        #expect(String(attributed.characters) == description)
        #expect(attributed.dice == dice)

        let range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)
    }

    @Test
    func `dice() formats negative count and die`() throws {
        let dice = Dice.die(.d6, count: -4)

        let formatter = Dice.FormatStyle().locale(Self.locale)
        let description = formatter.format(dice)
        #expect(description == "-4d6")

        let attributed = formatter.attributed.format(dice)
        #expect(String(attributed.characters) == description)
        #expect(attributed.dice == dice)

        let range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)
    }

    @Test
    func `dice() formats positive modifier`() {
        let dice = Dice.modifier(10)

        let formatter = Dice.FormatStyle().locale(Self.locale)
        let description = formatter.format(dice)
        #expect(description == "10")

        let attributed = formatter.attributed.format(dice)
        #expect(String(attributed.characters) == description)
        #expect(attributed.dice == dice)
    }

    @Test
    func `dice() formats negative modifier`() {
        let dice = Dice.modifier(-10)

        let formatter = Dice.FormatStyle().locale(Self.locale)
        let description = formatter.format(dice)
        #expect(description == "-10")

        let attributed = formatter.attributed.format(dice)
        #expect(String(attributed.characters) == description)
        #expect(attributed.dice == dice)
    }
}

struct DiceRollableTests {
    @Test(arguments: Die.allCases)
    func `average of single dice have expected values`(die: Die) {
        #expect(Dice.die(die, count: 1).average == die.average)
    }

    @Test(arguments: Die.allCases)
    func `average of two dice have expected values`(die: Die) {
        #expect(Dice.die(die, count: 2).average == die.rawValue + 1)
    }

    @Test(arguments: Die.allCases)
    func `average of negative dice have expected values`(die: Die) {
        #expect(Dice.die(die, count: -2).average == -(die.rawValue + 1))
    }

    @Test(arguments: Die.allCases)
    func `range of single dice have expected values`(die: Die) {
        #expect(Dice.die(die, count: 1).range == die.range)
    }

    @Test(arguments: Die.allCases)
    func `range of two dice have expected values`(die: Die) {
        #expect(Dice.die(die, count: 2).range == 2...(die.rawValue * 2))
    }

    @Test(arguments: Die.allCases)
    func `range of negative dice have expected values`(die: Die) {
        #expect(Dice.die(die, count: -2).range == (-die.rawValue * 2) ... -2)
    }

    @Test(arguments: Die.allCases)
    func `roll()`(die: Die) {
        for _ in 0..<100 {
            let dice = Dice.die(die, count: .random(in: 1...20))
            #expect(dice.range.contains(dice.roll()))
        }
    }

    @Test(arguments: Die.allCases)
    func `roll() with negative count`(die: Die) {
        for _ in 0..<100 {
            let dice = Dice.die(die, count: .random(in: -20 ... -1))
            #expect(dice.range.contains(dice.roll()))
        }
    }

    struct CheatingRandomNumberGenerator: RandomNumberGenerator {
        mutating func next() -> UInt64 {
            UInt64.max
        }
    }

    @Test(arguments: Die.allCases)
    func `roll(using:)`(die: Die) {
        var generator = CheatingRandomNumberGenerator()
        #expect(Dice.die(die, count: 2).roll(using: &generator) == die.rawValue * 2)
    }
}

struct DiceNotationCodableTests {
    @Test
    func `DiceNotation encoded format is string`() throws {
        try testCodable(
            json: """
            "4d6 + 10"
            """,
            value: DiceNotation(.d6, count: 4, modifier: 10),
        )
    }

    @Test
    func `DiceNotation throws error when formula not parseable`() throws {
        let json = """
        "coin toss"
        """
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(DiceNotation.self, from: #require(json.data(using: .utf8)))
        }
    }
}

struct DiceNotationDescriptionTests {
    @Test
    func `description returns die only`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
        ])
        #expect(diceNotation.description == "4d6")
    }

    @Test
    func `description returns die of negative count only`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: -4),
        ])
        #expect(diceNotation.description == "-4d6")
    }

    @Test
    func `description returns modifier only`() {
        let diceNotation = DiceNotation([
            .modifier(10),
        ])
        #expect(diceNotation.description == "10")
    }

    @Test
    func `description returns negative modifier only`() {
        let diceNotation = DiceNotation([
            .modifier(-10),
        ])
        #expect(diceNotation.description == "-10")
    }

    @Test
    func `description returns die and added modifier`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
        ])
        #expect(diceNotation.description == "4d6 + 10")
    }

    @Test
    func `description returns die and subtracted modifier`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(-10),
        ])
        #expect(diceNotation.description == "4d6 - 10")
    }

    @Test
    func `description returns die added`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
        #expect(diceNotation.description == "4d6 + 2d8")
    }

    @Test
    func `description returns die subtracted`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
        #expect(diceNotation.description == "4d6 - 2d8")
    }

    @Test
    func `description returns modifier added`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(6),
        ])
        #expect(diceNotation.description == "4d6 + 10 + 6")
    }

    @Test
    func `description returns modifier subtracted`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(-6),
        ])
        #expect(diceNotation.description == "4d6 + 10 - 6")
    }

    @Test
    func `description returns mixed dice and modifiers`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .die(.d8, count: -2),
            .modifier(-2),
        ])
        #expect(diceNotation.description == "4d6 + 10 - 2d8 - 2")
    }
}

struct DiceNotationFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `diceNotation() formats die only`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)
        #expect(attributed.dice == diceNotation.dice[0])

        let range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)
    }

    @Test
    func `diceNotation() formats die of negative count only`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: -4),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "-4d6")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)
        #expect(attributed.dice == diceNotation.dice[0])

        let range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)
    }

    @Test
    func `diceNotation() formats modifier only`() {
        let diceNotation = DiceNotation([
            .modifier(10),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "10")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)
        #expect(attributed.dice == diceNotation.dice[0])
    }

    @Test
    func `diceNotation() formats negative modifier only`() {
        let diceNotation = DiceNotation([
            .modifier(-10),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "-10")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)
        #expect(attributed.dice == diceNotation.dice[0])
    }

    @Test
    func `diceNotation() formats die and added modifier`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6 + 10")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)

        var range = try #require(attributed.range(of: "4d6"))
        #expect(attributed[range].dice == diceNotation.dice[0])

        range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)

        range = try #require(attributed.range(of: "10"))
        #expect(attributed[range].dice == diceNotation.dice[1])
    }

    @Test
    func `diceNotation() formats die and subtracted modifier`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(-10),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6 - 10")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)

        var range = try #require(attributed.range(of: "4d6"))
        #expect(attributed[range].dice == diceNotation.dice[0])

        range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)

        range = try #require(attributed.range(of: "10"))
        #expect(attributed[range].dice == diceNotation.dice[1])
    }

    @Test
    func `diceNotation() formats die added`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6 + 2d8")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)

        var range = try #require(attributed.range(of: "4d6"))
        #expect(attributed[range].dice == diceNotation.dice[0])

        range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)

        range = try #require(attributed.range(of: "2d8"))
        #expect(attributed[range].dice == diceNotation.dice[1])

        range = try #require(attributed.range(of: "d8"))
        #expect(attributed[range].die == .d8)
    }

    @Test
    func `diceNotation() formats die subtracted`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6 - 2d8")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)

        var range = try #require(attributed.range(of: "4d6"))
        #expect(attributed[range].dice == diceNotation.dice[0])

        range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)

        range = try #require(attributed.range(of: "2d8"))
        #expect(attributed[range].dice == diceNotation.dice[1])

        range = try #require(attributed.range(of: "d8"))
        #expect(attributed[range].die == .d8)
    }

    @Test
    func `diceNotation() formats modifier added`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(6),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6 + 10 + 6")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)

        var range = try #require(attributed.range(of: "4d6"))
        #expect(attributed[range].dice == diceNotation.dice[0])

        range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)

        range = try #require(attributed.range(of: "10"))
        #expect(attributed[range].dice == diceNotation.dice[1])

        range = try #require(attributed.range(of: "6", options: .backwards))
        #expect(attributed[range].dice == diceNotation.dice[2])
    }

    @Test
    func `diceNotation() formats modifier subtracted`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(-6),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6 + 10 - 6")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)

        var range = try #require(attributed.range(of: "4d6"))
        #expect(attributed[range].dice == diceNotation.dice[0])

        range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)

        range = try #require(attributed.range(of: "10"))
        #expect(attributed[range].dice == diceNotation.dice[1])

        range = try #require(attributed.range(of: "6", options: .backwards))
        #expect(attributed[range].dice == diceNotation.dice[2])
    }

    @Test
    func `diceNotation() formats mixed dice and modifiers`() throws {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .die(.d8, count: -2),
            .modifier(-2),
        ])

        let formatter = DiceNotation.FormatStyle().locale(Self.locale)
        let description = formatter.format(diceNotation)
        #expect(description == "4d6 + 10 - 2d8 - 2")

        let attributed = formatter.attributed.format(diceNotation)
        #expect(String(attributed.characters) == description)
        #expect(attributed.diceNotation == diceNotation)

        var range = try #require(attributed.range(of: "4d6"))
        #expect(attributed[range].dice == diceNotation.dice[0])

        range = try #require(attributed.range(of: "d6"))
        #expect(attributed[range].die == .d6)

        range = try #require(attributed.range(of: "10"))
        #expect(attributed[range].dice == diceNotation.dice[1])

        range = try #require(attributed.range(of: "2d8"))
        #expect(attributed[range].dice == diceNotation.dice[2])

        range = try #require(attributed.range(of: "d8"))
        #expect(attributed[range].die == .d8)

        range = try #require(attributed.range(of: "2", options: .backwards))
        #expect(attributed[range].dice == diceNotation.dice[3])
    }
}

struct DiceNotationInitTests {
    @Test
    func `init(_:) with dice list`() {
        let diceNotation = DiceNotation([
            .die(.d4, count: 4),
            .modifier(10),
        ])
        #expect(diceNotation.dice == [
            .die(.d4, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(arrayLiteral:) with dice list`() {
        let diceNotation: DiceNotation = [
            .die(.d4, count: 4),
            .modifier(10),
        ]
        #expect(diceNotation.dice == [
            .die(.d4, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with raw die`() {
        let diceNotation = DiceNotation(.d6)
        #expect(diceNotation.dice == [
            .die(.d6, count: 1),
        ])
    }

    @Test
    func `init(_:count:)`() {
        let diceNotation = DiceNotation(.d6, count: 4)
        #expect(diceNotation.dice == [
            .die(.d6, count: 4),
        ])
    }

    @Test
    func `init(_:count:modifier:)`() {
        let diceNotation = DiceNotation(.d6, count: 4, modifier: 10)
        #expect(diceNotation.dice == [
            .die(.d6, count: 4),
            .modifier(10),
        ])
    }
}

struct DiceNotationInitStringTests {
    @Test
    func `init(string:) with count and die`() {
        let diceNotation = DiceNotation(string: "4d6")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
        ])
    }

    @Test
    func `init(string:) with negative die count`() {
        let diceNotation = DiceNotation(string: "- 2d8")
        #expect(diceNotation?.dice == [
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(string:) with negative die count and no spaces`() {
        let diceNotation = DiceNotation(string: "-2d8")
        #expect(diceNotation?.dice == [
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(string:) with positive die count`() {
        let diceNotation = DiceNotation(string: "+ 3d12")
        #expect(diceNotation?.dice == [
            .die(.d12, count: 3),
        ])
    }

    @Test
    func `init(string:) with positive die count and no spaces`() {
        let diceNotation = DiceNotation(string: "+3d12")
        #expect(diceNotation?.dice == [
            .die(.d12, count: 3),
        ])
    }

    @Test
    func `init(string:) with die only`() {
        let diceNotation = DiceNotation(string: "d10")
        #expect(diceNotation?.dice == [
            .die(.d10, count: 1),
        ])
    }

    @Test(arguments: Die.allCases)
    func `init(string:) with each die`(die: Die) {
        let count: Int = .random(in: 1...20)
        let diceNotation = DiceNotation(string: "\(count)\(die)")
        #expect(diceNotation?.dice == [
            .die(die, count: count),
        ])
    }

    @Test
    func `init(string:) with modifier only`() {
        let diceNotation = DiceNotation(string: "10")
        #expect(diceNotation?.dice == [
            .modifier(10),
        ])
    }

    @Test
    func `init(string:) with negative modifier only`() {
        let diceNotation = DiceNotation(string: "- 10")
        #expect(diceNotation?.dice == [
            .modifier(-10),
        ])
    }

    @Test
    func `init(string:) with negative modifier and no spaces only`() {
        let diceNotation = DiceNotation(string: "-10")
        #expect(diceNotation?.dice == [
            .modifier(-10),
        ])
    }

    @Test
    func `init(string:) with positive modifier only`() {
        let diceNotation = DiceNotation(string: "+ 10")
        #expect(diceNotation?.dice == [
            .modifier(10),
        ])
    }

    @Test
    func `init(string:) with positive modifier and no spaces only`() {
        let diceNotation = DiceNotation(string: "+ 10")
        #expect(diceNotation?.dice == [
            .modifier(10),
        ])
    }

    @Test
    func `init(string:) with die and modifier`() {
        let diceNotation = DiceNotation(string: "4d6 + 10")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(string:) with die and modifier without spaces`() {
        let diceNotation = DiceNotation(string: "4d6+10")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(string:) with die and negative modifier`() {
        let diceNotation = DiceNotation(string: "4d6 - 10")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(string:) with die and negative modifier without spaces`() {
        let diceNotation = DiceNotation(string: "4d6-10")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(string:) with die and negative modifier using figure dash`() {
        let diceNotation = DiceNotation(string: "4d6 \u{2012} 10")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(string:) with die and negative modifier using minus sign`() {
        let diceNotation = DiceNotation(string: "4d6 \u{2212} 10")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(string:) with die added`() {
        let diceNotation = DiceNotation(string: "4d6 + 2d8")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
    }

    @Test
    func `init(string:) with die added without spaces`() {
        let diceNotation = DiceNotation(string: "4d6+2d8")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
    }

    @Test
    func `init(string:) with die subtracted`() {
        let diceNotation = DiceNotation(string: "4d6 - 2d8")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(string:) with die subtracted without spaces`() {
        let diceNotation = DiceNotation(string: "4d6-2d8")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(string:) with die subtracted using figure dash`() {
        let diceNotation = DiceNotation(string: "4d6 \u{2012} 2d8")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(string:) with die subtracted using minus sign`() {
        let diceNotation = DiceNotation(string: "4d6 \u{2212} 2d8")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(string:) with modifier added`() {
        let diceNotation = DiceNotation(string: "4d6 + 10 + 6")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(6),
        ])
    }

    @Test
    func `init(string:) with modifier subtracted`() {
        let diceNotation = DiceNotation(string: "4d6 + 10 - 6")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(-6),
        ])
    }

    @Test
    func `init(string:) with mixed dice and modifiers`() {
        let diceNotation = DiceNotation(string: "4d6 + 10 - 2d8 - 2")
        #expect(diceNotation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
            .die(.d8, count: -2),
            .modifier(-2),
        ])
    }

    @Test
    func `init(stringLiteral:) parses string as dice diceNotation`() {
        let diceNotation: DiceNotation = "4d6 + 10"
        #expect(diceNotation.dice == [
            .die(.d6, count: 4),
            .modifier(10),
        ])
    }
}

struct DiceNotationRollableTests {
    @Test
    func `average is die average`() {
        let dice = Dice.die(.d6, count: 2)
        let diceNotation = DiceNotation([dice])
        #expect(diceNotation.average == dice.average)
    }

    @Test
    func `average is negative die average`() {
        let dice = Dice.die(.d6, count: -2)
        let diceNotation = DiceNotation([dice])
        #expect(diceNotation.average == dice.average)
    }

    @Test
    func `average is modifier value`() {
        let diceNotation = DiceNotation([.modifier(10)])
        #expect(diceNotation.average == 10)
    }

    @Test
    func `average is negative modifier value`() {
        let diceNotation = DiceNotation([.modifier(-10)])
        #expect(diceNotation.average == -10)
    }

    @Test
    func `average is sum of dice averages`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ]
        let diceNotation = DiceNotation(dice)
        #expect(diceNotation.average == dice[0].average + dice[1].average)
    }

    @Test
    func `average subtracts die with negative count`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ]
        let diceNotation = DiceNotation(dice)
        #expect(diceNotation.average == dice[0].average + dice[1].average)
    }

    @Test
    func `average is sum of modifiers`() {
        let diceNotation = DiceNotation([
            .modifier(10),
            .modifier(6),
        ])
        #expect(diceNotation.average == 16)
    }

    @Test
    func `average subtracts negative modifier`() {
        let diceNotation = DiceNotation([
            .modifier(10),
            .modifier(-6),
        ])
        #expect(diceNotation.average == 4)
    }

    @Test
    func `average is sum of die and modifier`() {
        let dice = Dice.die(.d6, count: 2)
        let diceNotation = DiceNotation([dice, .modifier(10)])
        #expect(diceNotation.average == dice.average + 10)
    }

    @Test
    func `range is die range`() {
        let dice = Dice.die(.d6, count: 2)
        let diceNotation = DiceNotation([dice])
        #expect(diceNotation.range == dice.range)
    }

    @Test
    func `range is negative die range`() {
        let dice = Dice.die(.d6, count: -2)
        let diceNotation = DiceNotation([dice])
        #expect(diceNotation.range == dice.range)
    }

    @Test
    func `range is modifier value`() {
        let diceNotation = DiceNotation([.modifier(10)])
        #expect(diceNotation.range == 10...10)
    }

    @Test
    func `range is negative modifier value`() {
        let diceNotation = DiceNotation([.modifier(-10)])
        #expect(diceNotation.range == -10 ... -10)
    }

    @Test
    func `range is sum of dice ranges`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ]
        let diceNotation = DiceNotation(dice)
        #expect(diceNotation.range ==
            (dice[0].range.lowerBound + dice[1].range.lowerBound)
            ... (dice[0].range.upperBound + dice[1].range.upperBound))
    }

    @Test
    func `range subtracts die with negative count`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ]
        let diceNotation = DiceNotation(dice)
        #expect(diceNotation.range ==
            (dice[0].range.lowerBound + dice[1].range.lowerBound)
            ... (dice[0].range.upperBound + dice[1].range.upperBound))
    }

    @Test
    func `range is sum of modifiers`() {
        let diceNotation = DiceNotation([
            .modifier(10),
            .modifier(6),
        ])
        #expect(diceNotation.range == 16...16)
    }

    @Test
    func `range subtracts negative modifier`() {
        let diceNotation = DiceNotation([
            .modifier(10),
            .modifier(-6),
        ])
        #expect(diceNotation.range == 4...4)
    }

    @Test
    func `range is sum of die and modifier`() {
        let dice = Dice.die(.d6, count: 2)
        let diceNotation = DiceNotation([dice, .modifier(10)])
        #expect(diceNotation.range == (dice.range.lowerBound + 10)...(dice.range.upperBound + 10))
    }

    @Test(arguments: Die.allCases)
    func `roll()`(die: Die) {
        for _ in 0..<100 {
            let diceNotation = DiceNotation([
                .die(die, count: .random(in: 1...20)),
                .modifier(.random(in: 1...20)),
            ])
            #expect(diceNotation.range.contains(diceNotation.roll()))
        }
    }

    @Test(arguments: Die.allCases)
    func `roll() with negative count`(die: Die) {
        for _ in 0..<100 {
            let diceNotation = DiceNotation([
                .die(die, count: .random(in: -20 ... -1)),
                .modifier(.random(in: 1...20)),
            ])
            #expect(diceNotation.range.contains(diceNotation.roll()))
        }
    }

    @Test(arguments: Die.allCases)
    func `roll() with negative modifier`(die: Die) {
        for _ in 0..<100 {
            let diceNotation = DiceNotation([
                .die(die, count: .random(in: 1...20)),
                .modifier(.random(in: -20 ... -1)),
            ])
            #expect(diceNotation.range.contains(diceNotation.roll()))
        }
    }

    @Test
    func `roll() with die added`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
        #expect(diceNotation.range.contains(diceNotation.roll()))
    }

    @Test
    func `roll() with die subtracted`() {
        let diceNotation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
        #expect(diceNotation.range.contains(diceNotation.roll()))
    }

    struct CheatingRandomNumberGenerator: RandomNumberGenerator {
        mutating func next() -> UInt64 {
            UInt64.max
        }
    }

    @Test(arguments: Die.allCases)
    func `roll(using:)`(die: Die) {
        var generator = CheatingRandomNumberGenerator()
        let diceNotation = DiceNotation([
            .die(die, count: 2),
            .modifier(4),
        ])
        #expect(diceNotation.roll(using: &generator) == die.rawValue * 2 + 4)
    }
}
