//
//  Ability.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

/// The six abilities.
///
/// All creatures have six abilities that measure physical and mental characteristics.
public enum Ability: String, CaseIterable, Codable, Sendable {
    case strength
    case dexterity
    case constitution
    case intelligence
    case wisdom
    case charisma
}

extension Ability: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

public extension Ability {
    /// Ability grouping.
    ///
    /// The six abilities are divided into two groups of three, representing the ``physical`` and ``mental`` abilities.
    enum Group: CaseIterable, Comparable, Equatable, Hashable, Sendable {
        case physical
        case mental
    }

    /// Returns whether this ability is physical or mental.
    var group: Group {
        switch self {
        case .constitution, .dexterity, .strength:
            .physical
        case .charisma, .intelligence, .wisdom:
            .mental
        }
    }
}

/// Ability modifier.
///
/// Each ``Ability`` has a modifier applied when making D20 Tests, typically in the range `-5...10` given in the
/// associated value of ``modifier(_:)``.
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``AbilityModifier`` values to be
/// specified as integer and string literals.
public enum AbilityModifier: Equatable, Hashable, Sendable {
    case modifier(Int)
    case special(String)
}

public extension AbilityModifier {
    /// Initialize from an ability score.
    /// - Parameter abilityScore: Ability score to derive modifier from.
    /// - Returns: Ability modifier, or `nil` if `abilityScore` is ``AbilityScore/special(_:)``.
    init?(_ abilityScore: AbilityScore) {
        guard case let .score(score) = abilityScore else { return nil }
        self = .modifier(Int((Double(score - 10) / 2).rounded(.down)))
    }
}

extension AbilityModifier: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``modifier(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .modifier(value)
    }

    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: String) {
        self = .special(value)
    }
}

extension AbilityModifier: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.modifier(lhsModifier), .modifier(rhsModifier)):
            lhsModifier < rhsModifier
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}

extension AbilityModifier: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .modifier(modifier):
            modifier.formatted(.number.sign(strategy: .always()))
        case let .special(special):
            special
        }
    }
}

/// Ability score.
///
/// Each ``Ability`` has a score from `1...30` given in the associated value of ``score(_:)``.
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``AbilityScore`` values to be
/// specified as integer and string literals.
public enum AbilityScore: Equatable, Hashable, Sendable {
    case score(Int)
    case special(String)
}

extension AbilityScore: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``score(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .score(value)
    }

    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: String) {
        self = .special(value)
    }
}

extension AbilityScore: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.score(lhsScore), .score(rhsScore)):
            lhsScore < rhsScore
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}

extension AbilityScore: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .score(score): score.formatted(.number)
        case let .special(special): special
        }
    }
}

/// Whether a roll is made with advantage or disadvantage.
///
/// ``advantage`` reflects the positive circumstances surrounding a d20 roll, while ``disadvantage`` reflects negative
/// circumstances.
public enum Advantage: String, CaseIterable, Sendable {
    case advantage
    case disadvantage
}

/// How an initiative roll is made.
///
/// Initiative determines the order of turns during combat.
///
/// ``modifier(_:)`` indicates the creature uses a different modifier to its dexterity, ``proficiency(_:)``
/// indicates the creature adds their proficiency bonus to the roll once or twice, and ``advantage(_:)`` indicates the
/// roll is made with advantage.
///
/// For convenience, ``init(integerLiteral:)`` permits ``Initiative/modifier(_:)`` values to be specified as integer
/// literals.
public enum Initiative: Equatable, Hashable, Sendable {
    case modifier(Int)
    case proficiency(Proficiency)
    case advantage(Advantage)
}

extension Initiative: ExpressibleByIntegerLiteral {
    /// Initialize ``modifier(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .modifier(value)
    }
}

/// Passive ability score.
///
/// A passive check is a special kind of ``Ability`` check that doesn't involve any die rolls, typically in the range
/// `-5...20` and given in ``passive(_:)``.
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``Passive`` values to be
/// specified as integer and string literals.
public enum Passive: Equatable, Hashable, Sendable {
    case passive(Int)
    case special(String)
}

public extension Passive {
    /// Initialize from an ability modifier.
    /// - Parameters:
    ///   - abilityModifier: Ability modifier to derive passive score from.
    ///   - advantage: Whether the check has advantage or disadvantage.
    /// - Returns: Passive score, or `nil` if `abilityModifier` is ``AbilityModifier/special(_:)``.
    init?(_ abilityModifier: AbilityModifier?, advantage: Advantage? = nil) {
        guard case let .modifier(modifier) = abilityModifier else { return nil }
        let advantageModifier = switch advantage {
        case .advantage: 5
        case .disadvantage: -5
        default: 0
        }
        self = .passive(10 + modifier + advantageModifier)
    }
}

extension Passive: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``passive(_:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .passive(value)
    }

    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: String) {
        self = .special(value)
    }
}

extension Passive: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.passive(lhsPassive), .passive(rhsPassive)):
            lhsPassive < rhsPassive
        case let (.special(lhsSpecial), .special(rhsSpecial)):
            lhsSpecial < rhsSpecial
        case (_, .special): true
        default: false
        }
    }
}

extension Passive: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .passive(passive): passive.formatted(.number)
        case let .special(special): special
        }
    }
}

/// Whether a roll is made with proficiency or expertise.
///
/// `rawValue` is the number of times a creature's proficiency bonus should be added to the roll.
public enum Proficiency: Int, CaseIterable, Codable, Sendable {
    case proficient = 1
    case expertise = 2
}

/// The eighteen skills.
///
/// Most ``Ability`` checks involve using a skill, which represents a category of things creatures try to do with an
/// ability check.
public enum Skill: String, CaseIterable, Codable, CodingKeyRepresentable, Sendable {
    case acrobatics
    case animalHandling = "animal handling"
    case arcana
    case athletics
    case deception
    case history
    case insight
    case intimidation
    case investigation
    case medicine
    case nature
    case perception
    case performance
    case persuasion
    case religion
    case sleightOfHand = "sleight of hand"
    case stealth
    case survival
}

public extension Skill {
    /// Returns the ability the skill most often applies to.
    var ability: Ability {
        switch self {
        case .acrobatics: .dexterity
        case .animalHandling: .wisdom
        case .arcana: .intelligence
        case .athletics: .strength
        case .deception: .charisma
        case .history: .intelligence
        case .insight: .wisdom
        case .intimidation: .charisma
        case .investigation: .intelligence
        case .medicine: .wisdom
        case .nature: .intelligence
        case .perception: .wisdom
        case .performance: .charisma
        case .persuasion: .charisma
        case .religion: .intelligence
        case .sleightOfHand: .dexterity
        case .stealth: .dexterity
        case .survival: .wisdom
        }
    }
}

extension Skill: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
