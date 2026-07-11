//
//  StatsTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/12/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct ArmorClassCodableTests {
    @Test
    func `Armor class encodes as array`() throws {
        try testCodable(
            json: """
            [
                15
            ]
            """,
            value: [
                ArmorClass.ac(15),
            ],
        )
    }

    @Test
    func `Armor class encodes from`() throws {
        try testCodable(
            json: """
            [
                {
                    "ac": 16,
                    "from": [
                        "natural armor"
                    ]
                }
            ]
            """,
            value: [
                ArmorClass.ac(16, from: ["natural armor"]),
            ],
        )
    }

    @Test
    func `Armor class encodes condition`() throws {
        try testCodable(
            json: """
            [
                13,
                {
                    "ac": 17,
                    "condition": "with mage armor",
                    "braces": true
                }
            ]
            """,
            value: [
                ArmorClass.ac(13),
                ArmorClass.ac(17,
                              condition: "with mage armor",
                              inParens: true),
            ],
        )
    }

    @Test
    func `Armor class encodes special`() throws {
        try testCodable(
            json: """
            [
                {
                    "special": "12 + your Intelligence modifier"
                }
            ]
            """,
            value: [
                ArmorClass.special("12 + your Intelligence modifier"),
            ],
        )
    }
}

struct ArmorClassComparableTests {
    @Test
    func `ac(:_) compare by value`() {
        #expect(ArmorClass.ac(11) < ArmorClass.ac(12))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(ArmorClass.special("a") < ArmorClass.special("b"))
    }

    @Test
    func `ac(:_) compares less than special(:_)`() {
        #expect(ArmorClass.ac(11) < ArmorClass.special("12"))
    }
}

struct ArmorClassFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `armorClass() formats ac`() {
        let armorClass = ArmorClass.ac(11)

        let formatter = ArmorClass.FormatStyle().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "11")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)
        #expect(attributed.armorClass == armorClass)
    }

    @Test
    func `armorClass() formats from in parens`() {
        let armorClass = ArmorClass.ac(11, from: ["natural armor"])

        let formatter = ArmorClass.FormatStyle().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "11 (natural armor)")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)
        #expect(attributed.armorClass == armorClass)
    }

    @Test
    func `armorClass() formats multiple from in list`() {
        let armorClass = ArmorClass.ac(11, from: ["natural armor", "leather armor"])

        let formatter = ArmorClass.FormatStyle().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "11 (natural armor, leather armor)")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)
        #expect(attributed.armorClass == armorClass)
    }

    @Test
    func `armorClass() formats condition in parens`() {
        let armorClass = ArmorClass.ac(11, condition: "with mage armor", inParens: true)

        let formatter = ArmorClass.FormatStyle().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "(11 with mage armor)")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)
        #expect(attributed.armorClass == armorClass)
    }

    @Test
    func `armorClass() formats condition without parens`() {
        let armorClass = ArmorClass.ac(11, condition: "plus 1 for each coven member")

        let formatter = ArmorClass.FormatStyle().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "11 plus 1 for each coven member")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)
        #expect(attributed.armorClass == armorClass)
    }

    @Test
    func `armorClass() formats from and condition`() {
        let armorClass = ArmorClass.ac(11, from: ["natural armor"], condition: "plus 1 for each coven member")

        let formatter = ArmorClass.FormatStyle().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "11 (natural armor) plus 1 for each coven member")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)
        #expect(attributed.armorClass == armorClass)
    }

    @Test
    func `armorClass() formats special`() {
        let armorClass = ArmorClass.special("11 + the spell's level")

        let formatter = ArmorClass.FormatStyle().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "11 + the spell's level")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)
        #expect(attributed.armorClass == armorClass)
    }
}

struct ArmorClassInitTests {
    @Test
    func `init(integerLiteral:) sets ac`() {
        let armorClass: ArmorClass = 14
        #expect(armorClass == .ac(14))
    }

    @Test
    func `init(stringLiteral:) sets special`() {
        let armorClass: ArmorClass = "11 + the spell's level"
        #expect(armorClass == .special("11 + the spell's level"))
    }
}

struct ArmorClassListFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `armorClasses() formats list of armor class`() throws {
        let armorClass: [ArmorClass] = [
            .ac(11),
            .ac(12, condition: "in bear form"),
        ]

        let formatter: ArmorClass.ListFormatStyle<[ArmorClass]> = .armorClasses().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "11, 12 in bear form")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "11"))
        #expect(attributed[range].armorClass == armorClass[0])

        range = try #require(attributed.range(of: "12 in bear form"))
        #expect(attributed[range].armorClass == armorClass[1])
    }

    @Test
    func `armorClasses() formats braces part without comma`() throws {
        let armorClass: [ArmorClass] = [
            .ac(12),
            .ac(14, condition: "with mage armor", inParens: true),
        ]

        let formatter: ArmorClass.ListFormatStyle<[ArmorClass]> = .armorClasses().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "12 (14 with mage armor)")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "12"))
        #expect(attributed[range].armorClass == armorClass[0])

        range = try #require(attributed.range(of: "14 with mage armor"))
        #expect(attributed[range].armorClass == armorClass[1])
    }

    @Test
    func `armorClasses() formats consecutive braces joined`() throws {
        let armorClass: [ArmorClass] = [
            .ac(12, from: ["natural armor"]),
            .ac(14, condition: "with mage armor", inParens: true),
        ]

        let formatter: ArmorClass.ListFormatStyle<[ArmorClass]> = .armorClasses().locale(Self.locale)
        let description = formatter.format(armorClass)
        #expect(description == "12 (natural armor; 14 with mage armor)")

        let attributed = formatter.attributed.format(armorClass)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "12"))
        #expect(attributed[range].armorClass == armorClass[0])

        range = try #require(attributed.range(of: "14 with mage armor"))
        #expect(attributed[range].armorClass == armorClass[1])
    }
}

struct HitPointsCodableTests {
    @Test
    func `Hit points encodes formula and calculated average`() throws {
        try testCodable(
            json: """
            {
                "formula": "2d8 + 3",
                "average": 12
            }
            """,
            value: HitPoints.hp(DiceNotation(.d8, count: 2, modifier: 3)),
        )
    }

    @Test
    func `Hit points encodes different average`() throws {
        try testCodable(
            json: """
            {
                "formula": "2d8 + 3",
                "average": 14
            }
            """,
            value: HitPoints.hp(DiceNotation(.d8, count: 2, modifier: 3), given: 14),
        )
    }

    @Test
    func `Hit points encodes unparseable notation as other`() throws {
        try testCodable(
            json: """
            {
                "formula": "coin toss",
                "average": 50
            }
            """,
            value: HitPoints.other(50, formula: "coin toss"),
        )
    }

    @Test
    func `Hit points encodes special`() throws {
        try testCodable(
            json: """
            {
                "special": "as summoner"
            }
            """,
            value: HitPoints.special("as summoner"),
        )
    }
}

struct HitPointsComparableTests {
    @Test
    func `hp(:_) compare by average`() {
        #expect(HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10))
            < HitPoints.hp(DiceNotation(.d8, count: 4, modifier: 10)))
    }

    @Test
    func `hp(:_) compare by average uses given`() {
        #expect(HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10), given: 14)
            < HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10)))
    }

    @Test
    func `other(:_) compare by average`() {
        #expect(HitPoints.other(14, formula: "coin toss") < HitPoints.other(15, formula: "coin toss"))
    }

    @Test
    func `hp(:_) compare to other(:_) by average`() {
        #expect(HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10))
            < HitPoints.other(25, formula: "coin toss"))
    }

    @Test
    func `hp(:_) compare to other(:_) by given average`() {
        #expect(HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10), given: 14)
            < HitPoints.other(15, formula: "coin toss"))
    }

    @Test
    func `other(:_) compare to hp(:_) by average`() {
        #expect(HitPoints.other(20, formula: "coin toss") <
            HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10)))
    }

    @Test
    func `other(:_) compare to hp(:_) by given average`() {
        #expect(HitPoints.other(10, formula: "coin toss") <
            HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10), given: 14))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(HitPoints.special("a") < HitPoints.special("b"))
    }

    @Test
    func `hp(:_) compares less than special(:_)`() {
        #expect(HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10)) < HitPoints.special("1"))
    }

    @Test
    func `other(:_) compares less than special(:_)`() {
        #expect(HitPoints.other(1, formula: "coin toss") < HitPoints.special("1"))
    }
}

struct HitPointsFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `hitPoints() formats notation and typical average`() throws {
        let notation = DiceNotation(.d12, count: 19, modifier: 133)
        let hitPoints = HitPoints.hp(notation)

        let formatter = HitPoints.FormatStyle().locale(Self.locale)
        let description = formatter.format(hitPoints)
        #expect(description == "256 (19d12 + 133)")

        let attributed = formatter.attributed.format(hitPoints)
        #expect(String(attributed.characters) == description)
        #expect(attributed.hitPoints == hitPoints)

        let range = try #require(attributed.range(of: "19d12 + 133"))
        #expect(attributed[range].diceNotation == notation)
    }

    @Test
    func `hitPoints() formats notation and given average`() throws {
        let notation = DiceNotation(.d12, count: 19, modifier: 133)
        let hitPoints = HitPoints.hp(notation, given: 128)

        let formatter = HitPoints.FormatStyle().locale(Self.locale)
        let description = formatter.format(hitPoints)
        #expect(description == "128 (19d12 + 133)")

        let attributed = formatter.attributed.format(hitPoints)
        #expect(String(attributed.characters) == description)
        #expect(attributed.hitPoints == hitPoints)

        let range = try #require(attributed.range(of: "19d12 + 133"))
        #expect(attributed[range].diceNotation == notation)
    }

    @Test
    func `hitPoints() formats other`() {
        let hitPoints = HitPoints.other(2, formula: "coin toss")

        let formatter = HitPoints.FormatStyle().locale(Self.locale)
        let description = formatter.format(hitPoints)
        #expect(description == "2 (coin toss)")

        let attributed = formatter.attributed.format(hitPoints)
        #expect(String(attributed.characters) == description)
        #expect(attributed.hitPoints == hitPoints)
    }

    @Test
    func `hitPoints() formats special`() {
        let hitPoints = HitPoints.special("1")

        let formatter = HitPoints.FormatStyle().locale(Self.locale)
        let description = formatter.format(hitPoints)
        #expect(description == "1")

        let attributed = formatter.attributed.format(hitPoints)
        #expect(String(attributed.characters) == description)
        #expect(attributed.hitPoints == hitPoints)
    }
}

struct HitPointsInitTests {
    @Test
    func `init(stringLiteral:) sets hp when parseable`() {
        let hitPoints: HitPoints = "4d6 + 10"
        #expect(hitPoints == .hp(DiceNotation(.d6, count: 4, modifier: 10)))
    }

    @Test
    func `init(stringLiteral:) sets special when not parseable`() {
        let hitPoints: HitPoints = "not valid"
        #expect(hitPoints == .special("not valid"))
    }
}

struct MovementCodableTests {
    @Test(arguments: Movement.allCases)
    func `Movement encodes rawValue`(movement: Movement) throws {
        try testCodable(
            json: """
            "\(movement.rawValue)"
            """,
            value: movement,
        )
    }
}

struct MovementCodingKeyTests {
    @Test(arguments: Movement.allCases)
    func `Movement encodes dictionary key`(movement: Movement) throws {
        try testCodable(
            json: """
            {
                "\(movement.rawValue)": 30
            }
            """,
            value: [
                movement: 30,
            ],
        )
    }
}

struct MovementComparableTests {
    @Test(arguments: zip(Movement.allCases, Movement.allCases.dropFirst()))
    func `Movement smaller than next`(a: Movement, b: Movement) {
        #expect(a < b)
    }
}

struct MovementFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Movement.allCases)
    func `movement() formats capitalized rawValue`(movement: Movement) {
        let formatter = Movement.FormatStyle().locale(Self.locale)
        let description = formatter.format(movement)
        #expect(description == movement.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(movement)
        #expect(String(attributed.characters) == description)
        #expect(attributed.movement == movement)
    }

    @Test(arguments: Movement.allCases)
    func `movement(case:) formats lowercased rawValue`(movement: Movement) {
        let formatter = Movement.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(movement)
        #expect(description == movement.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(movement)
        #expect(String(attributed.characters) == description)
        #expect(attributed.movement == movement)
    }
}

struct SpeedCodableTests {
    @Test
    func `Speed encodes as integer`() throws {
        try testCodable(
            json: """
            30
            """,
            value: Speed.speed(30),
        )
    }

    @Test
    func `Speed encodes condition in object`() throws {
        try testCodable(
            json: """
            {
                "number": 30,
                "condition": "(in bear form)"
            }
            """,
            value: Speed.speed(30, condition: "(in bear form)"),
        )
    }

    @Test
    func `Speed encodes walking speed as true`() throws {
        try testCodable(
            json: """
            true
            """,
            value: Speed.walkingSpeed,
        )
    }
}

struct SpeedComparableTests {
    @Test
    func `speed(:_) compare by value`() {
        #expect(Speed.speed(30) < Speed.speed(35))
    }

    @Test
    func `walkingSpeed compare equal`() {
        #expect((Speed.walkingSpeed < Speed.walkingSpeed) == false)
    }

    @Test
    func `speed(:_) compares less than walkingSpeed`() {
        #expect(Speed.speed(30) < Speed.walkingSpeed)
    }
}

struct SpeedFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `speed() formats speed with unit`() {
        let speed = Speed.speed(30)

        let formatter = Speed.FormatStyle().locale(Self.locale)
        let description = formatter.format(speed)
        #expect(description == "30 ft.")

        let attributed = formatter.attributed.format(speed)
        #expect(String(attributed.characters) == description)
        #expect(attributed.speed == speed)
    }

    @Test
    func `speed() formats condition`() {
        let speed = Speed.speed(35, condition: "(in bear form)")

        let formatter = Speed.FormatStyle().locale(Self.locale)
        let description = formatter.format(speed)
        #expect(description == "35 ft. (in bear form)")

        let attributed = formatter.attributed.format(speed)
        #expect(String(attributed.characters) == description)
        #expect(attributed.speed == speed)
    }

    @Test
    func `speed() formats walking speed`() {
        let speed = Speed.walkingSpeed

        let formatter = Speed.FormatStyle().locale(Self.locale)
        let description = formatter.format(speed)
        #expect(description == "equal to your walking speed")

        let attributed = formatter.attributed.format(speed)
        #expect(String(attributed.characters) == description)
        #expect(attributed.speed == speed)
    }
}

struct SpeedInitTests {
    @Test
    func `init(integerLiteral:) sets speed`() {
        let speed: Speed = 30
        #expect(speed == .speed(30))
    }
}
