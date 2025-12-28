//
//  CodableTest.swift
//  MaterialPlane
//
//  Created by Scott James Remnant on 12/26/25.
//

import Foundation
import Testing

protocol CodableTest {
    func testCodable<Value: Equatable & Codable>(json: String, value: Value) throws
}

extension CodableTest {
    func testCodable<Value: Equatable & Codable>(json: String, value expectedValue: Value) throws {
        let value = try JSONDecoder().decode(Value.self, from: json.data(using: .utf8)!)
        #expect(value == expectedValue)

        // JSONEncoder isn't deterministic when dealing with Set<>, so rather than comparing for exact output, encode and decode the value, and make sure it stayed the same.
        let encodedJson = String(data: try JSONEncoder().encode(expectedValue), encoding: .utf8)!
        let decodedValue = try JSONDecoder().decode(Value.self, from: encodedJson.data(using: .utf8)!)
        #expect(decodedValue == expectedValue)
    }
}
