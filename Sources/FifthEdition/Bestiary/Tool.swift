//
//  Tool.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/14/26.
//

import MemberwiseInit
import RawRepresentableOptions

/// Gear.
///
/// Monsters have proficiency with their equipment. If a monster has equipment that can be given away or retrieved, the
/// items are given in the stat block.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Gear: Equatable, Hashable, Sendable {
    /// Item name.
    public var name: String

    /// Source identifier the item comes from.
    public var source: String

    /// Alternate name to use for display.
    public var displayName: String?

    /// Quantity of item equipped.
    public var quantity: Int = 1
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

/// Tools.
///
/// If a creature has proficiency with a tool, it can add its Proficiency Bonus to any ability check made using the
/// tool.
@RawRepresentableOptions
public struct Tool: CaseIterable, Codable, CodingKeyRepresentable, Equatable, Hashable, Sendable {
    private enum Options: String {
        case artisansTools = "artisan's tools"
        case alchemistsSupplies = "alchemist's supplies"
        case brewersSupplies = "brewer's supplies"
        case calligraphersSupplies = "calligrapher's supplies"
        case carpentersTools = "carpenter's tools"
        case cartographersTools = "cartographer's tools"
        case cobblersTools = "cobbler's tools"
        case cooksUtensils = "cook's utensils"
        case glassblowersTools = "glassblower's tools"
        case jewelersTools = "jeweler's tools"
        case leatherworkersTools = "leatherworker's tools"
        case masonsTools = "mason's tools"
        case paintersSupplies = "painter's supplies"
        case pottersTools = "potter's tools"
        case smithsTools = "smith's tools"
        case tinkersTools = "tinker's tools"
        case weaversTools = "weaver's tools"
        case woodcarversTools = "woodcarver's tools"
        case disguiseKit = "disguise kit"
        case forgeryKit = "forgery kit"
        case gamingSet = "gaming set"
        case dragonchessSet = "dragonchess set"
        case diceSet = "dice set"
        case playingCardSet = "playing card set"
        case playingCards = "playing cards"
        case threeDragonAnteSet = "three-dragon ante set"
        case herbalismKit = "herbalism kit"
        case musicalInstrument = "musical instrument"
        case bagpipes
        case drum
        case dulcimer
        case flute
        case horn
        case lute
        case lyre
        case panFlute = "pan flute"
        case shawm
        case viol
        case navigatorsTools = "navigator's tools"
        case thievesTools = "thieves' tools"
        case poisonersKit = "poisoner's kit"
        case vehicles
        case vehiclesAir = "vehicles (air)"
        case vehiclesLand = "vehicles (land)"
        case vehiclesWater = "vehicles (water)"
        case vehiclesSpace = "vehicles (space)"
    }

//    if let index = rawValue.firstIndex(of: "|") {
//        .item(name: rawValue[..<index].capitalized,
//              source: rawValue[rawValue.index(after: index)...].uppercased())
//    } else {
//        .other(rawValue)
//    }

    // case let .item(name, source): "\(name.lowercased())|\(source.lowercased())"
}
