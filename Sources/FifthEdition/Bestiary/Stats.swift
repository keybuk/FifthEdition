//
//  Stats.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/19/26.
//

/// Armor class.
///
/// A creature’s Armor Class represents how well the creature avoids being wounded in combat, typically in the range
/// `10...25` given in the associated value of ``ac(_:from:condition:inParens:)``. Human-readable text detailing the
/// source of the armor and any conditions for the choice are given in the `from` and `condition` associated values.
///
/// The `inParens` associated value specifies that the formatting is parenthesized and merged with any previously
/// parenthesized part, for example:
/// ```swift
/// [.ac(14, condition: "in bear form")].formatted()
/// // "14 in bear form"
///
/// [.ac(14, condition: "in bear form", inParens: true)].formatted()
/// // "(14 in bear form)"
///
/// [.ac(12, from: "natural armor"),
///  .ac(14, condition: "in bear form")].formatted()
/// // "12 (natural armor), 14 in bear form"
///
/// [.ac(12, from: "natural armor"),
///  .ac(14, condition: "in bear form", inParens: true)].formatted()
/// // "12 (natural armor; 14 in bear form)"
/// ```
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``ArmorClass`` values to be
/// specified as integer and string literals.
public enum ArmorClass: Equatable, Hashable, Sendable {
    case ac(Int, from: [String]? = nil, condition: String? = nil, inParens: Bool = false)
    case special(String)
}

extension ArmorClass: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``ac(_:from:condition:inParens:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .ac(value)
    }

    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: StringLiteralType) {
        self = .special(value)
    }
}

extension ArmorClass: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.ac(lhsAc, _, _, _), .ac(rhsAc, _, _, _)):
            lhsAc < rhsAc
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}

/// Hit points.
///
/// Hit Points represent durability and the will to live, usually provided as a ``DiceNotation`` formula given in
/// the associated value of ``hp(_:given:)``. The `given` associated value is `nil` if the creature's hit points matches
/// the ``DiceNotation/average``, otherwise provides the actual hit points value.
///
/// In the event the formula is not parseable, the average and formula are given in the associated values of
/// ``other(_:formula:)``.
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(stringLiteral:)``  permits ``HitPoints`` values to be specified as string literals.
public enum HitPoints: Equatable, Hashable, Sendable {
    case hp(DiceNotation, given: Int? = nil)
    case other(Int, formula: String)
    case special(String)
}

extension HitPoints: ExpressibleByStringLiteral {
    /// Initialize from a string literal.
    ///
    /// Sets ``hp(_:given:)`` when `value` is parseable as a ``DiceNotation``, otherwise sets ``special(_:)``.
    public init(stringLiteral value: StringLiteralType) {
        if let diceNotation = DiceNotation(string: value) {
            self = .hp(diceNotation)
        } else {
            self = .special(value)
        }
    }
}

extension HitPoints: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.hp(lhsHp, lhsGiven), .hp(rhsHp, rhsGiven)):
            (lhsGiven ?? lhsHp.average) < (rhsGiven ?? rhsHp.average)
        case let (.other(lhsHp, _), .other(rhsHp, _)):
            lhsHp < rhsHp
        case let (.hp(lhsHp, lhsGiven), .other(rhsHp, _)):
            (lhsGiven ?? lhsHp.average) < rhsHp
        case let (.other(lhsHp, _), .hp(rhsHp, rhsGiven)):
            lhsHp < (rhsGiven ?? rhsHp.average)
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}

/// Modes of movement.
///
/// On its turn, a creature can move a distance equal to its Speed or less. These different modes of movement can be
/// combined, or they can constitute its entire move.
public enum Movement: String, CaseIterable, Codable, CodingKeyRepresentable, Sendable {
    case walk
    case burrow
    case climb
    case fly
    case swim
}

extension Movement: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

/// Speed.
///
/// On its turn, a creature can move a distance equal to or less than its Speed, given in the associated value of
/// ``speed(_:condition:)``. Human-readable text detailing any conditions for the speed is given in the `condition`
/// associated value.
///
/// For convenience, ``init(integerLiteral:)`` permits ``Speed`` values to be specified as integer literals.
public enum Speed: Equatable, Hashable, Sendable {
    case speed(Int, condition: String? = nil)
    case walkingSpeed
}

extension Speed: ExpressibleByIntegerLiteral {
    /// Initialize ``speed(_:condition:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .speed(value)
    }
}

extension Speed: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.speed(lhsSpeed, _), .speed(rhsSpeed, _)):
            lhsSpeed < rhsSpeed
        case (.walkingSpeed, .walkingSpeed): false
        case (_, .walkingSpeed): true
        default: false
        }
    }
}
