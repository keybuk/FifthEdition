//
//  EnumTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

import Testing
@testable import FifthEdition

struct SizeComparableTests {
    static let testValues: [Bool] = [
        Size.tiny < Size.large,
        Size.medium < Size.huge,
        Size.medium > Size.small,
        Size.large > Size.tiny,
        Size.small < Size.huge,
    ]

    @Test(arguments: zip(Size.allCases, Size.allCases.dropFirst()))
    func `Size smaller than next`(_ a: Size, _ b: Size) {
        #expect(a < b)
    }

    @Test(arguments: testValues)
    func `Size comparisons`(_ testedValue: Bool) {
        #expect(testedValue)
    }
}

struct SizeGridSquaresTests {
    static let expectedValues = [
        (Size.tiny, 1),
        (Size.small, 1),
        (Size.medium, 1),
        (Size.large, 2),
        (Size.huge, 3),
        (Size.gargantuan, 4),
    ]

    @Test(arguments: expectedValues)
    func `gridSquares has expected value`(size: Size, expectedValue: Int) {
        #expect(size.gridSquares == expectedValue)
    }
}
