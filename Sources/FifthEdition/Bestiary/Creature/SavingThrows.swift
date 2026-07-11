//
//  SavingThrows.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import MemberwiseInit

public extension Creature {
    /// Saving throws.
    ///
    /// A saving throw—also called a save—represents an attempt to evade or or resist a threat. Where the
    /// ``AbilityModifier`` for a save is not the same as that derived from its ``Creature/abilities`` score,
    /// ``savingThrows`` provides the alternate value.
    ///
    /// Special rules are given as human-readable text in ``special``.
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct SavingThrows: Equatable, Hashable, Sendable {
        /// Saving throw modifiers.
        ///
        /// Provides the ``AbilityModifier`` for making a saving throws where they differ from that derived from its
        /// ``Creature/abilities`` score. Use ``Creature/subscript(savingThrow:)`` to obtain the provided or derived
        /// value.
        @Init(label: "_")
        public var savingThrows: [Ability: AbilityModifier]

        /// Human-readable text describing any special saving throws.
        public var special: String? // FIXME: Entry
    }
}

extension Creature.SavingThrows: ExpressibleByDictionaryLiteral {
    /// Initialize ``savingThrows`` from a dictionary literal.
    public init(dictionaryLiteral elements: (Ability, AbilityModifier)...) {
        self.init(Dictionary(uniqueKeysWithValues: elements))
    }
}

public extension Creature.SavingThrows {
    var isEmpty: Bool {
        savingThrows.isEmpty && special == nil
    }

    subscript(key: Ability) -> AbilityModifier? {
        savingThrows[key]
    }
}
