//
//  SusceptibleTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/31/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct ConditionCodableTests {
    @Test(arguments: Condition.allCases)
    func `Condition is encoded as rawValue`(condition: Condition) throws {
        try testCodable(
            json: """
            "\(condition.rawValue)"
            """,
            value: condition,
        )
    }

    @Test
    func `Unknown condition is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "hungry"
            """,
            value: Condition.other("hungry"),
        )
    }
}

struct ConditionComparableTests {
    @Test(arguments: zip(Condition.allCases, Condition.allCases.dropFirst()))
    func `Condition smaller than next`(a: Condition, b: Condition) {
        #expect(a < b)
    }

    @Test(arguments: Condition.allCases)
    func `Condition smaller than unknown`(condition: Condition) {
        #expect(condition < Condition.other("hungry"))
    }
}

struct ConditionFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Condition.allCases)
    func `condition() formats capitalized name`(condition: Condition) {
        let formatter = Condition.FormatStyle().locale(Self.locale)
        let description = formatter.format(condition)
        #expect(description == condition.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(condition)
        #expect(String(attributed.characters) == description)
        #expect(attributed.condition == condition)
    }

    @Test(arguments: Condition.allCases)
    func `condition(case:) formats lowercased name`(condition: Condition) {
        let formatter = Condition.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(condition)
        #expect(description == condition.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(condition)
        #expect(String(attributed.characters) == description)
        #expect(attributed.condition == condition)
    }

    @Test
    func `condition() formats capitalized unknown name`() {
        let condition = Condition.other("hungry")

        let formatter = Condition.FormatStyle().locale(Self.locale)
        let description = formatter.format(condition)
        #expect(description == "Hungry")

        let attributed = formatter.attributed.format(condition)
        #expect(String(attributed.characters) == description)
        #expect(attributed.condition == condition)
    }

    @Test
    func `condition(case:) formats lowercased unknown name`() {
        let condition = Condition.other("hungry")

        let formatter = Condition.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(condition)
        #expect(description == "hungry")

        let attributed = formatter.attributed.format(condition)
        #expect(String(attributed.characters) == description)
        #expect(attributed.condition == condition)
    }
}

struct ConditionRawRepresentableTests {
    static let expectedValues: [(Condition, String)] = [
        (.blinded, "blinded"),
        (.charmed, "charmed"),
        (.deafened, "deafened"),
        (.exhaustion, "exhaustion"),
        (.frightened, "frightened"),
        (.grappled, "grappled"),
        (.incapacitated, "incapacitated"),
        (.invisible, "invisible"),
        (.paralyzed, "paralyzed"),
        (.petrified, "petrified"),
        (.poisoned, "poisoned"),
        (.prone, "prone"),
        (.restrained, "restrained"),
        (.stunned, "stunned"),
        (.unconscious, "unconscious"),
        (.disease, "disease"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(condition: Condition, rawValue: String) {
        #expect(Condition(rawValue: rawValue) == condition)
    }

    @Test
    func `init(rawValue:) sets other for unknown case`() {
        #expect(Condition(rawValue: "hungry") == .other("hungry"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(condition: Condition, rawValue: String) {
        #expect(condition.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let condition = Condition.other("hungry")
        #expect(condition.rawValue == "hungry")
    }
}

struct SusceptibleCodableTests {
    @Test
    func `Condiitional encodes single condition`() throws {
        try testCodable(
            json: """
            "blinded"
            """,
            value: Susceptible.condition(.blinded),
            configuration: .conditionImmunity,
        )
    }

    @Test
    func `Condiitional encodes single unknown condition`() throws {
        try testCodable(
            json: """
            "drunk"
            """,
            value: Susceptible.condition(.other("drunk")),
            configuration: .conditionImmunity,
        )
    }

    @Test
    func `Condiitional encodes single unknown damage`() throws {
        try testCodable(
            json: """
            "custard"
            """,
            value: Susceptible.damage(.other("custard")),
            configuration: .damageImmunity,
        )
    }

    @Test
    func `Susceptible encodes special`() throws {
        try testCodable(
            json: """
            {
                "special": "immune to hungry"
            }
            """,
            value: Susceptible.special("immune to hungry"),
            configuration: .conditionImmunity,
        )
    }

    @Test
    func `Susceptible encodes condition immunity as object`() throws {
        try testCodable(
            json: """
            {
                "conditionImmune": [
                    "charmed",
                    "frightened"
                ],
            }
            """,
            value: Susceptible.susceptible([
                .condition(.charmed),
                .condition(.frightened),
            ]),
            configuration: .conditionImmunity,
        )
    }

    @Test
    func `Susceptible encodes damage immunity as object`() throws {
        try testCodable(
            json: """
            {
                "immune": [
                    "bludgeoning",
                    "piercing",
                    "slashing"
                ],
            }
            """,
            value: Susceptible.susceptible([
                .damage(.bludgeoning),
                .damage(.piercing),
                .damage(.slashing),
            ]),
            configuration: .damageImmunity,
        )
    }

    @Test
    func `Susceptible encodes damage resistance as object`() throws {
        try testCodable(
            json: """
            {
                "resist": [
                    "bludgeoning",
                    "piercing",
                    "slashing"
                ],
            }
            """,
            value: Susceptible.susceptible([
                .damage(.bludgeoning),
                .damage(.piercing),
                .damage(.slashing),
            ]),
            configuration: .damageResistance,
        )
    }

    @Test
    func `Susceptible encodes damage vulnerability as object`() throws {
        try testCodable(
            json: """
            {
                "vulnerable": [
                    "bludgeoning",
                    "piercing",
                    "slashing"
                ],
            }
            """,
            value: Susceptible.susceptible([
                .damage(.bludgeoning),
                .damage(.piercing),
                .damage(.slashing),
            ]),
            configuration: .damageVulnerability,
        )
    }

    @Test
    func `Susceptible encodes condition with note as object`() throws {
        try testCodable(
            json: """
            {
                "conditionImmune": [
                    "charmed",
                    "frightened"
                ],
                "note": "while raging",
                "cond": true
            }
            """,
            value: Susceptible.susceptible(
                [
                    .condition(.charmed),
                    .condition(.frightened),
                ],
                note: "while raging",
                isConditional: true,
            ),
            configuration: .conditionImmunity,
        )
    }

    @Test
    func `Susceptible encodes damage with note as object`() throws {
        try testCodable(
            json: """
            {
                "immune": [
                    "bludgeoning",
                    "piercing",
                    "slashing"
                ],
                "note": "from nonmagical attacks that aren't silvered",
                "cond": true
            }
            """,
            value: Susceptible.susceptible(
                [
                    .damage(.bludgeoning),
                    .damage(.piercing),
                    .damage(.slashing),
                ],
                note: "from nonmagical attacks that aren't silvered",
                isConditional: true,
            ),
            configuration: .damageImmunity,
        )
    }

    @Test
    func `Susceptible encodes condition with pre-note`() throws {
        try testCodable(
            json: """
            {
                "conditionImmune": [
                    "blinded",
                    "deafened"
                ],
                "preNote": "While hooded:"
            }
            """,
            value: Susceptible.susceptible([
                .condition(.blinded),
                .condition(.deafened),
            ],
            preNote: "While hooded:"),
            configuration: .conditionImmunity,
        )
    }

    @Test
    func `Susceptible encodes damage with pre-note`() throws {
        try testCodable(
            json: """
            {
                "immune": [
                    "psychic",
                ],
                "preNote": "While wearing tin foil hat:"
            }
            """,
            value: Susceptible.susceptible([
                .damage(.psychic),
            ],
            preNote: "While wearing tin foil hat:"),
            configuration: .damageImmunity,
        )
    }

    @Test
    func `Susceptible encodes recursive condition immunity`() throws {
        try testCodable(
            json: """
            {
                "conditionImmune": [
                    "blinded",
                    "deafened",
                    {
                        "conditionImmune": [
                            "charmed",
                            "frightened"
                        ],
                        "note": "when sight or hearing required",
                        "cond": true
                    }
                ],
                "preNote": "While hooded:"
            }
            """,
            value: Susceptible.susceptible([
                .condition(.blinded),
                .condition(.deafened),
                .susceptible([
                    .condition(.charmed),
                    .condition(.frightened),
                ],
                note: "when sight or hearing required",
                isConditional: true),
            ],
            preNote: "While hooded:"),
            configuration: .conditionImmunity,
        )
    }

    @Test
    func `Susceptible encodes recursive damage immunity`() throws {
        try testCodable(
            json: """
            {
                "immune": [
                    "psychic",
                    {
                        "immune": [
                            "lightning"
                        ],
                        "note": "when grounded",
                        "cond": true
                    }
                ],
                "preNote": "While wearing tin foil hat:"
            }
            """,
            value: Susceptible.susceptible([
                .damage(.psychic),
                .susceptible([
                    .damage(.lightning),
                ],
                note: "when grounded",
                isConditional: true),
            ],
            preNote: "While wearing tin foil hat:"),
            configuration: .damageImmunity,
        )
    }

    @Test
    func `Susceptible encodes recursive damage resistance`() throws {
        try testCodable(
            json: """
            {
                "resist": [
                    "psychic",
                    {
                        "resist": [
                            "lightning"
                        ],
                        "note": "when grounded",
                        "cond": true
                    }
                ],
                "preNote": "While wearing tin foil hat:"
            }
            """,
            value: Susceptible.susceptible([
                .damage(.psychic),
                .susceptible([
                    .damage(.lightning),
                ],
                note: "when grounded",
                isConditional: true),
            ],
            preNote: "While wearing tin foil hat:"),
            configuration: .damageResistance,
        )
    }

    @Test
    func `Susceptible encodes recursive damage vulnerability`() throws {
        try testCodable(
            json: """
            {
                "vulnerable": [
                    "piercing",
                    {
                        "vulnerable": [
                            "psychic"
                        ],
                        "note": "while charmed by the attacker",
                        "cond": true
                    }
                ],
                "note": "from magic weapons wielded by good creatures",
                "cond": true
            }
            """,
            value: Susceptible.susceptible(
                [
                    .damage(.piercing),
                    .susceptible([
                        .damage(.psychic),
                    ],
                    note: "while charmed by the attacker",
                    isConditional: true),
                ],
                note: "from magic weapons wielded by good creatures",
                isConditional: true,
            ),
            configuration: .damageVulnerability,
        )
    }
}

struct SusceptibleComparableTests {
    @Test
    func `damage(:_) compare by value`() {
        #expect(Susceptible.damage(.psychic) < Susceptible.damage(.radiant))
    }

    @Test
    func `condition(:_) compare by value`() {
        #expect(Susceptible.condition(.charmed) < Susceptible.condition(.frightened))
    }

    @Test
    func `damage(:_) compares less than condition(_:)`() {
        #expect(Susceptible.damage(.psychic) < Susceptible.condition(.frightened))
    }

    @Test
    func `susceptible(:_) compare by value`() {
        #expect(Susceptible.susceptible([.damage(.psychic)]) < Susceptible
            .susceptible([.condition(.frightened)]))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(Susceptible.special("a") < Susceptible.special("b"))
    }

    @Test
    func `damage(:_) compares less than special(_:)`() {
        #expect(Susceptible.damage(.psychic) < Susceptible.special("a"))
    }

    @Test
    func `condition(:_) compares less than special(_:)`() {
        #expect(Susceptible.condition(.charmed) < Susceptible.special("a"))
    }

    @Test
    func `susceptible(:_) compares less than special(_:)`() {
        #expect(Susceptible.susceptible([.damage(.psychic)]) < Susceptible.special("a"))
    }
}

struct SusceptibleFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `susceptible() formats capitalized condition name`() {
        let susceptible = Susceptible.condition(.charmed)

        let formatter = Susceptible.FormatStyle().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "Charmed")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)
        #expect(attributed.condition == .charmed)
    }

    @Test
    func `susceptible(case:) formats lowercased condition name`() {
        let susceptible = Susceptible.condition(.charmed)

        let formatter = Susceptible.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "charmed")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)
        #expect(attributed.condition == .charmed)
    }

    @Test
    func `susceptible() formats capitalized damage`() {
        let susceptible = Susceptible.damage(.necrotic)

        let formatter = Susceptible.FormatStyle().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "Necrotic")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)
        #expect(attributed.damage == .necrotic)
    }

    @Test
    func `susceptible(case:) formats lowercased damage`() {
        let susceptible = Susceptible.damage(.necrotic)

        let formatter = Susceptible.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "necrotic")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)
        #expect(attributed.damage == .necrotic)
    }

    @Test
    func `susceptible() formats special`() {
        let susceptible = Susceptible.special("immune to hunger")

        let formatter = Susceptible.FormatStyle().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "immune to hunger")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)
    }

    @Test
    func `susceptible() formats list of capitalized condition names`() throws {
        let susceptible = Susceptible.susceptible([
            .condition(.charmed),
            .condition(.frightened),
        ])

        let formatter = Susceptible.FormatStyle().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "Charmed, Frightened")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)

        var range = try #require(attributed.range(of: "Charmed"))
        #expect(attributed[range].condition == .charmed)

        range = try #require(attributed.range(of: "Frightened"))
        #expect(attributed[range].condition == .frightened)
    }

    @Test
    func `susceptible(case:) formats list of lowercased condition names`() throws {
        let susceptible = Susceptible.susceptible([
            .condition(.charmed),
            .condition(.frightened),
        ])

        let formatter = Susceptible.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "charmed, frightened")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)

        var range = try #require(attributed.range(of: "charmed"))
        #expect(attributed[range].condition == .charmed)

        range = try #require(attributed.range(of: "frightened"))
        #expect(attributed[range].condition == .frightened)
    }

    @Test
    func `susceptible() formats list of capitalized damage`() throws {
        let susceptible = Susceptible.susceptible([
            .damage(.bludgeoning),
            .damage(.piercing),
        ])

        let formatter = Susceptible.FormatStyle().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "Bludgeoning, Piercing")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)

        var range = try #require(attributed.range(of: "Bludgeoning"))
        #expect(attributed[range].damage == .bludgeoning)

        range = try #require(attributed.range(of: "Piercing"))
        #expect(attributed[range].damage == .piercing)
    }

    @Test
    func `susceptible(case:) formats list of lowercased damages`() throws {
        let susceptible = Susceptible.susceptible([
            .damage(.bludgeoning),
            .damage(.piercing),
        ])

        let formatter = Susceptible.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "bludgeoning, piercing")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)

        var range = try #require(attributed.range(of: "bludgeoning"))
        #expect(attributed[range].damage == .bludgeoning)

        range = try #require(attributed.range(of: "piercing"))
        #expect(attributed[range].damage == .piercing)
    }

    @Test
    func `susceptible() formats note appended to list`() throws {
        let susceptible = Susceptible.susceptible(
            [
                .condition(.charmed),
                .condition(.frightened),
            ],
            note: "when raging",
            isConditional: true,
        )

        let formatter = Susceptible.FormatStyle().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "Charmed and Frightened when raging")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)

        var range = try #require(attributed.range(of: "Charmed"))
        #expect(attributed[range].condition == .charmed)

        range = try #require(attributed.range(of: "Frightened"))
        #expect(attributed[range].condition == .frightened)
    }

    @Test
    func `susceptible() formats preNote prepended to list`() throws {
        let susceptible = Susceptible.susceptible(
            [
                .condition(.blinded),
                .condition(.deafened),
            ],
            preNote: "While wearing hood:",
        )

        let formatter = Susceptible.FormatStyle().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "While wearing hood: Blinded, Deafened")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)
        #expect(attributed.susceptible == susceptible)

        var range = try #require(attributed.range(of: "Blinded"))
        #expect(attributed[range].condition == .blinded)

        range = try #require(attributed.range(of: "Deafened"))
        #expect(attributed[range].condition == .deafened)
    }
}

struct SusceptibleListFormatStyleAttributedTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `susceptibles() formats semi-colon separated capitalized lists`() throws {
        let susceptible: [Susceptible] = [
            .condition(.charmed),
            .condition(.frightened),
            .damage(.force),
            .damage(.radiant),
        ]

        let formatter: Susceptible.ListFormatStyle<[Susceptible]> = .susceptibles().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "Force, Radiant; Charmed, Frightened")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "Force"))
        #expect(attributed[range].damage == .force)

        range = try #require(attributed.range(of: "Radiant"))
        #expect(attributed[range].damage == .radiant)

        range = try #require(attributed.range(of: "Charmed"))
        #expect(attributed[range].condition == .charmed)

        range = try #require(attributed.range(of: "Frightened"))
        #expect(attributed[range].condition == .frightened)
    }

    @Test
    func `susceptibles(case:) formats semi-colon separated lowercased lists`() throws {
        let susceptible: [Susceptible] = [
            .condition(.charmed),
            .condition(.frightened),
            .damage(.force),
            .damage(.radiant),
        ]

        let formatter: Susceptible.ListFormatStyle<[Susceptible]> = .susceptibles(case: .lowercased).locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "force, radiant; charmed, frightened")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "force"))
        #expect(attributed[range].damage == .force)

        range = try #require(attributed.range(of: "radiant"))
        #expect(attributed[range].damage == .radiant)

        range = try #require(attributed.range(of: "charmed"))
        #expect(attributed[range].condition == .charmed)

        range = try #require(attributed.range(of: "frightened"))
        #expect(attributed[range].condition == .frightened)
    }

    @Test
    func `susceptibles() formats semi-colon separated susceptible lists`() throws {
        let susceptible: [Susceptible] = [
            .susceptible(
                [
                    .condition(.charmed),
                    .condition(.frightened),
                ],
                note: "when raging",
                isConditional: true,
            ),
            .susceptible(
                [
                    .damage(.bludgeoning),
                    .damage(.piercing),
                    .damage(.slashing),
                ],
                note: "from nonmagical weapons that aren't silvered",
                isConditional: true,
            ),
        ]

        let formatter: Susceptible.ListFormatStyle<[Susceptible]> = .susceptibles().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description ==
            "Bludgeoning, Piercing, and Slashing from nonmagical weapons that aren't silvered; Charmed and Frightened when raging")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed
            .range(of: "Bludgeoning, Piercing, and Slashing from nonmagical weapons that aren't silvered"))
        #expect(attributed[range].susceptible == susceptible[1])

        range = try #require(attributed.range(of: "Bludgeoning"))
        #expect(attributed[range].damage == .bludgeoning)

        range = try #require(attributed.range(of: "Piercing"))
        #expect(attributed[range].damage == .piercing)

        range = try #require(attributed.range(of: "Slashing"))
        #expect(attributed[range].damage == .slashing)

        range = try #require(attributed.range(of: "Charmed and Frightened when raging"))
        #expect(attributed[range].susceptible == susceptible[0])

        range = try #require(attributed.range(of: "Charmed"))
        #expect(attributed[range].condition == .charmed)

        range = try #require(attributed.range(of: "Frightened"))
        #expect(attributed[range].condition == .frightened)
    }

    @Test
    func `susceptibles() formats semi-colon separated specials`() throws {
        let susceptible: [Susceptible] = [
            .special("immune to hunger"),
            .special("immune to custard damage"),
        ]

        let formatter: Susceptible.ListFormatStyle<[Susceptible]> = .susceptibles().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description == "immune to custard damage; immune to hunger")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "immune to custard damage"))
        #expect(attributed[range].susceptible == susceptible[1])

        range = try #require(attributed.range(of: "immune to hunger"))
        #expect(attributed[range].susceptible == susceptible[0])
    }

    @Test
    func `susceptibles() formats semi-colon separated mixed types`() throws {
        let susceptible: [Susceptible] = [
            .susceptible(
                [
                    .damage(.bludgeoning),
                    .damage(.piercing),
                    .damage(.slashing),
                ],
                note: "from nonmagical weapons that aren't silvered",
                isConditional: true,
            ),
            .special("immune to hunger"),
            .condition(.charmed),
            .damage(.necrotic),
        ]

        let formatter: Susceptible.ListFormatStyle<[Susceptible]> = .susceptibles().locale(Self.locale)
        let description = formatter.format(susceptible)
        #expect(description ==
            "Necrotic; Charmed; Bludgeoning, Piercing, and Slashing from nonmagical weapons that aren't silvered; immune to hunger")

        let attributed = formatter.attributed.format(susceptible)
        #expect(String(attributed.characters) == description)

        var range = try #require(attributed.range(of: "Necrotic"))
        #expect(attributed[range].susceptible == susceptible[3])
        #expect(attributed[range].damage == .necrotic)

        range = try #require(attributed.range(of: "Charmed"))
        #expect(attributed[range].susceptible == susceptible[2])
        #expect(attributed[range].condition == .charmed)

        range = try #require(attributed
            .range(of: "Bludgeoning, Piercing, and Slashing from nonmagical weapons that aren't silvered"))
        #expect(attributed[range].susceptible == susceptible[0])

        range = try #require(attributed.range(of: "Bludgeoning"))
        #expect(attributed[range].damage == .bludgeoning)

        range = try #require(attributed.range(of: "Piercing"))
        #expect(attributed[range].damage == .piercing)

        range = try #require(attributed.range(of: "Slashing"))
        #expect(attributed[range].damage == .slashing)

        range = try #require(attributed.range(of: "immune to hunger"))
        #expect(attributed[range].susceptible == susceptible[1])
    }
}

struct DamageCodableTests {
    @Test(arguments: Damage.allCases)
    func `Damage is encoded as rawValue`(damage: Damage) throws {
        try testCodable(
            json: """
            "\(damage.rawValue)"
            """,
            value: damage,
        )
    }

    @Test
    func `Unknown condition is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "custard"
            """,
            value: Damage.other("custard"),
        )
    }
}

struct DamageComparableTests {
    @Test(arguments: zip(Damage.allCases, Damage.allCases.dropFirst()))
    func `Damage smaller than next`(a: Damage, b: Damage) {
        #expect(a < b)
    }

    @Test(arguments: Damage.allCases)
    func `Damage smaller than unknown`(damage: Damage) {
        #expect(damage < Damage.other("custard"))
    }
}

struct DamageFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Damage.allCases)
    func `damage() formats capitalized name`(damage: Damage) {
        let formatter = Damage.FormatStyle().locale(Self.locale)
        let description = formatter.format(damage)
        #expect(description == damage.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(damage)
        #expect(String(attributed.characters) == description)
        #expect(attributed.damage == damage)
    }

    @Test(arguments: Damage.allCases)
    func `damage(case:) formats lowercased name`(damage: Damage) {
        let formatter = Damage.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(damage)
        #expect(description == damage.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(damage)
        #expect(String(attributed.characters) == description)
        #expect(attributed.damage == damage)
    }
}

struct DamageRawRepresentableTests {
    static let expectedValues: [(Damage, String)] = [
        (.acid, "acid"),
        (.bludgeoning, "bludgeoning"),
        (.cold, "cold"),
        (.fire, "fire"),
        (.force, "force"),
        (.lightning, "lightning"),
        (.necrotic, "necrotic"),
        (.piercing, "piercing"),
        (.poison, "poison"),
        (.psychic, "psychic"),
        (.radiant, "radiant"),
        (.slashing, "slashing"),
        (.thunder, "thunder"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(damage: Damage, rawValue: String) {
        #expect(Damage(rawValue: rawValue) == damage)
    }

    @Test
    func `init(rawValue:) sets other for unknown case`() {
        #expect(Damage(rawValue: "custard") == .other("custard"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(damage: Damage, rawValue: String) {
        #expect(damage.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let damage = Damage.other("custard")
        #expect(damage.rawValue == "custard")
    }
}
