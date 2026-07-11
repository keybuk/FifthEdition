//
//  ChallengeRating.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

/// Creature's challenge rating.
///
/// Challenge Rating (CR) summarizes the threat a monster poses to a group of four player characters, typically in the
/// range `0...30` given in the associated value of ``cr(_:)``.
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``ChallengeRating`` values to be
/// specified as integer and string literals.
public enum ChallengeRating: Equatable, Hashable, Sendable {
    case cr(Double)
    case special(String)
}

extension ChallengeRating: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``cr(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .cr(Double(value))
    }

    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: StringLiteralType) {
        self = .special(value)
    }
}

extension ChallengeRating: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.cr(lhsCr), .cr(rhsCr)):
            lhsCr < rhsCr
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}

extension ChallengeRating: CustomStringConvertible {
    public var description: String {
        switch self {
        case .cr(1 / 8): "1/8"
        case .cr(1 / 4): "1/4"
        case .cr(1 / 2): "1/2"
        case let .cr(cr): Int(cr).formatted(.number)
        case let .special(special): special
        }
    }
}

/// Experience points earned for defeating a creature.
///
/// XP is awarded for defeating the monster in combat or otherwise neutralizing it given in the associated value of
/// ``xp(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` permits ``ExperiencePoints`` values to be specified as an integer
/// literal.
public enum ExperiencePoints: Equatable, Hashable, Sendable {
    case xp(Int)
}

extension ExperiencePoints {
    /// Initialize from a challenge rating.
    /// - Parameter challengeRating: Challenge rating to derive experience points from.
    /// - Returns: Experience points, or `nil` if `challengeRating` is ``ChallengeRating/special(_:)`` or an unknown
    /// value.
    init?(_ challengeRating: ChallengeRating) {
        guard case let .cr(cr) = challengeRating else { return nil }
        switch cr {
        case 0: self = .xp(10)
        case 1 / 8: self = .xp(25)
        case 1 / 4: self = .xp(50)
        case 1 / 2: self = .xp(100)
        case 1: self = .xp(200)
        case 2: self = .xp(450)
        case 3: self = .xp(700)
        case 4: self = .xp(1100)
        case 5: self = .xp(1800)
        case 6: self = .xp(2300)
        case 7: self = .xp(2900)
        case 8: self = .xp(3900)
        case 9: self = .xp(5000)
        case 10: self = .xp(5900)
        case 11: self = .xp(7200)
        case 12: self = .xp(8400)
        case 13: self = .xp(10000)
        case 14: self = .xp(11500)
        case 15: self = .xp(13000)
        case 16: self = .xp(15000)
        case 17: self = .xp(18000)
        case 18: self = .xp(20000)
        case 19: self = .xp(22000)
        case 20: self = .xp(25000)
        case 21: self = .xp(33000)
        case 22: self = .xp(41000)
        case 23: self = .xp(50000)
        case 24: self = .xp(62000)
        case 25: self = .xp(75000)
        case 26: self = .xp(90000)
        case 27: self = .xp(105_000)
        case 28: self = .xp(120_000)
        case 29: self = .xp(135_000)
        case 30: self = .xp(155_000)
        default: return nil
        }
    }

    /// Initialize from a challenge encounter.
    /// - Parameter encounter: Challenge encounter to derive from.
    /// - Returns: ``Challenge/Encounter/experiencePoints``, or experience points derived from
    /// ``Challenge/Encounter/challengeRating``, or `nil`.
    init?(_ encounter: Creature.Challenge.Encounter) {
        if let experiencePoints = encounter.experiencePoints {
            self = experiencePoints
        } else if let challengeRating = encounter.challengeRating,
                  let experiencePoints = Self(challengeRating)
        {
            self = experiencePoints
        } else {
            return nil
        }
    }
}

extension ExperiencePoints: ExpressibleByIntegerLiteral {
    /// Initialize ``xp(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .xp(value)
    }
}

extension ExperiencePoints: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.xp(lhsXp), .xp(rhsXp)):
            lhsXp < rhsXp
        }
    }
}

extension ExperiencePoints: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .xp(xp): xp.formatted(.number)
        }
    }
}

/// Proficiency bonus.
///
/// Creatures have a Proficiency Bonus, which reflects the impact that training has on the creature’s capabilities,
/// typically in the range `2...9` given in the associated value of ``bonus(_:)``.
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``ProficiencyBonus`` values to be
/// specified as integer and string literals.
public enum ProficiencyBonus: Equatable, Hashable, Sendable {
    case bonus(Int)
    case special(String)
}

public extension ProficiencyBonus {
    /// Initialize from a challenge rating.
    /// - Parameter challengeRating: Challenge rating to derive bonus from.
    /// - Returns: Proficiency bonus, or `nil` if `challengeRating` is ``ChallengeRating/special(_:)``.
    init?(_ challengeRating: ChallengeRating) {
        guard case let .cr(cr) = challengeRating else { return nil }
        self = .bonus(max(2, Int((cr / 4).rounded(.up)) + 1))
    }

    /// Initialize from a challenge encounter.
    /// - Parameter encounter: Challenge encounter to derive bonus from.
    /// - Returns: Proficiency bonus derived from ``Creature/Challenge/Encounter/challengeRating``, or `nil`.
    init?(_ encounter: Creature.Challenge.Encounter) {
        if let challengeRating = encounter.challengeRating,
           let proficiencyBonus = Self(challengeRating)
        {
            self = proficiencyBonus
        } else {
            return nil
        }
    }
}

extension ProficiencyBonus: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``bonus(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .bonus(value)
    }

    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: StringLiteralType) {
        self = .special(value)
    }
}

extension ProficiencyBonus: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.bonus(lhsbonus), .bonus(rhsbonus)):
            lhsbonus < rhsbonus
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}

extension ProficiencyBonus: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .bonus(bonus):
            bonus.formatted(.number.sign(strategy: .always()))
        case let .special(special):
            special
        }
    }
}
