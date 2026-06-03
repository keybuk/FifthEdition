//
//  CodingTestHelpers.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/26/25.
//

import Foundation
import Testing

func testCodable<Value: Equatable & Codable>(json: String, value expectedValue: Value,
                                             sourceLocation: SourceLocation = #_sourceLocation)
    throws
{
    #expect(throws: Never.self, sourceLocation: sourceLocation) {
        let value = try JSONDecoder().decode(Value.self, from: json.data(using: .utf8)!)
        #expect(value == expectedValue, sourceLocation: sourceLocation)

        // JSONEncoder isn't deterministic when dealing with Set<>, so rather than comparing for exact output, encode
        // and decode the value, and make sure it stayed the same.
        let encodedJson = try String(data: JSONEncoder().encode(expectedValue), encoding: .utf8)!
        let decodedValue = try JSONDecoder().decode(Value.self, from: encodedJson.data(using: .utf8)!)
        #expect(decodedValue == expectedValue, sourceLocation: sourceLocation)
    }
}

func testCodable<Value: Equatable & CodableWithConfiguration>(json: String, value expectedValue: Value,
                                                              configuration: Value.DecodingConfiguration,
                                                              sourceLocation: SourceLocation = #_sourceLocation)
    throws
    where Value.DecodingConfiguration == Value.EncodingConfiguration
{
    #expect(throws: Never.self, sourceLocation: sourceLocation) {
        let value = try JSONDecoder().decode(Value.self, from: json.data(using: .utf8)!, configuration: configuration)
        #expect(value == expectedValue, sourceLocation: sourceLocation)

        // JSONEncoder isn't deterministic when dealing with Set<>, so rather than comparing for exact output, encode
        // and decode the value, and make sure it stayed the same.
        let encodedJson = try String(
            data: JSONEncoder().encode(expectedValue, configuration: configuration),
            encoding: .utf8,
        )!
        let decodedValue = try JSONDecoder().decode(
            Value.self,
            from: encodedJson.data(using: .utf8)!,
            configuration: configuration,
        )
        #expect(decodedValue == expectedValue, sourceLocation: sourceLocation)
    }
}
