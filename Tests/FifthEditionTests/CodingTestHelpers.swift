//
//  CodingTestHelpers.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/26/25.
//

@testable import FifthEdition
import Foundation
import Testing

func testDecodable<Value: Equatable & Decodable>(json: String, value expectedValue: Value, sourceLocation: SourceLocation = #_sourceLocation) throws {
    let value = try JSONDecoder().decode(Value.self, from: json.data(using: .utf8)!)
    #expect(value == expectedValue, sourceLocation: sourceLocation)
}

func testCodable<Value: Equatable & Codable>(json: String, value expectedValue: Value, sourceLocation: SourceLocation = #_sourceLocation) throws {
    try testDecodable(json: json, value: expectedValue, sourceLocation: sourceLocation)

    // JSONEncoder isn't deterministic when dealing with Set<>, so rather than comparing for exact output, encode and decode the value, and make sure it stayed the same.
    let encodedJson = try String(data: JSONEncoder().encode(expectedValue), encoding: .utf8)!
    let decodedValue = try JSONDecoder().decode(Value.self, from: encodedJson.data(using: .utf8)!)
    #expect(decodedValue == expectedValue, sourceLocation: sourceLocation)
}
