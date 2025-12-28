//
//  Bestiary.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import MemberwiseInit

@MemberwiseInit(.public)
public struct Creature: Equatable, Sendable {
    public enum ShortName: Equatable, Sendable {
        case name(String)
        case useName
    }

    @MemberwiseInit(.public)
    public struct CreatureType: Equatable, Sendable {
        public enum Choice: Equatable, Sendable {
            case type(FifthEdition.CreatureType)
            case choice(Set<FifthEdition.CreatureType>)
        }

        public enum SidekickType: String, CaseIterable, Codable, Sendable {
            case expert
            case spellcaster
            case warrior
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

    public enum HitPoints: Equatable, Sendable {
        case hp(DiceNotation)
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

    public enum AbilityScore: Equatable, Sendable {
        case score(Int)
        case special(String)
    }

    @MemberwiseInit(.public)
    public struct Save: Equatable, Codable, Sendable {
        public var str: String? = nil
        public var dex: String? = nil
        public var con: String? = nil
        public var int: String? = nil
        public var wis: String? = nil
        public var cha: String? = nil
    }

    @MemberwiseInit(.public)
    public struct SkillSet: Equatable, Sendable {
        @Init(label: "_")
        public var modifier: [Skill: String] = [:]

        public var other: [[Skill: String]]? = nil

        public subscript(_ skill: Skill) -> String? {
            get { modifier[skill] }
            set { modifier[skill] = newValue }
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

    public enum Passive: Equatable, Sendable {
        case score(Int)
        case special(String)
    }

    @MemberwiseInit(.public)
    public struct ChallengeRating: Equatable, Sendable {
        @Init(label: "_")
        public var cr: String

        public var lair: String? = nil
        public var coven: String? = nil
        public var xp: String? = nil
        public var xpLair: String? = nil
    }

    @MemberwiseInit(.public)
    public struct Gear: Equatable, Sendable {
        @Init(label: "_")
        public var item: String

        public var quantity: Int? = nil
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

    public var reprintedAs: Set<Reprint>? = nil
    public var isReprinted: Bool? = nil

    public var level: Int? = nil

    public var size: Set<Size>? = nil
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
    public var gear: [Gear]? = nil
    public var senses: [String]? = nil
    public var passive: Passive? = nil
    public var languages: Set<String>? = nil
    public var proficiencyBonus: String? = nil
    public var challengeRating: ChallengeRating? = nil
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
        case gear
        case tool
        case senses
        case passive
        case languages
        case proficiencyBonus = "pbNote"
        case challengeRating = "cr"
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
            swarmSize = try container.decodeIfPresent(Size.self, forKey: .swarmSize)
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
            try container.encodeIfPresent(swarmSize, forKey: .swarmSize)
            try container.encodeIfPresent(tags, forKey: .tags)
            try container.encodeIfPresent(sidekickType, forKey: .sidekickType)
            try container.encodeIfPresent(sidekickTags, forKey: .sidekickTags)
            try container.encodeIfPresent(sidekickHidden, forKey: .sidekickHidden)
            try container.encodeIfPresent(note, forKey: .note)
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

            guard let value = DiceNotation(formula) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .formula,
                    in: container,
                    debugDescription: "Not a valid dice expression"
                )
            }
            guard value.average == average else {
                throw DecodingError.dataCorruptedError(
                    forKey: .average,
                    in: container,
                    debugDescription: "Does not match formula"
                )
            }

            self = .hp(value)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .hp(let expression):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(expression.stringValue, forKey: .formula)
            try container.encode(expression.average, forKey: .average)
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

extension Creature.SkillSet: Codable {
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) { nil }
    }

    enum OtherCodingKeys: String, CodingKey {
        case oneOf
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for skill in Skill.allCases {
            let key = DynamicCodingKeys(stringValue: skill.rawValue)!
            if let value = try container.decodeIfPresent(String.self, forKey: key) {
                modifier[skill] = value
            }
        }

        let key = DynamicCodingKeys(stringValue: "other")!
        if var array = try? container.nestedUnkeyedContainer(forKey: key) {
            other = []
            while let nested = try? array.nestedContainer(keyedBy: OtherCodingKeys.self) {
                let oneOf = try nested.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .oneOf)
                var choice: [Skill: String] = [:]
                for skill in Skill.allCases {
                    let key = DynamicCodingKeys(stringValue: skill.rawValue)!
                    if let value = try oneOf.decodeIfPresent(String.self, forKey: key) {
                        choice[skill] = value
                    }
                }
                other!.append(choice)
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        for skill in Skill.allCases {
            if let value = modifier[skill] {
                let key = DynamicCodingKeys(stringValue: skill.rawValue)!
                try container.encode(value, forKey: key)
            }
        }

        if let other {
            let key = DynamicCodingKeys(stringValue: "other")!
            var array = container.nestedUnkeyedContainer(forKey: key)
            for choice in other {
                var nested = array.nestedContainer(keyedBy: OtherCodingKeys.self)
                var oneOf = nested.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .oneOf)
                for (skill, value) in choice {
                    let key = DynamicCodingKeys(stringValue: skill.rawValue)!
                    try oneOf.encode(value, forKey: key)
                }
            }
        }
    }

}

extension Creature.ToolSet: Codable {
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) { nil }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for tool in Tool.allCases {
            let key = DynamicCodingKeys(stringValue: tool.rawValue)!
            if let value = try container.decodeIfPresent(String.self, forKey: key) {
                tools[tool] = value
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        for tool in Tool.allCases {
            if let value = tools[tool] {
                let key = DynamicCodingKeys(stringValue: tool.rawValue)!
                try container.encode(value, forKey: key)
            }
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
            xp = try container.decodeIfPresent(String.self, forKey: .xp)
            xpLair = try? container.decodeIfPresent(String.self, forKey: .xpLair)
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
