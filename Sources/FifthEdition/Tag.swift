//
//  Tag.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

public enum ActionTag: String, CaseIterable, Codable, Sendable {
    case breathWeapon      = "Breath Weapon"
    case frightfulPresence = "Frightful Presence"
    case multiattack       = "Multiattack"
    case parry             = "Parry"
    case shapechanger      = "Shapechanger"
    case swallow           = "Swallow"
    case teleport          = "Teleport"
    case tentacles         = "Tentacles"
}

public enum LanguageTag: String, CaseIterable, Sendable {
    case any                     = "Any (Choose)"
    case all
    case cantSpeakKnownLanguages = "Can't Speak Known Languages"
    case languagesKnownInLife    = "Languages Known in Life"
    case telepathy
    case other
    case abyssal
    case aquan
    case auran
    case common
    case celestial
    case commonSignLanguage      = "Common Sign Language"
    case dwarvish
    case draconic
    case deepSpeech              = "Deep Speech"
    case druidic
    case elvish
    case gnomish
    case giant
    case goblin
    case gith
    case halfling
    case infernal
    case ignan
    case orc
    case primordial
    case sylvan
    case terran
    case thievesCant             = "Thieves' cant"
    case undercommon
}

public enum MiscTag: String, CaseIterable, Sendable {
    case hasAreasOfEffect       = "Has Areas of Effect"
    case inflictsCurse          = "Inflicts Curse"
    case inflictsDisease        = "Inflicts Disease"
    case hasHPReduction         = "Has HP Reduction"
    case hasMeleeWeaponAttacks  = "Has Weapon Attacks, Melee"
    case hasRangedWeaponAttacks = "Has Weapon Attacks, Ranged"
    case hasRangedAttacks       = "Has Attacks, Ranged"
    case hasMeleeAttacks        = "Has Attacks, Melee"
    case hasReachAttacks        = "Has Reach Attacks"
    case hasMeleeWeapons        = "Has Melee Weapons"
    case hasRangedWeapons       = "Has Ranged Weapons"
    case hasThrownWeapons       = "Has Thrown Weapons"
}

public enum SenseTag: String, CaseIterable, Sendable {
    case blindsight
    case darkvision
    case superiorDarkvision
    case tremorsense
    case truesight
}

public enum SpellcastingTag: String, CaseIterable, Sendable {
    case psionics
    case innate
    case formOnly  = "Form Only"
    case shared
    case other
    case artificer = "Class, Artificer"
    case bard      = "Class, Bard"
    case cleric    = "Class, Cleric"
    case druid     = "Class, Druid"
    case paladin   = "Class, Paladin"
    case ranger    = "Class, Ranger"
    case sorcerer  = "Class, Sorcerer"
    case warlock   = "Class, Warlock"
    case wizard    = "Class, Wizard"
}

public enum TraitTag: String, CaseIterable, Codable, Sendable {
    case aggressive              = "Aggressive"
    case ambusher                = "Ambusher"
    case amorphous               = "Amorphous"
    case amphibious              = "Amphibious"
    case antimagicSusceptibility = "Antimagic Susceptibility"
    case beastOfBurden           = "Beast of Burden"
    case brute                   = "Brute"
    case camouflage              = "Camouflage"
    case charge                  = "Charge"
    case damageAbsorption        = "Damage Absorption"
    case deathBurst              = "Death Burst"
    case devilsSight             = "Devil's Sight"
    case falseAppearance         = "False Appearance"
    case feyAncestry             = "Fey Ancestry"
    case flyby                   = "Flyby"
    case holdBreath              = "Hold Breath"
    case illumination            = "Illumination"
    case immutableForm           = "Immutable Form"
    case incorporealMovement     = "Incorporeal Movement"
    case keenSenses              = "Keen Senses"
    case legendaryResistances    = "Legendary Resistances"
    case lightSensitivity        = "Light Sensitivity"
    case magicResistance         = "Magic Resistance"
    case magicWeapons            = "Magic Weapons"
    case mimicry                 = "Mimicry"
    case packTactics             = "Pack Tactics"
    case pounce                  = "Pounce"
    case rampage                 = "Rampage"
    case reckless                = "Reckless"
    case regeneration            = "Regeneration"
    case rejuvenation            = "Rejuvenation"
    case shapechanger            = "Shapechanger"
    case siegeMonster            = "Siege Monster"
    case sneakAttack             = "Sneak Attack"
    case spellImmunity           = "Spell Immunity"
    case spiderClimb             = "Spider Climb"
    case sunlightSensitivity     = "Sunlight Sensitivity"
    case treeStride              = "Tree Stride"
    case tunneler                = "Tunneler"
    case turnImmunity            = "Turn Immunity"
    case turnResistance          = "Turn Resistance"
    case undeadFortitude         = "Undead Fortitude"
    case unusualNature           = "Unusual Nature"
    case waterBreathing          = "Water Breathing"
    case webSense                = "Web Sense"
    case webWalker               = "Web Walker"
}

// MARK: - Codable

extension LanguageTag: Codable {
    public static let codingMap: [(String, LanguageTag)] = [
        ("X",   .any),
        ("XX",  .all),
        ("CS",  .cantSpeakKnownLanguages),
        ("LF",  .languagesKnownInLife),
        ("TP",  .telepathy),
        ("OTH", .other),
        ("AB",  .abyssal),
        ("AQ",  .aquan),
        ("AU",  .auran),
        ("C",   .common),
        ("CE",  .celestial),
        ("CSL", .commonSignLanguage),
        ("D",   .dwarvish),
        ("DR",  .draconic),
        ("DS",  .deepSpeech),
        ("DU",  .druidic),
        ("E",   .elvish),
        ("G",   .gnomish),
        ("GI",  .giant),
        ("GO",  .goblin),
        ("GTH", .gith),
        ("H",   .halfling),
        ("I",   .infernal),
        ("IG",  .ignan),
        ("O",   .orc),
        ("P",   .primordial),
        ("S",   .sylvan),
        ("T",   .terran),
        ("TC",  .thievesCant),
        ("U",   .undercommon),
    ]

    static func value(for key: String) -> Self? {
        codingMap.first { this in
            this.0 == key
        }?.1
    }

    static func key(for value: Self) -> String? {
        codingMap.first { this in
            this.1 == value
        }?.0
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let tag = try container.decode(String.self)
        guard let value = Self.value(for: tag) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown tag: \(tag)")
        }

        self = value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Self.key(for: self)!)
    }
}

extension MiscTag: Codable {
    public static let codingMap: [(String, MiscTag)] = [
        ("AOE", .hasAreasOfEffect),
        ("CUR", .inflictsCurse),
        ("DIS", .inflictsDisease),
        ("HPR", .hasHPReduction),
        ("MW",  .hasMeleeWeaponAttacks),
        ("RW",  .hasRangedWeaponAttacks),
        ("MA",  .hasRangedAttacks),
        ("RA",  .hasMeleeAttacks),
        ("RCH", .hasReachAttacks),
        ("MLW", .hasMeleeWeapons),
        ("RNG", .hasRangedWeapons),
        ("THW", .hasThrownWeapons),
    ]

    static func value(for key: String) -> Self? {
        codingMap.first { this in
            this.0 == key
        }?.1
    }

    static func key(for value: Self) -> String? {
        codingMap.first { this in
            this.1 == value
        }?.0
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let tag = try container.decode(String.self)
        guard let value = Self.value(for: tag) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown tag: \(tag)")
        }

        self = value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Self.key(for: self)!)
    }
}

extension SenseTag: Codable {
    public static let codingMap: [(String, SenseTag)] = [
        ("B",  .blindsight),
        ("D",  .darkvision),
        ("SD", .superiorDarkvision),
        ("T",  .tremorsense),
        ("U",  .truesight),
    ]

    static func value(for key: String) -> Self? {
        codingMap.first { this in
            this.0 == key
        }?.1
    }

    static func key(for value: Self) -> String? {
        codingMap.first { this in
            this.1 == value
        }?.0
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let tag = try container.decode(String.self)
        guard let value = Self.value(for: tag) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown tag: \(tag)")
        }

        self = value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Self.key(for: self)!)
    }
}

extension SpellcastingTag: Codable {
    public static let codingMap: [(String, SpellcastingTag)] = [
        ("P",  .psionics),
        ("I",  .innate),
        ("F",  .formOnly),
        ("S",  .shared),
        ("O",  .other),
        ("CA", .artificer),
        ("CB", .bard),
        ("CC", .cleric),
        ("CD", .druid),
        ("CP", .paladin),
        ("CR", .ranger),
        ("CS", .sorcerer),
        ("CL", .warlock),
        ("CW", .wizard),
    ]

    static func value(for key: String) -> Self? {
        codingMap.first { this in
            this.0 == key
        }?.1
    }

    static func key(for value: Self) -> String? {
        codingMap.first { this in
            this.1 == value
        }?.0
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let tag = try container.decode(String.self)
        guard let value = Self.value(for: tag) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown tag: \(tag)")
        }

        self = value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Self.key(for: self)!)
    }
}
