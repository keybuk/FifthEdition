//
//  Enum+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
//

import Testing
@testable import FifthEdition

struct ActionTagCodableTests {
    @Test(arguments: ActionTag.allCases)
    func `Action tags`(_ actionTag: ActionTag) throws {
        try testCodable(
            json: """
            "\(actionTag.rawValue)"
            """,
            value: actionTag,
        )
    }
}

struct ConditionCodableTests {
    @Test(arguments: Condition.allCases)
    func conditions(_ condition: Condition) throws {
        try testCodable(
            json: """
            "\(condition.rawValue)"
            """,
            value: condition,
        )
    }
}

struct CreatureTypeCodableTests {
    @Test(arguments: CreatureType.allCases)
    func `Creature types`(_ creatureType: CreatureType) throws {
        try testCodable(
            json: """
            "\(creatureType.rawValue)"
            """,
            value: creatureType,
        )
    }
}

struct DamageTypeCodableTests {
    @Test(arguments: DamageType.allCases)
    func `Damage types`(_ damageType: DamageType) throws {
        try testCodable(
            json: """
            "\(damageType.rawValue)"
            """,
            value: damageType,
        )
    }

    @Test(arguments: DamageType.tags)
    func `Tagged damage types`(damageType: DamageType, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(damageType),
        )
    }

    @Test
    func `Tagged damage type set`() throws {
        try testCodable(
            json: """
            [
                "B",
                "S"
            ]
            """,
            value: TagSet<DamageType>([
                .bludgeoning,
                .slashing,
            ]),
        )
    }
}

struct DragonAgeCodableTests {
    @Test(arguments: DragonAge.allCases)
    func `Dragon ages`(_ dragonAge: DragonAge) throws {
        try testCodable(
            json: """
            "\(dragonAge.rawValue)"
            """,
            value: dragonAge,
        )
    }
}

struct DragonColorCodableTests {
    @Test(arguments: DragonColor.allCases)
    func `Dragon colors`(_ dragonColor: DragonColor) throws {
        try testCodable(
            json: """
            "\(dragonColor.rawValue)"
            """,
            value: dragonColor,
        )
    }
}

struct EditionCodableTests {
    @Test(arguments: Edition.allCases)
    func editions(_ edition: Edition) throws {
        try testCodable(
            json: """
            "\(edition.rawValue)"
            """,
            value: edition,
        )
    }
}

struct EnvironmentTypeCodableTests {
    @Test(arguments: EnvironmentType.allCases)
    func `Environment types`(_ environmentType: EnvironmentType) throws {
        try testCodable(
            json: """
            "\(environmentType.rawValue)"
            """,
            value: environmentType,
        )
    }
}

struct LanguageTagCodableTests {
    @Test(arguments: LanguageTag.allCases)
    func `Language tag`(_ languageTag: LanguageTag) throws {
        try testCodable(
            json: """
            "\(languageTag.rawValue)"
            """,
            value: languageTag,
        )
    }

    @Test(arguments: LanguageTag.tags)
    func `Tagged language tags`(languageTag: LanguageTag, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(languageTag),
        )
    }

    @Test
    func `Tagged language tags set`() throws {
        try testCodable(
            json: """
            [
                "LF",
                "TP"
            ]
            """,
            value: TagSet<LanguageTag>([
                .languagesKnownInLife,
                .telepathy,
            ]),
        )
    }
}

struct MiscTagCodableTests {
    @Test(arguments: MiscTag.allCases)
    func `Misc tag`(_ miscTag: MiscTag) throws {
        try testCodable(
            json: """
            "\(miscTag.rawValue)"
            """,
            value: miscTag,
        )
    }

    @Test(arguments: MiscTag.tags)
    func `Tagged misc tags`(miscTag: MiscTag, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(miscTag),
        )
    }

    @Test
    func `Tagged misc tags set`() throws {
        try testCodable(
            json: """
            [
                "AOE",
                "CUR"
            ]
            """,
            value: TagSet<MiscTag>([
                .hasAreasOfEffect,
                .inflictsCurse,
            ]),
        )
    }
}

struct SavingThrowCodableTests {
    @Test(arguments: SavingThrow.allCases)
    func `Saving throws`(_ savingThrow: SavingThrow) throws {
        try testCodable(
            json: """
            "\(savingThrow.rawValue)"
            """,
            value: savingThrow,
        )
    }
}

struct SenseCodableTests {
    @Test(arguments: Sense.allCases)
    func senses(_ sense: Sense) throws {
        try testCodable(
            json: """
            "\(sense.rawValue)"
            """,
            value: sense,
        )
    }

    @Test(arguments: Sense.tags)
    func `Tagged senses`(sense: Sense, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(sense),
        )
    }

    @Test
    func `Tagged senses set`() throws {
        try testCodable(
            json: """
            [
                "B",
                "T"
            ]
            """,
            value: TagSet<Sense>([
                .blindsight,
                .tremorsense,
            ]),
        )
    }
}

struct SidekickTypeCodableTests {
    @Test(arguments: SidekickType.allCases)
    func `Sidekick types`(_ sidekickType: SidekickType) throws {
        try testCodable(
            json: """
            "\(sidekickType.rawValue)"
            """,
            value: sidekickType,
        )
    }
}

struct SizeCodableTests {
    @Test(arguments: Size.allCases)
    func sizes(_ size: Size) throws {
        try testCodable(
            json: """
            "\(size.rawValue)"
            """,
            value: size,
        )
    }

    @Test(arguments: Size.tags)
    func `Tagged sizes`(size: Size, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(size),
        )
    }

    @Test
    func `Tagged size set`() throws {
        try testCodable(
            json: """
            [
                "T",
                "S"
            ]
            """,
            value: TagSet<Size>([.tiny, .small]),
        )
    }
}

struct SizeComparableTests {
    static let testValues: [Bool] = [
        Size.tiny < Size.large,
        Size.medium < Size.huge,
        Size.medium > Size.small,
        Size.large > Size.tiny,
        Size.small < Size.huge,
    ]

    @Test(arguments: testValues)
    func `Size comparisons`(_ testedValue: Bool) {
        #expect(testedValue)
    }
}

struct SkillCodableTests {
    @Test(arguments: Skill.allCases)
    func skills(_ skill: Skill) throws {
        try testCodable(
            json: """
            "\(skill.rawValue)"
            """,
            value: skill,
        )
    }
}

struct SpellcastingTypeCodableTests {
    @Test(arguments: SpellcastingType.allCases)
    func `Spellcasting types`(_ spellcastingType: SpellcastingType) throws {
        try testCodable(
            json: """
            "\(spellcastingType.rawValue)"
            """,
            value: spellcastingType,
        )
    }

    @Test(arguments: SpellcastingType.tags)
    func `Tagged spellcasting types`(spellcastingType: SpellcastingType, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(spellcastingType),
        )
    }

    @Test
    func `Tagged spellcasting types set`() throws {
        try testCodable(
            json: """
            [
                "P",
                "I",
            ]
            """,
            value: TagSet<SpellcastingType>([
                .innate,
                .psionics,
            ]),
        )
    }
}

struct ToolCodableTests {
    @Test(arguments: Tool.allCases)
    func tools(_ tool: Tool) throws {
        try testCodable(
            json: """
            "\(tool.rawValue)"
            """,
            value: tool,
        )
    }
}

struct TreasureCodableTests {
    @Test(arguments: Treasure.allCases)
    func treasure(_ treasure: Treasure) throws {
        try testCodable(
            json: """
            "\(treasure.rawValue)"
            """,
            value: treasure,
        )
    }
}

struct TraitTagCodableTests {
    @Test(arguments: TraitTag.allCases)
    func `Trait tags`(_ traitTag: TraitTag) throws {
        try testCodable(
            json: """
            "\(traitTag.rawValue)"
            """,
            value: traitTag,
        )
    }
}
