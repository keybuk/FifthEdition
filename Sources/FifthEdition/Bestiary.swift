//
//  Bestiary.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//
//  Derived from schema/site/bestiary/bestiary.json
//  Version: 1.21.56

import MemberwiseInit

@MemberwiseInit(.public)
public struct Creature: Equatable, Sendable {
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

        public subscript(_ skill: Skill) -> String? {
            get { skills[skill] }
            set { skills[skill] = newValue }
        }
    }

    @MemberwiseInit(.public)
    public struct ToolSet: Equatable, Sendable {
        @Init(label: "_")
        public var tools: [Tool: String] = [:]

        public subscript(_ tool: Tool) -> String? {
            get { tools[tool] }
            set { tools[tool] = newValue }
        }
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

    public var environment: Set<Environment>? = nil

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
    
    /// Returns the expected token path.
    public var tokenPath: String? {
        guard let name = token?.name ?? name,
              let source = token?.source ?? source else {
            return nil
        }

        let tokenName = String(
            name
                .replacingOccurrences(of: "Æ", with: "AE")
                .replacingOccurrences(of: "æ", with: "ae")
                .replacingOccurrences(of: "\"", with: "")
                .decomposedStringWithCanonicalMapping
                .unicodeScalars
                .filter { $0.isASCII }
        )

        return "bestiary/tokens/\(source)/\(tokenName).webp"
    }
}

// MARK: - Codable

extension Creature: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case shortName
        case alias
        case group
        case source
        case sourceNote = "sourceSub"
        case page
        case otherSources
        case additionalSources
        case reprintedAs
        case isReprinted
        case inSrd = "srd"
        case inSrd52 = "srd52"
        case inBasicRules = "basicRules"
        case inBasicRules2024 = "basicRules2024"
        case isLegacy = "legacy"
        case level
        case size
        case sizeNote
        case type
        case alignment
        case alignmentPrefix
        case armorClass = "ac"
        case hitPoints = "hp"
        case speed
        case initiative
        case str
        case dex
        case con
        case int
        case wis
        case cha
        case save
        case skill
        case tool
        case senses
        case passive
        case languages
        case proficiencyBonus = "pbNote"
        case challengeRating = "cr"
        case damageVulnerability = "vulnerable"
        case damageResistance = "resist"
        case damageImmunity = "immune"
        case conditionImmunity = "conditionImmune"
        case conditionInflict
        case conditionInflictLegendary
        case conditionInflictSpell
        case savingThrowForced
        case savingThrowForcedLegendary
        case savingThrowForcedSpell
        case damageDealt = "damageTags"
        case damageDealtLegendary = "damageTagsLegendary"
        case damageDealtSpell = "damageTagsSpell"
        case environment
        case spellcasting
        case trait
        case actionNote
        case actionHeader
        case action
        case bonusNote
        case bonusHeader
        case bonus
        case reactionNote
        case reactionHeader
        case reaction
        case legendaryGroup
        case legendaryActions
        case legendaryActionsLair
        case legendaryHeader
        case legendary
        case mythicHeader
        case mythic
        case footer
        case attachedItems
        case gear
        case treasure
        case actionTags
        case languageTags
        case miscTags
        case senseTags
        case spellcastingTags
        case traitTags
        case dragonCastingColor
        case dragonAge
        case summonedBySpell
        case summonedBySpellLevel
        case summonedByClass
        case summonedScaleByPlayerLevel
        case canBeFamiliar = "familiar"
        case isNamedCreature
        case isNPC
        case hasToken
        case token
        case tokenCredit
        case isTokenCustom = "tokenCustom"
        case foundryTokenScale
        case hasFluff
        case hasFluffImages
        case art = "altArt"
        case soundClip
    }
}

extension Creature.AbilityScore: Codable {
    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            self = .score(value)
        } else {
            let container = try decoder.container(keyedBy: SpecialCodingKeys.self)
            self = .special(try container.decode(String.self, forKey: .special))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .score(let score):
            var container = encoder.singleValueContainer()
            try container.encode(score)
        case .special(let special):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(special, forKey: .special)
        }
    }
}

extension Creature.Alignment: Codable {
    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Alignment.self) {
            self = .alignment(value)
        } else if let value = try? decoder.singleValueContainer().decode([Choice].self) {
            self = .choice(value)
        } else {
            var array = try decoder.unkeyedContainer()
            let container = try array.nestedContainer(keyedBy: SpecialCodingKeys.self)
            self = .special(try container.decode(String.self, forKey: .special))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .alignment(let options):
            var container = encoder.singleValueContainer()
            try container.encode(options)
        case .choice(let choices):
            var container = encoder.singleValueContainer()
            try container.encode(choices)
        case .special(let special):
            var array = encoder.unkeyedContainer()
            var container = array.nestedContainer(keyedBy: SpecialCodingKeys.self)
            try container.encode(special, forKey: .special)
        }
    }
}

extension Creature.ArmorClass: Codable {
    enum ObtainedCodingKeys: String, CodingKey {
        case ac
        case from
        case condition
        case braces
    }

    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            self = .ac(value)
        } else if let values = try? decoder.container(keyedBy: SpecialCodingKeys.self),
                  let value = try? values.decode(String.self, forKey: .special)
        {
            self = .special(value)
        } else {
            let container = try decoder.container(keyedBy: ObtainedCodingKeys.self)
            self = .obtained(
                try container.decode(Int.self, forKey: .ac),
                from: try container.decodeIfPresent([String].self, forKey: .from),
                condition: try container.decodeIfPresent(String.self, forKey: .condition),
                braces: try container.decodeIfPresent(Bool.self, forKey: .braces),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .ac(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .special(let value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case .obtained(let ac, let from, let condition, let braces):
            var container = encoder.container(keyedBy: ObtainedCodingKeys.self)
            try container.encode(ac, forKey: .ac)
            try container.encodeIfPresent(from, forKey: .from)
            try container.encodeIfPresent(condition, forKey: .condition)
            try container.encodeIfPresent(braces, forKey: .braces)
        }
    }
}

extension Creature.ChallengeRating: Codable {
    enum CodingKeys: String, CodingKey {
        case cr
        case lair
        case coven
        case xp
        case xpLair
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(String.self)
        {
            cr = value
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            cr = try container.decode(String.self, forKey: .cr)
            lair = try? container.decodeIfPresent(String.self, forKey: .lair)
            coven = try? container.decodeIfPresent(String.self, forKey: .coven)
            xp = try container.decodeIfPresent(Int.self, forKey: .xp)
            xpLair = try? container.decodeIfPresent(Int.self, forKey: .xpLair)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if lair == nil && coven == nil && xp == nil && xpLair == nil {
            var container = encoder.singleValueContainer()
            try container.encode(cr)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(cr, forKey: .cr)
            try container.encodeIfPresent(lair, forKey: .lair)
            try container.encodeIfPresent(coven, forKey: .coven)
            try container.encodeIfPresent(xp, forKey: .xp)
            try container.encodeIfPresent(xpLair, forKey: .xpLair)
        }
    }

}

extension Creature.ConditionImmunity: Codable {
    enum CodingKeys: String, CodingKey {
        case conditions = "conditionImmune"
        case preNote
        case note
        case conditional = "cond"
    }

    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(Condition.self)
        {
            self = .condition(value)
        } else if let container = try? decoder.container(keyedBy: SpecialCodingKeys.self),
                  let value = try? container.decode(String.self, forKey: .special)
        {
            self = .special(value)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self = .conditional(
                try container.decode(Set<Creature.ConditionImmunity>.self, forKey: .conditions),
                preNote: try container.decodeIfPresent(String.self, forKey: .preNote),
                note: try container.decodeIfPresent(String.self, forKey: .note),
                conditional: try container.decodeIfPresent(Bool.self, forKey: .conditional)
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .condition(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .special(let value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case .conditional(let conditions, let preNote, let note, let cond):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(conditions, forKey: .conditions)
            try container.encodeIfPresent(preNote, forKey: .preNote)
            try container.encodeIfPresent(note, forKey: .note)
            try container.encodeIfPresent(cond, forKey: .conditional)
        }
    }

}

extension Creature.CreatureType.Choice: Codable {
    enum ChoiceCodingKeys: String, CodingKey {
        case choose
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(CreatureType.self) {
            self = .type(value)
        } else {
            let values = try decoder.container(keyedBy: ChoiceCodingKeys.self)
            self = .choice(try values.decode(Set<CreatureType>.self, forKey: .choose))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .type(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .choice(let value):
            var values = encoder.container(keyedBy: ChoiceCodingKeys.self)
            try values.encode(value, forKey: .choose)
        }
    }
}

extension Creature.CreatureType: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case swarmSize
        case tags
        case sidekickType
        case sidekickTags
        case sidekickHidden
        case note
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(CreatureType.self) {
            type = .type(value)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decode(Choice.self, forKey: .type)
            swarmSize = try container.decodeIfPresent(Tagged<Size>.self, forKey: .swarmSize)?.value
            tags = try container.decodeIfPresent(Set<Tag>.self, forKey: .tags)
            sidekickType = try container.decodeIfPresent(SidekickType.self, forKey: .sidekickType)
            sidekickTags = try container.decodeIfPresent(Set<Tag>.self, forKey: .sidekickTags)
            sidekickHidden = try container.decodeIfPresent(Bool.self, forKey: .sidekickHidden)
            note = try container.decodeIfPresent(String.self, forKey: .note)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if case .type(let value) = type,
           swarmSize == nil && tags == nil && sidekickType == nil && sidekickTags == nil && sidekickHidden == nil && note == nil
        {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encodeIfPresent(Tagged(swarmSize), forKey: .swarmSize)
            try container.encodeIfPresent(tags, forKey: .tags)
            try container.encodeIfPresent(sidekickType, forKey: .sidekickType)
            try container.encodeIfPresent(sidekickTags, forKey: .sidekickTags)
            try container.encodeIfPresent(sidekickHidden, forKey: .sidekickHidden)
            try container.encodeIfPresent(note, forKey: .note)
        }
    }
}

extension Creature.DamageImmunity: Codable {
    enum CodingKeys: String, CodingKey {
        case damageTypes = "immune"
        case preNote
        case note
        case conditional = "cond"
    }

    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(DamageType.self)
        {
            self = .damage(value)
        } else if let container = try? decoder.container(keyedBy: SpecialCodingKeys.self),
                  let value = try? container.decode(String.self, forKey: .special)
        {
            self = .special(value)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self = .conditional(
                try container.decode(Set<Creature.DamageImmunity>.self, forKey: .damageTypes),
                preNote: try container.decodeIfPresent(String.self, forKey: .preNote),
                note: try container.decodeIfPresent(String.self, forKey: .note),
                conditional: try container.decodeIfPresent(Bool.self, forKey: .conditional)
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .damage(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .special(let value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case .conditional(let damageTypes, let preNote, let note, let cond):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(damageTypes, forKey: .damageTypes)
            try container.encodeIfPresent(preNote, forKey: .preNote)
            try container.encodeIfPresent(note, forKey: .note)
            try container.encodeIfPresent(cond, forKey: .conditional)
        }
    }

}

extension Creature.DamageResistance: Codable {
    enum CodingKeys: String, CodingKey {
        case damageTypes = "resist"
        case preNote
        case note
        case conditional = "cond"
    }

    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(DamageType.self)
        {
            self = .damage(value)
        } else if let container = try? decoder.container(keyedBy: SpecialCodingKeys.self),
                  let value = try? container.decode(String.self, forKey: .special)
        {
            self = .special(value)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self = .conditional(
                try container.decode(Set<Creature.DamageResistance>.self, forKey: .damageTypes),
                preNote: try container.decodeIfPresent(String.self, forKey: .preNote),
                note: try container.decodeIfPresent(String.self, forKey: .note),
                conditional: try container.decodeIfPresent(Bool.self, forKey: .conditional)
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .damage(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .special(let value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case .conditional(let damageTypes, let preNote, let note, let cond):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(damageTypes, forKey: .damageTypes)
            try container.encodeIfPresent(preNote, forKey: .preNote)
            try container.encodeIfPresent(note, forKey: .note)
            try container.encodeIfPresent(cond, forKey: .conditional)
        }
    }

}

extension Creature.DamageVulnerability: Codable {
    enum CodingKeys: String, CodingKey {
        case damageTypes = "vulnerable"
        case preNote
        case note
        case conditional = "cond"
    }

    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(DamageType.self)
        {
            self = .damage(value)
        } else if let container = try? decoder.container(keyedBy: SpecialCodingKeys.self),
                  let value = try? container.decode(String.self, forKey: .special)
        {
            self = .special(value)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self = .conditional(
                try container.decode(Set<Creature.DamageVulnerability>.self, forKey: .damageTypes),
                preNote: try container.decodeIfPresent(String.self, forKey: .preNote),
                note: try container.decodeIfPresent(String.self, forKey: .note),
                conditional: try container.decodeIfPresent(Bool.self, forKey: .conditional)
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .damage(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .special(let value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case .conditional(let damageTypes, let preNote, let note, let cond):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(damageTypes, forKey: .damageTypes)
            try container.encodeIfPresent(preNote, forKey: .preNote)
            try container.encodeIfPresent(note, forKey: .note)
            try container.encodeIfPresent(cond, forKey: .conditional)
        }
    }
}

extension Creature.Gear: Codable {
    enum CodingKeys: String, CodingKey {
        case item
        case quantity
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(String.self)
        {
            item = value
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            item = try container.decode(String.self, forKey: .item)
            quantity = try container.decode(Int.self, forKey: .quantity)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if quantity == nil {
            var container = encoder.singleValueContainer()
            try container.encode(item)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(item, forKey: .item)
            try container.encodeIfPresent(quantity, forKey: .quantity)
        }
    }
}


extension Creature.HitPoints: Codable {
    enum CodingKeys: String, CodingKey {
        case average
        case formula
    }

    enum SpecialCodingKeys: String, CodingKey {
        case special
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.container(keyedBy: SpecialCodingKeys.self),
           let value = try? container.decode(String.self, forKey: .special)
        {
            self = .special(value)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let formula = try container.decode(String.self, forKey: .formula)
            let average = try container.decode(Int.self, forKey: .average)

            if let notation = DiceNotation(formula) {
                if average == notation.average {
                    self = .hp(notation)
                } else {
                    self = .hp(notation, givenAverage: average)
                }
            } else {
                self = .unrollable(formula: formula, average: average)
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .hp(let notation, let givenAverage):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(notation.stringValue, forKey: .formula)
            try container.encode(givenAverage ?? notation.average, forKey: .average)
        case .unrollable(let formula, let average):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(formula, forKey: .formula)
            try container.encode(average, forKey: .average)
        case .special(let special):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(special, forKey: .special)
        }
    }
}

extension Creature.Initiative.Advantage: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        switch value {
        case "adv": self = .advantage
        case "dis": self = .disadvantage
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown value: \(value)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .advantage: try container.encode("adv")
        case .disadvantage: try container.encode("dis")
        }
    }
}

extension Creature.Initiative: Codable {
    enum CodingKeys: String, CodingKey {
        case initiative
        case proficiency
        case advantage = "advantageMode"
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            initiative = value
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            initiative = try container.decodeIfPresent(Int.self, forKey: .initiative)
            proficiency = try container.decodeIfPresent(Proficiency.self, forKey: .proficiency)
            advantage = try container.decodeIfPresent(Advantage.self, forKey: .advantage)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if let initiative, proficiency == nil && advantage == nil {
            var container = encoder.singleValueContainer()
            try container.encode(initiative)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(initiative, forKey: .initiative)
            try container.encodeIfPresent(proficiency, forKey: .proficiency)
            try container.encodeIfPresent(advantage, forKey: .advantage)
        }
    }
}

extension Creature.Passive: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .special(value)
        } else {
            self = .score(try container.decode(Int.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .score(let score):
            try container.encode(score)
        case .special(let special):
            try container.encode(special)
        }
    }
}

extension Creature.ShortName: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Bool.self), value {
            self = .useName
        } else {
            self = .name(try container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .name(let value): try container.encode(value)
        case .useName: try container.encode(true)
        }
    }
}

extension Creature.SkillSet: Codable {
    typealias CodingKeys = EnumCodingKey<Skill>

    enum OtherCodingKeys: String, CodingKey {
        case oneOf
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        for key in container.allKeys {
            if key.stringValue == "other" {
                continue
            }

            guard let value = key.value else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Unknown skill: \(key)")
            }
            skills[value] = try container.decodeIfPresent(String.self, forKey: key)
        }

        if var array = try? container.nestedUnkeyedContainer(forKey: CodingKeys(stringValue: "other")) {
            self.other = []
            while let nested = try? array.nestedContainer(keyedBy: OtherCodingKeys.self) {
                // If we try and decode [Skill: String] here, it looks for Array<Any>.
                let oneOf = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .oneOf)
                self.other?.append(
                    try CodingKeys.allCases
                        .reduce(into: [Skill: String]()) { result, key in
                            result[key.value!] = try oneOf.decodeIfPresent(String.self, forKey: key)
                        }
                )
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for key in CodingKeys.allCases {
            try container.encodeIfPresent(skills[key.value!], forKey: key)
        }

        if let other {
            var array = container.nestedUnkeyedContainer(forKey: CodingKeys(stringValue: "other"))
            for choice in other {
                var nested = array.nestedContainer(keyedBy: OtherCodingKeys.self)
                // If we encode choice here, it encodes it as an Array.
                var oneOf = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .oneOf)
                for key in CodingKeys.allCases {
                    try oneOf.encodeIfPresent(choice[key.value!], forKey: key)
                }
            }
        }
    }
}

extension Creature.ToolSet: Codable {
    typealias CodingKeys = EnumCodingKey<Tool>

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        for key in container.allKeys {
            guard let value = key.value else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Unknown tool: \(key)")
            }
            tools[value] = try container.decodeIfPresent(String.self, forKey: key)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for key in CodingKeys.allCases {
            try container.encodeIfPresent(tools[key.value!], forKey: key)
        }
    }
}

// MARK: - String Conversion

extension Creature.AbilityScore: CustomStringConvertible {
    public var description: String {
        switch self {
        case .score(let score): "\(score)"
        case .special(let special): special
        }
    }
}

extension Creature.Action: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "entries",
            values: name, entries,
        )
    }
}

extension Creature.Alignment.Choice: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "chance", "note",
            values: alignment, chance, note,
        )
    }
}

extension Creature.ArmorClass: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .ac(let ac):
            debugDescriptionOf(
                ".ac",
                names: "_",
                values: ac,
            )
        case .obtained(let ac, let from, let condition, let braces):
            debugDescriptionOf(
                ".obtained",
                names: "_", "from", "condition", "braces",
                values: ac, from, condition, braces,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.ChallengeRating: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "lair", "coven", "xp", "xpLair",
            values: cr, lair, coven, xp, xpLair,
        )
    }
}

extension Creature.ConditionImmunity: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .condition(let condition):
            debugDescriptionOf(
                ".condition",
                names: "_",
                values: condition,
            )
        case .conditional(let conditions, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: conditions, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.CreatureType: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: Swift.type(of: self)),
            names: "_", "swarmSize", "tags", "sidekickType", "sidekickTags", "sidekickHiden", "note",
            values: type, swarmSize, tags, sidekickType, sidekickTags, sidekickHidden, note,
        )
    }
}

extension Creature.DamageImmunity: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .damage(let damage):
            debugDescriptionOf(
                ".damage",
                names: "_",
                values: damage,
            )
        case .conditional(let damages, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: damages, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.DamageResistance: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .damage(let damage):
            debugDescriptionOf(
                ".damage",
                names: "_",
                values: damage,
            )
        case .conditional(let damages, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: damages, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.DamageVulnerability: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .damage(let damage):
            debugDescriptionOf(
                ".damage",
                names: "_",
                values: damage,
            )
        case .conditional(let damages, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: damages, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.Gear: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "quantity",
            values: item, quantity,
        )
    }
}

extension Creature.HitPoints: CustomStringConvertible {
    public var description: String {
        switch self {
        case .hp(let notation, nil): "\(notation)"
        case .hp(let notation, let givenAverage):
            "\(givenAverage!) or \(notation.stringValue)"
        case .unrollable(let formula, let average):
            "\(average) (\(formula))"
        case .special(let special): special
        }
    }
}

extension Creature.Passive: CustomStringConvertible {
    public var description: String {
        switch self {
        case .score(let score): "\(score)"
        case .special(let special): special
        }
    }
}

extension Creature.Save: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "str", "dex", "con", "int", "wis", "cha",
            values: str, dex, con, int, wis, cha,
        )
    }
}

extension Creature.ShortName: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .name(let name):
            debugDescriptionOf(
                ".name",
                names: "_",
                values: name,
            )
        case .useName: ".useName"
        }
    }
}

extension Creature.SkillSet: CustomDebugStringConvertible {
    public var debugDescription: String {
        if let other {
            debugDescriptionOf(
                String(describing: type(of: self)),
                names: "_", "other",
                values: skills, other,
            )
        } else {
            String(describing: skills)
        }
    }
}

extension Creature.ToolSet: CustomDebugStringConvertible {
    public var debugDescription: String {
        String(describing: tools)
    }
}

extension Creature.Trait: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: Swift.type(of: self)),
            names: "_", "entries", "type", "sort",
            values: name, entries, type, sort,
        )
    }
}

