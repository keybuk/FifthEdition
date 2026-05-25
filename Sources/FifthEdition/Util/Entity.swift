//
//  Entity.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/25/26.
//

@EnumWrapper
public enum EntityValue: String, Sendable {
    case action
    case adventure
    case adventureData
    case background
    case backgroundFluff
    case baseitem
    case book
    case bookData
    case boon
    case card
    case charoption
    case citation
    case `class`
    case classFeature
    case classFluff
    case condition
    case crochetPattern
    case cult
    case deck
    case deity
    case disease
    case diseaseFluff
    case encounterShape
    case facility
    case feat
    case featFluff
    case hazard
    case hazardFluff
    case item
    case itemEntry
    case itemFluff
    case itemGroup
    case itemMastery
    case itemProperty
    case itemType
    case itemTypeAdditionalEntries
    case language
    case languageFluff
    case legendaryGroup
    case magicvariant
    case makebrewCreatureTrait
    case monster
    case monsterFluff
    case monsterTemplate
    case name
    case object
    case objectFluff
    case optionalfeature
    case psionic
    case race
    case raceFeature
    case raceFluff
    case recipe
    case recipeFluff
    case reward
    case rewardFluff
    case sense
    case skill
    case spell
    case spellFluff
    case status
    case subclass
    case subclassFeature
    case subclassFluff
    case subrace
    case table
    case trap
    case trapFluff
    case variantrule
    case vehicle
    case vehicleFluff
    case vehicleUpgrade
}

/// Entity described in the schema.
public typealias Entity = EntityValue.Wrapper
