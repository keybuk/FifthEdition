//
//  SourceTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Testing
@testable import FifthEdition

struct PageCodableTests {
    @Test
    func `Page encodes numeric page`() throws {
        try testCodable(
            json: """
            42
            """,
            value: Page.number(42),
        )
    }

    @Test
    func `Page encodes roman numeral page`() throws {
        try testCodable(
            json: """
            "xxxxii"
            """,
            value: Page.numeral("xxxxii"),
        )
    }
}

struct PageComparableTests {
    @Test
    func `number(:_) compare by value`() {
        #expect(Page.number(10) < Page.number(11))
    }

    @Test
    func `numeral(:_) compare by value`() {
        #expect(Page.numeral("a") < Page.numeral("b"))
    }

    @Test
    func `numeral(:_) compares less than number(:_)`() {
        #expect(Page.numeral("a") < Page.number(10))
    }
}

struct PageInitTests {
    @Test
    func `init(integerLiteral:) sets number`() {
        let page: Page = 1
        #expect(page == .number(1))
    }

    @Test
    func `init(stringLiteral:) sets numeral`() {
        let page: Page = "A"
        #expect(page == .numeral("A"))
    }
}

struct PageStringTests {
    @Test
    func `description for number`() {
        let page = Page.number(1)
        #expect(page.description == "1")
    }

    @Test
    func `description for numeral`() {
        let page = Page.numeral("A")
        #expect(page.description == "A")
    }
}

struct ReferenceCodableTests {
    @Test
    func `Reference encodes true for present`() throws {
        try testCodable(
            json: """
            true
            """,
            value: Reference.present,
        )
    }

    @Test
    func `Reference encodes string for presentAs`() throws {
        try testCodable(
            json: """
            "Generic Monster"
            """,
            value: Reference.presentAs("Generic Monster"),
        )
    }
}

struct ReprintCodableTests {
    @Test
    func `Reprint encodes as uid`() throws {
        try testCodable(
            json: """
            "Adult Black Dragon|XMM"
            """,
            value: Reprint(name: "Adult Black Dragon",
                           source: "XMM"),
        )
    }

    @Test
    func `Reprint encodes displayName in uid`() throws {
        try testCodable(
            json: """
            "Priest Acolyte|XMM|Acolyte"
            """,
            value: Reprint(name: "Priest Acolyte",
                           source: "XMM",
                           displayName: "Acolyte"),
        )
    }

    @Test
    func `Reprint encodes entity in object as tag`() throws {
        try testCodable(
            json: """
            {
                "uid": "Net|XPHB",
                "tag": "item"
            }
            """,
            value: Reprint(name: "Net",
                           source: "XPHB",
                           entity: .item),
        )
    }

    @Test
    func `Reprint encodes edition in object`() throws {
        try testCodable(
            json: """
            {
                "uid": "Amethyst|XDMG",
                "edition": "one"
            }
            """,
            value: Reprint(name: "Amethyst",
                           source: "XDMG",
                           edition: .one),
        )
    }
}

struct ReprintInitTests {
    @Test
    func `init(stringLiteral:) sets name and source`() {
        let reprint: Reprint = "Priest Acolyte|XMM"
        #expect(reprint.name == "Priest Acolyte")
        #expect(reprint.source == "XMM")
    }
}

struct ReprintUidTests {
    @Test
    func `init(uid:) sets name and source`() {
        let reprint = Reprint(uid: "Priest Acolyte|XMM")
        #expect(reprint.name == "Priest Acolyte")
        #expect(reprint.source == "XMM")
    }

    @Test
    func `init(uid:) sets displayText`() {
        let reprint = Reprint(uid: "Priest Acolyte|XMM|Acolyte")
        #expect(reprint.name == "Priest Acolyte")
        #expect(reprint.source == "XMM")
        #expect(reprint.displayName == "Acolyte")
    }

    @Test
    func `init(uid:entity:edition:) sets additional properties`() {
        let reprint = Reprint(uid: "Priest Acolyte|XMM",
                              entity: .monster,
                              edition: .modern)
        #expect(reprint.name == "Priest Acolyte")
        #expect(reprint.source == "XMM")
        #expect(reprint.entity == .monster)
        #expect(reprint.edition == .modern)
    }

    @Test
    func `uid includes name and source`() {
        let reprint = Reprint(name: "Priest Acolyte",
                              source: "XMM")
        #expect(reprint.uid == "Priest Acolyte|XMM")
    }

    @Test
    func `uid includes displayName`() {
        let reprint = Reprint(name: "Priest Acolyte",
                              source: "XMM",
                              displayName: "Acolyte")
        #expect(reprint.uid == "Priest Acolyte|XMM|Acolyte")
    }
}

struct SourceCodableTests {
    @Test
    func `Source encodes object`() throws {
        try testCodable(
            json: """
            {
                "source": "XMM"
            }
            """,
            value: Source("XMM"),
        )
    }

    @Test
    func `Source encodes page`() throws {
        try testCodable(
            json: """
            {
                "source": "XPHB",
                "page": 346
            }
            """,
            value: Source("XPHB", page: .number(346)),
        )
    }
}

struct SourceTests {
    @Test
    func `init(stringLiteral:) sets source`() {
        let source: Source = "XMM"
        #expect(source.source == "XMM")
    }
}
