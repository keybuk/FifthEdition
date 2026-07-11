//
//  Resource.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/14/26.
//

import MemberwiseInit
import RawRepresentableOptions

/// Environments the creature may be found in.
@RawRepresentableOptions
public struct Habitat: CaseIterable, Codable, Equatable, Hashable, Sendable {
    private enum Habitat: String {
        case any
        case underwater
        case coastal
        case mountain
        case grassland
        case hill
        case arctic
        case urban
        case forest
        case swamp
        case underdark
        case desert
        case badlands
        case farmland
        case planar
        case planarTransitive = "planar, transitive"
        case planarElemental = "planar, elemental"
        case planarInner = "planar, inner"
        case planarUpper = "planar, upper"
        case planarLower = "planar, lower"
        case planarFeywild = "planar, feywild"
        case planarShadowfell = "planar, shadowfell"
        case planarWater = "planar, water"
        case planarEarth = "planar, earth"
        case planarFire = "planar, fire"
        case planarAir = "planar, air"
        case planarOoze = "planar, ooze"
        case planarMagma = "planar, magma"
        case planarAsh = "planar, ash"
        case planarIce = "planar, ice"
        case planarElementalChaos = "planar, elemental chaos"
        case planarEthereal = "planar, ethereal"
        case planarAstral = "planar, astral"
        case planarArborea = "planar, arborea"
        case planarArcadia = "planar, arcadia"
        case planarBeastlands = "planar, beastlands"
        case planarBytopia = "planar, bytopia"
        case planarElysium = "planar, elysium"
        case planarMountCelestia = "planar, mount celestia"
        case planarYsgard = "planar, ysgard"
        case planarAbyss = "planar, abyss"
        case planarAcheron = "planar, acheron"
        case planarCarceri = "planar, carceri"
        case planarGehenna = "planar, gehenna"
        case planarHades = "planar, hades"
        case planarNineHells = "planar, nine hells"
        case planarPandemonium = "planar, pandemonium"
        case planarLimbo = "planar, limbo"
        case planarMechanus = "planar, mechanus"
        case planarOutlands = "planar, outlands"
    }
}

/// Expendable resource.
///
/// Usually provided as a ``DiceNotation`` formula given in the associated value of ``resource(_:value:)``. The `value`
/// associated value is `nil` if the initial value matches the ``DiceNotation/average``, otherwise provides the initial
/// value.
///
/// In the event the formula is not parseable, the value and formula are given in the associated values of
/// ``value(_:formula:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``Resource`` values to be
/// specified as integer and string literals.
public enum Resource: Equatable, Hashable, Sendable {
    case resource(DiceNotation, value: Int? = nil)
    case value(Int, formula: String? = nil)
}

extension Resource: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize from an integer literal.
    ///
    /// Sets ``value(_:formula:)``.
    public init(integerLiteral value: IntegerLiteralType) {
        self = .value(value)
    }

    /// Initialize from a string literal.
    ///
    /// Sets ``resource(_:value:)`` to `value` parsed as a ``DiceNotation``.
    public init(stringLiteral value: StringLiteralType) {
        guard let diceNotation = DiceNotation(string: value) else {
            fatalError("String literal must be a dice notation")
        }
        self = .resource(diceNotation)
    }
}

extension Resource: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.resource(lhsFormula, lhsValue), .resource(rhsFormula, rhsValue)):
            (lhsValue ?? lhsFormula.average) < (rhsValue ?? rhsFormula.average)
        case let (.value(lhsValue, _), .value(rhsValue, _)):
            lhsValue < rhsValue
        case let (.resource(lhsFormula, lhsValue), .value(rhsValue, _)):
            (lhsValue ?? lhsFormula.average) < rhsValue
        case let (.value(lhsValue, _), .resource(rhsFormula, rhsValue)):
            lhsValue < (rhsValue ?? rhsFormula.average)
        }
    }
}

/// Treasure awarded for defeating the creature.
@RawRepresentableOptions
public struct Treasure: CaseIterable, Codable, Equatable, Hashable, Sendable {
    private enum Options: String {
        case any
        case individual
        case arcana
        case armaments
        case implements
        case relics
    }
}
