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

struct CodingValueTests {
    enum RingOfPower {
        case one
        case three
        case seven
        case nine
    }

    struct RingOfPowerCoding: Codable, CodingValue, Equatable {
        var value: RingOfPower

        init(_ value: RingOfPower) {
            self.value = value
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let intValue = try container.decode(Int.self)
            value = switch intValue {
            case 1: .one
            case 3: .three
            case 7: .seven
            case 9: .nine
            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid value: \(intValue)",
                )
            }
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch value {
            case .one: try container.encode(1)
            case .three: try container.encode(3)
            case .seven: try container.encode(7)
            case .nine: try container.encode(9)
            }
        }
    }

    @Test
    func `Implement Codable with ValueCoding`() throws {
        try testCodable(
            json: """
            3
            """,
            value: RingOfPowerCoding(.three),
        )
    }

    @Test
    func `init?(_:) returns nil when initialized with nil`() {
        #expect(RingOfPowerCoding(nil) == nil)
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
            frodo = try container.decode(Int.self, forKey: CodingKeys("frodo"))
            bilbo = try container.decode(Int.self, forKey: CodingKeys("bilbo"))
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(frodo, forKey: CodingKeys("frodo"))
            try container.encode(bilbo, forKey: CodingKeys("bilbo"))
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
            value: Hobbit(
                frodo: 33,
                bilbo: 111,
            ),
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

    @Test
    func `Implement Codable with EnumCodingKey`() throws {
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
                    "pallando": "blue",
                ],
            ),
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
            (.human, "H"),
            (.dwarf, "D"),
            (.elf, "E"),
            (.hobbit, "O"),
        ]
    }

    @Test
    func `Implement Codable with TagSet`() throws {
        try testCodable(
            json: """
            [
                "H",
                "O"
            ]
            """,
            value: TagSet<Species>([.human, .hobbit]),
        )
    }

    @Test
    func `Empty TagSet`() throws {
        try testCodable(
            json: """
            [
            ]
            """,
            value: TagSet<Species>(),
        )
    }

    @Test
    func `Unknown tag in set`() throws {
        let json = """
        [
            "X"
        ]
        """
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(TagSet<Species>.self, from: #require(json.data(using: .utf8)))
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
            (.human, "H"),
            (.dwarf, "D"),
            (.elf, "E"),
            (.hobbit, "O"),
        ]
    }

    @Test
    func `Tagged holds its initialized value`() {
        let value: Species = .human
        #expect(Tagged(value).value == value)
    }

    @Test
    func `Tagged is nil when initialized with nil`() {
        let value: Species? = nil
        #expect(Tagged(value) == nil)
    }

    @Test
    func `Implement Codable with Tagged`() throws {
        try testCodable(
            json: """
            "H"
            """,
            value: Tagged<Species>(.human),
        )
    }

    @Test(arguments: Species.tags)
    func `Tagged enumeration values`(species: Species, tag: String) throws {
        try testCodable(
            json: """
            "\(tag)"
            """,
            value: Tagged(species),
        )
    }

    @Test
    func `Unknown tag`() throws {
        let json = """
        "X"
        """
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Tagged<Species>.self, from: #require(json.data(using: .utf8)))
        }
    }
}
