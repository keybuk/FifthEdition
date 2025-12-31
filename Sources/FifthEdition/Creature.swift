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
        @Init(label: "_")
        public var name: String
        public var entries: [Entry]
    }

    public enum Alignment: Equatable, Sendable {
        @MemberwiseInit(.public)
        public struct Choice: Equatable, Codable, Sendable {
            public var alignment: FifthEdition.Alignment
            public var chance: Int? = nil
            public var note: String? = nil
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
        @Init(label: "_")
        public var cr: String

        public var lair: String? = nil
        public var coven: String? = nil
        public var xp: Int? = nil
        public var xpLair: Int? = nil
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

        @Init(label: "_")
        public var type: Choice

        public var swarmSize: Size? = nil
        public var tags: Set<Tag>? = nil
        public var sidekickType: SidekickType? = nil
        public var sidekickTags: Set<Tag>? = nil
        public var sidekickHidden: Bool? = nil
        public var note: String? = nil
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
        @Init(label: "_")
        public var item: String

        public var quantity: Int? = nil
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

        public var initiative: Int? = nil
        public var proficiency: Proficiency? = nil
        public var advantage: Advantage? = nil
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
        public var str: String? = nil
        public var dex: String? = nil
        public var con: String? = nil
        public var int: String? = nil
        public var wis: String? = nil
        public var cha: String? = nil
    }

    public enum ShortName: Equatable, Sendable {
        case name(String)
        case useName
    }

    @MemberwiseInit(.public)
    public struct SkillSet: Equatable, Sendable {
        @Init(label: "_")
        public var skills: [Skill: String] = [:]

        public var other: [[Skill: String]]? = nil
    }

    @MemberwiseInit(.public)
    public struct ToolSet: Equatable, Sendable {
        @Init(label: "_")
        public var tools: [Tool: String] = [:]
    }

    @MemberwiseInit(.public)
    public struct Trait: Codable, Equatable, Sendable {
        public enum TraitType: String, Codable, Equatable, Sendable {
            case entries
            case inset
        }

        @Init(label: "_")
        public var name: String
        public var entries: [Entry]

        public var type: TraitType? = nil
        public var sort: Int? = nil
    }

    public var name: String? = nil
    public var shortName: ShortName? = nil
    public var alias: [String]? = nil
    public var group: [String]? = nil

    public var source: String? = nil
    public var sourceNote: String? = nil
    public var page: Page? = nil
    public var otherSources: Set<Source>? = nil
    public var additionalSources: Set<Source>? = nil
    public var inSrd: SrdReference? = nil
    public var inSrd52: SrdReference? = nil
    public var inBasicRules: Bool? = nil
    public var inBasicRules2024: Bool? = nil
    public var isLegacy: Bool? = nil

    public var reprintedAs: Set<Reprint>? = nil
    public var isReprinted: Bool? = nil

    public var level: Int? = nil

    public var size: TagSet<Size>? = nil
    public var sizeNote: String? = nil

    public var type: CreatureType? = nil

    public var alignment: Alignment? = nil
    public var alignmentPrefix: String? = nil

    public var armorClass: [ArmorClass]? = nil
    public var hitPoints: HitPoints? = nil
    public var speed: Speed? = nil
    public var initiative: Initiative? = nil

    public var str: AbilityScore? = nil
    public var dex: AbilityScore? = nil
    public var con: AbilityScore? = nil
    public var int: AbilityScore? = nil
    public var wis: AbilityScore? = nil
    public var cha: AbilityScore? = nil

    public var save: Save? = nil
    public var skill: SkillSet? = nil
    public var tool: ToolSet? = nil
    public var senses: [String]? = nil
    public var passive: Passive? = nil
    public var languages: Set<String>? = nil
    public var proficiencyBonus: String? = nil
    public var challengeRating: ChallengeRating? = nil

    public var damageVulnerability: Set<DamageVulnerability>? = nil
    public var damageResistance: Set<DamageResistance>? = nil
    public var damageImmunity: Set<DamageImmunity>? = nil
    public var conditionImmunity: Set<ConditionImmunity>? = nil

    public var conditionInflict: Set<Condition>? = nil
    public var conditionInflictLegendary: Set<Condition>? = nil
    public var conditionInflictSpell: Set<Condition>? = nil

    public var savingThrowForced: Set<SavingThrow>? = nil
    public var savingThrowForcedLegendary: Set<SavingThrow>? = nil
    public var savingThrowForcedSpell: Set<SavingThrow>? = nil

    public var damageDealt: TagSet<DamageType>? = nil
    public var damageDealtLegendary: TagSet<DamageType>? = nil
    public var damageDealtSpell: TagSet<DamageType>? = nil

    public var environment: Set<EnvironmentType>? = nil

    public var spellcasting: [Spellcasting]? = nil
    public var trait: [Trait]? = nil

    public var actionNote: String? = nil
    public var actionHeader: [Entry]? = nil
    public var action: [Action]? = nil

    public var bonusNote: String? = nil
    public var bonusHeader: [Entry]? = nil
    public var bonus: [Action]? = nil

    public var reactionNote: String? = nil
    public var reactionHeader: [Entry]? = nil
    public var reaction: [Action]? = nil

    public var legendaryGroup: LegendaryGroup? = nil
    public var legendaryActions: Int? = nil
    public var legendaryActionsLair: Int? = nil
    public var legendaryHeader: [Entry]? = nil
    public var legendary: [Action]? = nil

    public var mythicHeader: [Entry]? = nil
    public var mythic: [Action]? = nil

    public var footer: [Entry]? = nil

    public var attachedItems: Set<String>? = nil
    public var gear: [Gear]? = nil
    public var treasure: Set<Treasure>? = nil

    public var actionTags: Set<ActionTag>? = nil
    public var languageTags: TagSet<LanguageTag>? = nil
    public var miscTags: TagSet<MiscTag>? = nil
    public var senseTags: TagSet<Sense>? = nil
    public var spellcastingTags: TagSet<SpellcastingType>? = nil
    public var traitTags: Set<TraitTag>? = nil

    public var dragonCastingColor: DragonColor? = nil
    public var dragonAge: DragonAge? = nil

    public var summonedBySpell: String? = nil
    public var summonedBySpellLevel: Int? = nil
    public var summonedByClass: String? = nil
    public var summonedScaleByPlayerLevel: Bool? = nil

    public var canBeFamiliar: Bool? = nil
    public var isNamedCreature: Bool? = nil
    public var isNPC: Bool? = nil

    public var hasToken: Bool? = nil
    public var token: Token? = nil
    public var tokenCredit: String? = nil
    public var isTokenCustom: Bool? = nil
    public var foundryTokenScale: Float? = nil
    public var hasFluff: Bool? = nil
    public var hasFluffImages: Bool? = nil
    public var art: [ArtItem]? = nil
    public var soundClip: MediaHref? = nil

    // TODO: variant, ? defs/entryVariantBestiary
    // TODO: _versions, array /creatureVersion
    // TODO: _isCopy, _copy
}
