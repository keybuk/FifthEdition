//
//  Alignments+Parse.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 10/9/26.
//

extension Creature.Alignment {
    /// Parse alignments from array of strings.
    /// - Parameters:
    ///   - strings: Strings of encoded alignment set.
    ///   - chance: Probability creature has this alignment.
    ///   - note: Human-readable text about the choice.
    init(strings: Set<String>,
         chance: Int? = nil,
         note: String? = nil)
    {
        var order: Set<Alignment> = []
        var morality: Set<Alignment> = []
        var isNeutral = false

        for string in strings {
            switch string {
            case "L": order.formUnion(Set<Alignment>.anyLawful)
            case "NX": order.formUnion(Set<Alignment>.anyNeutralOrder)
            case "C": order.formUnion(Set<Alignment>.anyChaotic)
            case "G": morality.formUnion(Set<Alignment>.anyGood)
            case "NY": morality.formUnion(Set<Alignment>.anyNeutralMorality)
            case "E": morality.formUnion(Set<Alignment>.anyEvil)
            case "N":
                // Process neutral later.
                isNeutral = true
            case "A":
                // Fill both axes.
                order.formUnion(Set<Alignment>.any)
                morality.formUnion(Set<Alignment>.any)
            case "U":
                // Empty both axes.
                order.removeAll()
                morality.removeAll()
            default:
                // Ignore unknown alignment.
                break
            }
        }

        // "N" when it appears along with values for both axes (NX, NY usually) means "Any Neutral", when it appears
        // with values for only one axis it means neutral in the other axis, and when it appears on its own it means
        // "True Neutral".
        if isNeutral, !order.isEmpty, !morality.isEmpty {
            order.formUnion(Set<Alignment>.anyNeutralMorality)
            morality.formUnion(Set<Alignment>.anyNeutralOrder)
        }
        if isNeutral, order.isEmpty {
            order.formUnion(Set<Alignment>.anyNeutralOrder)
        }
        if isNeutral, morality.isEmpty {
            morality.formUnion(Set<Alignment>.anyNeutralMorality)
        }

        self = .alignment(order.intersection(morality), chance: chance, note: note)
    }

    /// Returns the encoded strings of the alignment set.
    var strings: Set<String> {
        switch self {
        case .alignment(.anyNeutral, _, _):
            return ["N", "NX", "NY"]
        case .alignment(.unaligned, _, _):
            return ["U"]
        case .alignment(.any, _, _):
            return ["A"]
        case let .alignment(alignments, _, _):
            var strings: Set<String> = []

            if !alignments.isDisjoint(with: .anyLawful) {
                strings.insert("L")
            }
            if !alignments.isDisjoint(with: .anyNeutralOrder) {
                if alignments.count == 1 {
                    strings.insert("N")
                } else {
                    strings.insert("NX")
                }
            }
            if !alignments.isDisjoint(with: .anyChaotic) {
                strings.insert("C")
            }

            if !alignments.isDisjoint(with: .anyGood) {
                strings.insert("G")
            }
            if !alignments.isDisjoint(with: .anyNeutralMorality) {
                if alignments.count == 1 {
                    strings.insert("N")
                } else {
                    strings.insert("NY")
                }
            }
            if !alignments.isDisjoint(with: .anyEvil) {
                strings.insert("E")
            }

            return strings
        case .special:
            return []
        }
    }
}
