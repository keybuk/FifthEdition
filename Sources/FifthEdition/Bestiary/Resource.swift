//
//  Resource.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/14/26.
//

/// Gear.
///
/// Monsters have proficiency with their equipment. If a monster has equipment that can be given away or retrieved, the
/// items are given in the stat block.
public struct Gear: Equatable, Hashable, Sendable {
    /// Item name.
    public var name: String

    /// Source identifier the item comes from.
    public var source: String

    /// Alternate name to use for display.
    public var displayName: String?

    /// Quantity of item equipped.
    public var quantity: Int

    /// Initialize gear.
    /// - Parameters:
    ///   - name: Item name.
    ///   - source: Source identifier the item comes from.
    ///   - displayName: Alternate name to use for display.
    ///   - quantity: Quantity of item equipped.
    public init(name: String,
                source: String,
                displayName: String? = nil,
                quantity: Int = 1)
    {
        self.name = name
        self.source = source
        self.displayName = displayName
        self.quantity = quantity
    }
}

public extension Gear {
    /// Initialize gear from a uid.
    /// - Parameters:
    ///   - uid: Name and source in uid format.
    ///   - displayName: Alternate name to use for display.
    ///   - quantity: Quantity of item equipped.
    init?(uid: String, displayName: String? = nil, quantity: Int = 1) {
        guard let index = uid.firstIndex(of: "|") else { return nil }

        name = uid[..<index].capitalized
        source = uid[uid.index(after: index)...].uppercased()

        self.displayName = displayName
        self.quantity = quantity
    }

    /// Returns the gear name and source in uid format.
    var uid: String {
        "\(name.lowercased())|\(source.lowercased())"
    }
}

extension Gear: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.displayName ?? lhs.name) < (rhs.displayName ?? rhs.name)
    }
}

/// Environments the creature may be found in.
public enum Habitat: Comparable, Equatable, Hashable, Sendable {
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
    case planarTransitive
    case planarElemental
    case planarInner
    case planarUpper
    case planarLower
    case planarFeywild
    case planarShadowfell
    case planarWater
    case planarEarth
    case planarFire
    case planarAir
    case planarOoze
    case planarMagma
    case planarAsh
    case planarIce
    case planarElementalChaos
    case planarEthereal
    case planarAstral
    case planarArborea
    case planarArcadia
    case planarBeastlands
    case planarBytopia
    case planarElysium
    case planarMountCelestia
    case planarYsgard
    case planarAbyss
    case planarAcheron
    case planarCarceri
    case planarGehenna
    case planarHades
    case planarNineHells
    case planarPandemonium
    case planarLimbo
    case planarMechanus
    case planarOutlands

    /// Custom homebrew value.
    case other(String)
}

extension Habitat: CaseIterable {
    public static let allCases: [Self] = [
        .any,
        .underwater,
        .coastal,
        .mountain,
        .grassland,
        .hill,
        .arctic,
        .urban,
        .forest,
        .swamp,
        .underdark,
        .desert,
        .badlands,
        .farmland,
        .planar,
        .planarTransitive,
        .planarElemental,
        .planarInner,
        .planarUpper,
        .planarLower,
        .planarFeywild,
        .planarShadowfell,
        .planarWater,
        .planarEarth,
        .planarFire,
        .planarAir,
        .planarOoze,
        .planarMagma,
        .planarAsh,
        .planarIce,
        .planarElementalChaos,
        .planarEthereal,
        .planarAstral,
        .planarArborea,
        .planarArcadia,
        .planarBeastlands,
        .planarBytopia,
        .planarElysium,
        .planarMountCelestia,
        .planarYsgard,
        .planarAbyss,
        .planarAcheron,
        .planarCarceri,
        .planarGehenna,
        .planarHades,
        .planarNineHells,
        .planarPandemonium,
        .planarLimbo,
        .planarMechanus,
        .planarOutlands,
    ]
}

extension Habitat: Codable, RawRepresentable {
    public init(rawValue: RawValue) {
        self = switch rawValue {
        case "any": .any
        case "underwater": .underwater
        case "coastal": .coastal
        case "mountain": .mountain
        case "grassland": .grassland
        case "hill": .hill
        case "arctic": .arctic
        case "urban": .urban
        case "forest": .forest
        case "swamp": .swamp
        case "underdark": .underdark
        case "desert": .desert
        case "badlands": .badlands
        case "farmland": .farmland
        case "planar": .planar
        case "planar, transitive": .planarTransitive
        case "planar, elemental": .planarElemental
        case "planar, inner": .planarInner
        case "planar, upper": .planarUpper
        case "planar, lower": .planarLower
        case "planar, feywild": .planarFeywild
        case "planar, shadowfell": .planarShadowfell
        case "planar, water": .planarWater
        case "planar, earth": .planarEarth
        case "planar, fire": .planarFire
        case "planar, air": .planarAir
        case "planar, ooze": .planarOoze
        case "planar, magma": .planarMagma
        case "planar, ash": .planarAsh
        case "planar, ice": .planarIce
        case "planar, elemental chaos": .planarElementalChaos
        case "planar, ethereal": .planarEthereal
        case "planar, astral": .planarAstral
        case "planar, arborea": .planarArborea
        case "planar, arcadia": .planarArcadia
        case "planar, beastlands": .planarBeastlands
        case "planar, bytopia": .planarBytopia
        case "planar, elysium": .planarElysium
        case "planar, mount celestia": .planarMountCelestia
        case "planar, ysgard": .planarYsgard
        case "planar, abyss": .planarAbyss
        case "planar, acheron": .planarAcheron
        case "planar, carceri": .planarCarceri
        case "planar, gehenna": .planarGehenna
        case "planar, hades": .planarHades
        case "planar, nine hells": .planarNineHells
        case "planar, pandemonium": .planarPandemonium
        case "planar, limbo": .planarLimbo
        case "planar, mechanus": .planarMechanus
        case "planar, outlands": .planarOutlands
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .any: "any"
        case .underwater: "underwater"
        case .coastal: "coastal"
        case .mountain: "mountain"
        case .grassland: "grassland"
        case .hill: "hill"
        case .arctic: "arctic"
        case .urban: "urban"
        case .forest: "forest"
        case .swamp: "swamp"
        case .underdark: "underdark"
        case .desert: "desert"
        case .badlands: "badlands"
        case .farmland: "farmland"
        case .planar: "planar"
        case .planarTransitive: "planar, transitive"
        case .planarElemental: "planar, elemental"
        case .planarInner: "planar, inner"
        case .planarUpper: "planar, upper"
        case .planarLower: "planar, lower"
        case .planarFeywild: "planar, feywild"
        case .planarShadowfell: "planar, shadowfell"
        case .planarWater: "planar, water"
        case .planarEarth: "planar, earth"
        case .planarFire: "planar, fire"
        case .planarAir: "planar, air"
        case .planarOoze: "planar, ooze"
        case .planarMagma: "planar, magma"
        case .planarAsh: "planar, ash"
        case .planarIce: "planar, ice"
        case .planarElementalChaos: "planar, elemental chaos"
        case .planarEthereal: "planar, ethereal"
        case .planarAstral: "planar, astral"
        case .planarArborea: "planar, arborea"
        case .planarArcadia: "planar, arcadia"
        case .planarBeastlands: "planar, beastlands"
        case .planarBytopia: "planar, bytopia"
        case .planarElysium: "planar, elysium"
        case .planarMountCelestia: "planar, mount celestia"
        case .planarYsgard: "planar, ysgard"
        case .planarAbyss: "planar, abyss"
        case .planarAcheron: "planar, acheron"
        case .planarCarceri: "planar, carceri"
        case .planarGehenna: "planar, gehenna"
        case .planarHades: "planar, hades"
        case .planarNineHells: "planar, nine hells"
        case .planarPandemonium: "planar, pandemonium"
        case .planarLimbo: "planar, limbo"
        case .planarMechanus: "planar, mechanus"
        case .planarOutlands: "planar, outlands"
        case let .other(rawValue): rawValue
        }
    }
}

/// Tools.
///
/// If a creature has proficiency with a tool, it can add its Proficiency Bonus to any ability check made using the
/// tool.
public enum Tool: Comparable, Equatable, Hashable, Sendable {
    case artisansTools

    case alchemistsSupplies
    case brewersSupplies
    case calligraphersSupplies
    case carpentersTools
    case cartographersTools
    case cobblersTools
    case cooksUtensils
    case glassblowersTools
    case jewelersTools
    case leatherworkersTools
    case masonsTools
    case paintersSupplies
    case pottersTools
    case smithsTools
    case tinkersTools
    case weaversTools
    case woodcarversTools

    case disguiseKit
    case forgeryKit

    case gamingSet
    case dragonchessSet
    case diceSet
    case playingCardSet
    case playingCards
    case threeDragonAnteSet

    case herbalismKit

    case musicalInstrument
    case bagpipes
    case drum
    case dulcimer
    case flute
    case horn
    case lute
    case lyre
    case panFlute
    case shawm
    case viol

    case navigatorsTools
    case thievesTools
    case poisonersKit

    case vehicles
    case vehiclesAir
    case vehiclesLand
    case vehiclesSpace
    case vehiclesWater

    /// Item reference.
    case item(name: String, source: String)

    /// Custom homebrew value.
    case other(String)
}

extension Tool: CaseIterable {
    public static let allCases: [Self] = [
        .artisansTools,

        .alchemistsSupplies,
        .brewersSupplies,
        .calligraphersSupplies,
        .carpentersTools,
        .cartographersTools,
        .cobblersTools,
        .cooksUtensils,
        .glassblowersTools,
        .jewelersTools,
        .leatherworkersTools,
        .masonsTools,
        .paintersSupplies,
        .pottersTools,
        .smithsTools,
        .tinkersTools,
        .weaversTools,
        .woodcarversTools,

        .disguiseKit,
        .forgeryKit,

        .gamingSet,
        .dragonchessSet,
        .diceSet,
        .playingCardSet,
        .playingCards,
        .threeDragonAnteSet,

        .herbalismKit,

        .musicalInstrument,
        .bagpipes,
        .drum,
        .dulcimer,
        .flute,
        .horn,
        .lute,
        .lyre,
        .panFlute,
        .shawm,
        .viol,

        .navigatorsTools,
        .thievesTools,
        .poisonersKit,

        .vehicles,
        .vehiclesAir,
        .vehiclesLand,
        .vehiclesSpace,
        .vehiclesWater,
    ]
}

extension Tool: Codable, CodingKeyRepresentable, RawRepresentable {
    public init(rawValue: String) {
        self = switch rawValue {
        case "artisan's tools": .artisansTools
        case "alchemist's supplies": .alchemistsSupplies
        case "brewer's supplies": .brewersSupplies
        case "calligrapher's supplies": .calligraphersSupplies
        case "carpenter's tools": .carpentersTools
        case "cartographer's tools": .cartographersTools
        case "cobbler's tools": .cobblersTools
        case "cook's utensils": .cooksUtensils
        case "glassblower's tools": .glassblowersTools
        case "jeweler's tools": .jewelersTools
        case "leatherworker's tools": .leatherworkersTools
        case "mason's tools": .masonsTools
        case "painter's supplies": .paintersSupplies
        case "potter's tools": .pottersTools
        case "smith's tools": .smithsTools
        case "tinker's tools": .tinkersTools
        case "weaver's tools": .weaversTools
        case "woodcarver's tools": .woodcarversTools
        case "disguise kit": .disguiseKit
        case "forgery kit": .forgeryKit
        case "gaming set": .gamingSet
        case "dragonchess set": .dragonchessSet
        case "dice set": .diceSet
        case "playing card set": .playingCardSet
        case "playing cards": .playingCards
        case "three-dragon ante set": .threeDragonAnteSet
        case "herbalism kit": .herbalismKit
        case "musical instrument": .musicalInstrument
        case "bagpipes": .bagpipes
        case "drum": .drum
        case "dulcimer": .dulcimer
        case "flute": .flute
        case "horn": .horn
        case "lute": .lute
        case "lyre": .lyre
        case "pan flute": .panFlute
        case "shawm": .shawm
        case "viol": .viol
        case "navigator's tools": .navigatorsTools
        case "thieves' tools": .thievesTools
        case "poisoner's kit": .poisonersKit
        case "vehicles": .vehicles
        case "vehicles (air)": .vehiclesAir
        case "vehicles (land)": .vehiclesLand
        case "vehicles (water)": .vehiclesWater
        case "vehicles (space)": .vehiclesSpace
        default:
            if let index = rawValue.firstIndex(of: "|") {
                .item(name: rawValue[..<index].capitalized,
                      source: rawValue[rawValue.index(after: index)...].uppercased())
            } else {
                .other(rawValue)
            }
        }
    }

    public var rawValue: String {
        switch self {
        case .artisansTools: "artisan's tools"
        case .alchemistsSupplies: "alchemist's supplies"
        case .brewersSupplies: "brewer's supplies"
        case .calligraphersSupplies: "calligrapher's supplies"
        case .carpentersTools: "carpenter's tools"
        case .cartographersTools: "cartographer's tools"
        case .cobblersTools: "cobbler's tools"
        case .cooksUtensils: "cook's utensils"
        case .glassblowersTools: "glassblower's tools"
        case .jewelersTools: "jeweler's tools"
        case .leatherworkersTools: "leatherworker's tools"
        case .masonsTools: "mason's tools"
        case .paintersSupplies: "painter's supplies"
        case .pottersTools: "potter's tools"
        case .smithsTools: "smith's tools"
        case .tinkersTools: "tinker's tools"
        case .weaversTools: "weaver's tools"
        case .woodcarversTools: "woodcarver's tools"
        case .disguiseKit: "disguise kit"
        case .forgeryKit: "forgery kit"
        case .gamingSet: "gaming set"
        case .dragonchessSet: "dragonchess set"
        case .diceSet: "dice set"
        case .playingCardSet: "playing card set"
        case .playingCards: "playing cards"
        case .threeDragonAnteSet: "three-dragon ante set"
        case .herbalismKit: "herbalism kit"
        case .musicalInstrument: "musical instrument"
        case .bagpipes: "bagpipes"
        case .drum: "drum"
        case .dulcimer: "dulcimer"
        case .flute: "flute"
        case .horn: "horn"
        case .lute: "lute"
        case .lyre: "lyre"
        case .panFlute: "pan flute"
        case .shawm: "shawm"
        case .viol: "viol"
        case .navigatorsTools: "navigator's tools"
        case .thievesTools: "thieves' tools"
        case .poisonersKit: "poisoner's kit"
        case .vehicles: "vehicles"
        case .vehiclesAir: "vehicles (air)"
        case .vehiclesLand: "vehicles (land)"
        case .vehiclesWater: "vehicles (water)"
        case .vehiclesSpace: "vehicles (space)"
        case let .item(name, source): "\(name.lowercased())|\(source.lowercased())"
        case let .other(rawValue): rawValue
        }
    }
}

/// Treasure awarded for defeating the creature.
public enum Treasure: Comparable, Equatable, Hashable, Sendable {
    case any
    case individual
    case arcana
    case armaments
    case implements
    case relics

    /// Custom homebrew value.
    case other(String)
}

extension Treasure: CaseIterable {
    public static let allCases: [Self] = [
        .any,
        .individual,
        .arcana,
        .armaments,
        .implements,
        .relics,
    ]
}

extension Treasure: Codable, RawRepresentable {
    public init(rawValue: RawValue) {
        self = switch rawValue {
        case "any": .any
        case "individual": .individual
        case "arcana": .arcana
        case "armaments": .armaments
        case "implements": .implements
        case "relics": .relics
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .any: "any"
        case .individual: "individual"
        case .arcana: "arcana"
        case .armaments: "armaments"
        case .implements: "implements"
        case .relics: "relics"
        case let .other(rawValue): rawValue
        }
    }
}
