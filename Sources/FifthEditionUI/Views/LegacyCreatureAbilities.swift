//
//  LegacyCreatureAbilities.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/9/26.
//

import FifthEdition
import SwiftUI

/// View displaying a legacy Creature's ability scores.
///
/// A ``LegacyCreatureAbilities`` view displays a legacy creature's ability scores in the format used within stat blocks
/// in the 2014 5e edition books.
///
/// ## Styling
/// The names of the six abilities use the active ``tint(_:)`` color. The `statBlock` color can be used to
/// apply the standard coloring to these elements while still using the primary
/// UI color for the scores and modifiers for higher contrast on a display:
/// ```swift
/// LegacyCreatureAbilities(creature: creature)
///     .tint(.statBlock)
/// ```
///
/// For a more authentic look with the score and modifiers values also tinted, apply the tint using
/// ``foregroundStyle(_:)`` at the
/// same time:
/// ```swift
/// LegacyCreatureAbilities(creature: creature)
///     .foregroundStyle(.tint)
///     .tint(.statBlock)
/// ```
public struct LegacyCreatureAbilities: View {
    public let creature: Creature

    public init(creature: Creature) {
        self.creature = creature
    }

    public var body: some View {
        Grid {
            GridRow {
                ForEach(Ability.allCases, id: \.self) { ability in
                    Text("\(ability, format: .ability(case: .uppercased, width: .short))")
                        .fontWeight(.bold)
                        .foregroundStyle(.tint)
                        .frame(maxWidth: .infinity)
                }
            }

            GridRow {
                ForEach(Ability.allCases, id: \.self) { ability in
                    let abilityScore = creature.abilities[ability]
                    if let abilityScore, let abilityModifier = creature[ability] {
                        Text("\(abilityScore) (\(abilityModifier))")
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("\(abilityScore ?? "—")")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

#Preview {
    let creature = Creature(
        name: "Adult Red Dragon",
        source: "MM",
        size: [.huge],
        type: [.dragon],
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
    )

    ScrollView {
        LegacyCreatureAbilities(creature: creature)
            .tint(.legacyStatBlock)
            .padding()
    }
}
