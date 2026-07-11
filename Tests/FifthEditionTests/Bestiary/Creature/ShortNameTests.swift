//
//  ShortNameTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Testing
@testable import FifthEdition

struct CreatureShortNameCodableTests {
    @Test
    func `Short name encoded as true when full name`() throws {
        try testCodable(
            json: """
            true
            """,
            value: Creature.ShortName.name,
        )
    }

    @Test
    func `Short name encoded as given short name`() throws {
        try testCodable(
            json: """
            "name"
            """,
            value: Creature.ShortName.custom("name"),
        )
    }
}

struct CreatureShortNameTests {
    @Test
    func `shortName returns creature name lowercased with definite article`() {
        let creature = Creature(name: "Blink Dog",
                                source: "XMM",
                                size: [.medium],
                                type: [.fey])
        #expect(creature.shortName == "the blink dog")
    }

    @Test
    func `shortName removes name suffix after comma`() {
        let creature = Creature(name: "Rakdos Performer, Fire Eater",
                                source: "GGR",
                                size: [.medium],
                                type: [.humanoid])
        #expect(creature.shortName == "the rakdos performer")
    }

    @Test
    func `shortName returns named creature's capitalized first name`() {
        let creature = Creature(name: "Strahd von Zarovich",
                                isNamedCreature: true,
                                source: "CoS",
                                size: [.medium],
                                type: [.undead])
        #expect(creature.shortName == "Strahd")
    }

    @Test
    func `shortName removes dragon age and color`() {
        let creature = Creature(name: "Adult Red Dragon",
                                source: "XMM",
                                size: [.large],
                                type: [.dragon])
        #expect(creature.shortName == "the dragon")
    }

    @Test
    func `shortName removes dracolich age and color`() {
        let creature = Creature(name: "Adult Red Dracolich",
                                source: "XMM",
                                size: [.large],
                                type: [.undead])
        #expect(creature.shortName == "the dracolich")
    }

    @Test
    func `shortName doesn't remove unknown dragon age`() {
        let creature = Creature(name: "Geriatric Red Dragon",
                                source: "XMM",
                                size: [.large],
                                type: [.dragon])
        #expect(creature.shortName == "the geriatric red dragon")
    }

    @Test
    func `shortName returns capitalized full name of named creature`() {
        let creature = Creature(name: "Big Momma",
                                shortNameForm: .name,
                                isNamedCreature: true,
                                source: "LoX",
                                size: [.medium],
                                type: [.humanoid])
        #expect(creature.shortName == "Big Momma")
    }

    @Test
    func `shortName returns lowercased full name with definite article for unnamed creature`() {
        let creature = Creature(name: "Great Worm, Destroyer of Worlds",
                                shortNameForm: .name,
                                source: "Dune",
                                size: [.gargantuan],
                                type: [.monstrosity])
        #expect(creature.shortName == "the great worm, destroyer of worlds")
    }

    @Test
    func `shortName returns lowercased custom name with definite article for unnamed creature`() {
        let creature = Creature(name: "Sand Eater, Purple Worm",
                                shortNameForm: .custom("Worm"),
                                source: "AWM",
                                size: [.gargantuan],
                                type: [.monstrosity])
        #expect(creature.shortName == "the worm")
    }

    @Test
    func `shortName returns capitalized custom name for named creature`() {
        let creature = Creature(name: "Great Kroom, Purple Worm",
                                shortNameForm: .custom("Great Kroom"),
                                isNamedCreature: true,
                                source: "AWM",
                                size: [.gargantuan],
                                type: [.monstrosity])
        #expect(creature.shortName == "Great Kroom")
    }
}

struct CreatureTokenNameTests {
    @Test
    func `token name`() {
        let creature = Creature(name: "Blink Dog",
                                source: "XMM",
                                type: [.fey],
                                hasToken: true)
        #expect(creature.tokenName == "Blink Dog")
    }

    @Test
    func `tokenName has diacritics removed`() {
        let creature = Creature(name: "Kupalué",
                                source: "ToA",
                                type: [.plant],
                                hasToken: true)
        #expect(creature.tokenName == "Kupalue")
    }

    @Test
    func `tokenName has æ dipthong replaced`() {
        let creature = Creature(name: "Môrgæn",
                                source: "AI",
                                type: [.humanoid],
                                hasToken: true)
        #expect(creature.tokenName == "Morgaen")
    }

    @Test
    func `tokenName has quotes removed`() {
        let creature = Creature(name: "\"The Demogorgon\"",
                                source: "IMR",
                                type: [.giant],
                                hasToken: true)
        #expect(creature.tokenName == "The Demogorgon")
    }

    @Test
    func `tokenName uses name from token`() {
        let creature = Creature(name: "Demilich",
                                source: "WDMM",
                                type: [.undead],
                                hasToken: true,
                                token: CreatureToken(name: "Acererak",
                                                     source: "MM"))
        #expect(creature.tokenName == "Acererak")
    }
}

struct CreatureTokenPathTests {
    @Test
    func `token path`() {
        let creature = Creature(name: "Blink Dog",
                                source: "XMM",
                                type: [.fey],
                                hasToken: true)
        #expect(creature.tokenPath == "bestiary/tokens/XMM/Blink Dog.webp")
    }

    @Test
    func `tokenPath uses tokenName`() {
        let creature = Creature(name: "Kupalué",
                                source: "ToA",
                                type: [.plant],
                                hasToken: true)
        #expect(creature.tokenPath == "bestiary/tokens/ToA/Kupalue.webp")
    }

    @Test
    func `tokenPath uses tokenName from token`() {
        let creature = Creature(name: "Demilich",
                                source: "WDMM",
                                type: [.undead],
                                hasToken: true,
                                token: CreatureToken(name: "Acererak",
                                                     source: "MM"))
        #expect(creature.tokenPath == "bestiary/tokens/MM/Acererak.webp")
    }
}
