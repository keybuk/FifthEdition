//
//  Creature+Ability.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Returns the modifier for the given ability.
    ///
    /// Where the `ability` score in ``abilities`` is ``AbilityScore/score(_:)``, returns a
    /// ``AbilityModifier/modifier(_:)`` derived from the score, or `nil` if the score is
    /// ``AbilityScore/special(_:)``.
    subscript(ability: Ability) -> AbilityModifier? {
        abilities[ability].flatMap(AbilityModifier.init)
    }

    /// Returns the saving throw modifier for the given ability.
    ///
    /// Where ``SavingThrows/savingThrows`` has an entry for `ability`, returns that ``AbilityModifier/modifier(_:)`` or
    /// ``AbilityModifier/special(_:)`` value; otherwise returns an ``AbilityModifier/modifier(_:)`` derived from the
    /// score in ``abilities``, or `nil` if the score is ``AbilityScore/special(_:)``.
    subscript(savingThrow ability: Ability) -> AbilityModifier? {
        savingThrows[ability] ?? self[ability]
    }

    /// Returns the modifier for the given skill.
    ///
    /// Where ``Skills/skills`` has an entry for `skill`, returns that ``AbilityModifier/modifier(_:)`` or
    /// ``AbilityModifier/special(_:)`` value; otherwise returns an ``AbilityModifier/modifier(_:)`` derived from the
    /// score in ``abilities``, or `nil` if the score is ``AbilityScore/special(_:)``.
    subscript(skill: Skill) -> AbilityModifier? {
        skills[skill] ?? self[skill.ability]
    }

    /// Returns the passive score for the given skill.
    ///
    /// When `skill` is ``Skill/perception`` and ``passivePerception`` is provided, returns that ``Passive/passive(_:)``
    /// or ``Passive/special(_:)`` value; or returns a ``Passive/passive(_:)`` derived from the entry in
    /// ``Skills/skills`` is ``AbilityModifier/modifier(_:)``, or `nil` if that entry is
    /// ``AbilityModifier/special(_:)``; otherwise returns an ``Passive/passive(_:)`` derived from the score in
    /// ``abilities``, or `nil` if the score is ``AbilityScore/special(_:)``.
    subscript(passive skill: Skill) -> Passive? {
        if skill == .perception {
            passivePerception ?? Passive(self[skill])
        } else {
            Passive(self[skill])
        }
    }

    enum InitiativeCheck {
        case initiative
    }

    /// Returns the modifier for initiative checks.
    ///
    /// Where ``initiative`` is ``Initiative/modifier(_:)``, returns that modifier as a ``AbilityModifier/modifier(_:)``
    /// value; otherwise returns the ``AbilityModifier/modifier(_:)`` for ``Ability/dexterity`` with
    /// ``proficiencyBonus`` added the number of times given in ``Initiative/proficiency(_:)`` if provided; or `nil`
    /// where that modifier is ``AbilityModifier/special(_:)`` or `nil`.
    subscript(_: InitiativeCheck) -> AbilityModifier? {
        if case let .modifier(modifier) = initiative {
            .modifier(modifier)
        } else if case let .modifier(modifier) = self[.dexterity] {
            if case let .proficiency(proficiency) = initiative,
               case let .bonus(proficiencyBonus) = proficiencyBonus
            {
                .modifier(modifier + proficiencyBonus * proficiency.rawValue)
            } else {
                .modifier(modifier)
            }
        } else {
            nil
        }
    }

    /// Returns the passive score for initiative checks.
    ///
    /// Derives the ``Passive/passive(_:)`` value from the modifier for initiative checks with the adjustment for
    /// ``Initiative/advantage(_:)`` if provided, or `nil` if the modifier is `nil`.
    subscript(passive _: InitiativeCheck) -> Passive? {
        if case let .advantage(advantage) = initiative {
            Passive(self[.initiative], advantage: advantage)
        } else {
            Passive(self[.initiative])
        }
    }
}
