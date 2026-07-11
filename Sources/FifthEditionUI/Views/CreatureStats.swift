//
//  CreatureStats.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

import FifthEdition
import SwiftUI

/// View displaying a Creature's stats.
///
/// A ``CreatureStats`` view displays a creature's key statistics in the format used at the top of stat blocks in the
/// books.
///
/// ## Styling
/// The creature's name, the six abilities, and the title of each stat use the active ``tint(_:)`` color. The
/// `statBlock` color can be used to apply the standard coloring to these elements while still using the primary
/// UI color for the values for higher contrast on a display:
/// ```swift
/// CreatureStats(creature: creature)
///     .tint(.statBlock)
/// ```
///
/// For a more authentic look with the stat values also tinted, apply the tint using ``foregroundStyle(_:)`` at the
/// same time:
/// ```swift
/// CreatureStats(creature: creature)
///     .foregroundStyle(.tint)
///     .tint(.statBlock)
/// ```
public struct CreatureStats: View {
    public let creature: Creature

    public init(creature: Creature) {
        self.creature = creature
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text("\(creature.name)")
                .font(.title.lowercaseSmallCaps())
                .fontWeight(.bold)
                .foregroundStyle(.tint)

            Divider()
                .background(.tint)
            let sidekick = if let sidekick = creature.sidekick, sidekick.level != nil || !sidekick.isHidden {
                Text("\(sidekick); ")
            } else {
                Text("")
            }

            let alignment = if !creature.alignment.isEmpty {
                Text(", \(creature.alignment)")
            } else {
                Text("")
            }

            Text("\(sidekick)\(creature.size) \(creature.type)\(alignment)")
                .foregroundStyle(Color.secondary)
                .italic()

            HStack(alignment: .firstTextBaseline) {
                if !creature.armorClass.isEmpty {
                    Stat("AC", "\(creature.armorClass)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let initiativeModifier = creature[.initiative],
                   let passiveInitiative = creature[passive: .initiative]
                {
                    Stat("Initiative", "\(initiativeModifier) (\(passiveInitiative))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let hitPoints = creature.hitPoints {
                Stat("HP", "\(hitPoints)")
            }

            // TODO: resources
            Stat("Resources", "")

            if !creature.speeds.isEmpty {
                Stat("Speed", "\(creature.speeds)")
            }

            CreatureAbilities(creature: creature)

            if let savingThrowsSpecial = creature.savingThrows.special {
                // FIXME: MARKUP: actually Entry
                Stat("Saving Throws", "\(savingThrowsSpecial)")
            }

            if !creature.skills.isEmpty {
                Stat("Skills", "\(creature.skills)")
            }

            if !creature.tools.isEmpty {
                Stat("Tools", "\(creature.tools)")
            }

            if !creature.damageVulnerabilities.isEmpty {
                Stat("Vulnerabilities", "\(creature.damageVulnerabilities)")
            }
            if !creature.damageResistances.isEmpty {
                Stat("Resistances", "\(creature.damageResistances)")
            }

            let immunities = creature.damageImmunities.union(creature.conditionImmunities)
            if !immunities.isEmpty {
                Stat("Immunities", "\(immunities)")
            }

            if !creature.gear.isEmpty {
                Stat("Gear", "\(creature.gear)")
            }

            if let passivePerception = creature[passive: .perception] {
                Stat("Senses",
                     "\(creature.senses)\(!creature.senses.isEmpty ? "; " : "")Passive Perception \(passivePerception)")
            } else if !creature.senses.isEmpty {
                Stat("Senses", "\(creature.senses)")
            }

            if !creature.languages.isEmpty {
                Stat("Languages", "\(creature.languages)")
            } else {
                Stat("Languages", "None")
            }

            if let challenge = creature.challenge {
                Stat("CR", "\(challenge)")
            }
            // TODO: spell level
            // TODO: class level
        }
    }
}

#Preview {
    let creature = Creature(
        name: "Adult Red Dragon",
        source: "XMM",
        size: [.huge],
        type: .init(.dragon, tags: ["chromatic"]),
        alignment: [.chaoticEvil],
        armorClass: [19],
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
            .charisma: 23,
        ],
        savingThrows: [
            .dexterity: 6,
            .wisdom: 7,
        ],
        skills: [
            .perception: 13,
            .stealth: 6,
        ],
        initiative: .proficiency(.expertise),
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
        challenge: .init(17, lair: .xp(20000)),
    )

    ScrollView {
        CreatureStats(creature: creature)
            .tint(.statBlock)
            .padding()
    }
}
