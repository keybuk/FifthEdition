//
//  SizesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct CreatureSizesFormatStyleTests {
    static let locale = Locale(identifier: "en_US")

    @Test
    func `sizes() returns list of capitalized names`() throws {
        let sizes = Creature.Sizes([.medium, .small])

        let formatter = Creature.Sizes.FormatStyle().locale(Self.locale)
        let description = formatter.format(sizes)
        #expect(description == "Small or Medium")

        let attributed = formatter.attributed.format(sizes)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sizes == sizes)

        var range = try #require(attributed.range(of: "Small"))
        #expect(attributed[range].size == .small)

        range = try #require(attributed.range(of: "Medium"))
        #expect(attributed[range].size == .medium)
    }

    @Test
    func `sizes(case:) returns list of lowercased names`() throws {
        let sizes = Creature.Sizes([.medium, .small])

        let formatter = Creature.Sizes.FormatStyle(case: .lowercased).locale(Self.locale)
        let description = formatter.format(sizes)
        #expect(description == "small or medium")

        let attributed = formatter.attributed.format(sizes)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sizes == sizes)

        var range = try #require(attributed.range(of: "small"))
        #expect(attributed[range].size == .small)

        range = try #require(attributed.range(of: "medium"))
        #expect(attributed[range].size == .medium)
    }

    @Test
    func `sizes() returns with note appended`() throws {
        let sizes = Creature.Sizes(.medium, note: "or smaller")

        let formatter = Creature.Sizes.FormatStyle().locale(Self.locale)
        let description = formatter.format(sizes)
        #expect(description == "Medium or smaller")

        let attributed = formatter.attributed.format(sizes)
        #expect(String(attributed.characters) == description)
        #expect(attributed.creature.sizes == sizes)

        let range = try #require(attributed.range(of: "Medium"))
        #expect(attributed[range].size == .medium)
    }
}

struct CreatureSizesInitTests {
    @Test
    func `init(_:) sets single size`() {
        let sizes = Creature.Sizes(.large)
        #expect(sizes.sizes == [.large])
    }

    @Test
    func `init(_:) sets multiple sizes`() {
        let sizes = Creature.Sizes([.small, .medium])
        #expect(sizes.sizes == [.small, .medium])
    }

    @Test
    func `init(_:note:) sets size and note`() {
        let sizes = Creature.Sizes(.medium, note: "or smaller")
        #expect(sizes.sizes == [.medium])
        #expect(sizes.note == "or smaller")
    }

    @Test
    func `init(_:note:) sets sizes and note`() {
        let sizes = Creature.Sizes([.small, .medium], note: "depending on age")
        #expect(sizes.sizes == [.small, .medium])
        #expect(sizes.note == "depending on age")
    }

    @Test
    func `init(arrayLiteral:) sets sizes`() {
        let sizes: Creature.Sizes = [.small, .medium]
        #expect(sizes.sizes == [.small, .medium])
    }
}
