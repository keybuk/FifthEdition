//
//  DiceNotationTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Testing
@testable import FifthEdition

struct DiceNotationTests {
    static let testStrings: [String] = [
        "4d1",
        "3d2",
        "1d3 + 1",
        "2d4 - 1",
        "1d6 + 2",
        "3d8 - 1",
        "4d10 + 10",
        "1d12 - 2",
        "2d20 - 4",
        "1d100",
    ]
    static let testValues: [(Int, Die, Int)] = [
        (4, .d1, 0), // 4d1
        (3, .d2, 0), // 3d2
        (1, .d3, 1), // 1d3 + 1
        (2, .d4, -1), // 2d4 - 1
        (1, .d6, 2), // 1d6 + 2
        (3, .d8, -1), // 3d8 - 1
        (4, .d10, 10), // 4d10 + 10
        (1, .d12, -2), // 1d12-2
        (2, .d20, -4), // 2d20 - 4
        (1, .d100, 0), // 1d100
    ]
    static let testAverages: [Int] = [
        4, // 4d1
        4, // 3d2
        3, // 1d3 + 1
        4, // 2d4 - 1
        5, // 1d6 + 2
        12, // 3d8 - 1
        32, // 4d10 + 10
        4, // 1d12-2
        17, // 2d20 - 4
        50, // 1d100
    ]
    static let testRanges: [ClosedRange<Int>] = [
        4 ... 4, // 4d1
        3 ... 6, // 3d2
        2 ... 4, // 1d3 + 1
        1 ... 7, // 2d4 - 1
        3 ... 8, // 1d6 + 2
        2 ... 23, // 3d8 - 1
        14 ... 50, // 4d10 + 10
        -1 ... 10, // 1d12-2
        -2 ... 36, // 2d20 - 4
        1 ... 100, // 1d100
    ]

    @Test("Parsing", arguments: zip(testStrings, testValues))
    func initFromString(_ string: String, expected: (count: Int, die: Die, modifier: Int)) throws {
        let dice = try #require(DiceNotation(string),
                                "Failed to parse expression: \(string)")
        #expect(dice.count == expected.count)
        #expect(dice.die == expected.die)
        #expect(dice.modifier == expected.modifier)
    }

    @Test("Direct initialization", arguments: testValues)
    func average(_ input: (count: Int, die: Die, modifier: Int)) {
        let dice = DiceNotation(count: input.count, die: input.die, modifier: input.modifier)
        #expect(dice.count == input.count)
        #expect(dice.die == input.die)
        #expect(dice.modifier == input.modifier)
    }

    @Test("Average", arguments: zip(testValues, testAverages))
    func average(_ input: (count: Int, die: Die, modifier: Int), expected: Int) {
        let dice = DiceNotation(count: input.count, die: input.die, modifier: input.modifier)
        #expect(dice.average == expected)
    }

    @Test("Range", arguments: zip(testValues, testRanges))
    func range(_ input: (count: Int, die: Die, modifier: Int), expected: ClosedRange<Int>) {
        let dice = DiceNotation(count: input.count, die: input.die, modifier: input.modifier)
        #expect(dice.range == expected)
    }

    @Test("String value", arguments: zip(testValues, testStrings))
    func stringValues(_ input: (count: Int, die: Die, modifier: Int), expected: String) {
        let dice = DiceNotation(count: input.count, die: input.die, modifier: input.modifier)
        #expect(dice.stringValue == expected)
    }

    @Test("Roll", arguments: testValues)
    func roll(_ input: (count: Int, die: Die, modifier: Int)) {
        let dice = DiceNotation(count: input.count, die: input.die, modifier: input.modifier)
        for _ in 0 ..< 100 {
            #expect(dice.range.contains(dice.roll()))
        }
    }

    struct CheatingRandomNumberGenerator: RandomNumberGenerator {
        mutating func next() -> UInt64 {
            UInt64.max
        }
    }

    @Test("Roll using a given generator", arguments: testValues)
    func rollUsing(_ input: (count: Int, die: Die, modifier: Int)) {
        var generator = CheatingRandomNumberGenerator()

        let dice = DiceNotation(count: input.count, die: input.die, modifier: input.modifier)
        let roll = dice.roll(using: &generator)
        #expect(roll == dice.range.upperBound)
    }

    @Test("Parsing allows missing count")
    func stringWithoutCount() throws {
        let dice = try #require(DiceNotation("d6 + 3"),
                                "Failed to parse expression")
        #expect(dice.count == 1)
        #expect(dice.die == .d6)
        #expect(dice.modifier == 3)
    }

    @Test("Parsing allows missing modifier")
    func stringWithoutModifier() throws {
        let dice = try #require(DiceNotation("2d6 + 3"),
                                "Failed to parse expression")
        #expect(dice.count == 2)
        #expect(dice.die == .d6)
        #expect(dice.modifier == 3)
    }

    @Test("Parsing allows missing spaces before modifier")
    func stringMissingSpaceBeforeModifier() throws {
        let dice = try #require(DiceNotation("2d6+ 3"),
                                "Failed to parse expression")
        #expect(dice.count == 2)
        #expect(dice.die == .d6)
        #expect(dice.modifier == 3)
    }

    @Test("Parsing allows missing spaces after modifier")
    func stringMissingSpaceAfterModifier() throws {
        let dice = try #require(DiceNotation("2d6 +3"),
                                "Failed to parse expression")
        #expect(dice.count == 2)
        #expect(dice.die == .d6)
        #expect(dice.modifier == 3)
    }

    @Test("Parsing allows missing spaces around modifier")
    func stringMissingSpaceAroundModifier() throws {
        let dice = try #require(DiceNotation("2d6+3"),
                                "Failed to parse expression")
        #expect(dice.count == 2)
        #expect(dice.die == .d6)
        #expect(dice.modifier == 3)
    }

    @Test("Parsing returns nil for empty string")
    func emptyString() {
        #expect(DiceNotation("") == nil)
    }

    @Test("Parsing returns nil for invalid string")
    func invalidString() {
        #expect(DiceNotation("invalid") == nil)
    }

    @Test("Parsing returns nil for solitary number")
    func numberOnly() {
        #expect(DiceNotation("20") == nil)
    }

    @Test("Parsing returns nil for unknown die")
    func unknownDie() {
        #expect(DiceNotation("d11") == nil)
    }

    @Test("Parsing returns nil for missing sign")
    func missingSign() {
        #expect(DiceNotation("2d6 3") == nil)
    }
}
