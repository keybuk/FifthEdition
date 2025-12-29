//
//  Enum.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
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

public enum Condition: String, CaseIterable, Codable, Sendable {
    case blinded
    case charmed
    case deafened
    case exhaustion
    case frightened
    case grappled
    case incapacitated
    case invisible
    case paralyzed
    case petrified
    case poisoned
    case prone
    case restrained
    case stunned
    case unconscious
    case disease
}

public enum CreatureType: String, CaseIterable, Codable, Sendable {
    case aberration
    case beast
    case celestial
    case construct
    case dragon
    case elemental
    case fey
    case fiend
    case giant
    case humanoid
    case monstrosity
    case ooze
    case plant
    case undead
}

public enum DamageType: String, CaseIterable, Codable, Sendable {
    case acid
    case bludgeoning
    case cold
    case fire
    case force
    case lightning
    case necrotic
    case piercing
    case poison
    case psychic
    case radiant
    case slashing
    case thunder
}

public enum DragonAge: String, CaseIterable, Codable, Sendable {
    case young
    case adult
    case wyrmling
    case greatwyrm
    case ancient
    case aspect
}

public enum DragonColor: String, CaseIterable, Codable, Sendable {
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

public enum Edition: String, CaseIterable, Codable, Sendable {
    case classic
    case one
}

public enum Environment: String, CaseIterable, Codable, Sendable {
    case any
    case underwater
    case coastal
    case mountain
    case grassland
    case hill
    case arctic
    case urban
    case forest
    case swamp
    case underdark
    case desert
    case badlands
    case farmland
    case planar
    case planarTransitive     = "planar, transitive"
    case planarElemental      = "planar, elemental"
    case planarInner          = "planar, inner"
    case planarUpper          = "planar, upper"
    case planarLower          = "planar, lower"
    case planarFeywild        = "planar, feywild"
    case planarShadowfell     = "planar, shadowfell"
    case planarWater          = "planar, water"
    case planarEarth          = "planar, earth"
    case planarFire           = "planar, fire"
    case planarAir            = "planar, air"
    case planarOoze           = "planar, ooze"
    case planarMagma          = "planar, magma"
    case planarAsh            = "planar, ash"
    case planarIce            = "planar, ice"
    case planarElementalChaos = "planar, elemental chaos"
    case planarEthereal       = "planar, ethereal"
    case planarAstral         = "planar, astral"
    case planarArborea        = "planar, arborea"
    case planarArcadia        = "planar, arcadia"
    case planarBeastlands     = "planar, beastlands"
    case planarBytopia        = "planar, bytopia"
    case planarElysium        = "planar, elysium"
    case planarMountCelestia  = "planar, mount celestia"
    case planarYsgard         = "planar, ysgard"
    case planarAbyss          = "planar, abyss"
    case planarAcheron        = "planar, acheron"
    case planarCarceri        = "planar, carceri"
    case planarGehenna        = "planar, gehenna"
    case planarHades          = "planar, hades"
    case planarNineHells      = "planar, nine hells"
    case planarPandemonium    = "planar, pandemonium"
    case planarLimbo          = "planar, limbo"
    case planarMechanus       = "planar, mechanus"
    case planarOutlands       = "planar, outlands"
}

public enum LanguageTag: String, CaseIterable, Codable, Sendable {
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

public enum MiscTag: String, CaseIterable, Codable, Sendable {
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

public enum SavingThrow: String, CaseIterable, Codable, Sendable {
    case strength
    case constitution
    case dexterity
    case intelligence
    case wisdom
    case charisma
}

public enum Sense: String, CaseIterable, Codable, Sendable {
    case blindsight
    case darkvision
    case superiorDarkvision
    case tremorsense
    case truesight
}

public enum SidekickType: String, CaseIterable, Codable, Sendable {
    case expert
    case spellcaster
    case warrior
}

public enum Size: String, CaseIterable, Codable, Comparable, Sendable {
    case tiny
    case small
    case medium
    case large
    case huge
    case gargantuan

    public static func < (lhs: Size, rhs: Size) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

public enum Skill: String, CaseIterable, Codable, Sendable {
    case acrobatics
    case animalHandling = "animal handling"
    case arcana
    case athletics
    case deception
    case history
    case insight
    case intimidation
    case investigation
    case medicine
    case nature
    case perception
    case performance
    case persuasion
    case religion
    case sleightOfHand  = "sleight of hand"
    case stealth
    case survival
}

public enum SpellcastingType: String, CaseIterable, Codable, Sendable {
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

public enum Tool: String, CaseIterable, Codable, Sendable {
    case artisansTools         = "artisan's tools"
    case alchemistsSupplies    = "alchemist's supplies"
    case brewersSupplies       = "brewer's supplies"
    case calligraphersSupplies = "calligrapher's supplies"
    case carpentersTools       = "carpenter's tools"
    case cartographersTools    = "cartographer's tools"
    case cobblersTools         = "cobbler's tools"
    case cooksUtensils         = "cook's utensils"
    case glassblowersTools     = "glassblower's tools"
    case jewelersTools         = "jeweler's tools"
    case leatherworkersTools   = "leatherworker's tools"
    case masonsTools           = "mason's tools"
    case paintersSupplies      = "painter's supplies"
    case pottersTools          = "potter's tools"
    case smithsTools           = "smith's tools"
    case tinkersTools          = "tinker's tools"
    case weaversTools          = "weaver's tools"
    case woodcarversTools      = "woodcarver's tools"
    case disguisKit            = "disguise kit"
    case forgeryKit            = "forgery kit"
    case gamingSet             = "gaming set"
    case dragonchessSet        = "dragonchess set"
    case diceSet               = "dice set"
    case threeDragonAnteSet    = "three-dragon ante set"
    case playingCardSet        = "playing card set"
    case herbalismKit          = "herbalism kit"
    case musicalInstrument     = "musical instrument"
    case bagpipes              = "bagpipes"
    case drum                  = "drum"
    case dulcimer              = "dulcimer"
    case flute                 = "flute"
    case horn                  = "horn"
    case lute                  = "lute"
    case lyre                  = "lyre"
    case panFlute              = "pan flute"
    case shawm                 = "shawm"
    case viol                  = "viol"
    case navigatorsTools       = "navigator's tools"
    case thievesTools          = "thieves' tools"
    case poisonersKit          = "poisoner's kit"
    case vehicles              = "vehicles"
    case vehiclesAir           = "vehicles (air)"
    case vehiclesLand          = "vehicles (land)"
    case vehiclesWater         = "vehicles (water)"
    case vehiclesSpace         = "vehicles (space)"
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

public enum Treasure: String, CaseIterable, Codable, Sendable {
    case any
    case individual
    case arcana
    case armaments
    case implements
    case relics
}

// MARK: TagCoding

extension DamageType: TagCoding {
    public static let tags: [(DamageType, String)] = [
        (.acid,        "A"),
        (.bludgeoning, "B"),
        (.cold,        "C"),
        (.fire,        "F"),
        (.force,       "O"),
        (.lightning,   "L"),
        (.necrotic,    "N"),
        (.piercing,    "P"),
        (.poison,      "I"),
        (.psychic,     "Y"),
        (.radiant,     "R"),
        (.slashing,    "S"),
        (.thunder,     "T"),
    ]
}

extension LanguageTag: TagCoding {
    public static let tags: [(LanguageTag, String)] = [
        (.any,                     "X"),
        (.all,                     "XX"),
        (.cantSpeakKnownLanguages, "CS"),
        (.languagesKnownInLife,    "LF"),
        (.telepathy,               "TP"),
        (.other,                   "OTH"),
        (.abyssal,                 "AB"),
        (.aquan,                   "AQ"),
        (.auran,                   "AU"),
        (.common,                  "C"),
        (.celestial,               "CE"),
        (.commonSignLanguage,      "CSL"),
        (.dwarvish,                "D"),
        (.draconic,                "DR"),
        (.deepSpeech,              "DS"),
        (.druidic,                 "DU"),
        (.elvish,                  "E"),
        (.gnomish,                 "G"),
        (.giant,                   "GI"),
        (.goblin,                  "GO"),
        (.gith,                    "GTH"),
        (.halfling,                "H"),
        (.infernal,                "I"),
        (.ignan,                   "IG"),
        (.orc,                     "O"),
        (.primordial,              "P"),
        (.sylvan,                  "S"),
        (.terran,                  "T"),
        (.thievesCant,             "TC"),
        (.undercommon,             "U"),
    ]
}

extension MiscTag: TagCoding {
    public static let tags: [(MiscTag, String)] = [
        (.hasAreasOfEffect,       "AOE"),
        (.inflictsCurse,          "CUR"),
        (.inflictsDisease,        "DIS"),
        (.hasHPReduction,         "HPR"),
        (.hasMeleeWeaponAttacks,  "MW"),
        (.hasRangedWeaponAttacks, "RW"),
        (.hasRangedAttacks,       "MA"),
        (.hasMeleeAttacks,        "RA"),
        (.hasReachAttacks,        "RCH"),
        (.hasMeleeWeapons,        "MLW"),
        (.hasRangedWeapons,       "RNG"),
        (.hasThrownWeapons,       "THW"),
    ]
}

extension Sense: TagCoding {
    public static let tags: [(Sense, String)] = [
        (.blindsight,         "B"),
        (.darkvision,         "D"),
        (.superiorDarkvision, "SD"),
        (.tremorsense,        "T"),
        (.truesight,          "U"),
    ]
}

extension Size: TagCoding {
    public static let tags: [(Size, String)] = [
        (.tiny,       "T"),
        (.small,      "S"),
        (.medium,     "M"),
        (.large,      "L"),
        (.huge,       "H"),
        (.gargantuan, "G"),
    ]
}

extension SpellcastingType: TagCoding {
    public static let tags: [(SpellcastingType, String)] = [
        (.psionics,  "P"),
        (.innate,    "I"),
        (.formOnly,  "F"),
        (.shared,    "S"),
        (.other,     "O"),
        (.artificer, "CA"),
        (.bard,      "CB"),
        (.cleric,    "CC"),
        (.druid,     "CD"),
        (.paladin,   "CP"),
        (.ranger,    "CR"),
        (.sorcerer,  "CS"),
        (.warlock,   "CL"),
        (.wizard,    "CW"),
    ]
}
