//
//  Creature.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//
//  Derived from schema/site/bestiary/bestiary.json
//  Version: 1.21.56

import MemberwiseInit

@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Creature: Codable, Equatable, Sendable {
    public enum AbilityScore: Equatable, Sendable {
        case score(Int)
        case special(String)
    }

    @MemberwiseInit(.public)
    public struct Action: Codable, Equatable, Sendable {
        @Init(label: "_")
        public var name: String
        public var entries: [Entry]
    }

    public enum Alignment: Equatable, Sendable {
        @MemberwiseInit(.public, _optionalsDefaultNil: true)
        public struct Choice: Equatable, Codable, Sendable {
            public var alignment: FifthEdition.Alignment
            public var chance: Int?
            public var note: String?
        }

        case alignment(FifthEdition.Alignment)
        case choice([Choice])
        case special(String)
    }

    public enum ArmorClass: Equatable, Sendable {
        case ac(Int)
        case obtained(Int, from: [String]? = nil, condition: String? = nil, braces: Bool? = nil)
        case special(String)
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct ChallengeRating: Equatable, Sendable {
        @Init(label: "_")
        public var cr: String

        public var lair: String?
        public var coven: String?
        public var xp: Int?
        public var xpLair: Int?
    }

    public enum ConditionImmunity: Equatable, Hashable, Sendable {
        case condition(Condition)
        case conditional(Set<ConditionImmunity>, preNote: String? = nil, note: String? = nil, conditional: Bool? = nil)
        case special(String)
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct CreatureType: Equatable, Sendable {
        public enum Choice: Equatable, Sendable {
            case type(FifthEdition.CreatureType)
            case choice(Set<FifthEdition.CreatureType>)
        }

        @Init(label: "_")
        public var type: Choice

        public var swarmSize: Size?
        public var tags: Set<Tag>?
        public var sidekickType: SidekickType?
        public var sidekickTags: Set<Tag>?
        public var sidekickHidden: Bool?
        public var note: String?
    }

    public enum DamageImmunity: Equatable, Hashable, Sendable {
        case damage(DamageType)
        case conditional(Set<DamageImmunity>, preNote: String? = nil, note: String? = nil, conditional: Bool? = nil)
        case special(String)
    }

    public enum DamageResistance: Equatable, Hashable, Sendable {
        case damage(DamageType)
        case conditional(Set<DamageResistance>, preNote: String? = nil, note: String? = nil, conditional: Bool? = nil)
        case special(String)
    }

    public enum DamageVulnerability: Equatable, Hashable, Sendable {
        case damage(DamageType)
        case conditional(
            Set<DamageVulnerability>,
            preNote: String? = nil,
            note: String? = nil,
            conditional: Bool? = nil,
        )
        case special(String)
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct Gear: Equatable, Sendable {
        @Init(label: "_")
        public var item: String

        public var quantity: Int?
    }

    public enum HitPoints: Equatable, Sendable {
        case hp(DiceNotation, givenAverage: Int? = nil)
        case unrollable(formula: String, average: Int)
        case special(String)
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct Initiative: Equatable, Sendable {
        public enum Advantage: Equatable, Sendable {
            case advantage
            case disadvantage
        }

        public var initiative: Int?
        public var proficiency: Proficiency?
        public var advantage: Advantage?
    }

    @MemberwiseInit(.public)
    public struct LegendaryGroup: Codable, Equatable, Sendable {
        public var name: String
        public var source: String
    }

    public enum Passive: Equatable, Sendable {
        case score(Int)
        case special(String)
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct Save: Codable, Equatable, Sendable {
        // FIXME: Convert this into a SavingThrow-indexed dictionary like skills.
        public var str: String?
        public var dex: String?
        public var con: String?
        public var int: String?
        public var wis: String?
        public var cha: String?
    }

    public enum ShortName: Equatable, Sendable {
        case name(String)
        case useName
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct SkillSet: Equatable, Sendable {
        @Init(label: "_")
        public var skills: [Skill: String] = [:]

        public var other: [[Skill: String]]?
    }

    @MemberwiseInit(.public)
    public struct ToolSet: Equatable, Sendable {
        @Init(label: "_")
        public var tools: [Tool: String] = [:]
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct Trait: Codable, Equatable, Sendable {
        public enum TraitType: String, Codable, Equatable, Sendable {
            case entries
            case inset
        }

        @Init(label: "_")
        public var name: String
        public var entries: [Entry]

        public var type: TraitType?
        public var sort: Int?
    }

    public var name: String?
    public var shortName: ShortName?
    public var alias: [String]?
    public var group: [String]?

    public var source: String?
    public var sourceNote: String?
    public var page: Page?
    public var otherSources: Set<Source>?
    public var additionalSources: Set<Source>?
    public var inSrd: SrdReference?
    public var inSrd52: SrdReference?
    public var inBasicRules: Bool?
    public var inBasicRules2024: Bool?
    public var isLegacy: Bool?

    public var reprintedAs: Set<Reprint>?
    public var isReprinted: Bool?

    public var level: Int?

    public var size: TagSet<Size>?
    public var sizeNote: String?

    public var type: CreatureType?

    public var alignment: Alignment?
    public var alignmentPrefix: String?

    public var armorClass: [ArmorClass]?
    public var hitPoints: HitPoints?
    public var speed: Speed?
    public var initiative: Initiative?

    public var str: AbilityScore?
    public var dex: AbilityScore?
    public var con: AbilityScore?
    public var int: AbilityScore?
    public var wis: AbilityScore?
    public var cha: AbilityScore?

    public var save: Save?
    public var skill: SkillSet?
    public var tool: ToolSet?
    public var senses: [String]?
    public var passive: Passive?
    public var languages: Set<String>?
    public var proficiencyBonus: String?
    public var challengeRating: ChallengeRating?

    public var damageVulnerability: Set<DamageVulnerability>?
    public var damageResistance: Set<DamageResistance>?
    public var damageImmunity: Set<DamageImmunity>?
    public var conditionImmunity: Set<ConditionImmunity>?

    public var conditionInflict: Set<Condition>?
    public var conditionInflictLegendary: Set<Condition>?
    public var conditionInflictSpell: Set<Condition>?

    public var savingThrowForced: Set<SavingThrow>?
    public var savingThrowForcedLegendary: Set<SavingThrow>?
    public var savingThrowForcedSpell: Set<SavingThrow>?

    public var damageDealt: TagSet<DamageType>?
    public var damageDealtLegendary: TagSet<DamageType>?
    public var damageDealtSpell: TagSet<DamageType>?

    public var environment: Set<EnvironmentType>?

    public var spellcasting: [Spellcasting]?
    public var trait: [Trait]?

    public var actionNote: String?
    public var actionHeader: [Entry]?
    public var action: [Action]?

    public var bonusNote: String?
    public var bonusHeader: [Entry]?
    public var bonus: [Action]?

    public var reactionNote: String?
    public var reactionHeader: [Entry]?
    public var reaction: [Action]?

    public var legendaryGroup: LegendaryGroup?
    public var legendaryActions: Int?
    public var legendaryActionsLair: Int?
    public var legendaryHeader: [Entry]?
    public var legendary: [Action]?

    public var mythicHeader: [Entry]?
    public var mythic: [Action]?

    public var footer: [Entry]?

    public var attachedItems: Set<String>?
    public var gear: [Gear]?
    public var treasure: Set<Treasure>?

    public var actionTags: Set<ActionTag>?
    public var languageTags: TagSet<LanguageTag>?
    public var miscTags: TagSet<MiscTag>?
    public var senseTags: TagSet<Sense>?
    public var spellcastingTags: TagSet<SpellcastingType>?
    public var traitTags: Set<TraitTag>?

    public var dragonCastingColor: DragonColor?
    public var dragonAge: DragonAge?

    public var summonedBySpell: String?
    public var summonedBySpellLevel: Int?
    public var summonedByClass: String?
    public var summonedScaleByPlayerLevel: Bool?

    public var canBeFamiliar: Bool?
    public var isNamedCreature: Bool?
    public var isNPC: Bool?

    public var hasToken: Bool?
    public var token: Token?
    public var tokenCredit: String?
    public var isTokenCustom: Bool?
    public var foundryTokenScale: Float?
    public var hasFluff: Bool?
    public var hasFluffImages: Bool?
    public var art: [ArtItem]?
    public var soundClip: MediaHref?

    // TODO: variant, ? defs/entryVariantBestiary
    // TODO: _versions, array /creatureVersion
    // TODO: _isCopy, _copy
}
