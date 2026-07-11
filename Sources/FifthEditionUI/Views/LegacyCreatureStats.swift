//
//  LegacyCreatureStats.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

import FifthEdition
import SwiftUI

/// View displaying a legacy Creature's stats.
///
/// A ``LegacyCreatureStats`` view displays a legacy creature's key statistics in the format used at the top of stat
/// blocks in
/// the 2014 5e edition books.
///
/// ## Styling
/// The creature's name, the six abilities, and the title of each stat use the active ``tint(_:)`` color. The
/// `statBlock` color can be used to apply the standard coloring to these elements while still using the primary
/// UI color for the values for higher contrast on a display:
/// ```swift
/// LegacyCreatureStats(creature: creature)
///     .tint(.statBlock)
/// ```
///
/// For a more authentic look with the stat values also tinted, apply the tint using ``foregroundStyle(_:)`` at the
/// same time:
/// ```swift
/// LegacyCreatureStats(creature: creature)
///     .foregroundStyle(.tint)
///     .tint(.statBlock)
/// ```
public struct LegacyCreatureStats: View {
    public let creature: Creature

    public init(creature: Creature) {
        self.creature = creature
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(creature.name)")
                .font(.title.lowercaseSmallCaps())
                .fontDesign(.serif)
                .fontWeight(.semibold)
                .foregroundStyle(.tint)

            let sidekick = if let sidekick = creature.sidekick, sidekick.level != nil || !sidekick.isHidden {
                Text("\(sidekick, format: .sidekick(case: .lowercased)); ")
            } else {
                Text("")
            }

            let alignment = if !creature.alignment.isEmpty {
                Text(", \(creature.alignment, format: .alignment(case: .lowercased))")
            } else {
                Text("")
            }

            Text("\(sidekick)\(creature.size) \(creature.type, format: .types(case: .lowercased))\(alignment)")
                .foregroundStyle(Color.primary)
                .italic()

            Divider()
                .background(.tint)

            if !creature.armorClass.isEmpty {
                Stat("Armor Class", "\(creature.armorClass)")
            }

            if let hitPoints = creature.hitPoints {
                Stat("Hit Points", "\(hitPoints)")
            }

            // TODO: resources
            Stat("Resources", "")

            if !creature.speeds.isEmpty {
                Stat("Speed", "\(creature.speeds, format: .speeds(case: .lowercased))")
            }

            Divider()
                .background(.tint)

            LegacyCreatureAbilities(creature: creature)

            Divider()
                .background(.tint)

            if !creature.savingThrows.isEmpty {
                Stat("Saving Throws", "\(creature.savingThrows)")
            }

            if !creature.skills.isEmpty {
                Stat("Skills", "\(creature.skills)")
            }

            if !creature.tools.isEmpty {
                Stat("Tools", "\(creature.tools, format: .tools(case: .lowercased))")
            }

            if creature.initiative != nil,
               let initiativeModifier = creature[.initiative],
               let passiveInitiative = creature[passive: .initiative]
            {
                Stat("Initiative", "\(initiativeModifier) (\(passiveInitiative))")
            }

            if !creature.damageVulnerabilities.isEmpty {
                Stat("Damage Vulnerabilities",
                     "\(creature.damageVulnerabilities, format: .susceptibles(case: .lowercased))")
            }
            if !creature.damageResistances.isEmpty {
                Stat("Damage Resistances",
                     "\(creature.damageResistances, format: .susceptibles(case: .lowercased))")
            }
            if !creature.damageImmunities.isEmpty {
                Stat("Damage Immunities",
                     "\(creature.damageImmunities, format: .susceptibles(case: .lowercased))")
            }
            if !creature.conditionImmunities.isEmpty {
                Stat("Condition Immunities",
                     "\(creature.conditionImmunities, format: .susceptibles(case: .lowercased))")
            }

            if let passivePerception = creature[passive: .perception] {
                Stat("Senses",
                     "\(creature.senses)\(!creature.senses.isEmpty ? ", " : "")passive Perception \(passivePerception)")
            } else if !creature.senses.isEmpty {
                Stat("Senses", "\(creature.senses)")
            }

            if !creature.languages.isEmpty {
                Stat("Languages", "\(creature.languages)")
            } else {
                Stat("Languages", "None")
            }

            if let challenge = creature.challenge {
                HStack(alignment: .firstTextBaseline) {
                    if challenge.encounter != nil {
                        Stat("Challenge", "\(challenge, format: .challenge(detail: .expanded))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Added in later books, and useful, so always display.
                    if let proficiencyBonus = creature.proficiencyBonus {
                        Stat("Proficiency Bonus", "\(proficiencyBonus)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            // TODO: spell level
            // TODO: class level

            Divider()
                .background(.tint)
        }
    }
}

#Preview {
    let creature = Creature(
        name: "Adult Red Dragon",
        source: "MM",
        size: [.huge],
        type: [.dragon],
        alignment: [.chaoticEvil],
        armorClass: [.ac(19, from: ["natural armor"])],
        hitPoints: "19d12 + 133",
        speeds: [
            .walk: [40],
            .climb: [40],
            .fly: [80],
        ],
        abilities: [
            .strength: 27,
            .dexterity: 10,
            .constitution: 25,
            .intelligence: 16,
            .wisdom: 13,
            .charisma: 21,
        ],
        savingThrows: [
            .dexterity: 6,
            .constitution: 13,
            .wisdom: 7,
            .charisma: 11,
        ],
        skills: [
            .perception: 13,
            .stealth: 6,
        ],
        damageImmunities: [
            .damage(.fire),
        ],
        senses: [
            .sense(.blindsight, range: 60),
            .sense(.darkvision, range: 120),
        ],
        passivePerception: 23,
        languages: [
            .common,
            .draconic,
        ],
        challenge: 17,
    )

    ScrollView {
        LegacyCreatureStats(creature: creature)
            .tint(.legacyStatBlock)
            .padding()
    }
}
