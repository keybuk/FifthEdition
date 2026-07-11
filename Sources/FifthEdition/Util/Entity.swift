//
//  Entity.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/25/26.
//

/// Entity described in the schema.
public enum Entity: Comparable, Equatable, Hashable, Sendable {
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

    /// Custom homebrew value.
    case other(String)
}

extension Entity: CaseIterable {
    public static let allCases: [Self] = [
        .action,
        .adventure,
        .adventureData,
        .background,
        .backgroundFluff,
        .baseitem,
        .book,
        .bookData,
        .boon,
        .card,
        .charoption,
        .citation,
        .class,
        .classFeature,
        .classFluff,
        .condition,
        .crochetPattern,
        .cult,
        .deck,
        .deity,
        .disease,
        .diseaseFluff,
        .encounterShape,
        .facility,
        .feat,
        .featFluff,
        .hazard,
        .hazardFluff,
        .item,
        .itemEntry,
        .itemFluff,
        .itemGroup,
        .itemMastery,
        .itemProperty,
        .itemType,
        .itemTypeAdditionalEntries,
        .language,
        .languageFluff,
        .legendaryGroup,
        .magicvariant,
        .makebrewCreatureTrait,
        .monster,
        .monsterFluff,
        .monsterTemplate,
        .name,
        .object,
        .objectFluff,
        .optionalfeature,
        .psionic,
        .race,
        .raceFeature,
        .raceFluff,
        .recipe,
        .recipeFluff,
        .reward,
        .rewardFluff,
        .sense,
        .skill,
        .spell,
        .spellFluff,
        .status,
        .subclass,
        .subclassFeature,
        .subclassFluff,
        .subrace,
        .table,
        .trap,
        .trapFluff,
        .variantrule,
        .vehicle,
        .vehicleFluff,
        .vehicleUpgrade,
    ]
}

extension Entity: Codable, CodingKeyRepresentable, RawRepresentable {
    public init(rawValue: String) {
        self = switch rawValue {
        case "action": .action
        case "adventure": .adventure
        case "adventureData": .adventureData
        case "background": .background
        case "backgroundFluff": .backgroundFluff
        case "baseitem": .baseitem
        case "book": .book
        case "bookData": .bookData
        case "boon": .boon
        case "card": .card
        case "charoption": .charoption
        case "citation": .citation
        case "class": .class
        case "classFeature": .classFeature
        case "classFluff": .classFluff
        case "condition": .condition
        case "crochetPattern": .crochetPattern
        case "cult": .cult
        case "deck": .deck
        case "deity": .deity
        case "disease": .disease
        case "diseaseFluff": .diseaseFluff
        case "encounterShape": .encounterShape
        case "facility": .facility
        case "feat": .feat
        case "featFluff": .featFluff
        case "hazard": .hazard
        case "hazardFluff": .hazardFluff
        case "item": .item
        case "itemEntry": .itemEntry
        case "itemFluff": .itemFluff
        case "itemGroup": .itemGroup
        case "itemMastery": .itemMastery
        case "itemProperty": .itemProperty
        case "itemType": .itemType
        case "itemTypeAdditionalEntries": .itemTypeAdditionalEntries
        case "language": .language
        case "languageFluff": .languageFluff
        case "legendaryGroup": .legendaryGroup
        case "magicvariant": .magicvariant
        case "makebrewCreatureTrait": .makebrewCreatureTrait
        case "monster": .monster
        case "monsterFluff": .monsterFluff
        case "monsterTemplate": .monsterTemplate
        case "name": .name
        case "object": .object
        case "objectFluff": .objectFluff
        case "optionalfeature": .optionalfeature
        case "psionic": .psionic
        case "race": .race
        case "raceFeature": .raceFeature
        case "raceFluff": .raceFluff
        case "recipe": .recipe
        case "recipeFluff": .recipeFluff
        case "reward": .reward
        case "rewardFluff": .rewardFluff
        case "sense": .sense
        case "skill": .skill
        case "spell": .spell
        case "spellFluff": .spellFluff
        case "status": .status
        case "subclass": .subclass
        case "subclassFeature": .subclassFeature
        case "subclassFluff": .subclassFluff
        case "subrace": .subrace
        case "table": .table
        case "trap": .trap
        case "trapFluff": .trapFluff
        case "variantrule": .variantrule
        case "vehicle": .vehicle
        case "vehicleFluff": .vehicleFluff
        case "vehicleUpgrade": .vehicleUpgrade
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .action: "action"
        case .adventure: "adventure"
        case .adventureData: "adventureData"
        case .background: "background"
        case .backgroundFluff: "backgroundFluff"
        case .baseitem: "baseitem"
        case .book: "book"
        case .bookData: "bookData"
        case .boon: "boon"
        case .card: "card"
        case .charoption: "charoption"
        case .citation: "citation"
        case .class: "class"
        case .classFeature: "classFeature"
        case .classFluff: "classFluff"
        case .condition: "condition"
        case .crochetPattern: "crochetPattern"
        case .cult: "cult"
        case .deck: "deck"
        case .deity: "deity"
        case .disease: "disease"
        case .diseaseFluff: "diseaseFluff"
        case .encounterShape: "encounterShape"
        case .facility: "facility"
        case .feat: "feat"
        case .featFluff: "featFluff"
        case .hazard: "hazard"
        case .hazardFluff: "hazardFluff"
        case .item: "item"
        case .itemEntry: "itemEntry"
        case .itemFluff: "itemFluff"
        case .itemGroup: "itemGroup"
        case .itemMastery: "itemMastery"
        case .itemProperty: "itemProperty"
        case .itemType: "itemType"
        case .itemTypeAdditionalEntries: "itemTypeAdditionalEntries"
        case .language: "language"
        case .languageFluff: "languageFluff"
        case .legendaryGroup: "legendaryGroup"
        case .magicvariant: "magicvariant"
        case .makebrewCreatureTrait: "makebrewCreatureTrait"
        case .monster: "monster"
        case .monsterFluff: "monsterFluff"
        case .monsterTemplate: "monsterTemplate"
        case .name: "name"
        case .object: "object"
        case .objectFluff: "objectFluff"
        case .optionalfeature: "optionalfeature"
        case .psionic: "psionic"
        case .race: "race"
        case .raceFeature: "raceFeature"
        case .raceFluff: "raceFluff"
        case .recipe: "recipe"
        case .recipeFluff: "recipeFluff"
        case .reward: "reward"
        case .rewardFluff: "rewardFluff"
        case .sense: "sense"
        case .skill: "skill"
        case .spell: "spell"
        case .spellFluff: "spellFluff"
        case .status: "status"
        case .subclass: "subclass"
        case .subclassFeature: "subclassFeature"
        case .subclassFluff: "subclassFluff"
        case .subrace: "subrace"
        case .table: "table"
        case .trap: "trap"
        case .trapFluff: "trapFluff"
        case .variantrule: "variantrule"
        case .vehicle: "vehicle"
        case .vehicleFluff: "vehicleFluff"
        case .vehicleUpgrade: "vehicleUpgrade"
        case let .other(rawValue): rawValue
        }
    }
}
