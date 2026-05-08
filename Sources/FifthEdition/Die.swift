//
//  Die.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/8/26.
//

/// Die to be rolled.
///
/// Can represent those both in and out of jail.
public enum Die: Int, CaseIterable, Equatable, Hashable, Sendable {
    case d1 = 1
    case d2 = 2
    case d3 = 3
    case d4 = 4
    case d6 = 6
    case d8 = 8
    case d10 = 10
    case d12 = 12
    case d20 = 20
    case d100 = 100
}

extension Die: Comparable {
    public static func < (lhs: Die, rhs: Die) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Die: CustomStringConvertible {
    public var description: String {
        "d\(rawValue)"
    }
}
