//
//  Creature+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

extension Creature.AbilityScore: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .score(score): "\(score)"
        case let .special(special): special
        }
    }
}

extension Creature.HitPoints: CustomStringConvertible {
    public var description: String {
        switch self {
        case .hp(let notation, nil): "\(notation)"
        case let .hp(notation, givenAverage):
            "\(givenAverage!) or \(notation.stringValue)"
        case let .unrollable(formula, average):
            "\(average) (\(formula))"
        case let .special(special): special
        }
    }
}

extension Creature.Passive: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .score(score): "\(score)"
        case let .special(special): special
        }
    }
}
