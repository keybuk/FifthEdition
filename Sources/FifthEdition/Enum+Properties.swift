//
//  Enum+Properties.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

extension Size: Comparable {
    public static func < (lhs: Size, rhs: Size) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

public extension Size {
    /// Number of 5 ft grid squares occupied by creatures of this size.
    var gridSquares: Int {
        switch self {
        case .medium, .small, .tiny: 1
        case .large: 2
        case .huge: 3
        case .gargantuan: 4
        }
    }
}
