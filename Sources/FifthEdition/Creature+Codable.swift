//
//  Creature+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

extension Creature {
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
            self = try .special(container.decode(String.self, forKey: .special))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .score(score):
            var container = encoder.singleValueContainer()
            try container.encode(score)
        case let .special(special):
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
            self = try .special(container.decode(String.self, forKey: .special))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .alignment(options):
            var container = encoder.singleValueContainer()
            try container.encode(options)
        case let .choice(choices):
            var container = encoder.singleValueContainer()
            try container.encode(choices)
        case let .special(special):
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
            self = try .obtained(
                container.decode(Int.self, forKey: .ac),
                from: container.decodeIfPresent([String].self, forKey: .from),
                condition: container.decodeIfPresent(String.self, forKey: .condition),
                braces: container.decodeIfPresent(Bool.self, forKey: .braces),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .ac(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let .special(value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case let .obtained(ac, from, condition, braces):
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
        if lair == nil, coven == nil, xp == nil, xpLair == nil {
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
            self = try .conditional(
                container.decode(Set<Creature.ConditionImmunity>.self, forKey: .conditions),
                preNote: container.decodeIfPresent(String.self, forKey: .preNote),
                note: container.decodeIfPresent(String.self, forKey: .note),
                conditional: container.decodeIfPresent(Bool.self, forKey: .conditional),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .condition(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let .special(value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case let .conditional(conditions, preNote, note, cond):
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
            self = try .choice(values.decode(Set<CreatureType>.self, forKey: .choose))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .type(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let .choice(value):
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
        if case let .type(value) = type,
           swarmSize == nil, tags == nil, sidekickType == nil, sidekickTags == nil, sidekickHidden == nil, note == nil
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
            self = try .conditional(
                container.decode(Set<Creature.DamageImmunity>.self, forKey: .damageTypes),
                preNote: container.decodeIfPresent(String.self, forKey: .preNote),
                note: container.decodeIfPresent(String.self, forKey: .note),
                conditional: container.decodeIfPresent(Bool.self, forKey: .conditional),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .damage(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let .special(value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case let .conditional(damageTypes, preNote, note, cond):
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
            self = try .conditional(
                container.decode(Set<Creature.DamageResistance>.self, forKey: .damageTypes),
                preNote: container.decodeIfPresent(String.self, forKey: .preNote),
                note: container.decodeIfPresent(String.self, forKey: .note),
                conditional: container.decodeIfPresent(Bool.self, forKey: .conditional),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .damage(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let .special(value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case let .conditional(damageTypes, preNote, note, cond):
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
            self = try .conditional(
                container.decode(Set<Creature.DamageVulnerability>.self, forKey: .damageTypes),
                preNote: container.decodeIfPresent(String.self, forKey: .preNote),
                note: container.decodeIfPresent(String.self, forKey: .note),
                conditional: container.decodeIfPresent(Bool.self, forKey: .conditional),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .damage(value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let .special(value):
            var container = encoder.container(keyedBy: SpecialCodingKeys.self)
            try container.encode(value, forKey: .special)
        case let .conditional(damageTypes, preNote, note, cond):
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
        case let .hp(notation, givenAverage):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(notation.stringValue, forKey: .formula)
            try container.encode(givenAverage ?? notation.average, forKey: .average)
        case let .unrollable(formula, average):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(formula, forKey: .formula)
            try container.encode(average, forKey: .average)
        case let .special(special):
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
                debugDescription: "Unknown value: \(value)",
            )
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
        if let initiative, proficiency == nil, advantage == nil {
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
            self = try .score(container.decode(Int.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .score(score):
            try container.encode(score)
        case let .special(special):
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
            self = try .name(container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .name(value): try container.encode(value)
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
                    debugDescription: "Unknown skill: \(key)",
                )
            }
            skills[value] = try container.decodeIfPresent(String.self, forKey: key)
        }

        if var array = try? container.nestedUnkeyedContainer(forKey: CodingKeys(stringValue: "other")) {
            other = []
            while let nested = try? array.nestedContainer(keyedBy: OtherCodingKeys.self) {
                // If we try and decode [Skill: String] here, it looks for Array<Any>.
                let oneOf = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .oneOf)
                try other?.append(
                    CodingKeys.allCases
                        .reduce(into: [Skill: String]()) { result, key in
                            result[key.value!] = try oneOf.decodeIfPresent(String.self, forKey: key)
                        },
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
                    debugDescription: "Unknown tool: \(key)",
                )
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
