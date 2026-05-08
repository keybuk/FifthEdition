//
//  Meta+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/8/26.
//

extension Meta.Entity: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension Meta.Entity: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}
