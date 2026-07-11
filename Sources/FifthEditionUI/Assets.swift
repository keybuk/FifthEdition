//
//  Assets.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/25/26.
//

import SwiftUI

public extension Color {
    /// Foreground color for stat block entries.
    static let statBlock = Color("StatBlockColor", bundle: .module)

    /// Background color for stat blocks.
    static let statBlockBackground = Color("StatBlockBackgroundColor", bundle: .module)

    /// Border color for stat blocks.
    static let statBlockBorder = Color("StatBlockBorderColor", bundle: .module)

    /// Background color for physical ability scores.
    static let physicalScoreBackground = Color("PhysicalScoreBackgroundColor", bundle: .module)

    /// Background color for physical ability modifiers.
    static let physicalModifierBackground = Color("PhysicalModifierBackgroundColor", bundle: .module)

    /// Background color for mental ability scores.
    static let mentalScoreBackground = Color("MentalScoreBackgroundColor", bundle: .module)

    /// Background color for mental ability modifiers.
    static let mentalModifierBackground = Color("MentalModifierBackgroundColor", bundle: .module)

    /// Foreground color for legacy stat block entries.
    static let legacyStatBlock = Color("LegacyStatBlockColor", bundle: .module)

    /// Background color for legacy stat block entries.
    static let legacyStatBlockBackground = Color("LegacyStatBlockBackgroundColor", bundle: .module)
}

#Preview {
    VStack {
        HStack {
            Color.statBlock
            Color.statBlockBackground
            Color.statBlockBorder
        }
        HStack {
            Color.physicalScoreBackground
            Color.physicalModifierBackground
            Color.mentalScoreBackground
            Color.mentalModifierBackground
        }
        HStack {
            Color.legacyStatBlock
            Color.legacyStatBlockBackground
        }
    }
    .padding()
}
