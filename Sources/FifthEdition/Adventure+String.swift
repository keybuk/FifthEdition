//
//  Adventure+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

extension Adventure.Level: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .range(range): "\(range.lowerBound)–\(range.upperBound)"
        case let .custom(custom): custom
        }
    }
}
