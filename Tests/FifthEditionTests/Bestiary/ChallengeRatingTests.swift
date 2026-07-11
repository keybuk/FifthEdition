//
//  ChallengeRatingTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct ChallengeRatingCodableTests {
    @Test
    func `Challenge rating encodes into string`() throws {
        try testCodable(
            json: """
            "17"
            """,
            value: ChallengeRating.cr(17),
        )
    }

    @Test
    func `Challenge rating encodes 1/8`() throws {
        try testCodable(
            json: """
            "1/8"
            """,
            value: ChallengeRating.cr(1 / 8),
        )
    }

    @Test
    func `Challenge rating encodes 1/4`() throws {
        try testCodable(
            json: """
            "1/4"
            """,
            value: ChallengeRating.cr(1 / 4),
        )
    }

    @Test
    func `Challenge rating encodes 1/2`() throws {
        try testCodable(
            json: """
            "1/2"
            """,
            value: ChallengeRating.cr(1 / 2),
        )
    }

    @Test
    func `Challenge rating encodes special`() throws {
        try testCodable(
            json: """
            "equal to your PB"
            """,
            value: ChallengeRating.special("equal to your PB"),
        )
    }
}

struct ChallengeRatingComparableTests {
    @Test
    func `challengeRating(:_) compare by value`() {
        #expect(ChallengeRating.cr(1) < ChallengeRating.cr(2))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(ChallengeRating.special("a") < ChallengeRating.special("b"))
    }

    @Test
    func `challengeRating(:_) compares less than special(:_)`() {
        #expect(ChallengeRating.cr(2) < ChallengeRating.special("1"))
    }
}

struct ChallengeRatingDescriptionTests {
    @Test
    func `description returns cr`() {
        let challengeRating = ChallengeRating.cr(15)
        #expect(challengeRating.description == "15")
    }

    @Test
    func `description returns cr of 1/8`() {
        let challengeRating = ChallengeRating.cr(1 / 8)
        #expect(challengeRating.description == "1/8")
    }

    @Test
    func `description returns cr of 1/4`() {
        let challengeRating = ChallengeRating.cr(1 / 4)
        #expect(challengeRating.description == "1/4")
    }

    @Test
    func `description returns cr of 1/2`() {
        let challengeRating = ChallengeRating.cr(1 / 2)
        #expect(challengeRating.description == "1/2")
    }

    @Test
    func `description returns special`() {
        let challengeRating = ChallengeRating.special("equal to lowest level party member")
        #expect(challengeRating.description == "equal to lowest level party member")
    }
}

struct ChallengeRatingFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `challengeRating() returns cr`() {
        let challengeRating = ChallengeRating.cr(15)

        let formatter = ChallengeRating.FormatStyle().locale(Self.locale)
        let description = formatter.format(challengeRating)
        #expect(description == "15")

        let attributed = formatter.attributed.format(challengeRating)
        #expect(String(attributed.characters) == description)
        #expect(attributed.challengeRating == challengeRating)
    }

    @Test
    func `challengeRating() returns cr of 1/8`() {
        let challengeRating = ChallengeRating.cr(1 / 8)

        let formatter = ChallengeRating.FormatStyle().locale(Self.locale)
        let description = formatter.format(challengeRating)
        #expect(description == "1/8")

        let attributed = formatter.attributed.format(challengeRating)
        #expect(String(attributed.characters) == description)
        #expect(attributed.challengeRating == challengeRating)
    }

    @Test
    func `challengeRating() returns cr of 1/4`() {
        let challengeRating = ChallengeRating.cr(1 / 4)

        let formatter = ChallengeRating.FormatStyle().locale(Self.locale)
        let description = formatter.format(challengeRating)
        #expect(description == "1/4")

        let attributed = formatter.attributed.format(challengeRating)
        #expect(String(attributed.characters) == description)
        #expect(attributed.challengeRating == challengeRating)
    }

    @Test
    func `challengeRating() returns cr of 1/2`() {
        let challengeRating = ChallengeRating.cr(1 / 2)

        let formatter = ChallengeRating.FormatStyle().locale(Self.locale)
        let description = formatter.format(challengeRating)
        #expect(description == "1/2")

        let attributed = formatter.attributed.format(challengeRating)
        #expect(String(attributed.characters) == description)
        #expect(attributed.challengeRating == challengeRating)
    }

    @Test
    func `challengeRating() returns special`() {
        let challengeRating = ChallengeRating.special("equal to lowest level party member")

        let formatter = ChallengeRating.FormatStyle().locale(Self.locale)
        let description = formatter.format(challengeRating)
        #expect(description == "equal to lowest level party member")

        let attributed = formatter.attributed.format(challengeRating)
        #expect(String(attributed.characters) == description)
        #expect(attributed.challengeRating == challengeRating)
    }
}

struct ChallengeRatingInitTests {
    @Test
    func `init(integerLiteral:) sets cr`() {
        let challengeRating: ChallengeRating = 15
        #expect(challengeRating == .cr(15))
    }

    @Test
    func `init(stringLiteral:) sets special`() {
        let challengeRating: ChallengeRating = "equal to your PB"
        #expect(challengeRating == .special("equal to your PB"))
    }
}

struct CreatureChallengeRatingTests {
    @Test
    func `challengeRating returns challengeRating`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                challenge: 1)
        #expect(creature.challengeRating == .cr(1))
    }

    @Test
    func `challengeRating returns special`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                challenge: "equal to your PB")
        #expect(creature.challengeRating == .special("equal to your PB"))
    }

    @Test
    func `challengeRating returns nil if no challenge rating`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead])
        #expect(creature.challengeRating == nil)
    }
}

struct ExperiencePointsCodableTests {
    @Test
    func `ExperiencePoints encodes xp as integer`() throws {
        try testCodable(
            json: """
            13000
            """,
            value: ExperiencePoints.xp(13000),
        )
    }
}

struct ExperiencePointsComparableTests {
    @Test
    func `xp(:_) compare by value`() {
        #expect(ExperiencePoints.xp(100) < ExperiencePoints.xp(200))
    }
}

struct ExperiencePointsDescriptionTests {
    @Test
    func `description returns xp`() {
        let experiencePoints = ExperiencePoints.xp(13000)
        #expect(experiencePoints.description == "13,000")
    }
}

struct ExperiencePointsFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `experiencePoints formats xp`() {
        let experiencePoints = ExperiencePoints.xp(13000)

        let formatter = ExperiencePoints.FormatStyle().locale(Self.locale)
        let description = formatter.format(experiencePoints)
        #expect(description == "13,000")

        let attributed = formatter.attributed.format(experiencePoints)
        #expect(String(attributed.characters) == description)
        #expect(attributed.experiencePoints == experiencePoints)
    }
}

struct ExperiencePointsInitTests {
    static let expectedExperience: [(Double, Int)] = [
        (0, 10),
        (1 / 8, 25),
        (1 / 4, 50),
        (1 / 2, 100),
        (1, 200),
        (2, 450),
        (3, 700),
        (4, 1100),
        (5, 1800),
        (6, 2300),
        (7, 2900),
        (8, 3900),
        (9, 5000),
        (10, 5900),
        (11, 7200),
        (12, 8400),
        (13, 10000),
        (14, 11500),
        (15, 13000),
        (16, 15000),
        (17, 18000),
        (18, 20000),
        (19, 22000),
        (20, 25000),
        (21, 33000),
        (22, 41000),
        (23, 50000),
        (24, 62000),
        (25, 75000),
        (26, 90000),
        (27, 105_000),
        (28, 120_000),
        (29, 135_000),
        (30, 155_000),
    ]

    @Test(arguments: expectedExperience)
    func `init?(_:) returns xp for challenge rating`(cr: Double, xp: Int) {
        let challengeRating = ChallengeRating.cr(cr)
        #expect(ExperiencePoints(challengeRating) == .xp(xp))
    }

    @Test
    func `init?(_:) returns xp in encounter`() {
        let encounter = Creature.Challenge.Encounter(experiencePoints: .xp(13000))
        #expect(ExperiencePoints(encounter) == .xp(13000))
    }

    @Test(arguments: expectedExperience)
    func `init?(_:) returns xp from challenge rating in encounter`(cr: Double, xp: Int) {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(cr))
        #expect(ExperiencePoints(encounter) == .xp(xp))
    }

    @Test
    func `init?(_:) returns nil for unknown challenge rating`() {
        let challengeRating = ChallengeRating.cr(-1)
        #expect(ExperiencePoints(challengeRating) == nil)
    }

    @Test
    func `init?(_:) returns nil for special`() {
        let challengeRating = ChallengeRating.special("equal to your PB")
        #expect(ExperiencePoints(challengeRating) == nil)
    }

    @Test
    func `init(integerLiteral:) sets xp`() {
        let experiencePoints: ExperiencePoints = 13000
        #expect(experiencePoints == .xp(13000))
    }
}

struct ProficiencyBonusCodableTests {
    @Test
    func `Proficiency bonus as integer`() throws {
        try testCodable(
            json: """
            "2"
            """,
            value: ProficiencyBonus.bonus(2),
        )
    }

    @Test
    func `Proficiency bonus as positive integer`() throws {
        try testCodable(
            json: """
            "+2"
            """,
            value: ProficiencyBonus.bonus(2),
        )
    }

    @Test
    func `Proficiency bonus as negative integer`() throws {
        try testCodable(
            json: """
            "-2"
            """,
            value: ProficiencyBonus.bonus(-2),
        )
    }

    @Test
    func `Proficiency bonus as string`() throws {
        try testCodable(
            json: """
            "equal to your PB"
            """,
            value: ProficiencyBonus.special("equal to your PB"),
        )
    }
}

struct ProficiencyBonusComparableTests {
    @Test
    func `bonus(:_) compare by value`() {
        #expect(ProficiencyBonus.bonus(2) < ProficiencyBonus.bonus(4))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(ProficiencyBonus.special("a") < ProficiencyBonus.special("b"))
    }

    @Test
    func `bonus(:_) compares less than special(:_)`() {
        #expect(ProficiencyBonus.bonus(2) < ProficiencyBonus.special("1"))
    }
}

struct ProficiencyBonusDescriptionTests {
    @Test
    func `description returns positive bonus with sign`() {
        let proficiencyBonus = ProficiencyBonus.bonus(2)
        #expect(proficiencyBonus.description == "+2")
    }

    @Test
    func `description returns zero bonus with sign`() {
        let proficiencyBonus = ProficiencyBonus.bonus(0)
        #expect(proficiencyBonus.description == "+0")
    }

    @Test
    func `description returns negative bonus with sign`() {
        let proficiencyBonus = ProficiencyBonus.bonus(-2)
        #expect(proficiencyBonus.description == "-2")
    }

    @Test
    func `description returns special`() {
        let proficiencyBonus = ProficiencyBonus.special("equal to your PB")
        #expect(proficiencyBonus.description == "equal to your PB")
    }
}

struct ProficiencyBonusFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `proficiencyBonus() formats positive bonus with sign`() {
        let proficiencyBonus = ProficiencyBonus.bonus(2)

        let formatter = ProficiencyBonus.FormatStyle().locale(Self.locale)
        let description = formatter.format(proficiencyBonus)
        #expect(description == "+2")

        let attributed = formatter.attributed.format(proficiencyBonus)
        #expect(String(attributed.characters) == description)
        #expect(attributed.proficiencyBonus == proficiencyBonus)
    }

    @Test
    func `proficiencyBonus() formats zero bonus with sign`() {
        let proficiencyBonus = ProficiencyBonus.bonus(0)

        let formatter = ProficiencyBonus.FormatStyle().locale(Self.locale)
        let description = formatter.format(proficiencyBonus)
        #expect(description == "+0")

        let attributed = formatter.attributed.format(proficiencyBonus)
        #expect(String(attributed.characters) == description)
        #expect(attributed.proficiencyBonus == proficiencyBonus)
    }

    @Test
    func `proficiencyBonus() formats negative bonus with sign`() {
        let proficiencyBonus = ProficiencyBonus.bonus(-2)

        let formatter = ProficiencyBonus.FormatStyle().locale(Self.locale)
        let description = formatter.format(proficiencyBonus)
        #expect(description == "-2")

        let attributed = formatter.attributed.format(proficiencyBonus)
        #expect(String(attributed.characters) == description)
        #expect(attributed.proficiencyBonus == proficiencyBonus)
    }

    @Test
    func `proficiencyBonus() formats special`() {
        let proficiencyBonus = ProficiencyBonus.special("equal to your PB")

        let formatter = ProficiencyBonus.FormatStyle().locale(Self.locale)
        let description = formatter.format(proficiencyBonus)
        #expect(description == "equal to your PB")

        let attributed = formatter.attributed.format(proficiencyBonus)
        #expect(String(attributed.characters) == description)
        #expect(attributed.proficiencyBonus == proficiencyBonus)
    }
}

struct ProficiencyBonusInitTests {
    static let expectedBonus: [(Double, Int)] = [
        (0, 2),
        (1 / 8, 2),
        (1 / 4, 2),
        (1 / 2, 2),
        (1, 2),
        (2, 2),
        (3, 2),
        (4, 2),
        (5, 3),
        (6, 3),
        (7, 3),
        (8, 3),
        (9, 4),
        (10, 4),
        (11, 4),
        (12, 4),
        (13, 5),
        (14, 5),
        (15, 5),
        (16, 5),
        (17, 6),
        (18, 6),
        (19, 6),
        (20, 6),
        (21, 7),
        (22, 7),
        (23, 7),
        (24, 7),
        (25, 8),
        (26, 8),
        (27, 8),
        (28, 8),
        (29, 9),
        (30, 9),
    ]

    @Test(arguments: expectedBonus)
    func `init?(_:) returns expected bonus from challenge rating`(cr: Double, pb: Int) {
        let challengeRating = ChallengeRating.cr(cr)
        #expect(ProficiencyBonus(challengeRating) == .bonus(pb))
    }

    @Test(arguments: expectedBonus)
    func `init?(_:) returns expected bonus from challenge rating in encounter`(cr: Double, pb: Int) {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(cr))
        #expect(ProficiencyBonus(encounter) == .bonus(pb))
    }

    @Test
    func `init?(_:) returns nil for special challenge rating`() {
        let challengeRating = ChallengeRating.special("your level")
        #expect(ProficiencyBonus(challengeRating) == nil)
    }

    @Test
    func `init(integerLiteral:) returns bonus`() {
        let proficiencyBonus: ProficiencyBonus = 2
        #expect(proficiencyBonus == .bonus(2))
    }

    @Test
    func `init(stringLiteral:) returns special`() {
        let proficiencyBonus: ProficiencyBonus = "equal to your PB"
        #expect(proficiencyBonus == .special("equal to your PB"))
    }
}
