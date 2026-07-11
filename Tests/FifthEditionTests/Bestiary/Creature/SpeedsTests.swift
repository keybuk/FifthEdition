//
//  SpeedsTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureSpeedsCodableTests {
    @Test
    func `Speeds encodes as object`() throws {
        try testCodable(
            json: """
            {
                "walk": 30,
                "fly": 40,
            }
            """,
            value: Creature.Speeds([
                .walk: [.speed(30)],
                .fly: [.speed(40)],
            ]),
        )
    }

    @Test
    func `Speeds encodes hover in object`() throws {
        try testCodable(
            json: """
            {
                "walk": 30,
                "fly": 40,
                "canHover": true
            }
            """,
            value: Creature.Speeds(
                [
                    .walk: [.speed(30)],
                    .fly: [.speed(40)],
                ],
                canHover: true,
            ),
        )
    }

    @Test
    func `Speeds encodes additional speeds as alternate`() throws {
        try testCodable(
            json: """
            {
                "walk": 30,
                "fly": 40,
                "alternate": {
                    "walk": [
                        {
                            "number": 35,
                            "condition": "(when raging)"
                        }
                    ],
                    "fly": [
                        {
                            "number": 45,
                            "condition": "(when raging)"
                        }
                    ]
                }
            }
            """,
            value: Creature.Speeds([
                .walk: [
                    .speed(30),
                    .speed(35, condition: "(when raging)"),
                ],
                .fly: [
                    .speed(40),
                    .speed(45, condition: "(when raging)"),
                ],
            ]),
        )
    }

    @Test
    func `Speeds encodes movement choice as choose`() throws {
        try testCodable(
            json: """
            {
                "walk": 30,
                "choose": {
                    "from": [
                        "climb",
                        "fly"
                    ],
                    "amount": 30,
                    "note": "(DM's choice)"
                }
            }
            """,
            value: Creature.Speeds(
                [
                    .walk: [.speed(30)],
                ],
                choose: [.climb, .fly],
                speed: 30,
                note: "(DM's choice)",
            ),
        )
    }

    @Test
    func `Speeds decodes integer as walking speed`() throws {
        try testCodable(
            json: """
            30
            """,
            value: Creature.Speeds([
                .walk: [.speed(30)],
            ]),
        )
    }
}

struct CreatureSpeedsCollectionTests {
    @Test
    func `subscript(_:)`() {
        let speeds: Creature.Speeds = [
            .walk: [30],
            .fly: [40],
        ]
        #expect(speeds[.walk] == [.speed(30)])
        #expect(speeds[.fly] == [.speed(40)])
        #expect(speeds[.climb] == nil)
    }

    @Test
    func `isEmpty returns true for speeds`() {
        let speeds: Creature.Speeds = [:]
        #expect(speeds.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if speeds`() {
        let speeds: Creature.Speeds = [
            .walk: [30],
            .fly: [40],
        ]
        #expect(speeds.isEmpty == false)
    }

    @Test
    func `isEmpty returns false if some speeds hidden`() {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
                .fly: [40],
            ],
            hidden: [.fly],
        )
        #expect(speeds.isEmpty == false)
    }

    @Test
    func `isEmpty returns true if all speeds hidden`() {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
                .fly: [40],
            ],
            hidden: [.walk, .fly],
        )
        #expect(speeds.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if movement choice`() {
        let speeds = Creature.Speeds(choose: [.fly],
                                     speed: 30)
        #expect(speeds.isEmpty == false)
    }
}

struct CreatureSpeedsFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `speeds() formats single walking speed`() {
        let speeds = Creature.Speeds([
            .walk: [30],
        ])

        let formatter = Creature.Speeds.FormatStyle().locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft.")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)
        #expect(attributed.speed == speeds[.walk]![0])
    }

    @Test
    func `speeds() formats alternate walking speeds`() throws {
        let speeds = Creature.Speeds([
            .walk: [
                30,
                .speed(40, condition: "(bear form only)"),
            ],
        ])

        let formatter = Creature.Speeds.FormatStyle().locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., 40 ft. (bear form only)")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "40 ft. (bear form only)"))
        #expect(attributed[range].speed == speeds[.walk]![1])
    }

    @Test
    func `speeds() formats multiple speeds with capitalized movement`() throws {
        let speeds = Creature.Speeds([
            .walk: [30],
            .fly: [40],
        ])

        let formatter = Creature.Speeds.FormatStyle().locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., Fly 40 ft.")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "Fly"))
        #expect(attributed[range].movement == .fly)

        range = try #require(attributed.range(of: "40 ft."))
        #expect(attributed[range].speed == speeds[.fly]![0])
    }

    @Test
    func `speeds(case:) formats multiple speeds with lowercased movement`() throws {
        let speeds = Creature.Speeds([
            .walk: [30],
            .fly: [40],
        ])

        let formatter = Creature.Speeds.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., fly 40 ft.")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "fly"))
        #expect(attributed[range].movement == .fly)

        range = try #require(attributed.range(of: "40 ft."))
        #expect(attributed[range].speed == speeds[.fly]![0])
    }

    @Test
    func `speeds() formats hover with fly speed`() throws {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
                .fly: [.speed(40, condition: "(hover)")],
            ],
            canHover: true,
        )

        let formatter = Creature.Speeds.FormatStyle().locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., Fly 40 ft. (hover)")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "Fly"))
        #expect(attributed[range].movement == .fly)

        range = try #require(attributed.range(of: "40 ft. (hover)"))
        #expect(attributed[range].speed == speeds[.fly]![0])
    }

    @Test
    func `speeds() formats walking speed with capitalized movement`() throws {
        let speeds = Creature.Speeds([
            .walk: [30],
            .fly: [.walkingSpeed],
        ])

        let formatter = Creature.Speeds.FormatStyle().locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., Fly equal to your walking speed")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "Fly"))
        #expect(attributed[range].movement == .fly)

        range = try #require(attributed.range(of: "equal to your walking speed"))
        #expect(attributed[range].speed == speeds[.fly]![0])
    }

    @Test
    func `speeds(case:) formats walking speed with lowercased movement`() throws {
        let speeds = Creature.Speeds([
            .walk: [30],
            .fly: [.walkingSpeed],
        ])

        let formatter = Creature.Speeds.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., fly equal to your walking speed")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "fly"))
        #expect(attributed[range].movement == .fly)

        range = try #require(attributed.range(of: "equal to your walking speed"))
        #expect(attributed[range].speed == speeds[.fly]![0])
    }

    @Test
    func `speeds() formats choice of speeds with capitalized movement`() throws {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
            ],
            choose: [.climb, .fly],
            speed: 40,
            note: "(DM's choice)",
        )

        let formatter = Creature.Speeds.FormatStyle().locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., Climb or Fly 40 ft. (DM's choice)")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "Climb"))
        #expect(attributed[range].movement == .climb)

        range = try #require(attributed.range(of: "Fly"))
        #expect(attributed[range].movement == .fly)

        range = try #require(attributed.range(of: "40 ft. (DM's choice)"))
        #expect(attributed[range].speed == speeds.choiceSpeed)
    }

    @Test
    func `speeds(case:) formats choice of speeds with lowercased movement`() throws {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
            ],
            choose: [.climb, .fly],
            speed: 40,
            note: "(DM's choice)",
        )

        let formatter = Creature.Speeds.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., climb or fly 40 ft. (DM's choice)")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "climb"))
        #expect(attributed[range].movement == .climb)

        range = try #require(attributed.range(of: "fly"))
        #expect(attributed[range].movement == .fly)

        range = try #require(attributed.range(of: "40 ft. (DM's choice)"))
        #expect(attributed[range].speed == speeds.choiceSpeed)
    }

    @Test
    func `speeds() does not format hidden speeds`() throws {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
                .climb: [40],
                .fly: [40],
            ],
            hidden: [.fly],
        )

        let formatter = Creature.Speeds.FormatStyle().locale(Self.locale)
        let description = formatter.format(speeds)
        #expect(description == "30 ft., Climb 40 ft.")

        let attributed = formatter.attributed.format(speeds)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.speeds == speeds)

        var range = try #require(attributed.range(of: "30 ft."))
        #expect(attributed[range].speed == speeds[.walk]![0])

        range = try #require(attributed.range(of: "Climb"))
        #expect(attributed[range].movement == .climb)

        range = try #require(attributed.range(of: "40 ft."))
        #expect(attributed[range].speed == speeds[.fly]![0])
    }
}

struct CreatureSpeedsInitTests {
    @Test
    func `init(_:) sets speeds`() {
        let speeds = Creature.Speeds([
            .walk: [30],
            .fly: [40],
        ])
        #expect(speeds.speeds == [
            .walk: [.speed(30)],
            .fly: [.speed(40)],
        ])
    }

    @Test
    func `init(_:canHover:) sets speeds and canHover`() {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
                .fly: [40],
            ],
            canHover: true,
        )
        #expect(speeds.speeds == [
            .walk: [.speed(30)],
            .fly: [.speed(40)],
        ])
        #expect(speeds.canHover == true)
    }

    @Test
    func `init(_:hidden:) sets speeds and hidden`() {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
                .fly: [40],
            ],
            hidden: [.fly],
        )
        #expect(speeds.speeds == [
            .walk: [.speed(30)],
            .fly: [.speed(40)],
        ])
        #expect(speeds.hidden == [.fly])
    }

    @Test
    func `init(_:choose:speed:) sets speeds and choice`() {
        let speeds = Creature.Speeds(
            [
                .walk: [30],
            ],
            choose: [.climb, .fly],
            speed: 30,
            note: "(DM's choice)",
        )
        #expect(speeds.speeds == [
            .walk: [.speed(30)],
        ])
        #expect(speeds.chooseMovement == [.climb, .fly])
        #expect(speeds.choiceSpeed == .speed(30, condition: "(DM's choice)"))
    }

    @Test
    func `init(choose:speed:) sets choice`() {
        let speeds = Creature.Speeds(
            choose: [.climb, .fly],
            speed: 30,
            note: "(DM's choice)",
        )
        #expect(speeds.speeds == [:])
        #expect(speeds.chooseMovement == [.climb, .fly])
        #expect(speeds.choiceSpeed == .speed(30, condition: "(DM's choice)"))
    }

    @Test
    func `init(integerLiteral:) sets walking speed`() {
        let speeds: Creature.Speeds = 30
        #expect(speeds.speeds == [
            .walk: [.speed(30)],
        ])
    }

    @Test
    func `init(dictionaryLiteral:) sets speeds`() {
        let speeds: Creature.Speeds = [
            .walk: [.speed(30)],
            .fly: [.speed(40)],
        ]
        #expect(speeds.speeds == [
            .walk: [.speed(30)],
            .fly: [.speed(40)],
        ])
    }
}
