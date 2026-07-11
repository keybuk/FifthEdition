//
//  AbilityTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct AbilityCodableTests {
    @Test(arguments: Ability.allCases)
    func `Ability encodes rawValue`(ability: Ability) throws {
        try testCodable(
            json: """
            "\(ability.rawValue)"
            """,
            value: ability,
        )
    }
}

struct AbilityCodingKeyTests {
    @Test(arguments: Ability.allCases)
    func `Ability encodes dictionary key using first three characters`(ability: Ability) throws {
        try testCodable(
            json: """
            {
                "\(ability.rawValue.prefix(3))": 42
            }
            """,
            value: [
                ability: 42,
            ],
        )
    }
}

struct AbilityComparableTests {
    @Test(arguments: zip(Ability.allCases, Ability.allCases.dropFirst()))
    func `Ability smaller than next`(a: Ability, b: Ability) {
        #expect(a < b)
    }
}

struct AbilityFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Ability.allCases)
    func `ability() formats capitalized rawValue`(ability: Ability) {
        let formatter = Ability.FormatStyle().locale(Self.locale)
        let description = formatter.format(ability)
        #expect(description == ability.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(ability)
        #expect(String(attributed.characters) == description)
        #expect(attributed.ability == ability)
    }

    @Test(arguments: Ability.allCases)
    func `ability(case:) formats lowercased rawValue`(ability: Ability) {
        let formatter = Ability.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(ability)
        #expect(description == ability.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(ability)
        #expect(String(attributed.characters) == description)
        #expect(attributed.ability == ability)
    }

    @Test(arguments: Ability.allCases)
    func `ability(case:) formats uppercased rawValue`(ability: Ability) {
        let formatter = Ability.FormatStyle(case: .uppercased).locale(Self.locale)
        let description = formatter.format(ability)
        #expect(description == ability.rawValue.uppercased(with: Self.locale))

        let attributed = formatter.attributed.format(ability)
        #expect(String(attributed.characters) == description)
        #expect(attributed.ability == ability)
    }

    @Test(arguments: Ability.allCases)
    func `ability(width:) formats capitalized name in short form`(ability: Ability) {
        let formatter = Ability.FormatStyle(width: .short).locale(Self.locale)
        let description = formatter.format(ability)
        #expect(description == ability.rawValue.prefix(3).capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(ability)
        #expect(String(attributed.characters) == description)
        #expect(attributed.ability == ability)
    }

    @Test(arguments: Ability.allCases)
    func `ability(case:width:) formats lowercased name in short form`(ability: Ability) {
        let formatter = Ability.FormatStyle(case: .lowercased, width: .short).locale(Self.locale)
        let description = formatter.format(ability)
        #expect(description == ability.rawValue.prefix(3).lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(ability)
        #expect(String(attributed.characters) == description)
        #expect(attributed.ability == ability)
    }

    @Test(arguments: Ability.allCases)
    func `ability(case:width:) formats uppercased name in short form`(ability: Ability) {
        let formatter = Ability.FormatStyle(case: .uppercased, width: .short).locale(Self.locale)
        let description = formatter.format(ability)
        #expect(description == ability.rawValue.prefix(3).uppercased(with: Self.locale))

        let attributed = formatter.attributed.format(ability)
        #expect(String(attributed.characters) == description)
        #expect(attributed.ability == ability)
    }
}

struct AbilityGroupTests {
    static let expectedGroups: [Ability.Group: [Ability]] = [
        .physical: [.strength, .dexterity, .constitution],
        .mental: [.intelligence, .wisdom, .charisma],
    ]

    @Test(arguments: expectedGroups)
    func `group has expected value`(group: Ability.Group, abilities: [Ability]) {
        #expect(abilities.allSatisfy { $0.group == group })
    }
}

struct AbilityModifierCodableTests {
    @Test
    func `Ability modifier encodes as string with sign`() throws {
        try testCodable(
            json: """
            "+5"
            """,
            value: AbilityModifier.modifier(5),
        )
    }

    @Test
    func `Negative ability modifier encodes as string with sign`() throws {
        try testCodable(
            json: """
            "-5"
            """,
            value: AbilityModifier.modifier(-5),
        )
    }

    @Test
    func `Special ability modifier is encoded as string`() throws {
        try testCodable(
            json: """
            "same as player"
            """,
            value: AbilityModifier.special("same as player"),
        )
    }
}

struct AbilityModifierComparableTests {
    @Test
    func `modifier(:_) compare by value`() {
        #expect(AbilityModifier.modifier(2) < AbilityModifier.modifier(4))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(AbilityModifier.special("a") < AbilityModifier.special("b"))
    }

    @Test
    func `modifier(:_) compares less than special(:_)`() {
        #expect(AbilityModifier.modifier(2) < AbilityModifier.special("1"))
    }
}

struct AbilityModifierDescriptionTests {
    @Test
    func `description returns positive modifier with sign`() {
        let abilityModifier = AbilityModifier.modifier(5)
        #expect(abilityModifier.description == "+5")
    }

    @Test
    func `description returns zero modifier with sign`() {
        let abilityModifier = AbilityModifier.modifier(0)
        #expect(abilityModifier.description == "+0")
    }

    @Test
    func `description returns negative modifier with sign`() {
        let abilityModifier = AbilityModifier.modifier(-5)
        #expect(abilityModifier.description == "-5")
    }

    @Test
    func `description returns formats special`() {
        let abilityModifier = AbilityModifier.special("same as player")
        #expect(abilityModifier.description == "same as player")
    }
}

struct AbilityModifierFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `abilityModifier() formats positive modifier with sign`() {
        let abilityModifier = AbilityModifier.modifier(5)

        let formatter = AbilityModifier.FormatStyle().locale(Self.locale)
        let description = formatter.format(abilityModifier)
        #expect(description == "+5")

        let attributed = formatter.attributed.format(abilityModifier)
        #expect(String(attributed.characters) == description)
        #expect(attributed.abilityModifier == abilityModifier)
    }

    @Test
    func `abilityModifier() formats zero modifier with sign`() {
        let abilityModifier = AbilityModifier.modifier(0)

        let formatter = AbilityModifier.FormatStyle().locale(Self.locale)
        let description = formatter.format(abilityModifier)
        #expect(description == "+0")

        let attributed = formatter.attributed.format(abilityModifier)
        #expect(String(attributed.characters) == description)
        #expect(attributed.abilityModifier == abilityModifier)
    }

    @Test
    func `abilityModifier() formats negative modifier with sign`() {
        let abilityModifier = AbilityModifier.modifier(-5)

        let formatter = AbilityModifier.FormatStyle().locale(Self.locale)
        let description = formatter.format(abilityModifier)
        #expect(description == "-5")

        let attributed = formatter.attributed.format(abilityModifier)
        #expect(String(attributed.characters) == description)
        #expect(attributed.abilityModifier == abilityModifier)
    }

    @Test
    func `abilityModifier() formats special`() {
        let abilityModifier = AbilityModifier.special("same as player")

        let formatter = AbilityModifier.FormatStyle().locale(Self.locale)
        let description = formatter.format(abilityModifier)
        #expect(description == "same as player")

        let attributed = formatter.attributed.format(abilityModifier)
        #expect(String(attributed.characters) == description)
        #expect(attributed.abilityModifier == abilityModifier)
    }
}

struct AbilityModifierInitTests {
    static let expectedModifiers = [
        (0, -5),
        (1, -5),
        (2, -4),
        (3, -4),
        (4, -3),
        (5, -3),
        (6, -2),
        (7, -2),
        (8, -1),
        (9, -1),
        (10, 0),
        (11, 0),
        (12, 1),
        (13, 1),
        (14, 2),
        (15, 2),
        (16, 3),
        (17, 3),
        (18, 4),
        (19, 4),
        (20, 5),
        (21, 5),
        (22, 6),
        (23, 6),
        (24, 7),
        (25, 7),
        (26, 8),
        (27, 8),
        (28, 9),
        (29, 9),
        (30, 10),
    ]

    @Test
    func `init(integerValue:) sets modifier`() {
        let abilityModifier: AbilityModifier = 5
        #expect(abilityModifier == .modifier(5))
    }

    @Test
    func `init(stringValue:) sets special`() {
        let abilityModifier: AbilityModifier = "same as player"
        #expect(abilityModifier == .special("same as player"))
    }

    @Test(arguments: expectedModifiers)
    func `init?(_:) returns expected modifier for score`(score: Int, expectedModifier: Int) {
        let abilityScore = AbilityScore.score(score)
        let abilityModifier = AbilityModifier(abilityScore)
        #expect(abilityModifier == .modifier(expectedModifier))
    }

    @Test
    func `init?(_:) returns nil for special`() {
        let abilityModifier = AbilityModifier(.special("same as player"))
        #expect(abilityModifier == nil)
    }
}

struct AbilityScoreCodableTests {
    @Test
    func `Ability score is encoded as integer`() throws {
        try testCodable(
            json: """
            16
            """,
            value: AbilityScore.score(16),
        )
    }

    @Test
    func `Special ability score is encoded as object`() throws {
        try testCodable(
            json: """
            {
                "special": "same as player"
            }
            """,
            value: AbilityScore.special("same as player"),
        )
    }
}

struct AbilityScoreComparableTests {
    @Test
    func `score(:_) compare by value`() {
        #expect(AbilityScore.score(15) < AbilityScore.score(20))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(AbilityScore.special("a") < AbilityScore.special("b"))
    }

    @Test
    func `score(:_) compares less than special(:_)`() {
        #expect(AbilityScore.score(12) < AbilityScore.special("12"))
    }
}

struct AbilityScoreDescriptionTests {
    @Test
    func `description returns score`() {
        let abilityScore = AbilityScore.score(15)
        #expect(abilityScore.description == "15")
    }

    @Test
    func `description returns special`() {
        let abilityScore = AbilityScore.special("same as player")
        #expect(abilityScore.description == "same as player")
    }
}

struct AbilityScoreFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `abilityScore() formats score`() {
        let abilityScore = AbilityScore.score(15)

        let formatter = AbilityScore.FormatStyle().locale(Self.locale)
        let description = formatter.format(abilityScore)
        #expect(description == "15")

        let attributed = formatter.attributed.format(abilityScore)
        #expect(String(attributed.characters) == description)
        #expect(attributed.abilityScore == abilityScore)
    }

    @Test
    func `abilityScore() formats special`() {
        let abilityScore = AbilityScore.special("same as player")

        let formatter = AbilityScore.FormatStyle().locale(Self.locale)
        let description = formatter.format(abilityScore)
        #expect(description == "same as player")

        let attributed = formatter.attributed.format(abilityScore)
        #expect(String(attributed.characters) == description)
        #expect(attributed.abilityScore == abilityScore)
    }
}

struct AbilityScoreInitTests {
    @Test
    func `init(integerLiteral:) sets score`() {
        let abilityScore: AbilityScore = 15
        #expect(abilityScore == .score(15))
    }

    @Test
    func `init(stringLiteral:) sets special`() {
        let abilityScore: AbilityScore = "same as player"
        #expect(abilityScore == .special("same as player"))
    }
}

struct AdvantageCodableTests {
    static let expectedCoding: [(Advantage, String)] = [
        (.advantage, "adv"),
        (.disadvantage, "dis"),
    ]

    @Test(arguments: expectedCoding)
    func `Advantage encodes as string`(advantage: Advantage, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: advantage,
        )
    }
}

struct InitiativeCodableTests {
    @Test
    func `Initiative encodes as modifier`() throws {
        try testCodable(
            json: """
            5
            """,
            value: Initiative.modifier(5),
        )
    }

    @Test
    func `Initiative encodes modifier in object`() throws {
        try testCodable(
            json: """
            {
                "initiative": 5
            }
            """,
            value: Initiative.modifier(5),
        )
    }

    @Test
    func `Initiative encodes proficiency in object`() throws {
        try testCodable(
            json: """
            {
                "proficiency": 1
            }
            """,
            value: Initiative.proficiency(.proficient),
        )
    }

    @Test
    func `Initiative encodes expertise in object`() throws {
        try testCodable(
            json: """
            {
                "proficiency": 2
            }
            """,
            value: Initiative.proficiency(.expertise),
        )
    }

    @Test
    func `Initiative encodes advantage in object`() throws {
        try testCodable(
            json: """
            {
                "advantageMode": "adv"
            }
            """,
            value: Initiative.advantage(.advantage),
        )
    }

    @Test
    func `Initiative encodes disadvantage in object`() throws {
        try testCodable(
            json: """
            {
                "advantageMode": "dis"
            }
            """,
            value: Initiative.advantage(.disadvantage),
        )
    }

    @Test
    func `init(from:) throws error if multiple fields in object`() throws {
        let json = """
        {
            "initiative": 5,
            "proficiency": 1
        }
        """
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Initiative.self, from: #require(json.data(using: .utf8)))
        }
    }
}

struct InitiativeInitTests {
    @Test
    func `init(integerLiteral:) sets modifier`() {
        let initiative: Initiative = 5
        #expect(initiative == .modifier(5))
    }
}

struct PassiveCodableTests {
    @Test
    func `Passive encodes passive`() throws {
        try testCodable(
            json: """
            15
            """,
            value: Passive.passive(15),
        )
    }

    @Test
    func `Special passive is encoded as string`() throws {
        try testCodable(
            json: """
            "same as player"
            """,
            value: Passive.special("same as player"),
        )
    }
}

struct PassiveComparableTests {
    @Test
    func `passive(:_) compare by value`() {
        #expect(Passive.passive(10) < Passive.passive(15))
    }

    @Test
    func `special(:_) compare by value`() {
        #expect(Passive.special("a") < Passive.special("b"))
    }

    @Test
    func `passive(:_) compares less than special(:_)`() {
        #expect(Passive.passive(15) < Passive.special("10"))
    }
}

struct PassiveDescriptionTests {
    @Test
    func `description returns passive`() {
        let passive = Passive.passive(15)
        #expect(passive.description == "15")
    }

    @Test
    func `description returns special`() {
        let passive = Passive.special("same as player")
        #expect(passive.description == "same as player")
    }
}

struct PassiveFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `passive() formats passive`() {
        let passive = Passive.passive(15)

        let formatter = Passive.FormatStyle().locale(Self.locale)
        let description = formatter.format(passive)
        #expect(description == "15")

        let attributed = formatter.attributed.format(passive)
        #expect(String(attributed.characters) == description)
        #expect(attributed.passive == passive)
    }

    @Test
    func `passive() formats special`() {
        let passive = Passive.special("same as player")

        let formatter = Passive.FormatStyle().locale(Self.locale)
        let description = formatter.format(passive)
        #expect(description == "same as player")

        let attributed = formatter.attributed.format(passive)
        #expect(String(attributed.characters) == description)
        #expect(attributed.passive == passive)
    }
}

struct PassiveInitTests {
    @Test
    func `init(integerValue:) sets modifier`() {
        let passive: Passive = 15
        #expect(passive == .passive(15))
    }

    @Test
    func `init(stringValue:) sets special`() {
        let passive: Passive = "same as player"
        #expect(passive == .special("same as player"))
    }

    @Test(arguments: -5...20)
    func `init?(_:) returns expected passive score for modifier`(modifier: Int) {
        let abilityModifier = AbilityModifier.modifier(modifier)
        let passive = Passive(abilityModifier)
        #expect(passive == .passive(10 + modifier))
    }

    @Test(arguments: -5...20)
    func `init?(_:) returns expected passive score for modifier with advantage`(modifier: Int) {
        let abilityModifier = AbilityModifier.modifier(modifier)
        let passive = Passive(abilityModifier, advantage: .advantage)
        #expect(passive == .passive(10 + modifier + 5))
    }

    @Test(arguments: -5...20)
    func `init?(_:) returns expected passive score for modifier with disadvantage`(modifier: Int) {
        let abilityModifier = AbilityModifier.modifier(modifier)
        let passive = Passive(abilityModifier, advantage: .disadvantage)
        #expect(passive == .passive(10 + modifier - 5))
    }
}

struct ProficiencyCodableTests {
    @Test(arguments: Proficiency.allCases)
    func `Proficiency encodes rawValue`(proficiency: Proficiency) throws {
        try testCodable(
            json: """
            \(proficiency.rawValue)
            """,
            value: proficiency,
        )
    }
}

struct SkillAbilityTests {
    static let expectedAbilities: [(Ability, Set<Skill>)] = [
        (.strength, [.athletics]),
        (.dexterity, [.acrobatics, .sleightOfHand, .stealth]),
        (.constitution, []),
        (.intelligence, [.arcana, .history, .investigation, .nature, .religion]),
        (.wisdom, [.animalHandling, .insight, .medicine, .perception, .survival]),
        (.charisma, [.deception, .intimidation, .performance, .persuasion]),
    ]

    @Test(arguments: expectedAbilities)
    func `ability has expected value`(ability: Ability, skills: Set<Skill>) {
        #expect(skills.allSatisfy { $0.ability == ability })
    }
}

struct SkillCodableTests {
    @Test(arguments: Skill.allCases)
    func `Skill encodes rawValue`(skill: Skill) throws {
        try testCodable(
            json: """
            "\(skill.rawValue)"
            """,
            value: skill,
        )
    }
}

struct SkillCodingKeyTests {
    @Test(arguments: Skill.allCases)
    func `Skill encodes rawValue as dictionary key`(skill: Skill) throws {
        try testCodable(
            json: """
            {
                "\(skill.rawValue)": 42
            }
            """,
            value: [
                skill: 42,
            ],
        )
    }
}

struct SkillComparableTests {
    @Test(arguments: zip(Skill.allCases, Skill.allCases.dropFirst()))
    func `Skill smaller than next`(a: Skill, b: Skill) {
        #expect(a < b)
    }
}

struct SkillFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test(arguments: Skill.allCases)
    func `skill() formats capitalized name`(skill: Skill) {
        let formatter = Skill.FormatStyle().locale(Self.locale)
        let description = formatter.format(skill)
        #expect(description == skill.rawValue.capitalized(with: Self.locale))

        let attributed = formatter.attributed.format(skill)
        #expect(String(attributed.characters) == description)
        #expect(attributed.skill == skill)
    }

    @Test(arguments: Skill.allCases)
    func `skill(case:) formats lowercased name`(skill: Skill) {
        let formatter = Skill.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(skill)
        #expect(description == skill.rawValue.lowercased(with: Self.locale))

        let attributed = formatter.attributed.format(skill)
        #expect(String(attributed.characters) == description)
        #expect(attributed.skill == skill)
    }
}
