//
//  Type.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

import RawRepresentableOptions

/// The nine alignments.
///
/// A creature’s alignment broadly describes its ethical attitudes and ideals. Alignment is a combination of two
/// factors: one identifies morality (good, evil, or neutral), and the other describes attitudes toward order (lawful,
/// chaotic, or neutral).
public enum Alignment: String, CaseIterable, Sendable {
    case lawfulGood = "lawful good"
    case lawfulNeutral = "lawful neutral"
    case lawfulEvil = "lawful evil"
    case neutralGood = "neutral good"
    case neutral
    case neutralEvil = "neutral evil"
    case chaoticGood = "chaotic good"
    case chaoticNeutral = "chaotic neutral"
    case chaoticEvil = "chaotic evil"
}

extension Alignment: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

public extension Set<Alignment> {
    static let lawfulGood: Self = [.lawfulGood]
    static let lawfulNeutral: Self = [.lawfulNeutral]
    static let lawfulEvil: Self = [.lawfulEvil]
    static let neutralGood: Self = [.neutralGood]
    static let neutral: Self = [.neutral]
    static let neutralEvil: Self = [.neutralEvil]
    static let chaoticGood: Self = [.chaoticGood]
    static let chaoticNeutral: Self = [.chaoticNeutral]
    static let chaoticEvil: Self = [.chaoticEvil]

    /// Unaligned.
    static let unaligned: Self = []

    /// Any alignment.
    static let any = Self(Element.allCases)

    /// Any lawful alignment.
    static let anyLawful: Self = [.lawfulGood, .lawfulNeutral, .lawfulEvil]

    /// Any non-lawful alignment.
    static let anyNonLawful: Self = .any.subtracting(.anyLawful)

    /// Any alignment neutral on order.
    static let anyNeutralOrder: Self = [.neutralGood, .neutral, .neutralEvil]

    /// Any chaotic alignment.
    static let anyChaotic: Self = [.chaoticGood, .chaoticNeutral, .chaoticEvil]

    /// Any non-chaotic alignment.
    static let anyNonChaotic: Self = .any.subtracting(.anyChaotic)

    /// Any good alignment.
    static let anyGood: Self = [.lawfulGood, .neutralGood, .chaoticGood]

    /// Any non-good alignment.
    static let anyNonGood: Self = .any.subtracting(.anyGood)

    /// Any alignment neutral on morarily.
    static let anyNeutralMorality: Self = [.lawfulNeutral, .neutral, .chaoticNeutral]

    /// Any evil alignment.
    static let anyEvil: Self = [.lawfulEvil, .neutralEvil, .chaoticEvil]

    /// Any non-evil alignment.
    static let anyNonEvil: Self = .any.subtracting(.anyEvil)

    /// Any neutral alignment.
    static let anyNeutral: Self = .anyNeutralMorality.union(Self.anyNeutralOrder)
}

/// Type of creature.
///
/// Each creature has a type. Certain spells, magic items, class features, and other effects in the game interact in
/// special ways with creatures of a particular type.
@RawRepresentableOptions
public struct CreatureType: CaseIterable, Codable, Equatable, Hashable, Sendable {
    private enum Options: String {
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
    }
}

/// Age of Dragon.
@RawRepresentableOptions
public struct DragonAge: CaseIterable, Codable, Equatable, Hashable, Sendable {
    enum Options: String {
        case young
        case adult
        case wyrmling
        case greatwyrm
        case ancient
        case aspect
    }
}

/// Color of Dragon.
@RawRepresentableOptions
public struct DragonColor: CaseIterable, Codable, Equatable, Hashable, Sendable {
    enum Options: String {
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
}

/// Type of sidekick.
@RawRepresentableOptions
public struct SidekickType: CaseIterable, Codable, Equatable, Hashable, Sendable {
    private enum Options: String {
        case expert
        case spellcaster
        case warrior
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
