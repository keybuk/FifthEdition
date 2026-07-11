//
//  Susceptible.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/30/26.
//

/// Condition affecting a creature.
///
/// A condition is a temporary game state. The definition of a condition says how it affects its recipient.
public enum Condition: Comparable, Equatable, Hashable, Sendable {
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

    /// Custom homebrew value.
    case other(String)
}

extension Condition: CaseIterable {
    public static let allCases: [Self] = [
        .blinded,
        .charmed,
        .deafened,
        .exhaustion,
        .frightened,
        .grappled,
        .incapacitated,
        .invisible,
        .paralyzed,
        .petrified,
        .poisoned,
        .prone,
        .restrained,
        .stunned,
        .unconscious,
        .disease,
    ]
}

extension Condition: Codable, RawRepresentable {
    public init(rawValue: String) {
        self = switch rawValue {
        case "blinded": .blinded
        case "charmed": .charmed
        case "deafened": .deafened
        case "exhaustion": .exhaustion
        case "frightened": .frightened
        case "grappled": .grappled
        case "incapacitated": .incapacitated
        case "invisible": .invisible
        case "paralyzed": .paralyzed
        case "petrified": .petrified
        case "poisoned": .poisoned
        case "prone": .prone
        case "restrained": .restrained
        case "stunned": .stunned
        case "unconscious": .unconscious
        case "disease": .disease
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .blinded: "blinded"
        case .charmed: "charmed"
        case .deafened: "deafened"
        case .exhaustion: "exhaustion"
        case .frightened: "frightened"
        case .grappled: "grappled"
        case .incapacitated: "incapacitated"
        case .invisible: "invisible"
        case .paralyzed: "paralyzed"
        case .petrified: "petrified"
        case .poisoned: "poisoned"
        case .prone: "prone"
        case .restrained: "restrained"
        case .stunned: "stunned"
        case .unconscious: "unconscious"
        case .disease: "disease"
        case let .other(rawValue): rawValue
        }
    }
}

/// Immunity, resistance, or vulnerability to a condition or type of damage.
///
/// ``condition(_:)`` represents a creature's immunity to a condition, while ``damage(_:)`` represents a creature's
/// immunity, resistance, or vulnerability to a type of damage.
///
/// Recursively expanded sets of conditions or damage types, along with rules given as human-readable text, are given
/// in the associated values of ``susceptible(_:preNote:note:isConditional:)``.
///
/// The `isConditional` associated value when `true` specifies that the text is formatted as a sentence, when
/// omitted, it is formatted as a grouping, for example:
/// ```swift
/// Susceptible.susceptible([.damage(.fire), damage(.lightning)])
///     .formatted()
/// // "Fire, Lightning"
///
/// Susceptible.susceptible([.damage(.bludgeoning), damage(.piercing), damage(.slashing)],
///     .note: "from nonmagical weapons that aren't silvered", isConditional: true))
///     .formatted()
/// // "Bludgeoning, Piercing, and Slashing from nonmagical weapons that aren't silvered"
/// ```
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
public enum Susceptible: Equatable, Hashable, Sendable {
    case condition(Condition)
    case damage(Damage)
    case susceptible(Set<Susceptible>, preNote: String? = nil, note: String? = nil, isConditional: Bool = false)
    case special(String)
}

extension Susceptible: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.condition(lhsCondition), .condition(rhsCondition)):
            lhsCondition.rawValue < rhsCondition.rawValue
        case let (.damage(lhsDamage), .damage(rhsDamage)):
            lhsDamage.rawValue < rhsDamage.rawValue
        case let (.susceptible(lhsSusceptible, _, _, _), .susceptible(rhsSusceptible, _, _, _)):
            if lhsSusceptible.isEmpty {
                true
            } else if rhsSusceptible.isEmpty {
                true
            } else {
                lhsSusceptible.min()! < rhsSusceptible.min()!
            }
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        case (.special, _): false
        case (_, .susceptible): true
        case (.susceptible, _): false
        case (_, .condition): true
        case (.condition, _): false
        default: false
        }
    }
}

/// Type of damage.
///
/// Each instance of damage has a type, like ``fire`` or ``slashing``. Damage types have no rules of their own, but
/// other rules, such as Resistance, rely on damage types.
public enum Damage: Comparable, Equatable, Hashable, Sendable {
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

    /// Custom homebrew value.
    case other(String)
}

extension Damage: CaseIterable {
    public static let allCases: [Self] = [
        .acid,
        .bludgeoning,
        .cold,
        .fire,
        .force,
        .lightning,
        .necrotic,
        .piercing,
        .poison,
        .psychic,
        .radiant,
        .slashing,
        .thunder,
    ]
}

extension Damage: Codable, RawRepresentable {
    public init(rawValue: String) {
        self = switch rawValue {
        case "acid": .acid
        case "bludgeoning": .bludgeoning
        case "cold": .cold
        case "fire": .fire
        case "force": .force
        case "lightning": .lightning
        case "necrotic": .necrotic
        case "piercing": .piercing
        case "poison": .poison
        case "psychic": .psychic
        case "radiant": .radiant
        case "slashing": .slashing
        case "thunder": .thunder
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .acid: "acid"
        case .bludgeoning: "bludgeoning"
        case .cold: "cold"
        case .fire: "fire"
        case .force: "force"
        case .lightning: "lightning"
        case .necrotic: "necrotic"
        case .piercing: "piercing"
        case .poison: "poison"
        case .psychic: "psychic"
        case .radiant: "radiant"
        case .slashing: "slashing"
        case .thunder: "thunder"
        case let .other(rawValue): rawValue
        }
    }
}
