//
//  Util+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

extension Ordinal: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .number(number): "\(number)"
        case let .numeral(numeral): numeral
        }
    }
}
