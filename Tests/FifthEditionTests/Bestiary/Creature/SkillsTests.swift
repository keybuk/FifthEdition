//
//  SkillsTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureSkillsCodableTests {
    @Test
    func `Skills encodes as object`() throws {
        try testCodable(
            json: """
            {
                "deception": "+2",
                "performance": "+4"
            }
            """,
            value: Creature.Skills([
                .deception: .modifier(2),
                .performance: .modifier(4),
            ]),
        )
    }

    @Test
    func `Skills encodes choice in object`() throws {
        try testCodable(
            json: """
            {
                "deception": "+5",
                "perception": "+4",
                "other": [
                    {
                        "oneOf": {
                            "arcana": "+7",
                            "history": "+7",
                            "nature": "+7",
                            "religion": "+7"
                        }
                    },
                    {
                        "oneOf": {
                            "intimidation": "+5",
                            "performance": "+5"
                        }
                    },
                ]
            }
            """,
            value: Creature.Skills(
                [
                    .deception: AbilityModifier.modifier(5),
                    .perception: AbilityModifier.modifier(4),
                ],
                [
                    .arcana: AbilityModifier.modifier(7),
                    .history: AbilityModifier.modifier(7),
                    .nature: AbilityModifier.modifier(7),
                    .religion: AbilityModifier.modifier(7),
                ],
                [
                    .intimidation: AbilityModifier.modifier(5),
                    .performance: AbilityModifier.modifier(5),
                ],
            ),
        )
    }

    @Test
    func `Skills encodes special`() throws {
        try testCodable(
            json: """
            {
                "deception": "+2",
                "performance": "+4",
                "special": "alchemist's tools +4"
            }
            """,
            value: Creature.Skills([
                .deception: .modifier(2),
                .performance: .modifier(4),
            ],
            special: "alchemist's tools +4"),
        )
    }
}

struct CreatureSkillsCollectionTests {
    @Test
    func `subscript(_:)`() {
        let skills: Creature.Skills = [
            .deception: .modifier(2),
            .performance: .modifier(4),
        ]
        #expect(skills[.deception] == .modifier(2))
        #expect(skills[.performance] == .modifier(4))
        #expect(skills[.intimidation] == nil)
    }

    @Test
    func `isEmpty returns true for empty skills`() {
        let skills = Creature.Skills([:])
        #expect(skills.isEmpty == true)
    }

    @Test
    func `isEmpty returns false if skills`() {
        let skills = Creature.Skills([
            .deception: .modifier(2),
            .performance: .modifier(4),
        ])
        #expect(skills.isEmpty == false)
    }

    @Test
    func `isEmpty returns false if other skills`() {
        let skills = Creature.Skills([:],
                                     [
                                         .intimidation: AbilityModifier.modifier(3),
                                         .persuasion: AbilityModifier.modifier(1),
                                     ])
        #expect(skills.isEmpty == false)
    }

    @Test
    func `isEmpty returns false if special`() {
        let skills = Creature.Skills([:],
                                     special: "advantage against humanoids")
        #expect(skills.isEmpty == false)
    }
}

struct CreatureSkillsFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `skills() formats sorted list of capitalized name and modifier`() throws {
        let skills = Creature.Skills([
            .sleightOfHand: AbilityModifier.modifier(3),
            .persuasion: AbilityModifier.modifier(2),
        ])

        let formatter = Creature.Skills.FormatStyle().locale(Self.locale)
        let description = formatter.format(skills)
        #expect(description == "Persuasion +2, Sleight Of Hand +3")

        let attributed = formatter.attributed.format(skills)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.skills == skills)

        var range = try #require(attributed.range(of: "Persuasion"))
        #expect(attributed[range].skill == .persuasion)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == skills[.persuasion])

        range = try #require(attributed.range(of: "Sleight Of Hand"))
        #expect(attributed[range].skill == .sleightOfHand)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == skills[.sleightOfHand])
    }

    @Test
    func `skills(case:) formats sorted list of lowercased name and modifier`() throws {
        let skills = Creature.Skills([
            .sleightOfHand: AbilityModifier.modifier(3),
            .persuasion: AbilityModifier.modifier(2),
        ])

        let formatter = Creature.Skills.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(skills)
        #expect(description == "persuasion +2, sleight of hand +3")

        let attributed = formatter.attributed.format(skills)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.skills == skills)

        var range = try #require(attributed.range(of: "persuasion"))
        #expect(attributed[range].skill == .persuasion)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == skills[.persuasion])

        range = try #require(attributed.range(of: "sleight of hand"))
        #expect(attributed[range].skill == .sleightOfHand)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == skills[.sleightOfHand])
    }

    @Test
    func `skills() formats special at end`() throws {
        let skills = Creature.Skills(
            [
                .sleightOfHand: AbilityModifier.modifier(3),
                .persuasion: AbilityModifier.modifier(2),
            ],
            special: "advantage against humans",
        )

        let formatter = Creature.Skills.FormatStyle().locale(Self.locale)
        let description = formatter.format(skills)
        #expect(description == "Persuasion +2, Sleight Of Hand +3, advantage against humans")

        let attributed = formatter.attributed.format(skills)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.skills == skills)

        var range = try #require(attributed.range(of: "Persuasion"))
        #expect(attributed[range].skill == .persuasion)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == skills[.persuasion])

        range = try #require(attributed.range(of: "Sleight Of Hand"))
        #expect(attributed[range].skill == .sleightOfHand)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == skills[.sleightOfHand])
    }

    @Test
    func `skills() formats list of prefixed sorted choices of capitalized name and modifier`() throws {
        let skills = Creature.Skills(
            [
                .deception: .modifier(4),
                .performance: .modifier(1),
            ],
            [
                .intimidation: AbilityModifier.modifier(3),
                .persuasion: AbilityModifier.modifier(2),
            ],
        )

        let formatter = Creature.Skills.FormatStyle().locale(Self.locale)
        let description = formatter.format(skills)
        #expect(description ==
            "Deception +4, Performance +1, plus one of the following: Intimidation +3 or Persuasion +2")

        let attributed = formatter.attributed.format(skills)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.skills == skills)

        var range = try #require(attributed.range(of: "Deception"))
        #expect(attributed[range].skill == .deception)

        range = try #require(attributed.range(of: "+4"))
        #expect(attributed[range].abilityModifier == skills[.deception])

        range = try #require(attributed.range(of: "Performance"))
        #expect(attributed[range].skill == .performance)

        range = try #require(attributed.range(of: "+1"))
        #expect(attributed[range].abilityModifier == skills[.performance])

        range = try #require(attributed.range(of: "Intimidation"))
        #expect(attributed[range].skill == .intimidation)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == skills.other.first?[.intimidation])

        range = try #require(attributed.range(of: "Persuasion"))
        #expect(attributed[range].skill == .persuasion)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == skills.other.first?[.persuasion])
    }

    @Test
    func `skills(case:) formats list of prefixed sorted choices of lowercased name and modifier`() throws {
        let skills = Creature.Skills(
            [
                .deception: .modifier(4),
                .performance: .modifier(1),
            ],
            [
                .intimidation: AbilityModifier.modifier(3),
                .persuasion: AbilityModifier.modifier(2),
            ],
        )

        let formatter = Creature.Skills.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(skills)
        #expect(description ==
            "deception +4, performance +1, plus one of the following: intimidation +3 or persuasion +2")

        let attributed = formatter.attributed.format(skills)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.skills == skills)

        var range = try #require(attributed.range(of: "deception"))
        #expect(attributed[range].skill == .deception)

        range = try #require(attributed.range(of: "+4"))
        #expect(attributed[range].abilityModifier == skills[.deception])

        range = try #require(attributed.range(of: "performance"))
        #expect(attributed[range].skill == .performance)

        range = try #require(attributed.range(of: "+1"))
        #expect(attributed[range].abilityModifier == skills[.performance])

        range = try #require(attributed.range(of: "intimidation"))
        #expect(attributed[range].skill == .intimidation)

        range = try #require(attributed.range(of: "+3"))
        #expect(attributed[range].abilityModifier == skills.other.first?[.intimidation])

        range = try #require(attributed.range(of: "persuasion"))
        #expect(attributed[range].skill == .persuasion)

        range = try #require(attributed.range(of: "+2"))
        #expect(attributed[range].abilityModifier == skills.other.first?[.persuasion])
    }
}

struct CreatureSkillsInitTests {
    @Test
    func `init(_:) sets skills`() {
        let skills = Creature.Skills([
            .deception: .modifier(2),
            .performance: .modifier(4),
        ])
        #expect(skills.skills == [
            .deception: .modifier(2),
            .performance: .modifier(4),
        ])
    }

    @Test
    func `init(_:...) sets skills and other skills`() {
        let skills = Creature.Skills(
            [
                .deception: .modifier(2),
                .performance: .modifier(4),
            ],
            [
                .intimidation: AbilityModifier.modifier(3),
                .persuasion: AbilityModifier.modifier(1),
            ],
        )
        #expect(skills.skills == [
            .deception: .modifier(2),
            .performance: .modifier(4),
        ])
        #expect(skills.other == [
            [
                .intimidation: AbilityModifier.modifier(3),
                .persuasion: AbilityModifier.modifier(1),
            ],
        ])
    }

    @Test
    func `init(_:special:) sets skills and special`() {
        let skills = Creature.Skills([.deception: .modifier(2)],
                                     special: "advantage against humanoids")
        #expect(skills.skills == [.deception: .modifier(2)])
        #expect(skills.special == "advantage against humanoids")
    }

    @Test
    func `init(dictionaryLiteral:) sets skills`() {
        let skills: Creature.Skills = [
            .deception: .modifier(2),
            .performance: .modifier(4),
        ]
        #expect(skills.skills == [
            .deception: .modifier(2),
            .performance: .modifier(4),
        ])
    }
}
