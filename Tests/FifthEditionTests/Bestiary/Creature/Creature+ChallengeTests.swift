//
//  Creature+ChallengeTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Testing
@testable import FifthEdition

struct CreatureProficiencyBonusTests {
    @Test
    func `proficiencyBonus returns proficiency bonus`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .wisdom: 10,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                challenge: .init(1, proficiencyBonus: 3))
        #expect(creature.proficiencyBonus == .bonus(3))
    }

    @Test
    func `proficiencyBonus returns special proficiency bonus`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .wisdom: 10,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                challenge: .init(1, proficiencyBonus: "2 + 1 for each year since death"))
        #expect(creature.proficiencyBonus == .special("2 + 1 for each year since death"))
    }

    @Test
    func `proficiencyBonus returns proficiency bonus from challenge rating`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .wisdom: 10,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                challenge: 1)
        #expect(creature.proficiencyBonus == .bonus(2))
    }

    @Test
    func `proficiencyBonus returns nil if no proficiency bonus and special challenge rating`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .wisdom: 10,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                challenge: "1 for each each year since death")
        #expect(creature.proficiencyBonus == nil)
    }

    @Test
    func `proficiencyBonus returns nil if no proficiency bonus or challenge rating`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .wisdom: 10,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature.proficiencyBonus == nil)
    }
}
