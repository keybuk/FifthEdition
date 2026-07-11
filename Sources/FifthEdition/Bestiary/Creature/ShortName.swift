//
//  ShortName.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/23/26.
//

public extension Creature {
    /// How to generate the shortened form of the creature's name
    enum ShortName: Equatable, Hashable, Sendable {
        /// Use the creature's name.
        case name

        /// Use a custom short name.
        case custom(String)
    }
}

public extension Creature {
    /// Returns the shortened form of the creature's name.
    var shortName: String {
        if isNamedCreature {
            shortNamePart
        } else {
            "the \(shortNamePart.localizedLowercase)"
        }
    }

    private var shortNamePart: String {
        switch shortNameForm {
        case .name: return name
        case let .custom(custom): return custom
        case nil: break
        }

        // Separate "Given Name, the Description", then separate into words.
        let givenName = name.split(separator: ",").first!
        let words = givenName.split(separator: " ")

        let dragonType = words.last!.lowercased()
        if dragonType == "dragon" || dragonType == "dracolich",
           DragonAge(rawValue: words.first!.lowercased()).value != nil
        {
            // Dragons use their type.
            return String(words.last!)
        } else if isNamedCreature {
            // Named creatures use their first name.
            return String(words.first!)
        } else {
            // Otherwise use the given name.
            return String(givenName)
        }
    }
}
