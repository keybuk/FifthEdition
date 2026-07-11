//
//  Ability+Color.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/26/26.
//

import FifthEdition
import SwiftUI

public extension Ability.Group {
    /// Background color for scores in this group.
    var scoreBackground: Color {
        switch self {
        case .physical: .physicalScoreBackground
        case .mental: .mentalScoreBackground
        }
    }

    /// Background color for modifiers in this group.
    var modifierBackground: Color {
        switch self {
        case .physical: .physicalModifierBackground
        case .mental: .mentalModifierBackground
        }
    }
}

#Preview {
    VStack {
        HStack {
            Ability.Group.physical.scoreBackground
            Ability.Group.physical.modifierBackground
        }
        HStack {
            Ability.Group.mental.scoreBackground
            Ability.Group.mental.modifierBackground
        }
    }
    .padding()
}
