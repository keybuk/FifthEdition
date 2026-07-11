//
//  Creature+AbilityTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Testing
@testable import FifthEdition

struct CreatureSubscriptTests {
    @Test
    func `subscript(_:) returns ability modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[.dexterity] == .modifier(2))
    }

    @Test
    func `subscript(_:) returns nil when score is special`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[.charisma] == nil)
    }

    @Test
    func `subscript(_:) returns nil when score is omitted`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[.intelligence] == nil)
    }

    @Test
    func `subscript(savingThrow:) returns saving throw modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                savingThrows: [
                                    .strength: 4,
                                    .wisdom: "automatically fails",
                                ])
        #expect(creature[savingThrow: .strength] == .modifier(4))
    }

    @Test
    func `subscript(savingThrow:) returns special`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                savingThrows: [
                                    .strength: 4,
                                    .wisdom: "automatically fails",
                                ])
        #expect(creature[savingThrow: .wisdom] == .special("automatically fails"))
    }

    @Test
    func `subscript(savingThrow:) returns ability modifier if no saving throw modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                savingThrows: [
                                    .strength: 4,
                                    .wisdom: "automatically fails",
                                ])
        #expect(creature[savingThrow: .dexterity] == .modifier(2))
    }

    @Test
    func `subscript(savingThrow:) returns nil if no saving throw modifier and special score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                savingThrows: [
                                    .strength: 4,
                                    .wisdom: "automatically fails",
                                ])
        #expect(creature[savingThrow: .charisma] == nil)
    }

    @Test
    func `subscript(savingThrow:) returns nil if no saving throw modifier or score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                savingThrows: [
                                    .strength: 4,
                                    .wisdom: "automatically fails",
                                ])
        #expect(creature[savingThrow: .intelligence] == nil)
    }

    @Test
    func `subscript(_:) returns skill modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[.acrobatics] == .modifier(4))
    }

    @Test
    func `subscript(_:) returns special`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[.persuasion] == .special("disadvantage against humanoids"))
    }

    @Test
    func `subscript(:) returns ability modifier if no skill modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[.athletics] == .modifier(1))
    }

    @Test
    func `subscript(:) returns nil if no skill modifier and special score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[.deception] == nil)
    }

    @Test
    func `subscript(:) returns nil if no skill modifier or score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[.arcana] == nil)
    }

    @Test
    func `subscript(passive:) returns score from skill modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[passive: .acrobatics] == 14)
    }

    @Test
    func `subscript(passive:) returns nil if special`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[passive: .persuasion] == nil)
    }

    @Test
    func `subscript(passive:) returns score from ability modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[passive: .athletics] == 11)
    }

    @Test
    func `subscript(passive:) returns nil if no skill modifier and special score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[passive: .arcana] == nil)
    }

    @Test
    func `subscript(passive:) returns nil if no skill modifier or score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                skills: [
                                    .acrobatics: 4,
                                    .persuasion: "disadvantage against humanoids",
                                ])
        #expect(creature[passive: .arcana] == nil)
    }

    @Test
    func `subscript(passive:) returns score from passive perception`() {
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
                                skills: [
                                    .perception: 1,
                                ],
                                passivePerception: 12)
        #expect(creature[passive: .perception] == .passive(12))
    }

    @Test
    func `subscript(passive:) returns special from passive perception`() {
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
                                skills: [
                                    .perception: 1,
                                ],
                                passivePerception: "fails all checks")
        #expect(creature[passive: .perception] == .special("fails all checks"))
    }

    @Test
    func `subscript(passive:) returns score from skill modifier if no passive perception`() {
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
                                skills: [
                                    .perception: 1,
                                ])
        #expect(creature[passive: .perception] == .passive(11))
    }

    @Test
    func `subscript(passive:) returns score from ability modifier if no passive perception or skill`() {
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
        #expect(creature[passive: .perception] == .passive(10))
    }

    @Test
    func `subscript(:) returns initiative modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: 3)
        #expect(creature[.initiative] == .modifier(3))
    }

    @Test
    func `subscript(:) returns dexterity modifier for initiative with proficiency`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: .proficiency(.proficient),
                                challenge: .init(1, proficiencyBonus: 3))
        #expect(creature[.initiative] == .modifier(5))
    }

    @Test
    func `subscript(:) returns dexterity modifier for initiative with expertise`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: .proficiency(.expertise),
                                challenge: .init(1, proficiencyBonus: 3))
        #expect(creature[.initiative] == .modifier(8))
    }

    @Test
    func `subscript(:) returns dexterity modifier for initiative`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[.initiative] == .modifier(2))
    }

    @Test
    func `subscript(:) returns nil for initiative if special dexterity score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: "15 unless wearing heavy armor",
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[.initiative] == nil)
    }

    @Test
    func `subscript(:) returns nil for initiative if no dexterity score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[.initiative] == nil)
    }

    @Test
    func `subscript(passive:) returns passive initiative from modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: 3)
        #expect(creature[passive: .initiative] == .passive(13))
    }

    @Test
    func `subscript(passive:) returns passive initiative with advantage`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: .advantage(.advantage))
        #expect(creature[passive: .initiative] == .passive(17))
    }

    @Test
    func `subscript(passive:) returns passive initiative with disadvantage`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: .advantage(.disadvantage))
        #expect(creature[passive: .initiative] == .passive(7))
    }

    @Test
    func `subscript(passive:) returns passive initiative with proficiency`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: .proficiency(.proficient),
                                challenge: .init(1, proficiencyBonus: 3))
        #expect(creature[passive: .initiative] == .passive(15))
    }

    @Test
    func `subscript(passive:) returns passive initiative with expertise`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ],
                                initiative: .proficiency(.expertise),
                                challenge: .init(1, proficiencyBonus: 3))
        #expect(creature[passive: .initiative] == .passive(18))
    }

    @Test
    func `subscript(passive:) returns passive initiative from dexterity modifier`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: 15,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[passive: .initiative] == .passive(12))
    }

    @Test
    func `subscript(passive:) returns nil if special dexterity score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .dexterity: "15 unless wearing heavy armor",
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[passive: .initiative] == nil)
    }

    @Test
    func `subscript(passive:) returns nil if no dexterity score`() {
        let creature = Creature(name: "Zombie Kitten",
                                source: "XMM",
                                type: [.undead],
                                abilities: [
                                    .strength: 13,
                                    .constitution: 12,
                                    .charisma: "8 - 1 for each year since death",
                                ])
        #expect(creature[passive: .initiative] == nil)
    }
}
