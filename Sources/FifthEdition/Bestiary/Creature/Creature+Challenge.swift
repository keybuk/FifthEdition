//
//  Creature+Challenge.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Returns the creature's challenge rating.
    var challengeRating: ChallengeRating? {
        challenge?.encounter?.challengeRating
    }

    /// Returns the creature's proficiency bonus.
    var proficiencyBonus: ProficiencyBonus? {
        challenge?.proficiencyBonus ?? challenge?.encounter.flatMap(ProficiencyBonus.init)
    }
}
