//
//  Creature+PropertiesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

@testable import FifthEdition
import Testing

struct CreatureGridSquaresTests {
    @Test("Grid squares for single size", arguments: Size.allCases)
    func gridSquares(_ size: Size) throws {
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

    @Test("Grid squares when no size given")
    func gridSquaresWhenNoSize() throws {
        let creature = Creature(
            name: "Sizeless Monster",
            source: "XMM",
        )
        #expect(creature.gridSquares == 1)
    }

    @Test("Grid squares for multiple sizes")
    func gridSquaresForMultiple() throws {
        let creature = Creature(
            name: "Growing Monster",
            source: "XMM",
            size: [.large, .huge, .gargantuan],
        )
        #expect(creature.gridSquares == 2)
    }
}

struct CreatureTokenPathTests {
    @Test("Token path")
    func tokenPath() throws {
        let creature = Creature(
            name: "Blink Dog",
            source: "XMM",
            hasToken: true,
        )
        #expect(creature.tokenPath == "bestiary/tokens/XMM/Blink Dog.webp")
    }

    @Test("Token path has diacritics removed")
    func tokenPathWithoutDiacritics() throws {
        let creature = Creature(
            name: "Kupalué",
            source: "ToA",
            hasToken: true,
        )
        #expect(creature.tokenPath == "bestiary/tokens/ToA/Kupalue.webp")
    }

    @Test("Token path has æ dipthong replaced")
    func tokenPathWithoutAeDipthong() throws {
        let creature = Creature(
            name: "Môrgæn",
            source: "AI",
            hasToken: true,
        )
        #expect(creature.tokenPath == "bestiary/tokens/AI/Morgaen.webp")
    }

    @Test("Token path has quotes removed")
    func tokenPathWithoutQuotes() throws {
        let creature = Creature(
            name: "\"The Demogorgon\"",
            source: "IMR",
            hasToken: true,
        )
        #expect(creature.tokenPath == "bestiary/tokens/IMR/The Demogorgon.webp")
    }

    @Test("Token path from token")
    func tokenPathFromToken() throws {
        let creature = Creature(
            name: "Demilich",
            source: "WDMM",
            hasToken: true,
            token: Token(
                name: "Acererak",
                source: "MM",
            ),
        )
        #expect(creature.tokenPath == "bestiary/tokens/MM/Acererak.webp")
    }

    @Test("No token if no name")
    func noName() throws {
        let creature = Creature(
            source: "XMM",
            hasToken: true,
        )
        #expect(creature.tokenPath == nil)
    }

    @Test("No token if no source")
    func noSource() throws {
        let creature = Creature(
            name: "Blink Dog",
            hasToken: true,
        )
        #expect(creature.tokenPath == nil)
    }
}

struct CreatureUidTests {
    @Test("UID")
    func uid() throws {
        let creature = Creature(
            name: "Blink Dog",
            source: "XMM",
        )
        #expect(creature.uid == "blink dog|xmm")
    }

    @Test("No UID if no name")
    func noName() throws {
        let creature = Creature(
            source: "XMM",
        )
        #expect(creature.uid == nil)
    }

    @Test("No UID if no source")
    func noSource() throws {
        let creature = Creature(
            name: "Blink Dog",
        )
        #expect(creature.uid == nil)
    }
}

struct CreatureSkillSetSubscriptTests {
    @Test("Get skill by subscript")
    func getSubscript() {
        let skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        #expect(skill[.deception] == "+5")
    }

    @Test("Get unset skill by subscript")
    func getSubscriptUnset() {
        let skill = Creature.SkillSet([
            .deception: "+5",
            .perception: "+4",
        ])
        #expect(skill[.nature] == nil)
    }

    @Test("Set skill by subscript")
    func setSubscript() {
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

    @Test("Change skill by subscript")
    func changeSubscript() {
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
    @Test("Get tool by subscript")
    func getSubscript() {
        let tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        #expect(tool[.smithsTools] == "+2")
    }

    @Test("Get unset tool by subscript")
    func getSubscriptUnset() {
        let tool = Creature.ToolSet([
            .cobblersTools: "+1",
            .smithsTools: "+2",
        ])
        #expect(tool[.brewersSupplies] == nil)
    }

    @Test("Set tool by subscript")
    func setSubscript() {
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

    @Test("Change tool by subscript")
    func changeSubscript() {
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
