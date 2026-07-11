//
//  CodingTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/26/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct DateCodingTests {
    @Test
    func `Date encoded in ISO8601 using configuration`() throws {
        try testCodable(
            json: """
            "2020-07-18"
            """,
            value: DateComponents(calendar: Calendar(identifier: .iso8601),
                                  year: 2020,
                                  month: 7,
                                  day: 18).date,
            configuration: .iso8601,
        )
    }
}

struct DynamicCodingKeyTests {
    struct Hobbit: Equatable, Codable {
        var frodo: Int
        var bilbo: Int

        init(frodo: Int, bilbo: Int) {
            self.frodo = frodo
            self.bilbo = bilbo
        }

        typealias CodingKeys = DynamicCodingKey

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            frodo = try container.decode(Int.self, forKey: CodingKeys(stringValue: "frodo"))
            bilbo = try container.decode(Int.self, forKey: CodingKeys(stringValue: "bilbo"))
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(frodo, forKey: CodingKeys(stringValue: "frodo"))
            try container.encode(bilbo, forKey: CodingKeys(stringValue: "bilbo"))
        }
    }

    @Test
    func `Implement Codable with DynamicCodingKey`() throws {
        try testCodable(
            json: """
            {
                "frodo": 33,
                "bilbo": 111
            }
            """,
            value: Hobbit(frodo: 33,
                          bilbo: 111),
        )
    }
}

struct SetCodingTests {
    @Test
    func `Set encoded using configuration`() throws {
        try testCodable(
            json: """
            [
                "2020-07-18",
                "2021-12-18",
            ]
            """,
            value: Set([
                DateComponents(calendar: Calendar(identifier: .iso8601),
                               year: 2020,
                               month: 7,
                               day: 18).date,
                DateComponents(calendar: Calendar(identifier: .iso8601),
                               year: 2021,
                               month: 12,
                               day: 18).date,
            ]),
            configuration: .iso8601,
        )
    }
}

struct AlternativeCodingMapTests {
    enum Species: String, AlternativeCodingMap {
        case human
        case dwarf
        case elf
        case hobbit
        case tiefling

        static let codingValues: [(Species, String)] = [
            (.human, "H"),
            (.dwarf, "D"),
            (.elf, "E"),
            (.hobbit, "O"),
        ]
    }

    @Test(arguments: Species.codingValues)
    func `init?(codingValue:) default conformance`(value: Species, codingValue: String) {
        #expect(Species(codingValue: codingValue) == value)
    }

    @Test
    func `init?(codingValue:) returns nil for unknown value`() {
        #expect(Species(codingValue: "X") == nil)
    }

    @Test(arguments: Species.codingValues)
    func `codingValue default conformance`(value: Species, codingValue: String) {
        #expect(value.codingValue == codingValue)
    }

    @Test
    func `codingValue returns nil for unknown value`() {
        #expect(Species.tiefling.codingValue == nil)
    }
}

struct AlternateCodingTests {
    enum Species: String, AlternativeCodingMap {
        case human
        case dwarf
        case elf
        case hobbit

        static let codingValues: [(Species, String)] = [
            (.human, "H"),
            (.dwarf, "D"),
            (.elf, "E"),
            (.hobbit, "O"),
        ]
    }

    @Test
    func `AlternateCoding holds its initialized value`() {
        let value: Species = .human
        #expect(AlternateCoding(value)?.value == value)
    }

    @Test
    func `init?(_:) is nil when initialized with nil`() {
        #expect(AlternateCoding<Species>(nil) == nil)
    }

    @Test
    func `Implement Codable with AlternateCoding`() throws {
        try testCodable(
            json: """
            "H"
            """,
            value: AlternateCoding<Species>(.human),
        )
    }

    @Test(arguments: Species.codingValues)
    func `Alternate enumeration value codings`(species: Species, codingValue: String) throws {
        try testCodable(
            json: """
            "\(codingValue)"
            """,
            value: AlternateCoding(species),
        )
    }

    @Test
    func `init(from:) throws error when decoding unknown value`() throws {
        let json = """
        "X"
        """
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(AlternateCoding<Species>.self, from: #require(json.data(using: .utf8)))
        }
    }
}

struct AlternateSetCodingTests {
    enum Species: String, AlternativeCodingMap {
        case human
        case dwarf
        case elf
        case hobbit

        static let codingValues: [(Species, String)] = [
            (.human, "H"),
            (.dwarf, "D"),
            (.elf, "E"),
            (.hobbit, "O"),
        ]
    }

    @Test
    func `Implement Codable with AlternateSetCoding`() throws {
        try testCodable(
            json: """
            [
                "H",
                "O"
            ]
            """,
            value: AlternateSetCoding<Species>([.human, .hobbit]),
        )
    }

    @Test
    func `AlternateSetCoding with empty set`() throws {
        try testCodable(
            json: """
            [
            ]
            """,
            value: AlternateSetCoding<Species>([]),
        )
    }

    @Test
    func `Unknown coding value in set`() throws {
        let json = """
        [
            "X"
        ]
        """
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(AlternateSetCoding<Species>.self, from: #require(json.data(using: .utf8)))
        }
    }

    @Test
    func `init?(_:) is nil when initialized with nil`() {
        #expect(AlternateSetCoding<Species>(nil) == nil)
    }
}
