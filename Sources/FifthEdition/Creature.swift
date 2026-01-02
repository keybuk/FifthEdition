//
//  Creature.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//
//  Derived from schema/site/bestiary/bestiary.json
//  Version: 1.21.56

import MemberwiseInit

@MemberwiseInit(.public)
public struct Creature: Codable, Equatable, Sendable {
    public enum AbilityScore: Equatable, Sendable {
        case score(Int)
        case special(String)
    }

    @MemberwiseInit(.public)
    public struct Action: Codable, Equatable, Sendable {
        @Init(label: "_") public var name: String
        public var entries: [Entry]
    }

    public enum Alignment: Equatable, Sendable {
        @MemberwiseInit(.public)
        public struct Choice: Equatable, Codable, Sendable {
            public var alignment: FifthEdition.Alignment
            @Init(default: nil) public var chance: Int?
            @Init(default: nil) public var note: String?
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

    @MemberwiseInit(.public)
    public struct ChallengeRating: Equatable, Sendable {
        @Init(label: "_") public var cr: String

        @Init(default: nil) public var lair: String?
        @Init(default: nil) public var coven: String?
        @Init(default: nil) public var xp: Int?
        @Init(default: nil) public var xpLair: Int?
    }

    public enum ConditionImmunity: Equatable, Hashable, Sendable {
        case condition(Condition)
        case conditional(Set<ConditionImmunity>, preNote: String? = nil, note: String? = nil, conditional: Bool? = nil)
        case special(String)
    }

    @MemberwiseInit(.public)
    public struct CreatureType: Equatable, Sendable {
        public enum Choice: Equatable, Sendable {
            case type(FifthEdition.CreatureType)
            case choice(Set<FifthEdition.CreatureType>)
        }

        @Init(label: "_") public var type: Choice

        @Init(default: nil) public var swarmSize: Size?
        @Init(default: nil) public var tags: Set<Tag>?
        @Init(default: nil) public var sidekickType: SidekickType?
        @Init(default: nil) public var sidekickTags: Set<Tag>?
        @Init(default: nil) public var sidekickHidden: Bool?
        @Init(default: nil) public var note: String?
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
        case conditional(Set<DamageVulnerability>, preNote: String? = nil, note: String? = nil, conditional: Bool? = nil)
        case special(String)
    }

    @MemberwiseInit(.public)
    public struct Gear: Equatable, Sendable {
        @Init(label: "_") public var item: String

        @Init(default: nil) public var quantity: Int?
    }

    public enum HitPoints: Equatable, Sendable {
        case hp(DiceNotation, givenAverage: Int? = nil)
        case unrollable(formula: String, average: Int)
        case special(String)
    }

    @MemberwiseInit(.public)
    public struct Initiative: Equatable, Sendable {
        public enum Advantage: Equatable, Sendable {
            case advantage
            case disadvantage
        }

        @Init(default: nil) public var initiative: Int?
        @Init(default: nil) public var proficiency: Proficiency?
        @Init(default: nil) public var advantage: Advantage?
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

    @MemberwiseInit(.public)
    public struct Save: Codable, Equatable, Sendable {
        // FIXME: Convert this into a SavingThrow-indexed dictionary like skills.
        @Init(default: nil) public var str: String?
        @Init(default: nil) public var dex: String?
        @Init(default: nil) public var con: String?
        @Init(default: nil) public var int: String?
        @Init(default: nil) public var wis: String?
        @Init(default: nil) public var cha: String?
    }

    public enum ShortName: Equatable, Sendable {
        case name(String)
        case useName
    }

    @MemberwiseInit(.public)
    public struct SkillSet: Equatable, Sendable {
        @Init(label: "_") public var skills: [Skill: String] = [:]

        @Init(default: nil) public var other: [[Skill: String]]?
    }

    @MemberwiseInit(.public)
    public struct ToolSet: Equatable, Sendable {
        @Init(label: "_") public var tools: [Tool: String] = [:]
    }

    @MemberwiseInit(.public)
    public struct Trait: Codable, Equatable, Sendable {
        public enum TraitType: String, Codable, Equatable, Sendable {
            case entries
            case inset
        }

        @Init(label: "_") public var name: String
        public var entries: [Entry]

        @Init(default: nil) public var type: TraitType?
        @Init(default: nil) public var sort: Int?
    }

    @Init(default: nil) public var name: String?
    @Init(default: nil) public var shortName: ShortName?
    @Init(default: nil) public var alias: [String]?
    @Init(default: nil) public var group: [String]?

    @Init(default: nil) public var source: String?
    @Init(default: nil) public var sourceNote: String?
    @Init(default: nil) public var page: Page?
    @Init(default: nil) public var otherSources: Set<Source>?
    @Init(default: nil) public var additionalSources: Set<Source>?
    @Init(default: nil) public var inSrd: SrdReference?
    @Init(default: nil) public var inSrd52: SrdReference?
    @Init(default: nil) public var inBasicRules: Bool?
    @Init(default: nil) public var inBasicRules2024: Bool?
    @Init(default: nil) public var isLegacy: Bool?

    @Init(default: nil) public var reprintedAs: Set<Reprint>?
    @Init(default: nil) public var isReprinted: Bool?

    @Init(default: nil) public var level: Int?

    @Init(default: nil) public var size: TagSet<Size>?
    @Init(default: nil) public var sizeNote: String?

    @Init(default: nil) public var type: CreatureType?

    @Init(default: nil) public var alignment: Alignment?
    @Init(default: nil) public var alignmentPrefix: String?

    @Init(default: nil) public var armorClass: [ArmorClass]?
    @Init(default: nil) public var hitPoints: HitPoints?
    @Init(default: nil) public var speed: Speed?
    @Init(default: nil) public var initiative: Initiative?

    @Init(default: nil) public var str: AbilityScore?
    @Init(default: nil) public var dex: AbilityScore?
    @Init(default: nil) public var con: AbilityScore?
    @Init(default: nil) public var int: AbilityScore?
    @Init(default: nil) public var wis: AbilityScore?
    @Init(default: nil) public var cha: AbilityScore?

    @Init(default: nil) public var save: Save?
    @Init(default: nil) public var skill: SkillSet?
    @Init(default: nil) public var tool: ToolSet?
    @Init(default: nil) public var senses: [String]?
    @Init(default: nil) public var passive: Passive?
    @Init(default: nil) public var languages: Set<String>?
    @Init(default: nil) public var proficiencyBonus: String?
    @Init(default: nil) public var challengeRating: ChallengeRating?

    @Init(default: nil) public var damageVulnerability: Set<DamageVulnerability>?
    @Init(default: nil) public var damageResistance: Set<DamageResistance>?
    @Init(default: nil) public var damageImmunity: Set<DamageImmunity>?
    @Init(default: nil) public var conditionImmunity: Set<ConditionImmunity>?

    @Init(default: nil) public var conditionInflict: Set<Condition>?
    @Init(default: nil) public var conditionInflictLegendary: Set<Condition>?
    @Init(default: nil) public var conditionInflictSpell: Set<Condition>?

    @Init(default: nil) public var savingThrowForced: Set<SavingThrow>?
    @Init(default: nil) public var savingThrowForcedLegendary: Set<SavingThrow>?
    @Init(default: nil) public var savingThrowForcedSpell: Set<SavingThrow>?

    @Init(default: nil) public var damageDealt: TagSet<DamageType>?
    @Init(default: nil) public var damageDealtLegendary: TagSet<DamageType>?
    @Init(default: nil) public var damageDealtSpell: TagSet<DamageType>?

    @Init(default: nil) public var environment: Set<EnvironmentType>?

    @Init(default: nil) public var spellcasting: [Spellcasting]?
    @Init(default: nil) public var trait: [Trait]?

    @Init(default: nil) public var actionNote: String?
    @Init(default: nil) public var actionHeader: [Entry]?
    @Init(default: nil) public var action: [Action]?

    @Init(default: nil) public var bonusNote: String?
    @Init(default: nil) public var bonusHeader: [Entry]?
    @Init(default: nil) public var bonus: [Action]?

    @Init(default: nil) public var reactionNote: String?
    @Init(default: nil) public var reactionHeader: [Entry]?
    @Init(default: nil) public var reaction: [Action]?

    @Init(default: nil) public var legendaryGroup: LegendaryGroup?
    @Init(default: nil) public var legendaryActions: Int?
    @Init(default: nil) public var legendaryActionsLair: Int?
    @Init(default: nil) public var legendaryHeader: [Entry]?
    @Init(default: nil) public var legendary: [Action]?

    @Init(default: nil) public var mythicHeader: [Entry]?
    @Init(default: nil) public var mythic: [Action]?

    @Init(default: nil) public var footer: [Entry]?

    @Init(default: nil) public var attachedItems: Set<String>?
    @Init(default: nil) public var gear: [Gear]?
    @Init(default: nil) public var treasure: Set<Treasure>?

    @Init(default: nil) public var actionTags: Set<ActionTag>?
    @Init(default: nil) public var languageTags: TagSet<LanguageTag>?
    @Init(default: nil) public var miscTags: TagSet<MiscTag>?
    @Init(default: nil) public var senseTags: TagSet<Sense>?
    @Init(default: nil) public var spellcastingTags: TagSet<SpellcastingType>?
    @Init(default: nil) public var traitTags: Set<TraitTag>?

    @Init(default: nil) public var dragonCastingColor: DragonColor?
    @Init(default: nil) public var dragonAge: DragonAge?

    @Init(default: nil) public var summonedBySpell: String?
    @Init(default: nil) public var summonedBySpellLevel: Int?
    @Init(default: nil) public var summonedByClass: String?
    @Init(default: nil) public var summonedScaleByPlayerLevel: Bool?

    @Init(default: nil) public var canBeFamiliar: Bool?
    @Init(default: nil) public var isNamedCreature: Bool?
    @Init(default: nil) public var isNPC: Bool?

    @Init(default: nil) public var hasToken: Bool?
    @Init(default: nil) public var token: Token?
    @Init(default: nil) public var tokenCredit: String?
    @Init(default: nil) public var isTokenCustom: Bool?
    @Init(default: nil) public var foundryTokenScale: Float?
    @Init(default: nil) public var hasFluff: Bool?
    @Init(default: nil) public var hasFluffImages: Bool?
    @Init(default: nil) public var art: [ArtItem]?
    @Init(default: nil) public var soundClip: MediaHref?

    // TODO: variant, ? defs/entryVariantBestiary
    // TODO: _versions, array /creatureVersion
    // TODO: _isCopy, _copy
}
