//
//  CreatureAbilities.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/9/26.
//

import FifthEdition
import SwiftUI

/// View displaying a Creature's ability scores.
///
/// A ``CreatureAbilities`` view displays a creature's ability scores in the format used within stat blocks in the
/// books.
///
/// ## Styling
/// The names of the six abilities use the active ``tint(_:)`` color. The `statBlock` color can be used to
/// apply the standard coloring to these elements while still using the primary
/// UI color for the scores and modifiers for higher contrast on a display:
/// ```swift
/// CreatureAbilities(creature: creature)
///     .tint(.statBlock)
/// ```
///
/// For a more authentic look with the score and modifiers values also tinted, apply the tint using
/// ``foregroundStyle(_:)`` at the
/// same time:
/// ```swift
/// CreatureAbilities(creature: creature)
///     .foregroundStyle(.tint)
///     .tint(.statBlock)
/// ```
public struct CreatureAbilities: View {
    public let creature: Creature

    public init(creature: Creature) {
        self.creature = creature
    }

    public var body: some View {
        ViewThatFits(in: .horizontal) {
            // Book style: 3x2 with physical scores on top.
            HStack(alignment: .firstTextBaseline) {
                Grid(horizontalSpacing: 0, verticalSpacing: 1) {
                    header
                    scores(for: .strength)
                    scores(for: .intelligence)
                }

                Grid(horizontalSpacing: 0, verticalSpacing: 1) {
                    header
                    scores(for: .dexterity)
                    scores(for: .wisdom)
                }

                Grid(horizontalSpacing: 0, verticalSpacing: 1) {
                    header
                    scores(for: .constitution)
                    scores(for: .charisma)
                }
            }

            // D&D Beyond style: 2x3 with physical scores on left.
            HStack(alignment: .firstTextBaseline) {
                Grid(horizontalSpacing: 0, verticalSpacing: 1) {
                    header
                    scores(for: .strength)
                    scores(for: .dexterity)
                    scores(for: .constitution)
                }

                Grid(horizontalSpacing: 0, verticalSpacing: 1) {
                    header
                    scores(for: .intelligence)
                    scores(for: .wisdom)
                    scores(for: .charisma)
                }
            }
        }
    }

    var header: some View {
        GridRow {
            Color.clear
                .gridCellColumns(2)
                .gridCellUnsizedAxes([.horizontal, .vertical])
            Text("MOD")
                .font(.caption)
                .foregroundStyle(Color.secondary)
            Text("SAVE")
                .font(.caption)
                .foregroundStyle(Color.secondary)
        }
    }

    func scores(for ability: Ability) -> some View {
        GridRow {
            Text("\(ability, format: .ability(width: .short))")
                .font(.body.lowercaseSmallCaps())
                .fontWeight(.bold)
                .foregroundStyle(.tint)
                .fixedSize()
                .padding([.top, .bottom], 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ability.group.scoreBackground)

            let abilityScore = creature.abilities[ability]
            let abilityModifier = creature[ability]
            let isSpecial = (abilityScore != nil) != (abilityModifier != nil)

            Text("\(abilityScore ?? "—")")
                .padding([.top, .bottom], 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isSpecial ? ability.group.modifierBackground : ability.group.scoreBackground)
                .gridCellColumns(isSpecial ? 2 : 1)

            if !isSpecial {
                Text("\(abilityModifier ?? "—")")
                    .padding([.top, .bottom], 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ability.group.modifierBackground)
            }

            Text("\(creature[savingThrow: ability] ?? "—")")
                .padding([.top, .bottom], 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ability.group.modifierBackground)
        }
    }
}

#Preview {
    let creature = Creature(
        name: "Adult Red Dragon",
        source: "XMM",
        size: [.huge],
        type: [.dragon],
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
    )

    ScrollView {
        CreatureAbilities(creature: creature)
            .tint(.statBlock)
            .padding()
    }
}
