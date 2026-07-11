//
//  ChallengeTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureChallengeCodableTests {
    @Test
    func `Challenge encodes challenge rating as string`() throws {
        try testCodable(
            json: """
            "5"
            """,
            value: Creature.Challenge(.cr(5)),
        )
    }

    @Test
    func `Challenge encodes special challenge rating as string`() throws {
        try testCodable(
            json: """
            "equal to your level"
            """,
            value: Creature.Challenge(.special("equal to your level")),
        )
    }

    @Test
    func `Challenge encodes challenge rating with experience points as object`() throws {
        try testCodable(
            json: """
            {
                "cr": "5",
                "xp": 13500
            }
            """,
            value: Creature.Challenge(.cr(5), experiencePoints: .xp(13500)),
        )
    }

    @Test
    func `Challenge encodes challenge rating with lair xp as object`() throws {
        try testCodable(
            json: """
            {
                "cr": "5",
                "xpLair": 14500
            }
            """,
            value: Creature.Challenge(.cr(5), lair: .xp(14500)),
        )
    }

    @Test
    func `Challenge encodes challenge rating with coven xp as object`() throws {
        try testCodable(
            json: """
            {
                "cr": "5",
                "xpCoven": 13750
            }
            """,
            value: Creature.Challenge(.cr(5), coven: .xp(13750)),
        )
    }

    @Test
    func `Challenge encodes challenge rating with lair cr as object`() throws {
        try testCodable(
            json: """
            {
                "cr": "5",
                "lair": "7"
            }
            """,
            value: Creature.Challenge(.cr(5), lair: .cr(7)),
        )
    }

    @Test
    func `Challenge encodes challenge rating with coven cr as object`() throws {
        try testCodable(
            json: """
            {
                "cr": "5",
                "coven": "6"
            }
            """,
            value: Creature.Challenge(.cr(5), coven: .cr(6)),
        )
    }
}

struct CreatureChallengeFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `challenge() formats cr with standard xp and proficiency bonus`() throws {
        let challenge = Creature.Challenge(.cr(15))

        let formatter = Creature.Challenge.FormatStyle().locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (XP 13,000; PB +5)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,000"))
        #expect(attributed[range].experiencePoints == .xp(13000))

        range = try #require(attributed.range(of: "+5"))
        #expect(attributed[range].proficiencyBonus == .bonus(5))
    }

    @Test
    func `challenge() formats cr with provided xp`() throws {
        let challenge = Creature.Challenge(.cr(15), experiencePoints: .xp(13500))

        let formatter = Creature.Challenge.FormatStyle().locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (XP 13,500; PB +5)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,500"))
        #expect(attributed[range].experiencePoints == challenge.encounter?.experiencePoints)

        range = try #require(attributed.range(of: "+5"))
        #expect(attributed[range].proficiencyBonus == .bonus(5))
    }

    @Test
    func `challenge(detail:) formats cr with standard xp`() throws {
        let challenge = Creature.Challenge(.cr(15))

        let formatter = Creature.Challenge.FormatStyle(detail: .expanded).locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (13,000 XP)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,000"))
        #expect(attributed[range].experiencePoints == .xp(13000))
    }

    @Test
    func `challenge(detail:) formats cr with provided xp`() throws {
        let challenge = Creature.Challenge(.cr(15), experiencePoints: .xp(13500))

        let formatter = Creature.Challenge.FormatStyle(detail: .expanded).locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (13,500 XP)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,500"))
        #expect(attributed[range].experiencePoints == .xp(13500))
    }

    @Test
    func `challenge() formats special cr and zero xp`() throws {
        let challenge = Creature.Challenge(.special("equal to lowest level party member"))

        let formatter = Creature.Challenge.FormatStyle().locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "equal to lowest level party member (XP 0)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "equal to lowest level party member"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "0"))
        #expect(attributed[range].experiencePoints == .xp(0))
    }

    @Test
    func `challenge(detail:) formats special cr`() {
        let challenge = Creature.Challenge(.special("equal to lowest level party member"))

        let formatter = Creature.Challenge.FormatStyle(detail: .expanded).locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "equal to lowest level party member")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)
        #expect(attributed.challengeRating == challenge.encounter?.challengeRating)
    }

    @Test
    func `challenge() formats cr for lair`() throws {
        let challenge = Creature.Challenge(.cr(15), lair: .xp(14500))

        let formatter = Creature.Challenge.FormatStyle().locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (XP 13,000 or 14,500 in lair; PB +5)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,000"))
        #expect(attributed[range].experiencePoints == .xp(13000))

        range = try #require(attributed.range(of: "14,500"))
        #expect(attributed[range].experiencePoints == challenge.lair?.experiencePoints)

        range = try #require(attributed.range(of: "+5"))
        #expect(attributed[range].proficiencyBonus == .bonus(5))
    }

    @Test
    func `challenge() formats cr for coven`() throws {
        let challenge = Creature.Challenge(.cr(15), coven: .xp(13750))

        let formatter = Creature.Challenge.FormatStyle().locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (XP 13,000 or 13,750 when part of a coven; PB +5)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,000"))
        #expect(attributed[range].experiencePoints == .xp(13000))

        range = try #require(attributed.range(of: "13,750"))
        #expect(attributed[range].experiencePoints == challenge.coven?.experiencePoints)

        range = try #require(attributed.range(of: "+5"))
        #expect(attributed[range].proficiencyBonus == .bonus(5))
    }

    @Test
    func `challenge() formats cr with provided proficiency bonus`() throws {
        let challenge = Creature.Challenge(.cr(15), proficiencyBonus: .bonus(7))

        let formatter = Creature.Challenge.FormatStyle().locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (XP 13,000; PB +7)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,000"))
        #expect(attributed[range].experiencePoints == .xp(13000))

        range = try #require(attributed.range(of: "+7"))
        #expect(attributed[range].proficiencyBonus == challenge.proficiencyBonus)
    }

    @Test
    func `challenge() formats cr with special proficiency bonus`() throws {
        let challenge = Creature.Challenge(.cr(15), proficiencyBonus: .special("equal to your PB"))

        let formatter = Creature.Challenge.FormatStyle().locale(Self.locale)
        let description = formatter.format(challenge)
        #expect(description == "15 (XP 13,000; PB equal to your PB)")

        let attributed = formatter.attributed.format(challenge)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challenge == challenge)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == challenge.encounter?.challengeRating)

        range = try #require(attributed.range(of: "13,000"))
        #expect(attributed[range].experiencePoints == .xp(13000))

        range = try #require(attributed.range(of: "equal to your PB"))
        #expect(attributed[range].proficiencyBonus == challenge.proficiencyBonus)
    }
}

struct CreatureChallengeInitTests {
    @Test
    func `init(_:) sets encounter challenge rating`() {
        let challenge = Creature.Challenge(.cr(5))
        #expect(challenge.encounter?.challengeRating == .cr(5))
    }

    @Test
    func `init(_:experiencePoints:) sets encounter`() {
        let challenge = Creature.Challenge(.cr(5), experiencePoints: .xp(13500))
        #expect(challenge.encounter?.challengeRating == .cr(5))
        #expect(challenge.encounter?.experiencePoints == .xp(13500))
    }

    @Test
    func `init(_:lair:) sets lair experience points`() {
        let challenge = Creature.Challenge(.cr(5), lair: .xp(14500))
        #expect(challenge.lair?.experiencePoints == .xp(14500))
    }

    @Test
    func `init(_:coven:) sets coven experience points`() {
        let challenge = Creature.Challenge(.cr(5), coven: .xp(13750))
        #expect(challenge.coven?.experiencePoints == .xp(13750))
    }

    @Test
    func `init(_:lair:) sets lair challenge rating`() {
        let challenge = Creature.Challenge(.cr(5), lair: .cr(6))
        #expect(challenge.lair?.challengeRating == .cr(6))
    }

    @Test
    func `init(_:coven:) sets coven challenge rating`() {
        let challenge = Creature.Challenge(.cr(5), coven: .cr(6))
        #expect(challenge.coven?.challengeRating == .cr(6))
    }

    @Test
    func `init(_:proficiencyBonus) sets proficiency bonus`() {
        let challenge = Creature.Challenge(.cr(5), proficiencyBonus: .bonus(5))
        #expect(challenge.proficiencyBonus == .bonus(5))
    }

    @Test
    func `init(integerLiteral:) sets encounter`() {
        let challenge: Creature.Challenge = 5
        #expect(challenge.encounter?.challengeRating == .cr(5))
    }

    @Test
    func `init(stringLiteral:) sets encounter special`() {
        let challenge: Creature.Challenge = "equal to your level"
        #expect(challenge.encounter?.challengeRating == .special("equal to your level"))
    }
}

struct CreatureChallengeEncounterFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `challengeEncounter() formats xp from rating`() {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(15))

        let formatter = Creature.Challenge.Encounter.FormatStyle().locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "13,000")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)
    }

    @Test
    func `challengeEncounter(width) formats cr and default xp`() throws {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(15))

        let formatter = Creature.Challenge.Encounter.FormatStyle(width: .wide).locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "15 (13,000 XP)")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == .cr(15))

        range = try #require(attributed.range(of: "13,000"))
        #expect(attributed[range].experiencePoints == .xp(13000))
    }

    @Test
    func `challengeEncounter() formats xp from encounter`() {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(15), experiencePoints: .xp(13500))

        let formatter = Creature.Challenge.Encounter.FormatStyle().locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "13,500")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)
        #expect(attributed.experiencePoints == encounter.experiencePoints)
    }

    @Test
    func `challengeEncounter(width:) formats cr and xp from encounter`() throws {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(15), experiencePoints: .xp(13500))

        let formatter = Creature.Challenge.Encounter.FormatStyle(width: .wide).locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "15 (13,500 XP)")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)

        var range = try #require(attributed.range(of: "15"))
        #expect(attributed[range].challengeRating == .cr(15))

        range = try #require(attributed.range(of: "13,500"))
        #expect(attributed[range].experiencePoints == .xp(13500))
    }

    @Test
    func `challengeEncounter() formats special cr when no xp`() {
        let encounter = Creature.Challenge.Encounter(challengeRating: .special("equal to your pb"))

        let formatter = Creature.Challenge.Encounter.FormatStyle().locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "equal to your pb")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)
        #expect(attributed.challengeRating == .special("equal to your pb"))
    }

    @Test
    func `challengeEncounter() formats xp from rating over special cr`() {
        let encounter = Creature.Challenge.Encounter(
            challengeRating: .special("equal to your pb"),
            experiencePoints: 150,
        )

        let formatter = Creature.Challenge.Encounter.FormatStyle().locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "150")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)
        #expect(attributed.experiencePoints == .xp(150))
    }

    @Test
    func `challengeRating(width:) formats special cr with no xp`() {
        let encounter = Creature.Challenge.Encounter(challengeRating: .special("equal to your pb"))

        let formatter = Creature.Challenge.Encounter.FormatStyle().locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "equal to your pb")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)
        #expect(attributed.challengeRating == .special("equal to your pb"))
    }

    @Test
    func `challengeRating(width:) formats special cr and xp from rating`() throws {
        let encounter = Creature.Challenge.Encounter(
            challengeRating: .special("equal to your pb"),
            experiencePoints: .xp(150),
        )

        let formatter = Creature.Challenge.Encounter.FormatStyle(width: .wide).locale(Self.locale)
        let description = formatter.format(encounter)
        #expect(description == "equal to your pb (150 XP)")

        let attributed = formatter.attributed.format(encounter)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.challengeEncounter == encounter)

        var range = try #require(attributed.range(of: "equal to your pb"))
        #expect(attributed[range].challengeRating == .special("equal to your pb"))

        range = try #require(attributed.range(of: "150"))
        #expect(attributed[range].experiencePoints == .xp(150))
    }
}

struct CreatureChallengeEncounterInitTests {
    @Test
    func `init(challengeRating:) sets challenge rating`() {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(15))
        #expect(encounter.challengeRating == .cr(15))
    }

    @Test
    func `init(challengeRating:experiencePoints:) sets challenge rating and experience points`() {
        let encounter = Creature.Challenge.Encounter(challengeRating: .cr(15),
                                                     experiencePoints: .xp(13500))
        #expect(encounter.challengeRating == .cr(15))
        #expect(encounter.experiencePoints == .xp(13500))
    }

    @Test
    func `init(experiencePoints:) sets experience points`() {
        let encounter = Creature.Challenge.Encounter(experiencePoints: .xp(13000))
        #expect(encounter.experiencePoints == .xp(13000))
    }

    @Test
    func `init(integerLiteral:) sets challenge rating`() {
        let encounter: Creature.Challenge.Encounter = 15
        #expect(encounter.challengeRating == .cr(15))
    }

    @Test
    func `init(integerLiteral:) sets experience points`() {
        let encounter: Creature.Challenge.Encounter = 150
        #expect(encounter.experiencePoints == .xp(150))
    }

    @Test
    func `init(stringLiteral:) sets challenge rating special`() {
        let encounter: Creature.Challenge.Encounter = "equal to your pb"
        #expect(encounter.challengeRating == .special("equal to your pb"))
    }
}
