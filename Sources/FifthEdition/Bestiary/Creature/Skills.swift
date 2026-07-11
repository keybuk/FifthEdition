//
//  Skills.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Skills.
    ///
    /// Most ``Ability`` checks involve using a skill, which represents a category of things creatures try to do with an
    /// ability check. Where the ``AbilityModifier`` for such a check is not the same as that derived from its
    /// ``Creature/abilities`` score, ``skills`` provides the alternate value.
    ///
    /// Where a choice of skills a creature may have is presented as part of its stat block, one or more sets of skills
    /// from
    /// which one may be chosen are given in ``other``.
    ///
    /// Special rules are given as human-readable text in ``special``.
    struct Skills: Equatable, Hashable, Sendable {
        /// Skill check modifiers.
        ///
        /// Provides the ``AbilityModifier`` for making skill checks where they differ from that derived from its
        /// ``Creature/abilities`` score. Use ``Creature/subscript(_:)-(Skill)`` to obtain the provided or derived
        /// value.
        public var skills: [Skill: AbilityModifier]

        /// Other available check skill modifiers.
        ///
        /// Each entry in the set is a map of skills from which one may be chosen.
        public var other: Set<[Skill: AbilityModifier]>

        /// Human-readable text describing any special skills.
        public var special: String? // FIXME: Entry

        /// Initialize skills.
        /// - Parameters:
        ///   - skills: Skill check modifiers, additional elements are placed in ``other``.
        ///   - special: Human-readable text describing any special skills.
        public init(_ skills: [Skill: AbilityModifier]...,
                    special: String? = nil)
        {
            self.skills = skills.first!
            other = Set(skills.dropFirst())
            self.special = special
        }
    }
}

extension Creature.Skills: ExpressibleByDictionaryLiteral {
    /// Initialize ``skills`` from a dictionary literal.
    public init(dictionaryLiteral elements: (Skill, AbilityModifier)...) {
        self.init(Dictionary(uniqueKeysWithValues: elements))
    }
}

public extension Creature.Skills {
    var isEmpty: Bool {
        skills.isEmpty && other.isEmpty && special == nil
    }

    subscript(key: Skill) -> AbilityModifier? {
        skills[key]
    }
}
