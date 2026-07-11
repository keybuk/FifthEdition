//
//  AttributedListFormatStyleTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/28/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct AttributedListFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `format(_:) returns values in list maintaining attributes`() throws {
        var attributed: [AttributedString] = [
            "dndbeyond",
            "wizards",
            "5etools",
        ]
        attributed[0].link = URL(string: "http://dndbeyond.com/")
        attributed[1].link = URL(string: "http://wizards.com/")
        attributed[2].link = URL(string: "http://5e.tools/")

        let formatter: AttributedListFormatStyle<AttributedStringStyle, [AttributedString]> = .list(type: .and)
            .locale(Self.locale)
        let formatted = formatter.format(attributed)

        #expect(String(formatted.characters) == "dndbeyond, wizards, and 5etools")

        var range = try #require(formatted.range(of: "dndbeyond"))
        #expect(formatted[range].link == attributed[0].link)

        range = try #require(formatted.range(of: "wizards"))
        #expect(formatted[range].link == attributed[1].link)

        range = try #require(formatted.range(of: "5etools"))
        #expect(formatted[range].link == attributed[2].link)
    }

    @Test
    func `format(_:) uses value formatter`() throws {
        let formatter: AttributedListFormatStyle<IntegerFormatStyle<Int>.Attributed, [Int]> = .list(
            memberStyle: IntegerFormatStyle<Int>().attributed,
            type: .and,
        ).locale(Self.locale)
        let formatted = formatter.format([4, 8, 15, 16, 23, 42])

        #expect(String(formatted.characters) == "4, 8, 15, 16, 23, and 42")

        var range = try #require(formatted.range(of: "4"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "8"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "15"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "16"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "23"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "42"))
        #expect(formatted[range].numberPart == .integer)
    }

    @Test
    func `list(type:) returns attributed formatter`() throws {
        var attributed: [AttributedString] = [
            "dndbeyond",
            "wizards",
            "5etools",
        ]
        attributed[0].link = URL(string: "http://dndbeyond.com/")
        attributed[1].link = URL(string: "http://wizards.com/")
        attributed[2].link = URL(string: "http://5e.tools/")

        let formatted = attributed.formatted(.list(type: .and).locale(Self.locale))
        #expect(String(formatted.characters) == "dndbeyond, wizards, and 5etools")

        var range = try #require(formatted.range(of: "dndbeyond"))
        #expect(formatted[range].link == attributed[0].link)

        range = try #require(formatted.range(of: "wizards"))
        #expect(formatted[range].link == attributed[1].link)

        range = try #require(formatted.range(of: "5etools"))
        #expect(formatted[range].link == attributed[2].link)
    }

    @Test
    func `list(memberStyle:type:) returns attributed formatter`() throws {
        var attributed: [AttributedString] = [
            "dndbeyond",
            "wizards",
            "5etools",
        ]
        attributed[0].link = URL(string: "http://dndbeyond.com/")
        attributed[1].link = URL(string: "http://wizards.com/")
        attributed[2].link = URL(string: "http://5e.tools/")

        let formatted = [4, 8, 15, 16, 23, 42]
            .formatted(.list(memberStyle: .number.attributed, type: .and).locale(Self.locale))
        #expect(String(formatted.characters) == "4, 8, 15, 16, 23, and 42")

        var range = try #require(formatted.range(of: "4"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "8"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "15"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "16"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "23"))
        #expect(formatted[range].numberPart == .integer)

        range = try #require(formatted.range(of: "42"))
        #expect(formatted[range].numberPart == .integer)
    }
}
