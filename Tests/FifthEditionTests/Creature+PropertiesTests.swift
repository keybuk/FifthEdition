//
//  Creature+PropertiesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Testing
@testable import FifthEdition

struct CreatureGridSquaresTests {
    @Test(arguments: Size.allCases)
    func `grid squares`(_ size: Size) {
        let creature = Creature(
            name: "\(size.rawValue.uppercased()) Monster",
            source: "XMM",
            size: [size],
        )
        switch size {
        case .tiny: #expect(creature.gridSquares == 1)
        case .small: #expect(creature.gridSquares == 1)
        case .medium: #expect(creature.gridSquares == 1)
        case .large: #expect(creature.gridSquares == 2)
        case .huge: #expect(creature.gridSquares == 3)
        case .gargantuan: #expect(creature.gridSquares == 4)
        }
    }

    @Test
    func `gridSquares returns 1 when no size`() {
        let creature = Creature(
            name: "Sizeless Monster",
            source: "XMM",
        )
        #expect(creature.gridSquares == 1)
    }

    @Test
    func `gridSquares returns smallest size`() {
        let creature = Creature(
            name: "Growing Monster",
            source: "XMM",
            size: [.large, .huge, .gargantuan],
        )
        #expect(creature.gridSquares == 2)
    }
}

struct CreatureTokenNameTests {
    @Test
    func `token name`() {
        let creature = Creature(
            name: "Blink Dog",
            source: "XMM",
            hasToken: true,
        )
        #expect(creature.tokenName == "Blink Dog")
    }

    @Test
    func `tokenName has diacritics removed`() {
        let creature = Creature(
            name: "Kupalué",
            source: "ToA",
            hasToken: true,
        )
        #expect(creature.tokenName == "Kupalue")
    }

    @Test
    func `tokenName has æ dipthong replaced`() {
        let creature = Creature(
            name: "Môrgæn",
            source: "AI",
            hasToken: true,
        )
        #expect(creature.tokenName == "Morgaen")
    }

    @Test
    func `tokenName has quotes removed`() {
        let creature = Creature(
            name: "\"The Demogorgon\"",
            source: "IMR",
            hasToken: true,
        )
        #expect(creature.tokenName == "The Demogorgon")
    }

    @Test
    func `tokenName uses name from token`() {
        let creature = Creature(
            name: "Demilich",
            source: "WDMM",
            hasToken: true,
            token: .init(
                name: "Acererak",
                source: "MM",
            ),
        )
        #expect(creature.tokenName == "Acererak")
    }

    @Test
    func `tokenName is nil if no name`() {
        let creature = Creature(
            source: "XMM",
            hasToken: true,
        )
        #expect(creature.tokenName == nil)
    }
}

struct CreatureTokenPathTests {
    @Test
    func `token path`() {
        let creature = Creature(
            name: "Blink Dog",
            source: "XMM",
            hasToken: true,
        )
        #expect(creature.tokenPath == "bestiary/tokens/XMM/Blink Dog.webp")
    }

    @Test
    func `tokenPath uses tokenName`() {
        let creature = Creature(
            name: "Kupalué",
            source: "ToA",
            hasToken: true,
        )
        #expect(creature.tokenPath == "bestiary/tokens/ToA/Kupalue.webp")
    }

    @Test
    func `tokenPath uses tokenName from token`() {
        let creature = Creature(
            name: "Demilich",
            source: "WDMM",
            hasToken: true,
            token: .init(
                name: "Acererak",
                source: "MM",
            ),
        )
        #expect(creature.tokenPath == "bestiary/tokens/MM/Acererak.webp")
    }

    @Test
    func `tokenPath is nil if no name`() {
        let creature = Creature(
            source: "XMM",
            hasToken: true,
        )
        #expect(creature.tokenPath == nil)
    }

    @Test
    func `tokenPath is nil if no source`() {
        let creature = Creature(
            name: "Blink Dog",
            hasToken: true,
        )
        #expect(creature.tokenPath == nil)
    }
}

struct CreatureUidTests {
    @Test
    func uid() {
        let creature = Creature(
            name: "Blink Dog",
            source: "XMM",
        )
        #expect(creature.uid == "blink dog|xmm")
    }

    @Test
    func `uid is nil if no name`() {
        let creature = Creature(
            source: "XMM",
        )
        #expect(creature.uid == nil)
    }

    @Test
    func `uid is nil if no source`() {
        let creature = Creature(
            name: "Blink Dog",
        )
        #expect(creature.uid == nil)
    }
}

struct CreatureSkillSetSubscriptTests {
    @Test
    func `skill[]`() {
        let skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        #expect(skill[.deception] == "+5")
    }

    @Test
    func `skill[] returns nil if unset`() {
        let skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        #expect(skill[.nature] == nil)
    }

    @Test
    func `skill[] sets unset skill`() {
        var skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        skill[.nature] = "+2"

        #expect(skill.skills == [
            .deception: "+5",
            .perception: "+4",
            .nature: "+2",
        ])
    }

    @Test
    func `skill[] updates skill`() {
        var skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        skill[.perception] = "+2"

        #expect(skill.skills == [
            .deception: "+5",
            .perception: "+2",
        ])
    }
}

struct CreatureToolSetSubscriptTests {
    @Test
    func `tool[]`() {
        let tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        #expect(tool[.smithsTools] == "+2")
    }

    @Test
    func `tool[] returns nil if unset`() {
        let tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        #expect(tool[.brewersSupplies] == nil)
    }

    @Test
    func `tool[] sets unset tool`() {
        var tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        tool[.brewersSupplies] = "+3"

        #expect(tool.tools == [
            .cobblersTools: "+1",
            .smithsTools: "+2",
            .brewersSupplies: "+3",
        ])
    }

    @Test
    func `tool[] updates tool`() {
        var tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        tool[.smithsTools] = "+3"

        #expect(tool.tools == [
            .cobblersTools: "+1",
            .smithsTools: "+3",
        ])
    }
}
