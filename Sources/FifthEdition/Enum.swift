//
//  Enum.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
//

public enum ActionTag: String, CaseIterable, Codable, Sendable {
    case breathWeapon = "Breath Weapon"
    case frightfulPresence = "Frightful Presence"
    case multiattack = "Multiattack"
    case parry = "Parry"
    case shapechanger = "Shapechanger"
    case swallow = "Swallow"
    case teleport = "Teleport"
    case tentacles = "Tentacles"
}

@EnumWrapper
public enum DragonAgeValue: String, Sendable {
    case young
    case adult
    case wyrmling
    case greatwyrm
    case ancient
    case aspect
}

public typealias DragonAge = DragonAgeValue.Wrapper

@EnumWrapper
public enum DragonColorValue: String, Sendable {
    case black
    case blue
    case green
    case red
    case white
    case brass
    case bronze
    case copper
    case gold
    case silver
    case deep
    case spirit
}

public typealias DragonColor = DragonColorValue.Wrapper

public enum LanguageTag: String, CaseIterable, Codable, Sendable {
    case any = "Any (Choose)"
    // all
    case all
    case cantSpeakKnownLanguages = "Can't Speak Known Languages"
    // "Any languages it knew in life"
    // "the languages it knew in life"
    case languagesKnownInLife = "Languages Known in Life"
    case telepathy
    case other
    // Aarakocra
    // Aartuk
    case abyssal
    case aquan
    case auran
    // Bullywug
    case celestial
    case common
    case commonSignLanguage = "Common Sign Language"
    // deep crow
    // demodand
    case deepSpeech = "Deep Speech"
    case draconic
    case druidic
    case dwarvish
    case elvish
    // giant owl
    case giant
    case gith
    // gnoll
    case gnomish
    case goblin
    /// grung
    case halfling
    // homarid
    case ignan
    case infernal
    /// kruthik
    /// modron
    case orc
    /// "Primordial (Aquan)"
    /// "Primordial (Auran)"
    case primordial
    // quori
    case sylvan
    case terran
    // thayan
    case thievesCant = "Thieves' cant"
    case undercommon
    // yeti

    // {language}
    // {language} plus any {four} languages
    // {language} plus {one} {more,other} language
    // {language} plus {two,three} {more,other} languages
    // {language} + telepathy(range inc mile)
    // telepathy(range inc mile)
    // telepathy(range inc mile) but can't speak
    // understands {language}
    // understands {language} but can't speak[ it]
    // understands {language} and {language} but can't speak[ it]
    // understands {language} plus {one} {more,other} language but can't speak[ it]
    // understands {language} plus {two} {more,other} languages but can't speak[ it]
    // [and ]any {one} language"
    // [and ]any {one} language (usually {language}"
    // [and ]any {two,four} languages"

    // understands all languages it spoke in life but can't speak
    // understands the languages it knew in life but can't speak

    // understands one language of its creator but can't speak
    // understands the languages of its creator but can't speak

    // "Understands the languages you know"
    // "Understands the languages you speak"
    // "all languages known to its summoner"
    // "one language of its creator's choice"
    // "plus one of your choice"

    // "all languages known by any creature within 30 feet of it"
    // "and any languages it knew before becoming a vargouille"
    // "but it can't speak"
}

public enum MiscTag: String, CaseIterable, Codable, Sendable {
    case hasAreasOfEffect = "Has Areas of Effect"
    case inflictsCurse = "Inflicts Curse"
    case inflictsDisease = "Inflicts Disease"
    case hasHPReduction = "Has HP Reduction"
    case hasMeleeWeaponAttacks = "Has Weapon Attacks, Melee"
    case hasRangedWeaponAttacks = "Has Weapon Attacks, Ranged"
    case hasRangedAttacks = "Has Attacks, Ranged"
    case hasMeleeAttacks = "Has Attacks, Melee"
    case hasReachAttacks = "Has Reach Attacks"
    case hasMeleeWeapons = "Has Melee Weapons"
    case hasRangedWeapons = "Has Ranged Weapons"
    case hasThrownWeapons = "Has Thrown Weapons"
}

public enum SpellcastingTag: String, CaseIterable, Codable, Sendable {
    case psionics
    case innate
    case formOnly = "Form Only"
    case shared
    case other
    case artificer = "Class, Artificer"
    case bard = "Class, Bard"
    case cleric = "Class, Cleric"
    case druid = "Class, Druid"
    case paladin = "Class, Paladin"
    case ranger = "Class, Ranger"
    case sorcerer = "Class, Sorcerer"
    case warlock = "Class, Warlock"
    case wizard = "Class, Wizard"
}

public enum TraitTag: String, CaseIterable, Codable, Sendable {
    case aggressive = "Aggressive"
    case ambusher = "Ambusher"
    case amorphous = "Amorphous"
    case amphibious = "Amphibious"
    case antimagicSusceptibility = "Antimagic Susceptibility"
    case beastOfBurden = "Beast of Burden"
    case brute = "Brute"
    case camouflage = "Camouflage"
    case charge = "Charge"
    case damageAbsorption = "Damage Absorption"
    case deathBurst = "Death Burst"
    case devilsSight = "Devil's Sight"
    case etherealSight = "Ethereal Sight"
    case falseAppearance = "False Appearance"
    case feyAncestry = "Fey Ancestry"
    case flyby = "Flyby"
    case holdBreath = "Hold Breath"
    case illumination = "Illumination"
    case immutableForm = "Immutable Form"
    case incorporealMovement = "Incorporeal Movement"
    case keenSenses = "Keen Senses"
    case legendaryResistances = "Legendary Resistances"
    case lightSensitivity = "Light Sensitivity"
    case magicResistance = "Magic Resistance"
    case magicWeapons = "Magic Weapons"
    case mimicry = "Mimicry"
    case packTactics = "Pack Tactics"
    case pounce = "Pounce"
    case rampage = "Rampage"
    case reckless = "Reckless"
    case regeneration = "Regeneration"
    case rejuvenation = "Rejuvenation"
    case shapechanger = "Shapechanger"
    case siegeMonster = "Siege Monster"
    case sneakAttack = "Sneak Attack"
    case spellImmunity = "Spell Immunity"
    case spiderClimb = "Spider Climb"
    case sunlightSensitivity = "Sunlight Sensitivity"
    case sureFooted = "Sure-Footed"
    case treeStride = "Tree Stride"
    case tunneler = "Tunneler"
    case turnImmunity = "Turn Immunity"
    case turnResistance = "Turn Resistance"
    case undeadFortitude = "Undead Fortitude"
    case unusualNature = "Unusual Nature"
    case waterBreathing = "Water Breathing"
    case webSense = "Web Sense"
    case webWalker = "Web Walker"
}
