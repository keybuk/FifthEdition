//
//  Util+Expressible.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

extension Ordinal: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number(value)
    }
}

extension Ordinal: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .numeral(value)
    }
}
