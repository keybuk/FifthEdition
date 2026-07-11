//
//  GroupFormatStyleTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/28/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct GroupFormatStyleTests {
    @Test
    func `format(_:) returns value in parens`() {
        let formatter: GroupFormatStyle = .group(type: .parens)
        #expect(formatter.format("value") == "(value)")
    }

    @Test
    func `format(_:) returns value in braces`() {
        let formatter: GroupFormatStyle = .group(type: .braces)
        #expect(formatter.format("value") == "{value}")
    }

    @Test
    func `format(_:) returns value in brackets`() {
        let formatter: GroupFormatStyle = .group(type: .brackets)
        #expect(formatter.format("value") == "[value]")
    }

    @Test
    func `format(_:) returns unmodified value`() {
        let formatter: GroupFormatStyle = .group(type: .none)
        #expect(formatter.format("value") == "value")
    }

    @Test
    func `format(_:) uses value formatter`() {
        let formatter: GroupFormatStyle = .group(style: IntegerFormatStyle<Int>(), type: .parens)
        #expect(formatter.format(42) == "(42)")
    }

    @Test
    func `group(type:) returns formatter`() {
        let formatted = "value".formatted(.group(type: .parens))
        #expect(formatted == "(value)")
    }

    @Test
    func `group(style:type:) returns formatter`() {
        let formatted = 42.formatted(.group(style: .number, type: .parens))
        #expect(formatted == "(42)")
    }
}

struct AttributedGroupFormatStyleTests {
    @Test
    func `format(_:) returns value in parens maintaining attributes`() throws {
        var attributed: AttributedString = "value"
        attributed.link = URL(string: "http://dndbeyond.com/")

        let formatter: AttributedGroupFormatStyle = .group(type: .parens)
        let formatted = formatter.format(attributed)

        #expect(String(formatted.characters) == "(value)")

        let range = try #require(formatted.range(of: "value"))
        #expect(formatted[range].link == attributed.link)
    }

    @Test
    func `format(_:) returns value in braces maintaining attributes`() throws {
        var attributed: AttributedString = "value"
        attributed.link = URL(string: "http://dndbeyond.com/")

        let formatter: AttributedGroupFormatStyle = .group(type: .braces)
        let formatted = formatter.format(attributed)

        #expect(String(formatted.characters) == "{value}")

        let range = try #require(formatted.range(of: "value"))
        #expect(formatted[range].link == attributed.link)
    }

    @Test
    func `format(_:) returns value in brackets maintaining attributes`() throws {
        var attributed: AttributedString = "value"
        attributed.link = URL(string: "http://dndbeyond.com/")

        let formatter: AttributedGroupFormatStyle = .group(type: .brackets)
        let formatted = formatter.format(attributed)

        #expect(String(formatted.characters) == "[value]")

        let range = try #require(formatted.range(of: "value"))
        #expect(formatted[range].link == attributed.link)
    }

    @Test
    func `format(_:) returns unmodified value maintaining attributes`() {
        var attributed: AttributedString = "value"
        attributed.link = URL(string: "http://dndbeyond.com/")

        let formatter: AttributedGroupFormatStyle = .group(type: .none)
        let formatted = formatter.format(attributed)

        #expect(String(formatted.characters) == "value")
        #expect(formatted.link == attributed.link)
    }

    @Test
    func `group(type:) returns attributed formatter`() throws {
        var attributed: AttributedString = "value"
        attributed.link = URL(string: "http://dndbeyond.com/")

        let formatted = attributed.formatted(.group(type: .parens))
        #expect(String(formatted.characters) == "(value)")

        let range = try #require(formatted.range(of: "value"))
        #expect(formatted[range].link == attributed.link)
    }

    @Test
    func `group(style:type:) returns attributed formatter`() throws {
        let formatted = 42.formatted(.group(style: .number.attributed, type: .parens))
        #expect(String(formatted.characters) == "(42)")

        let range = try #require(formatted.range(of: "42"))
        #expect(formatted[range].numberPart == .integer)
    }
}
