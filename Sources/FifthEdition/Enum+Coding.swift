//
//  Enum+Coding.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
//

extension Damage: AlternativeCodingMap {
    static let codingValues: [(Damage, String)] = [
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

extension LanguageTag: AlternativeCodingMap {
    static let codingValues: [(LanguageTag, String)] = [
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

extension MiscTag: AlternativeCodingMap {
    static let codingValues: [(MiscTag, String)] = [
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

extension SpellcastingTag: AlternativeCodingMap {
    static let codingValues: [(SpellcastingTag, String)] = [
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
