//
//  Meta.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//
//  Derived from schema-template/util.json
//  Version: 1.18.0

import MemberwiseInit

/// Metadata.
@MemberwiseInit(.public)
public struct Meta: Equatable, Sendable {
    /// Dependencies.
    ///
    /// Values are a set of sources that this depends on. For example if `dependencies[.monster] = ["MM"]` then this
    /// source depends on monsters from the "MM" bestiary.
    public var dependencies: [Entity: Set<String>] = [:]

    /// Internal copies.
    ///
    /// Entities that are copied from within the current source.
    public var internalCopies: Set<Entity> = []

    /// Other sources to be loaded.
    ///
    /// Values are map from sources to be loaded to other sources from that source to search for. For example,
    /// if `otherSources[.monster] = ["MM": "CoS"]` then creatures in the "MM" bestiary with a "CoS" entry in
    /// ``Creature/otherSources`` should be included.
    public var otherSources: [Entity: [String: String]] = [:]
}

public extension Meta {
    /// Entity described in the schema.
    struct Entity: RawRepresentable, Codable, CodingKeyRepresentable, Equatable, Hashable, Sendable {
        public static let action = Entity(rawValue: "action")
        public static let adventure = Entity(rawValue: "adventure")
        public static let adventureData = Entity(rawValue: "adventureData")
        public static let background = Entity(rawValue: "background")
        public static let backgroundFluff = Entity(rawValue: "backgroundFluff")
        public static let baseitem = Entity(rawValue: "baseitem")
        public static let book = Entity(rawValue: "book")
        public static let bookData = Entity(rawValue: "bookData")
        public static let boon = Entity(rawValue: "boon")
        public static let card = Entity(rawValue: "card")
        public static let charoption = Entity(rawValue: "charoption")
        public static let citation = Entity(rawValue: "citation")
        public static let `class` = Entity(rawValue: "class")
        public static let classFeature = Entity(rawValue: "classFeature")
        public static let classFluff = Entity(rawValue: "classFluff")
        public static let condition = Entity(rawValue: "condition")
        public static let crochetPattern = Entity(rawValue: "crochetPattern")
        public static let cult = Entity(rawValue: "cult")
        public static let deck = Entity(rawValue: "deck")
        public static let deity = Entity(rawValue: "deity")
        public static let disease = Entity(rawValue: "disease")
        public static let diseaseFluff = Entity(rawValue: "diseaseFluff")
        public static let encounterShape = Entity(rawValue: "encounterShape")
        public static let facility = Entity(rawValue: "facility")
        public static let feat = Entity(rawValue: "feat")
        public static let featFluff = Entity(rawValue: "featFluff")
        public static let hazard = Entity(rawValue: "hazard")
        public static let hazardFluff = Entity(rawValue: "hazardFluff")
        public static let item = Entity(rawValue: "item")
        public static let itemEntry = Entity(rawValue: "itemEntry")
        public static let itemFluff = Entity(rawValue: "itemFluff")
        public static let itemGroup = Entity(rawValue: "itemGroup")
        public static let itemMastery = Entity(rawValue: "itemMastery")
        public static let itemProperty = Entity(rawValue: "itemProperty")
        public static let itemType = Entity(rawValue: "itemType")
        public static let itemTypeAdditionalEntries = Entity(rawValue: "itemTypeAdditionalEntries")
        public static let language = Entity(rawValue: "language")
        public static let languageFluff = Entity(rawValue: "languageFluff")
        public static let legendaryGroup = Entity(rawValue: "legendaryGroup")
        public static let magicvariant = Entity(rawValue: "magicvariant")
        public static let makebrewCreatureTrait = Entity(rawValue: "makebrewCreatureTrait")
        public static let monster = Entity(rawValue: "monster")
        public static let monsterFluff = Entity(rawValue: "monsterFluff")
        public static let monsterTemplate = Entity(rawValue: "monsterTemplate")
        public static let name = Entity(rawValue: "name")
        public static let object = Entity(rawValue: "object")
        public static let objectFluff = Entity(rawValue: "objectFluff")
        public static let optionalfeature = Entity(rawValue: "optionalfeature")
        public static let psionic = Entity(rawValue: "psionic")
        public static let race = Entity(rawValue: "race")
        public static let raceFeature = Entity(rawValue: "raceFeature")
        public static let raceFluff = Entity(rawValue: "raceFluff")
        public static let recipe = Entity(rawValue: "recipe")
        public static let recipeFluff = Entity(rawValue: "recipeFluff")
        public static let reward = Entity(rawValue: "reward")
        public static let rewardFluff = Entity(rawValue: "rewardFluff")
        public static let sense = Entity(rawValue: "sense")
        public static let skill = Entity(rawValue: "skill")
        public static let spell = Entity(rawValue: "spell")
        public static let spellFluff = Entity(rawValue: "spellFluff")
        public static let status = Entity(rawValue: "status")
        public static let subclass = Entity(rawValue: "subclass")
        public static let subclassFeature = Entity(rawValue: "subclassFeature")
        public static let subclassFluff = Entity(rawValue: "subclassFluff")
        public static let subrace = Entity(rawValue: "subrace")
        public static let table = Entity(rawValue: "table")
        public static let trap = Entity(rawValue: "trap")
        public static let trapFluff = Entity(rawValue: "trapFluff")
        public static let variantrule = Entity(rawValue: "variantrule")
        public static let vehicle = Entity(rawValue: "vehicle")
        public static let vehicleFluff = Entity(rawValue: "vehicleFluff")
        public static let vehicleUpgrade = Entity(rawValue: "vehicleUpgrade")

        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
