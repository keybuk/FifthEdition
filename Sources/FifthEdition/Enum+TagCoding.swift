//
//  Enum+TagCoding.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
//

extension DamageType: TagCoding {
    public static let tags: [(DamageType, String)] = [
        (.acid, "A"),
        (.bludgeoning, "B"),
        (.cold, "C"),
        (.fire, "F"),
        (.force, "O"),
        (.lightning, "L"),
        (.necrotic, "N"),
        (.piercing, "P"),
        (.poison, "I"),
        (.psychic, "Y"),
        (.radiant, "R"),
        (.slashing, "S"),
        (.thunder, "T"),
    ]
}

extension LanguageTag: TagCoding {
    public static let tags: [(LanguageTag, String)] = [
        (.any, "X"),
        (.all, "XX"),
        (.cantSpeakKnownLanguages, "CS"),
        (.languagesKnownInLife, "LF"),
        (.telepathy, "TP"),
        (.other, "OTH"),
        (.abyssal, "AB"),
        (.aquan, "AQ"),
        (.auran, "AU"),
        (.common, "C"),
        (.celestial, "CE"),
        (.commonSignLanguage, "CSL"),
        (.dwarvish, "D"),
        (.draconic, "DR"),
        (.deepSpeech, "DS"),
        (.druidic, "DU"),
        (.elvish, "E"),
        (.gnomish, "G"),
        (.giant, "GI"),
        (.goblin, "GO"),
        (.gith, "GTH"),
        (.halfling, "H"),
        (.infernal, "I"),
        (.ignan, "IG"),
        (.orc, "O"),
        (.primordial, "P"),
        (.sylvan, "S"),
        (.terran, "T"),
        (.thievesCant, "TC"),
        (.undercommon, "U"),
    ]
}

extension MiscTag: TagCoding {
    public static let tags: [(MiscTag, String)] = [
        (.hasAreasOfEffect, "AOE"),
        (.inflictsCurse, "CUR"),
        (.inflictsDisease, "DIS"),
        (.hasHPReduction, "HPR"),
        (.hasMeleeWeaponAttacks, "MW"),
        (.hasRangedWeaponAttacks, "RW"),
        (.hasRangedAttacks, "MA"),
        (.hasMeleeAttacks, "RA"),
        (.hasReachAttacks, "RCH"),
        (.hasMeleeWeapons, "MLW"),
        (.hasRangedWeapons, "RNG"),
        (.hasThrownWeapons, "THW"),
    ]
}

extension Sense: TagCoding {
    public static let tags: [(Sense, String)] = [
        (.blindsight, "B"),
        (.darkvision, "D"),
        (.superiorDarkvision, "SD"),
        (.tremorsense, "T"),
        (.truesight, "U"),
    ]
}

extension Size: TagCoding {
    public static let tags: [(Size, String)] = [
        (.tiny, "T"),
        (.small, "S"),
        (.medium, "M"),
        (.large, "L"),
        (.huge, "H"),
        (.gargantuan, "G"),
    ]
}

extension SpellcastingType: TagCoding {
    public static let tags: [(SpellcastingType, String)] = [
        (.psionics, "P"),
        (.innate, "I"),
        (.formOnly, "F"),
        (.shared, "S"),
        (.other, "O"),
        (.artificer, "CA"),
        (.bard, "CB"),
        (.cleric, "CC"),
        (.druid, "CD"),
        (.paladin, "CP"),
        (.ranger, "CR"),
        (.sorcerer, "CS"),
        (.warlock, "CL"),
        (.wizard, "CW"),
    ]
}
