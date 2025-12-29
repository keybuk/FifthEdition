//
//  EnumTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
//

import Testing
@testable import FifthEdition

struct ActionTagCodableTests {

    @Test("Action tags", arguments: ActionTag.allCases)
    func actionTag(_ actionTag: ActionTag) throws {
        try testCodable(
            json: """
            "\(actionTag.rawValue)"
            """,
            value: actionTag
        )
    }

}

struct ConditionCodableTests {

    @Test("Conditions", arguments: Condition.allCases)
    func condition(_ condition: Condition) throws {
        try testCodable(
            json: """
            "\(condition.rawValue)"
            """,
            value: condition
        )
    }

}

struct CreatureTypeCodableTests {

    @Test("Creature types", arguments: CreatureType.allCases)
    func creatureType(_ creatureType: CreatureType) throws {
        try testCodable(
            json: """
            "\(creatureType.rawValue)"
            """,
            value: creatureType
        )
    }

}

struct DamageTypeCodableTests {

    @Test("Damage types", arguments: DamageType.allCases)
    func damageType(_ damageType: DamageType) throws {
        try testCodable(
            json: """
            "\(damageType.rawValue)"
            """,
            value: damageType
        )
    }

    @Test("Tagged damage types", arguments: DamageType.tags)
    func taggedDamageType(damageType: DamageType, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(damageType)
        )
    }

    @Test("Tagged damage type set")
    func taggedDamageTypeSet() throws {
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

    @Test("Dragon ages", arguments: DragonAge.allCases)
    func dragonAge(_ dragonAge: DragonAge) throws {
        try testCodable(
            json: """
            "\(dragonAge.rawValue)"
            """,
            value: dragonAge
        )
    }

}

struct DragonColorCodableTests {

    @Test("Dragon colors", arguments: DragonColor.allCases)
    func dragonColor(_ dragonColor: DragonColor) throws {
        try testCodable(
            json: """
            "\(dragonColor.rawValue)"
            """,
            value: dragonColor
        )
    }

}

struct EditionCodableTests {

    @Test("Editions", arguments: Edition.allCases)
    func editon(_ edition: Edition) throws {
        try testCodable(
            json: """
            "\(edition.rawValue)"
            """,
            value: edition
        )
    }

}

struct EnvironmentCodableTests {

    @Test("Environments", arguments: Environment.allCases)
    func environment(_ environment: Environment) throws {
        try testCodable(
            json: """
            "\(environment.rawValue)"
            """,
            value: environment
        )
    }

}

struct LanguageTagCodableTests {

    @Test("Language tag", arguments: LanguageTag.allCases)
    func languageTag(_ languageTag: LanguageTag) throws {
        try testCodable(
            json: """
            "\(languageTag.rawValue)"
            """,
            value: languageTag
        )
    }

    @Test("Tagged language tags", arguments: LanguageTag.tags)
    func taggedLanguageTag(languageTag: LanguageTag, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(languageTag)
        )
    }

    @Test("Tagged language tags set")
    func taggedLanguageTagSet() throws {
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

    @Test("Misc tag", arguments: MiscTag.allCases)
    func miscTag(_ miscTag: MiscTag) throws {
        try testCodable(
            json: """
            "\(miscTag.rawValue)"
            """,
            value: miscTag
        )
    }

    @Test("Tagged misc tags", arguments: MiscTag.tags)
    func taggedMiscTag(miscTag: MiscTag, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(miscTag)
        )
    }

    @Test("Tagged misc tags set")
    func taggedMiscTagSet() throws {
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

    @Test("Saving throws", arguments: SavingThrow.allCases)
    func savingThrow(_ savingThrow: SavingThrow) throws {
        try testCodable(
            json: """
            "\(savingThrow.rawValue)"
            """,
            value: savingThrow
        )
    }

}

struct SenseCodableTests {

    @Test("Senses", arguments: Sense.allCases)
    func sense(_ sense: Sense) throws {
        try testCodable(
            json: """
            "\(sense.rawValue)"
            """,
            value: sense
        )
    }

    @Test("Tagged senses", arguments: Sense.tags)
    func taggedSense(sense: Sense, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(sense)
        )
    }

    @Test("Tagged senses set")
    func taggedSenseSet() throws {
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

    @Test("Sidekick types", arguments: SidekickType.allCases)
    func sidekickType(_ sidekickType: SidekickType) throws {
        try testCodable(
            json: """
            "\(sidekickType.rawValue)"
            """,
            value: sidekickType
        )
    }

}

struct SizeCodableTests {

    @Test("Sizes", arguments: Size.allCases)
    func size(_ size: Size) throws {
        try testCodable(
            json: """
            "\(size.rawValue)"
            """,
            value: size
        )
    }

    @Test("Tagged sizes", arguments: Size.tags)
    func taggedSize(size: Size, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(size)
        )
    }

    @Test("Tagged size set")
    func taggedSizeSet() throws {
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

    @Test("Size comparisons", arguments: testValues)
    func sizeComparison(_ testedValue: Bool) {
        #expect(testedValue)
    }
}

struct SkillCodableTests {

    @Test("Skills", arguments: Skill.allCases)
    func skill(_ skill: Skill) throws {
        try testCodable(
            json: """
            "\(skill.rawValue)"
            """,
            value: skill
        )
    }

}

struct SpellcastingTypeCodableTests {

    @Test("Spellcasting types", arguments: SpellcastingType.allCases)
    func spellcastingType(_ spellcastingType: SpellcastingType) throws {
        try testCodable(
            json: """
            "\(spellcastingType.rawValue)"
            """,
            value: spellcastingType
        )
    }

    @Test("Tagged spellcasting types", arguments: SpellcastingType.tags)
    func taggedSpellcastingType(spellcastingType: SpellcastingType, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(spellcastingType)
        )
    }

    @Test("Tagged spellcasting types set")
    func taggedSpellcastingTypeSet() throws {
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

    @Test("Tools", arguments: Tool.allCases)
    func tool(_ tool: Tool) throws {
        try testCodable(
            json: """
            "\(tool.rawValue)"
            """,
            value: tool
        )
    }

}

struct TreasureCodableTests {

    @Test("Treasure", arguments: Treasure.allCases)
    func treasure(_ treasure: Treasure) throws {
        try testCodable(
            json: """
            "\(treasure.rawValue)"
            """,
            value: treasure
        )
    }

}

struct TraitTagCodableTests {

    @Test("Trait tags", arguments: TraitTag.allCases)
    func traitTag(_ traitTag: TraitTag) throws {
        try testCodable(
            json: """
            "\(traitTag.rawValue)"
            """,
            value: traitTag
        )
    }

}
