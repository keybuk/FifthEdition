//
//  CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/26/25.
//

import Foundation
import Testing
@testable import FifthEdition

protocol CodableTest {
    func testCodable<Value: Equatable & Codable>(json: String, value: Value, sourceLocation: SourceLocation) throws
}

extension CodableTest {
    func testCodable<Value: Equatable & Codable>(json: String, value expectedValue: Value, sourceLocation: SourceLocation = #_sourceLocation) throws {
        let value = try JSONDecoder().decode(Value.self, from: json.data(using: .utf8)!)
        #expect(value == expectedValue, sourceLocation: sourceLocation)

        // JSONEncoder isn't deterministic when dealing with Set<>, so rather than comparing for exact output, encode and decode the value, and make sure it stayed the same.
        let encodedJson = String(data: try JSONEncoder().encode(expectedValue), encoding: .utf8)!
        let decodedValue = try JSONDecoder().decode(Value.self, from: encodedJson.data(using: .utf8)!)
        #expect(decodedValue == expectedValue, sourceLocation: sourceLocation)
    }
}

struct DynamicCodingKeyTests: CodableTest {

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
    func dynamicCodingKey() async throws {
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

struct EnumCodingKeyTests: CodableTest {

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
    func enumCodingKey() async throws {
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
