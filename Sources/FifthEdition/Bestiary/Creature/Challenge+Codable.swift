//
//  Challenge+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.Challenge: Codable {
    public enum CodingKeys: String, CodingKey {
        case challengeRating = "cr"
        case lair
        case coven
        case experiencePoints = "xp"
        case xpLair
        /// Not present in the schema, but implement anyway.
        case xpCoven
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object or a Challenge string.
        if let cr = try? decoder.singleValueContainer().decode(ChallengeRating.self) {
            encounter = Encounter(challengeRating: cr)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            encounter = try Encounter(
                challengeRating: container.decode(ChallengeRating.self, forKey: .challengeRating),
                experiencePoints: container.decodeIfPresent(ExperiencePoints.self, forKey: .experiencePoints),
            )

            if let xp = try container.decodeIfPresent(ExperiencePoints.self, forKey: .xpLair) {
                lair = Encounter(experiencePoints: xp)
            } else if let cr = try container.decodeIfPresent(ChallengeRating.self, forKey: .lair) {
                lair = Encounter(challengeRating: cr)
            }

            if let xp = try container.decodeIfPresent(ExperiencePoints.self, forKey: .xpCoven) {
                coven = Encounter(experiencePoints: xp)
            } else if let cr = try container.decodeIfPresent(ChallengeRating.self, forKey: .coven) {
                coven = Encounter(challengeRating: cr)
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        // Value is encoded as an object or a single ChallengeRating string.
        if encounter?.experiencePoints == nil, lair == nil, coven == nil {
            if let challengeRating = encounter?.challengeRating {
                var container = encoder.singleValueContainer()
                try container.encode(challengeRating)
            }
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(encounter?.challengeRating, forKey: .challengeRating)
            try container.encodeIfPresent(encounter?.experiencePoints, forKey: .experiencePoints)

            if let xp = lair?.experiencePoints {
                try container.encode(xp, forKey: .xpLair)
            } else if let cr = lair?.challengeRating {
                try container.encode(cr, forKey: .lair)
            }

            if let xp = coven?.experiencePoints {
                try container.encode(xp, forKey: .xpCoven)
            } else if let cr = coven?.challengeRating {
                try container.encode(cr, forKey: .coven)
            }
        }
    }
}
