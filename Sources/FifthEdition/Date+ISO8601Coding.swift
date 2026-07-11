//
//  Date+ISO8601Coding.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/4/26.
//

import Foundation

/// Extend Date to support encoding in alternate formats specified by configuration.
extension Date: @retroactive CodableWithConfiguration {
    public enum CodingConfiguration {
        case iso8601
    }

    static let formatStyle = Date.ISO8601FormatStyle(timeZone: .current)
        .year().month().day()

    public init(from decoder: any Decoder, configuration _: CodingConfiguration) throws {
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        if let dateValue = try? Date(dateStr, strategy: Self.formatStyle) {
            self = dateValue
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Could not parse date: \(dateStr)")
        }
    }

    public func encode(to encoder: any Encoder, configuration _: CodingConfiguration) throws {
        var container = encoder.singleValueContainer()
        try container.encode(formatted(Self.formatStyle))
    }
}
