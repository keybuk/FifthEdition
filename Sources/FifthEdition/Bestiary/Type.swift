//
//  Type.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

public enum New {
    /// The nine alignments.
    ///
    /// A creature’s alignment broadly describes its ethical attitudes and ideals. Alignment is a combination of two
    /// factors:
    /// one identifies morality (good, evil, or neutral), and the other describes attitudes toward order (lawful,
    /// chaotic,
    /// or neutral).
    public enum Alignment: String, CaseIterable, Sendable {
        case lawfulGood
        case lawfulNeutral
        case lawfulEvil
        case neutralGood
        case neutral
        case neutralEvil
        case chaoticGood
        case chaoticNeutral
        case chaoticEvil
    }
}

// good: Set<Alignment> = [.lawfulGood, neutralGood, .chaoticGood]
// neutralGoodEvil: Set<Alignment> = [.neutralGood, .neutral, .neutralEvil]
// evil: Set<Alignment> = [.lawfulEvil, neutralEvil, .chaoticEvil]
// lawful: Set<Alignment> = [.lawfulGood, lawfulNeutral, .lawfulEvil]
// neutralLawfulChaotic: Set<Alignment> = [.lawfulNeutral, .neutral, .chaoticNeutral]
// chaotic: Set<Alignment> = [.chaoticGood, chaoticNeutral, .chaoticEvil]

// TODO: SetAlgebra would work great for this. .good.union(.evil) .good.intersection(.evil)

/// Alignment.
///
/// Represents a single alignment such as ``lawfulGood`` or a set of alignments such as ``anyLawful``.
public enum Alignment: String, CaseIterable, Sendable {
    case unaligned
    case any = "any alignment"
    case lawful
    case chaotic
    case neutral
    case good
    case evil
    case lawfulGood = "lawful good"
    case lawfulNeutral = "lawful neutral"
    case lawfulEvil = "lawful evil"
    case neutralGood = "neutral good"
    case neutralEvil = "neutral evil"
    case chaoticGood = "chaotic good"
    case chaoticNeutral = "chaotic neutral"
    case chaoticEvil = "chaotic evil"
    case anyNeutral = "any neutral alignment"
    case anyLawful = "any lawful alignment"
    case anyChaotic = "any chaotic alignment"
    case anyGood = "any good alignment"
    case anyEvil = "any evil alignment"
    case anyNonLawful = "any non-lawful alignment"
    case anyNonChaotic = "any non-chaotic alignment"
    case anyNonGood = "any non-good alignment"
    case anyNonEvil = "any non-evil alignment"
}

/// Type of creature.
///
/// Each creature has a type. Certain spells, magic items, class features, and other effects in the game interact in
/// special ways with creatures of a particular type.
public enum CreatureType: Comparable, Equatable, Hashable, Sendable {
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
    case vehicle

    /// Custom homebrew value.
    case other(String)
}

extension CreatureType: CaseIterable {
    public static let allCases: [Self] = [
        .aberration,
        .beast,
        .celestial,
        .construct,
        .dragon,
        .elemental,
        .fey,
        .fiend,
        .giant,
        .humanoid,
        .monstrosity,
        .ooze,
        .plant,
        .undead,
        .vehicle,
    ]
}

extension CreatureType: Codable, RawRepresentable {
    public init(rawValue: String) {
        self = switch rawValue {
        case "aberration": .aberration
        case "beast": .beast
        case "celestial": .celestial
        case "construct": .construct
        case "dragon": .dragon
        case "elemental": .elemental
        case "fey": .fey
        case "fiend": .fiend
        case "giant": .giant
        case "humanoid": .humanoid
        case "monstrosity": .monstrosity
        case "ooze": .ooze
        case "plant": .plant
        case "undead": .undead
        case "vehicle": .vehicle
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .aberration: "aberration"
        case .beast: "beast"
        case .celestial: "celestial"
        case .construct: "construct"
        case .dragon: "dragon"
        case .elemental: "elemental"
        case .fey: "fey"
        case .fiend: "fiend"
        case .giant: "giant"
        case .humanoid: "humanoid"
        case .monstrosity: "monstrosity"
        case .ooze: "ooze"
        case .plant: "plant"
        case .undead: "undead"
        case .vehicle: "vehicle"
        case let .other(rawValue): rawValue
        }
    }
}

/// Type of sidekick.
public enum SidekickType: Comparable, Equatable, Hashable, Sendable {
    case expert
    case spellcaster
    case warrior

    /// Custom homebrew value.
    case other(String)
}

extension SidekickType: CaseIterable {
    public static let allCases: [Self] = [
        .expert,
        .spellcaster,
        .warrior,
    ]
}

extension SidekickType: Codable, RawRepresentable {
    public init(rawValue: String) {
        self = switch rawValue {
        case "expert": .expert
        case "spellcaster": .spellcaster
        case "warrior": .warrior
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .expert: "expert"
        case .spellcaster: "spellcaster"
        case .warrior: "warrior"
        case let .other(rawValue): rawValue
        }
    }
}

/// Creature size.
///
/// A creature's size determines the area on a map that it effectively controls in combat and the area it needs to fight
/// effectively.
public enum Size: String, CaseIterable, Sendable {
    case fine
    case diminutive
    case tiny
    case small
    case medium
    case large
    case huge
    case gargantuan
    case colossal
    case varies
}

extension Size: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

/// Tag conveying further information about a creature type.
///
/// For convenience,. ``init(stringLiteral:)`` permits ``Tag`` values to be specified as string literals.
public struct Tag: Equatable, Hashable, Sendable {
    /// Tag.
    public var tag: String

    /// Prefix to display before ``tag``.
    public var prefix: String?

    /// Whether ``prefix`` should be hidden.
    ///
    /// When `true`, ``prefix`` is only used for searching and filtering.
    public var isPrefixHidden: Bool = false

    /// Initialize a tag.
    public init(_ tag: String) {
        self.tag = tag
    }

    /// Initialize a tag with a prefix.
    /// - Parameters:
    ///   - tag: Tag.
    ///   - prefix: Prefix to display before ``tag``.
    ///   - isHidden: Whether ``prefix`` should be hidden.
    public init(_ tag: String, prefix: String, isHidden: Bool = false) {
        self.tag = tag
        self.prefix = prefix
        isPrefixHidden = isHidden
    }
}

extension Tag: ExpressibleByStringLiteral {
    /// Initialize ``tag`` from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Tag: Comparable {
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        (lhs.prefix ?? lhs.tag) < (rhs.prefix ?? rhs.tag)
    }
}
