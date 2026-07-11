//
//  Coding.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

import Foundation

/// Extend Set to support decoding elements with a configuration.
extension Set: @retroactive DecodableWithConfiguration
    where Element: DecodableWithConfiguration
{
    public init(from decoder: any Decoder, configuration: Element.DecodingConfiguration) throws {
        try self.init(Array(from: decoder, configuration: configuration))
    }
}

/// Extend Set to support encoding elements with a configuration.
extension Set: @retroactive EncodableWithConfiguration
    where Element: EncodableWithConfiguration
{
    public func encode(to encoder: any Encoder, configuration: Element.EncodingConfiguration) throws {
        try Array(self).encode(to: encoder, configuration: configuration)
    }
}

/// Protocol for enumerated types that have an alternative value when coded.
///
/// For example `Size.medium` might be encoded as either "medium" or "M".
protocol AlternativeCoding {
    associatedtype CodingValue

    var codingValue: CodingValue? { get }

    init?(codingValue: CodingValue)
}

protocol AlternativeCodingMap: AlternativeCoding {
    associatedtype CodingValue

    static var codingValues: [(Self, CodingValue)] { get }
}

extension AlternativeCodingMap where CodingValue: Equatable {
    init?(codingValue: CodingValue) {
        guard let value = Self.codingValues.first(where: { $0.1 == codingValue })?.0 else { return nil }
        self = value
    }
}

extension AlternativeCodingMap where Self: Equatable {
    var codingValue: CodingValue? {
        Self.codingValues.first { $0.0 == self }?.1
    }
}

/// Wrapper around ``Value`` to provide an alternate ``Codable`` implementation using ``AlternativeCoding``.
struct AlternateCoding<Value: AlternativeCoding> {
    var value: Value

    init?(_ value: Value?) {
        guard let value else { return nil }
        self.value = value
    }
}

extension AlternateCoding: Equatable where Value: Equatable {}
extension AlternateCoding: Hashable where Value: Hashable {}

extension AlternateCoding: Decodable where Value.CodingValue: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let codingValue = try container.decode(Value.CodingValue.self)
        guard let decodedValue = Value(codingValue: codingValue) else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Unknown value: \(codingValue)")
        }

        value = decodedValue
    }
}

extension AlternateCoding: Encodable where Value.CodingValue: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        guard let codingValue = value.codingValue else {
            throw EncodingError.invalidValue(value,
                                             EncodingError.Context(codingPath: container.codingPath,
                                                                   debugDescription: "No coding for value: \(value)"))
        }

        try container.encode(codingValue)
    }
}

/// Wrapper around ``Set<Value>`` to provide an alternate ``Codable`` implementation using ``AlternativeCoding``.
struct AlternateSetCoding<Value: AlternativeCoding & Hashable> {
    var value: Set<Value>

    init?(_ value: Set<Value>?) {
        guard let value else { return nil }
        self.value = value
    }
}

extension AlternateSetCoding: Equatable where Value: Equatable {}
extension AlternateSetCoding: Hashable where Value: Hashable {}

extension AlternateSetCoding: Decodable where Value.CodingValue: Decodable {
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()

        value = []
        while !container.isAtEnd {
            let codingValue = try container.decode(Value.CodingValue.self)
            guard let decodedValue = Value(codingValue: codingValue) else {
                throw DecodingError.dataCorruptedError(in: container,
                                                       debugDescription: "Unknown value: \(codingValue)")
            }
            value.insert(decodedValue)
        }
    }
}

extension AlternateSetCoding: Encodable where Value.CodingValue: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        for decodedValue in value {
            guard let codingValue = decodedValue.codingValue else {
                throw EncodingError.invalidValue(value,
                                                 EncodingError.Context(codingPath: container.codingPath,
                                                                       debugDescription: "No coding for value: \(decodedValue)"))
            }

            try container.encode(codingValue)
        }
    }
}
