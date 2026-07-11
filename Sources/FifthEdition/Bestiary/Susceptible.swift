//
//  Susceptible.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/30/26.
//

import RawRepresentableOptions

/// Condition affecting a creature.
///
/// A condition is a temporary game state. The definition of a condition says how it affects its recipient.
@RawRepresentableOptions
public struct Condition: CaseIterable, Codable, Equatable, Hashable, Sendable {
    private enum Options: String {
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
@RawRepresentableOptions
public struct Damage: CaseIterable, Codable, Equatable, Hashable, Sendable {
    private enum Options: String {
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
}
