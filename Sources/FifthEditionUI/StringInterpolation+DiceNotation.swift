//
//  StringInterpolation+DiceNotation.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/14/26.
//

import FifthEdition
import SwiftUI

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation(_ die: Die) {
        appendInterpolation(die, format: .die.attributed)
    }

    mutating func appendInterpolation(_ die: Die, format: Die.FormatStyle) {
        appendInterpolation(die, format: format.attributed)
    }

    mutating func appendInterpolation(_ dice: Dice) {
        appendInterpolation(dice, format: .dice().attributed)
    }

    mutating func appendInterpolation(_ dice: Dice, format: Dice.FormatStyle) {
        appendInterpolation(dice, format: format.attributed)
    }

    mutating func appendInterpolation(_ diceNotation: DiceNotation) {
        appendInterpolation(diceNotation, format: .diceNotation.attributed)
    }

    mutating func appendInterpolation(_ diceNotation: DiceNotation, format: DiceNotation.FormatStyle) {
        appendInterpolation(diceNotation, format: format.attributed)
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("Die")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Die.d20)")

            Text("Dice")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Dice.die(.d8, count: 2))")
            Text("\(Dice.modifier(5))")

            Text("DiceNotation")
                .font(.headline)
                .padding(.top, 8)
            Text("\(DiceNotation(.d6, count: 4, modifier: 10))")
        }
    }
    .padding()
}
