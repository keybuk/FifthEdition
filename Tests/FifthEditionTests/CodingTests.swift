//
//  CodingTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/26/25.
//

import Foundation
import Testing
@testable import FifthEdition

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
            frodo = try container.decode(Int.self, forKey: CodingKeys("frodo"))
            bilbo = try container.decode(Int.self, forKey: CodingKeys("bilbo"))
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(frodo, forKey: CodingKeys("frodo"))
            try container.encode(bilbo, forKey: CodingKeys("bilbo"))
        }
    }

    @Test("Implement Codable with DynamicCodingKey")
    func dynamicCodingKey() throws {
        try testCodable(
            json: """
            {
                "frodo": 33,
                "bilbo": 111
            }
            """,
            value: Hobbit(
                frodo: 33,
                bilbo: 111,
            )
        )
    }

}

struct EnumCodingKeyTests {

    struct Wizard: Equatable, Codable {
        enum Name: String, CaseIterable {
            case gandalf
            case radagast
            case saruman
        }

        var colors: [Name: String] = [:]
        var others: [String: String] = [:]

        typealias CodingKeys = EnumCodingKey<Name>

        init(colors: [Name: String], others: [String: String]) {
            self.colors = colors
            self.others = others
        }

        init(from decoder: any Decoder) throws {
            // Test iterating CodingKeys.allCases and obtaining enum value.
            let container = try decoder.container(keyedBy: CodingKeys.self)
            colors = try CodingKeys.allCases.reduce(into: [Name: String]()) { result, key in
                result[key.value!] = try container.decode(String.self, forKey: key)
            }

            // We can also iterate unknown values through container.allKeys and check value is nil.
            others = try container.allKeys.reduce(into: [String: String]()) { result, key in
                if key.value == nil {
                    result[key.stringValue] = try container.decode(String.self, forKey: key)
                }
            }
        }

        func encode(to encoder: any Encoder) throws {
            // Test iterating Name.allCases and converting to key.
            var container = encoder.container(keyedBy: CodingKeys.self)
            for key in CodingKeys.allCases {
                try container.encode(colors[key.value!], forKey: key)
            }

            // We can also create unknown values directly this way.
            for (key, value) in others {
                try container.encode(value, forKey: CodingKeys(stringValue: key))
            }
        }
    }

    @Test("Implement Codable with EnumCodingKey")
    func enumCodingKey() throws {
        try testCodable(
            json: """
            {
                "gandalf": "grey",
                "radagast": "brown",
                "saruman": "white",
                "alatar": "blue",
                "pallando": "blue"
            }
            """,
            value: Wizard(
                colors: [
                    .gandalf: "grey",
                    .saruman: "white",
                    .radagast: "brown",
                ],
                others: [
                    "alatar": "blue",
                    "pallando": "blue"
                ],
            )
        )
    }

}

struct TagSetCodableTests {

    enum Species: String, TagCoding {
        case human
        case dwarf
        case elf
        case hobbit

        static let tags: [(Species, String)] = [
            (.human,  "H"),
            (.dwarf,  "D"),
            (.elf,    "E"),
            (.hobbit, "O"),
        ]
    }

    @Test("Implement Codable with TagSet")
    func tagSet() throws {
        try testCodable(
            json: """
            [
                "H",
                "O"
            ]
            """,
            value: TagSet<Species>([.human, .hobbit])
        )
    }

    @Test("Empty TagSet")
    func tagEmpty() throws {
        try testCodable(
            json: """
            [
            ]
            """,
            value: TagSet<Species>()
        )
    }

    @Test("Unknown tag in set")
    func unknownTag() throws {
        #expect(throws: DecodingError.self) {
            try testDecodable(
                json: """
                [
                    "X"
                ]
                """,
                value: TagSet<Species>()
            )
        }
    }

}

struct TaggedCodableTests {

    enum Species: String, TagCoding {
        case human
        case dwarf
        case elf
        case hobbit

        static let tags: [(Species, String)] = [
            (.human,  "H"),
            (.dwarf,  "D"),
            (.elf,    "E"),
            (.hobbit, "O"),
        ]
    }

    @Test("Tagged holds its initialized value")
    func value() throws {
        let value: Species = .human
        #expect(Tagged(value).value == value)
    }

    @Test("Tagged is nil when initialized with nil")
    func nilValue() throws {
        let value: Species? = nil
        #expect(Tagged(value) == nil)
    }

    @Test("Implement Codable with Tagged")
    func tagged() throws {
        try testCodable(
            json: """
            "H"
            """,
            value: Tagged<Species>(.human)
        )
    }

    @Test("Tagged enumeration values", arguments: Species.tags)
    func taggedValue(species: Species, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(species)
        )
    }

    @Test("Unknown tag")
    func unknownTag() throws {
        #expect(throws: DecodingError.self) {
            try testDecodable(
                json: """
                "X"
                """,
                value: Tagged<Species>(.human)
            )
        }
    }

}
