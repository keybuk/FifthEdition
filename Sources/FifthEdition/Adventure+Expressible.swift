//
//  Adventure+Expressible.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

extension Adventure.Level: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .custom(value)
    }
}
