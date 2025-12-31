//
//  Creature+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

extension Creature.AbilityScore: CustomStringConvertible {
    public var description: String {
        switch self {
        case .score(let score): "\(score)"
        case .special(let special): special
        }
    }
}

extension Creature.Action: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "entries",
            values: name, entries,
        )
    }
}

extension Creature.Alignment.Choice: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "chance", "note",
            values: alignment, chance, note,
        )
    }
}

extension Creature.ArmorClass: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .ac(let ac):
            debugDescriptionOf(
                ".ac",
                names: "_",
                values: ac,
            )
        case .obtained(let ac, let from, let condition, let braces):
            debugDescriptionOf(
                ".obtained",
                names: "_", "from", "condition", "braces",
                values: ac, from, condition, braces,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.ChallengeRating: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "lair", "coven", "xp", "xpLair",
            values: cr, lair, coven, xp, xpLair,
        )
    }
}

extension Creature.ConditionImmunity: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .condition(let condition):
            debugDescriptionOf(
                ".condition",
                names: "_",
                values: condition,
            )
        case .conditional(let conditions, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: conditions, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.CreatureType: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: Swift.type(of: self)),
            names: "_", "swarmSize", "tags", "sidekickType", "sidekickTags", "sidekickHiden", "note",
            values: type, swarmSize, tags, sidekickType, sidekickTags, sidekickHidden, note,
        )
    }
}

extension Creature.DamageImmunity: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .damage(let damage):
            debugDescriptionOf(
                ".damage",
                names: "_",
                values: damage,
            )
        case .conditional(let damages, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: damages, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.DamageResistance: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .damage(let damage):
            debugDescriptionOf(
                ".damage",
                names: "_",
                values: damage,
            )
        case .conditional(let damages, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: damages, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.DamageVulnerability: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .damage(let damage):
            debugDescriptionOf(
                ".damage",
                names: "_",
                values: damage,
            )
        case .conditional(let damages, let preNote, let note, let conditional):
            debugDescriptionOf(
                ".conditional",
                names: "_", "preNote", "note", "conditional",
                values: damages, preNote, note, conditional,
            )
        case .special(let special):
            debugDescriptionOf(
                ".special",
                names: "_",
                values: special,
            )
        }
    }
}

extension Creature.Gear: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "quantity",
            values: item, quantity,
        )
    }
}

extension Creature.HitPoints: CustomStringConvertible {
    public var description: String {
        switch self {
        case .hp(let notation, nil): "\(notation)"
        case .hp(let notation, let givenAverage):
            "\(givenAverage!) or \(notation.stringValue)"
        case .unrollable(let formula, let average):
            "\(average) (\(formula))"
        case .special(let special): special
        }
    }
}

extension Creature.Passive: CustomStringConvertible {
    public var description: String {
        switch self {
        case .score(let score): "\(score)"
        case .special(let special): special
        }
    }
}

extension Creature.Save: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "str", "dex", "con", "int", "wis", "cha",
            values: str, dex, con, int, wis, cha,
        )
    }
}

extension Creature.ShortName: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .name(let name):
            debugDescriptionOf(
                ".name",
                names: "_",
                values: name,
            )
        case .useName: ".useName"
        }
    }
}

extension Creature.SkillSet: CustomDebugStringConvertible {
    public var debugDescription: String {
        if let other {
            debugDescriptionOf(
                String(describing: type(of: self)),
                names: "_", "other",
                values: skills, other,
            )
        } else {
            String(describing: skills)
        }
    }
}

extension Creature.ToolSet: CustomDebugStringConvertible {
    public var debugDescription: String {
        String(describing: tools)
    }
}

extension Creature.Trait: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: Swift.type(of: self)),
            names: "_", "entries", "type", "sort",
            values: name, entries, type, sort,
        )
    }
}

