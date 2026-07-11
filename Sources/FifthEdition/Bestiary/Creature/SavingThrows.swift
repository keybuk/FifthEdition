//
//  SavingThrows.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Saving throws.
    ///
    /// A saving throw—also called a save—represents an attempt to evade or or resist a threat. Where the
    /// ``AbilityModifier`` for a save is not the same as that derived from its ``Creature/abilities`` score,
    /// ``savingThrows`` provides the alternate value.
    ///
    /// Special rules are given as human-readable text in ``special``.
    struct SavingThrows: Equatable, Hashable, Sendable {
        /// Saving throw modifiers.
        ///
        /// Provides the ``AbilityModifier`` for making a saving throws where they differ from that derived from its
        /// ``Creature/abilities`` score. Use ``Creature/subscript(savingThrow:)`` to obtain the provided or derived
        /// value.
        public var savingThrows: [Ability: AbilityModifier]

        /// Human-readable text describing any special saving throws.
        public var special: String? // FIXME: Entry

        /// Initialize saving throws.
        /// - Parameters:
        ///   - savingThrows: Saving throw modifiers.
        ///   - special: Human-readable text describing any special saving throws.
        public init(_ savingThrows: [Ability: AbilityModifier],
                    special: String? = nil)
        {
            self.savingThrows = savingThrows
            self.special = special
        }
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
