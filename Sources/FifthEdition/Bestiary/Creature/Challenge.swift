//
//  Challenge.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Challenge of defeating a creature.
    ///
    /// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``Challenge`` values to be
    /// specified as integer and string literals.
    struct Challenge: Equatable, Hashable, Sendable {
        /// In a normal encounter.
        ///
        /// Provides the ``ChallengeRating`` for the creature in a normal encounter, and ``ExperiencePoints`` awarded
        /// for
        /// defeating it. For convenience, use ``Creature/challengeRating`` to obtain the provided value.
        public var encounter: Encounter?

        /// While in its lair.
        ///
        /// Provides the ``ExperiencePoints`` awarded for defeating the creature while in its lair, or the equivalent
        /// ``ChallengeRating`` for creatures using 5e (2014) rules.
        public var lair: Encounter?

        /// When part of a coven.
        ///
        /// Provides the ``ExperiencePoints`` awarded for defeating the creature when part of a coven, or the equivalent
        /// ``ChallengeRating`` for creatures using 5e (2014) rules.
        public var coven: Encounter?

        /// Proficiency bonus.
        ///
        /// Provides the ``ProficiencyBonus`` if it differs from that derived from ``encounter``. Use
        /// ``Creature/proficiencyBonus`` to obtain the provided or derived value,.
        public var proficiencyBonus: ProficiencyBonus?

        /// Inititalize for a normal encounter.
        /// - Parameters:
        ///   - challengeRating: Challenge rating.
        ///   - experiencePoints: Experience points awarded for defeat.
        ///   - proficiencyBonus: Proficiency bonus.
        public init(_ challengeRating: ChallengeRating,
                    experiencePoints: ExperiencePoints? = nil,
                    proficiencyBonus: ProficiencyBonus? = nil)
        {
            encounter = Encounter(challengeRating: challengeRating, experiencePoints: experiencePoints)
            self.proficiencyBonus = proficiencyBonus
        }

        /// Initialize for 5.5e (2024) rules.
        /// - Parameters:
        ///   - challengeRating: Challenge rating.
        ///   - experiencePoints: Experience points awarded for defeat.
        ///   - lair: Experience points awarded for defeat while in its lair.
        ///   - coven: Experience points awarded for defeat when part of a coven.
        ///   - proficiencyBonus: Proficiency bonus.
        public init(_ challengeRating: ChallengeRating,
                    experiencePoints: ExperiencePoints? = nil,
                    lair: ExperiencePoints,
                    coven: ExperiencePoints? = nil,
                    proficiencyBonus: ProficiencyBonus? = nil)
        {
            encounter = Encounter(challengeRating: challengeRating, experiencePoints: experiencePoints)
            self.lair = Encounter(experiencePoints: lair)
            if let coven {
                self.coven = Encounter(experiencePoints: coven)
            }
            self.proficiencyBonus = proficiencyBonus
        }

        /// Initialize for 5.5e (2024) rules.
        /// - Parameters:
        ///   - challengeRating: Challenge rating.
        ///   - experiencePoints: Experience points awarded for defeat.
        ///   - lair: Experience points awarded for defeat while in its lair.
        ///   - coven: Experience points awarded for defeat when part of a coven.
        ///   - proficiencyBonus: Proficiency bonus.
        public init(_ challengeRating: ChallengeRating,
                    experiencePoints: ExperiencePoints? = nil,
                    lair: ExperiencePoints? = nil,
                    coven: ExperiencePoints,
                    proficiencyBonus: ProficiencyBonus? = nil)
        {
            encounter = Encounter(challengeRating: challengeRating, experiencePoints: experiencePoints)
            if let lair {
                self.lair = Encounter(experiencePoints: lair)
            }
            self.coven = Encounter(experiencePoints: coven)
            self.proficiencyBonus = proficiencyBonus
        }

        /// Initialize for 5e (2014) rules.
        /// - Parameters:
        ///   - challengeRating: Challenge rating.
        ///   - experiencePoints: Experience points awarded for defeat.
        ///   - lair: Challenge rating while in its lair.
        ///   - coven: Challenge rating when part of a coven.
        ///   - proficiencyBonus: Proficiency bonus.
        public init(_ challengeRating: ChallengeRating,
                    experiencePoints: ExperiencePoints? = nil,
                    lair: ChallengeRating,
                    coven: ChallengeRating? = nil,
                    proficiencyBonus: ProficiencyBonus? = nil)
        {
            encounter = Encounter(challengeRating: challengeRating, experiencePoints: experiencePoints)
            self.lair = Encounter(challengeRating: lair)
            if let coven {
                self.coven = Encounter(challengeRating: coven)
            }
            self.proficiencyBonus = proficiencyBonus
        }

        /// Initialize for 5e (2014) rules.
        /// - Parameters:
        ///   - challengeRating: Challenge rating.
        ///   - experiencePoints: Experience points awarded for defeat.
        ///   - lair: Challenge rating while in its lair.
        ///   - coven: Challenge rating when part of a coven.
        ///   - proficiencyBonus: Proficiency bonus.
        public init(_ challengeRating: ChallengeRating,
                    experiencePoints: ExperiencePoints? = nil,
                    lair: ChallengeRating? = nil,
                    coven: ChallengeRating,
                    proficiencyBonus: ProficiencyBonus? = nil)
        {
            encounter = Encounter(challengeRating: challengeRating, experiencePoints: experiencePoints)
            if let lair {
                self.lair = Encounter(challengeRating: lair)
            }
            self.coven = Encounter(challengeRating: coven)
            self.proficiencyBonus = proficiencyBonus
        }

        /// Initialize with proficiency bonus.
        init(proficiencyBonus: ProficiencyBonus) {
            self.proficiencyBonus = proficiencyBonus
        }
    }
}

extension Creature.Challenge: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``encounter`` from an integer literal.
    public init(integerLiteral value: Int) {
        encounter = Encounter(integerLiteral: value)
    }

    /// Initialize ``encounter`` from a string literal.
    public init(stringLiteral value: StringLiteralType) {
        encounter = Encounter(stringLiteral: value)
    }
}

public extension Creature.Challenge {
    /// The challenge a creature poses in a particular encounter and reward for defeating it.
    ///
    /// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``Encounter`` values to be
    /// specified as integer and string literals.
    struct Encounter: Equatable, Hashable, Sendable {
        /// Challenge rating.
        public var challengeRating: ChallengeRating?

        /// Experience points awarded for defeat.
        public var experiencePoints: ExperiencePoints?

        /// Initialize from challenge rating.
        /// - Parameters:
        ///   - challengeRating: Challenge rating.
        ///   - experiencePoints: Experience points awarded for defeat, if not derived from ``challengeRating``.
        public init(challengeRating: ChallengeRating, experiencePoints: ExperiencePoints? = nil) {
            self.challengeRating = challengeRating
            self.experiencePoints = experiencePoints
        }

        /// Initialize from experience points.
        public init(experiencePoints: ExperiencePoints) {
            self.experiencePoints = experiencePoints
        }
    }
}

extension Creature.Challenge.Encounter: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize from an integer literal.
    ///
    /// Initializes ``experiencePoints`` from `value` when greater than `30`, otherwise initializes ``challengeRating``.
    public init(integerLiteral value: Int) {
        if value > 30 {
            experiencePoints = ExperiencePoints(integerLiteral: value)
        } else {
            challengeRating = ChallengeRating(integerLiteral: value)
        }
    }

    /// Initialize ``ChallengeRating/special(_:)`` from a string literal.
    public init(stringLiteral value: StringLiteralType) {
        challengeRating = ChallengeRating(stringLiteral: value)
    }
}
