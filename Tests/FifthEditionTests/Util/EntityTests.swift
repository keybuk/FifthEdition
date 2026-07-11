//
//  EntityTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/25/26.
//

import Testing
@testable import FifthEdition

struct EntityCodableTests {
    @Test(arguments: Entity.allCases)
    func `Entity is encoded as rawValue`(_ entity: Entity) throws {
        try testCodable(
            json: """
            "\(entity.rawValue)"
            """,
            value: entity,
        )
    }

    @Test
    func `Unknown entity is encoded as rawValue`() throws {
        try testCodable(
            json: """
            "userManual"
            """,
            value: Entity.other("userManual"),
        )
    }
}

struct EntityCodingKeyTests {
    @Test(arguments: Entity.allCases)
    func `Entity encodes as dictionary key`(entity: Entity) throws {
        try testCodable(
            json: """
            {
                "\(entity.rawValue)": 42
            }
            """,
            value: [
                entity: 42,
            ],
        )
    }

    @Test
    func `Unknown entity encodes as dictionary key`() throws {
        try testCodable(
            json: """
            {
                "userManual": 42
            }
            """,
            value: [
                Entity.other("userManual"): 42,
            ],
        )
    }
}

struct EntityComparableTests {
    @Test(arguments: zip(Entity.allCases, Entity.allCases.dropFirst()))
    func `Entity smaller than next`(a: Entity, b: Entity) {
        #expect(a < b)
    }

    @Test(arguments: Entity.allCases)
    func `Entity smaller than unknown`(entity: Entity) {
        #expect(entity < Entity.other("custard"))
    }
}

struct EntityRawRepresentableTests {
    static let expectedValues: [(Entity, String)] = [
        (.action, "action"),
        (.adventure, "adventure"),
        (.adventureData, "adventureData"),
        (.background, "background"),
        (.backgroundFluff, "backgroundFluff"),
        (.baseitem, "baseitem"),
        (.book, "book"),
        (.bookData, "bookData"),
        (.boon, "boon"),
        (.card, "card"),
        (.charoption, "charoption"),
        (.citation, "citation"),
        (.class, "class"),
        (.classFeature, "classFeature"),
        (.classFluff, "classFluff"),
        (.condition, "condition"),
        (.crochetPattern, "crochetPattern"),
        (.cult, "cult"),
        (.deck, "deck"),
        (.deity, "deity"),
        (.disease, "disease"),
        (.diseaseFluff, "diseaseFluff"),
        (.encounterShape, "encounterShape"),
        (.facility, "facility"),
        (.feat, "feat"),
        (.featFluff, "featFluff"),
        (.hazard, "hazard"),
        (.hazardFluff, "hazardFluff"),
        (.item, "item"),
        (.itemEntry, "itemEntry"),
        (.itemFluff, "itemFluff"),
        (.itemGroup, "itemGroup"),
        (.itemMastery, "itemMastery"),
        (.itemProperty, "itemProperty"),
        (.itemType, "itemType"),
        (.itemTypeAdditionalEntries, "itemTypeAdditionalEntries"),
        (.language, "language"),
        (.languageFluff, "languageFluff"),
        (.legendaryGroup, "legendaryGroup"),
        (.magicvariant, "magicvariant"),
        (.makebrewCreatureTrait, "makebrewCreatureTrait"),
        (.monster, "monster"),
        (.monsterFluff, "monsterFluff"),
        (.monsterTemplate, "monsterTemplate"),
        (.name, "name"),
        (.object, "object"),
        (.objectFluff, "objectFluff"),
        (.optionalfeature, "optionalfeature"),
        (.psionic, "psionic"),
        (.race, "race"),
        (.raceFeature, "raceFeature"),
        (.raceFluff, "raceFluff"),
        (.recipe, "recipe"),
        (.recipeFluff, "recipeFluff"),
        (.reward, "reward"),
        (.rewardFluff, "rewardFluff"),
        (.sense, "sense"),
        (.skill, "skill"),
        (.spell, "spell"),
        (.spellFluff, "spellFluff"),
        (.status, "status"),
        (.subclass, "subclass"),
        (.subclassFeature, "subclassFeature"),
        (.subclassFluff, "subclassFluff"),
        (.subrace, "subrace"),
        (.table, "table"),
        (.trap, "trap"),
        (.trapFluff, "trapFluff"),
        (.variantrule, "variantrule"),
        (.vehicle, "vehicle"),
        (.vehicleFluff, "vehicleFluff"),
        (.vehicleUpgrade, "vehicleUpgrade"),
    ]

    @Test(arguments: expectedValues)
    func `init(rawValue:) sets known case`(entity: Entity, rawValue: String) {
        #expect(Entity(rawValue: rawValue) == entity)
    }

    @Test
    func `init(rawValue:) sets other for unknown case`() {
        #expect(Entity(rawValue: "userManual") == .other("userManual"))
    }

    @Test(arguments: expectedValues)
    func `rawValue has expected value`(entity: Entity, rawValue: String) {
        #expect(entity.rawValue == rawValue)
    }

    @Test
    func `rawValue has expected value for unknown case`() {
        let entity = Entity.other("userManual")
        #expect(entity.rawValue == "userManual")
    }
}
