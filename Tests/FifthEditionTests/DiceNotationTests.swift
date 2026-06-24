//
//  DiceNotationTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct DieTests {
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

    @Test(arguments: expectedSides)
    func `rawValue is number of sides`(die: Die, sides: Int) {
        #expect(die.rawValue == sides)
    }

    @Test(arguments: zip(Die.allCases, Die.allCases.dropFirst()))
    func `Die is comparable`(a: Die, b: Die) {
        #expect(a < b)
    }

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

    @Test(arguments: Die.allCases)
    func `description is the die name`(die: Die) {
        #expect(die.description == "d\(die.rawValue.formatted(.number))")
    }
}

struct DiceTests {
    @Test
    func `description is count and die`() {
        let dice = Dice.die(.d6, count: 4)
        #expect(dice.description == "4d6")
    }

    @Test
    func `description of negative count and die`() {
        let dice = Dice.die(.d6, count: -4)
        #expect(dice.description == "-4d6")
    }

    @Test
    func `description of positive modifier`() {
        let dice = Dice.modifier(10)
        #expect(dice.description == "10")
    }

    @Test
    func `description of negative modifier`() {
        let dice = Dice.modifier(-10)
        #expect(dice.description == "-10")
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
    func `init(from:) throws error when decoding unparseable format`() throws {
        let json = """
        "NOT VALID"
        """
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(DiceNotation.self, from: #require(json.data(using: .utf8)))
        }
    }
}

struct DiceNotationInitTests {
    @Test
    func `init(_:) with dice list`() {
        let notation = DiceNotation([
            .die(.d4, count: 4),
            .modifier(10),
        ])
        #expect(notation.dice == [
            .die(.d4, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(arrayLiteral:) with dice list`() {
        let notation: DiceNotation = [
            .die(.d4, count: 4),
            .modifier(10),
        ]
        #expect(notation.dice == [
            .die(.d4, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with raw die`() {
        let notation = DiceNotation(.d6)
        #expect(notation.dice == [
            .die(.d6, count: 1),
        ])
    }

    @Test
    func `init(_:count:)`() {
        let notation = DiceNotation(.d6, count: 4)
        #expect(notation.dice == [
            .die(.d6, count: 4),
        ])
    }

    @Test
    func `init(_:count:modifier:)`() {
        let notation = DiceNotation(.d6, count: 4, modifier: 10)
        #expect(notation.dice == [
            .die(.d6, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with count and die`() {
        let notation = DiceNotation("4d6")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
        ])
    }

    @Test
    func `init(_:) with negative die count`() {
        let notation = DiceNotation("- 2d8")
        #expect(notation?.dice == [
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(_:) with negative die count and no spaces`() {
        let notation = DiceNotation("-2d8")
        #expect(notation?.dice == [
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(_:) with positive die count`() {
        let notation = DiceNotation("+ 3d12")
        #expect(notation?.dice == [
            .die(.d12, count: 3),
        ])
    }

    @Test
    func `init(_:) with positive die count and no spaces`() {
        let notation = DiceNotation("+3d12")
        #expect(notation?.dice == [
            .die(.d12, count: 3),
        ])
    }

    @Test
    func `init(_:) with die only`() {
        let notation = DiceNotation("d10")
        #expect(notation?.dice == [
            .die(.d10, count: 1),
        ])
    }

    @Test(arguments: Die.allCases)
    func `init(_:) with each die`(die: Die) {
        let count: Int = .random(in: 1...20)
        let notation = DiceNotation("\(count)\(die)")
        #expect(notation?.dice == [
            .die(die, count: count),
        ])
    }

    @Test
    func `init(_:) with modifier only`() {
        let notation = DiceNotation("10")
        #expect(notation?.dice == [
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with negative modifier only`() {
        let notation = DiceNotation("- 10")
        #expect(notation?.dice == [
            .modifier(-10),
        ])
    }

    @Test
    func `init(_:) with negative modifier and no spaces only`() {
        let notation = DiceNotation("-10")
        #expect(notation?.dice == [
            .modifier(-10),
        ])
    }

    @Test
    func `init(_:) with positive modifier only`() {
        let notation = DiceNotation("+ 10")
        #expect(notation?.dice == [
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with positive modifier and no spaces only`() {
        let notation = DiceNotation("+ 10")
        #expect(notation?.dice == [
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with die and modifier`() {
        let notation = DiceNotation("4d6 + 10")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with die and modifier without spaces`() {
        let notation = DiceNotation("4d6+10")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
        ])
    }

    @Test
    func `init(_:) with die and negative modifier`() {
        let notation = DiceNotation("4d6 - 10")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(_:) with die and negative modifier without spaces`() {
        let notation = DiceNotation("4d6-10")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(_:) with die and negative modifier using figure dash`() {
        let notation = DiceNotation("4d6 \u{2012} 10")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(_:) with die and negative modifier using minus sign`() {
        let notation = DiceNotation("4d6 \u{2212} 10")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(-10),
        ])
    }

    @Test
    func `init(_:) with die added`() {
        let notation = DiceNotation("4d6 + 2d8")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
    }

    @Test
    func `init(_:) with die added without spaces`() {
        let notation = DiceNotation("4d6+2d8")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
    }

    @Test
    func `init(_:) with die subtracted`() {
        let notation = DiceNotation("4d6 - 2d8")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(_:) with die subtracted without spaces`() {
        let notation = DiceNotation("4d6-2d8")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(_:) with die subtracted using figure dash`() {
        let notation = DiceNotation("4d6 \u{2012} 2d8")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(_:) with die subtracted using minus sign`() {
        let notation = DiceNotation("4d6 \u{2212} 2d8")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
    }

    @Test
    func `init(_:) with modifier added`() {
        let notation = DiceNotation("4d6 + 10 + 6")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(6),
        ])
    }

    @Test
    func `init(_:) with modifier subtracted`() {
        let notation = DiceNotation("4d6 + 10 - 6")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(-6),
        ])
    }

    @Test
    func `init(_:) with mixed dice and modifiers`() {
        let notation = DiceNotation("4d6 + 10 - 2d8 - 2")
        #expect(notation?.dice == [
            .die(.d6, count: 4),
            .modifier(10),
            .die(.d8, count: -2),
            .modifier(-2),
        ])
    }
}

struct DiceNotationRollableTests {
    @Test
    func `average is die average`() {
        let dice = Dice.die(.d6, count: 2)
        let notation = DiceNotation([dice])
        #expect(notation.average == dice.average)
    }

    @Test
    func `average is negative die average`() {
        let dice = Dice.die(.d6, count: -2)
        let notation = DiceNotation([dice])
        #expect(notation.average == dice.average)
    }

    @Test
    func `average is modifier value`() {
        let notation = DiceNotation([.modifier(10)])
        #expect(notation.average == 10)
    }

    @Test
    func `average is negative modifier value`() {
        let notation = DiceNotation([.modifier(-10)])
        #expect(notation.average == -10)
    }

    @Test
    func `average is sum of dice averages`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ]
        let notation = DiceNotation(dice)
        #expect(notation.average == dice[0].average + dice[1].average)
    }

    @Test
    func `average subtracts die with negative count`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ]
        let notation = DiceNotation(dice)
        #expect(notation.average == dice[0].average + dice[1].average)
    }

    @Test
    func `average is sum of modifiers`() {
        let notation = DiceNotation([
            .modifier(10),
            .modifier(6),
        ])
        #expect(notation.average == 16)
    }

    @Test
    func `average subtracts negative modifier`() {
        let notation = DiceNotation([
            .modifier(10),
            .modifier(-6),
        ])
        #expect(notation.average == 4)
    }

    @Test
    func `average is sum of die and modifier`() {
        let dice = Dice.die(.d6, count: 2)
        let notation = DiceNotation([dice, .modifier(10)])
        #expect(notation.average == dice.average + 10)
    }

    @Test
    func `range is die range`() {
        let dice = Dice.die(.d6, count: 2)
        let notation = DiceNotation([dice])
        #expect(notation.range == dice.range)
    }

    @Test
    func `range is negative die range`() {
        let dice = Dice.die(.d6, count: -2)
        let notation = DiceNotation([dice])
        #expect(notation.range == dice.range)
    }

    @Test
    func `range is modifier value`() {
        let notation = DiceNotation([.modifier(10)])
        #expect(notation.range == 10...10)
    }

    @Test
    func `range is negative modifier value`() {
        let notation = DiceNotation([.modifier(-10)])
        #expect(notation.range == -10 ... -10)
    }

    @Test
    func `range is sum of dice ranges`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ]
        let notation = DiceNotation(dice)
        #expect(notation.range ==
            (dice[0].range.lowerBound + dice[1].range.lowerBound)
            ... (dice[0].range.upperBound + dice[1].range.upperBound))
    }

    @Test
    func `range subtracts die with negative count`() {
        let dice: [Dice] = [
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ]
        let notation = DiceNotation(dice)
        #expect(notation.range ==
            (dice[0].range.lowerBound + dice[1].range.lowerBound)
            ... (dice[0].range.upperBound + dice[1].range.upperBound))
    }

    @Test
    func `range is sum of modifiers`() {
        let notation = DiceNotation([
            .modifier(10),
            .modifier(6),
        ])
        #expect(notation.range == 16...16)
    }

    @Test
    func `range subtracts negative modifier`() {
        let notation = DiceNotation([
            .modifier(10),
            .modifier(-6),
        ])
        #expect(notation.range == 4...4)
    }

    @Test
    func `range is sum of die and modifier`() {
        let dice = Dice.die(.d6, count: 2)
        let notation = DiceNotation([dice, .modifier(10)])
        #expect(notation.range == (dice.range.lowerBound + 10)...(dice.range.upperBound + 10))
    }

    @Test(arguments: Die.allCases)
    func `roll()`(die: Die) {
        for _ in 0..<100 {
            let notation = DiceNotation([
                .die(die, count: .random(in: 1...20)),
                .modifier(.random(in: 1...20)),
            ])
            #expect(notation.range.contains(notation.roll()))
        }
    }

    @Test(arguments: Die.allCases)
    func `roll() with negative count`(die: Die) {
        for _ in 0..<100 {
            let notation = DiceNotation([
                .die(die, count: .random(in: -20 ... -1)),
                .modifier(.random(in: 1...20)),
            ])
            #expect(notation.range.contains(notation.roll()))
        }
    }

    @Test(arguments: Die.allCases)
    func `roll() with negative modifier`(die: Die) {
        for _ in 0..<100 {
            let notation = DiceNotation([
                .die(die, count: .random(in: 1...20)),
                .modifier(.random(in: -20 ... -1)),
            ])
            #expect(notation.range.contains(notation.roll()))
        }
    }

    @Test
    func `roll() with die added`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
        #expect(notation.range.contains(notation.roll()))
    }

    @Test
    func `roll() with die subtracted`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
        #expect(notation.range.contains(notation.roll()))
    }

    struct CheatingRandomNumberGenerator: RandomNumberGenerator {
        mutating func next() -> UInt64 {
            UInt64.max
        }
    }

    @Test(arguments: Die.allCases)
    func `roll(using:)`(die: Die) {
        var generator = CheatingRandomNumberGenerator()
        let notation = DiceNotation([
            .die(die, count: 2),
            .modifier(4),
        ])
        #expect(notation.roll(using: &generator) == die.rawValue * 2 + 4)
    }
}

struct DiceNotationStringTests {
    @Test
    func `description with die only`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
        ])
        #expect(notation.description == "4d6")
    }

    @Test
    func `description with die of negative count only`() {
        let notation = DiceNotation([
            .die(.d6, count: -4),
        ])
        #expect(notation.description == "-4d6")
    }

    @Test
    func `description with modifier only`() {
        let notation = DiceNotation([
            .modifier(10),
        ])
        #expect(notation.description == "10")
    }

    @Test
    func `description with negative modifier only`() {
        let notation = DiceNotation([
            .modifier(-10),
        ])
        #expect(notation.description == "-10")
    }

    @Test
    func `description with die and added modifier`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
        ])
        #expect(notation.description == "4d6 + 10")
    }

    @Test
    func `description with die and subtracted`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(-10),
        ])
        #expect(notation.description == "4d6 - 10")
    }

    @Test
    func `description with die added`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: 2),
        ])
        #expect(notation.description == "4d6 + 2d8")
    }

    @Test
    func `description with die subtracted`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .die(.d8, count: -2),
        ])
        #expect(notation.description == "4d6 - 2d8")
    }

    @Test
    func `description with modifier added`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(6),
        ])
        #expect(notation.description == "4d6 + 10 + 6")
    }

    @Test
    func `description with modifier subtracted`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .modifier(-6),
        ])
        #expect(notation.description == "4d6 + 10 - 6")
    }

    @Test
    func `description with mixed dice and modifiers`() {
        let notation = DiceNotation([
            .die(.d6, count: 4),
            .modifier(10),
            .die(.d8, count: -2),
            .modifier(-2),
        ])
        #expect(notation.description == "4d6 + 10 - 2d8 - 2")
    }
}
