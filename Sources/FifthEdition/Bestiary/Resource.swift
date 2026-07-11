//
//  Resource.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/14/26.
//

import MemberwiseInit

/// Environments the creature may be found in.
public enum Habitat: Comparable, Equatable, Hashable, Sendable {
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
    case planarTransitive
    case planarElemental
    case planarInner
    case planarUpper
    case planarLower
    case planarFeywild
    case planarShadowfell
    case planarWater
    case planarEarth
    case planarFire
    case planarAir
    case planarOoze
    case planarMagma
    case planarAsh
    case planarIce
    case planarElementalChaos
    case planarEthereal
    case planarAstral
    case planarArborea
    case planarArcadia
    case planarBeastlands
    case planarBytopia
    case planarElysium
    case planarMountCelestia
    case planarYsgard
    case planarAbyss
    case planarAcheron
    case planarCarceri
    case planarGehenna
    case planarHades
    case planarNineHells
    case planarPandemonium
    case planarLimbo
    case planarMechanus
    case planarOutlands

    /// Custom homebrew value.
    case other(String)
}

extension Habitat: CaseIterable {
    public static let allCases: [Self] = [
        .any,
        .underwater,
        .coastal,
        .mountain,
        .grassland,
        .hill,
        .arctic,
        .urban,
        .forest,
        .swamp,
        .underdark,
        .desert,
        .badlands,
        .farmland,
        .planar,
        .planarTransitive,
        .planarElemental,
        .planarInner,
        .planarUpper,
        .planarLower,
        .planarFeywild,
        .planarShadowfell,
        .planarWater,
        .planarEarth,
        .planarFire,
        .planarAir,
        .planarOoze,
        .planarMagma,
        .planarAsh,
        .planarIce,
        .planarElementalChaos,
        .planarEthereal,
        .planarAstral,
        .planarArborea,
        .planarArcadia,
        .planarBeastlands,
        .planarBytopia,
        .planarElysium,
        .planarMountCelestia,
        .planarYsgard,
        .planarAbyss,
        .planarAcheron,
        .planarCarceri,
        .planarGehenna,
        .planarHades,
        .planarNineHells,
        .planarPandemonium,
        .planarLimbo,
        .planarMechanus,
        .planarOutlands,
    ]
}

extension Habitat: Codable, RawRepresentable {
    public init(rawValue: RawValue) {
        self = switch rawValue {
        case "any": .any
        case "underwater": .underwater
        case "coastal": .coastal
        case "mountain": .mountain
        case "grassland": .grassland
        case "hill": .hill
        case "arctic": .arctic
        case "urban": .urban
        case "forest": .forest
        case "swamp": .swamp
        case "underdark": .underdark
        case "desert": .desert
        case "badlands": .badlands
        case "farmland": .farmland
        case "planar": .planar
        case "planar, transitive": .planarTransitive
        case "planar, elemental": .planarElemental
        case "planar, inner": .planarInner
        case "planar, upper": .planarUpper
        case "planar, lower": .planarLower
        case "planar, feywild": .planarFeywild
        case "planar, shadowfell": .planarShadowfell
        case "planar, water": .planarWater
        case "planar, earth": .planarEarth
        case "planar, fire": .planarFire
        case "planar, air": .planarAir
        case "planar, ooze": .planarOoze
        case "planar, magma": .planarMagma
        case "planar, ash": .planarAsh
        case "planar, ice": .planarIce
        case "planar, elemental chaos": .planarElementalChaos
        case "planar, ethereal": .planarEthereal
        case "planar, astral": .planarAstral
        case "planar, arborea": .planarArborea
        case "planar, arcadia": .planarArcadia
        case "planar, beastlands": .planarBeastlands
        case "planar, bytopia": .planarBytopia
        case "planar, elysium": .planarElysium
        case "planar, mount celestia": .planarMountCelestia
        case "planar, ysgard": .planarYsgard
        case "planar, abyss": .planarAbyss
        case "planar, acheron": .planarAcheron
        case "planar, carceri": .planarCarceri
        case "planar, gehenna": .planarGehenna
        case "planar, hades": .planarHades
        case "planar, nine hells": .planarNineHells
        case "planar, pandemonium": .planarPandemonium
        case "planar, limbo": .planarLimbo
        case "planar, mechanus": .planarMechanus
        case "planar, outlands": .planarOutlands
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .any: "any"
        case .underwater: "underwater"
        case .coastal: "coastal"
        case .mountain: "mountain"
        case .grassland: "grassland"
        case .hill: "hill"
        case .arctic: "arctic"
        case .urban: "urban"
        case .forest: "forest"
        case .swamp: "swamp"
        case .underdark: "underdark"
        case .desert: "desert"
        case .badlands: "badlands"
        case .farmland: "farmland"
        case .planar: "planar"
        case .planarTransitive: "planar, transitive"
        case .planarElemental: "planar, elemental"
        case .planarInner: "planar, inner"
        case .planarUpper: "planar, upper"
        case .planarLower: "planar, lower"
        case .planarFeywild: "planar, feywild"
        case .planarShadowfell: "planar, shadowfell"
        case .planarWater: "planar, water"
        case .planarEarth: "planar, earth"
        case .planarFire: "planar, fire"
        case .planarAir: "planar, air"
        case .planarOoze: "planar, ooze"
        case .planarMagma: "planar, magma"
        case .planarAsh: "planar, ash"
        case .planarIce: "planar, ice"
        case .planarElementalChaos: "planar, elemental chaos"
        case .planarEthereal: "planar, ethereal"
        case .planarAstral: "planar, astral"
        case .planarArborea: "planar, arborea"
        case .planarArcadia: "planar, arcadia"
        case .planarBeastlands: "planar, beastlands"
        case .planarBytopia: "planar, bytopia"
        case .planarElysium: "planar, elysium"
        case .planarMountCelestia: "planar, mount celestia"
        case .planarYsgard: "planar, ysgard"
        case .planarAbyss: "planar, abyss"
        case .planarAcheron: "planar, acheron"
        case .planarCarceri: "planar, carceri"
        case .planarGehenna: "planar, gehenna"
        case .planarHades: "planar, hades"
        case .planarNineHells: "planar, nine hells"
        case .planarPandemonium: "planar, pandemonium"
        case .planarLimbo: "planar, limbo"
        case .planarMechanus: "planar, mechanus"
        case .planarOutlands: "planar, outlands"
        case let .other(rawValue): rawValue
        }
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
public enum Treasure: Comparable, Equatable, Hashable, Sendable {
    case any
    case individual
    case arcana
    case armaments
    case implements
    case relics

    /// Custom homebrew value.
    case other(String)
}

extension Treasure: CaseIterable {
    public static let allCases: [Self] = [
        .any,
        .individual,
        .arcana,
        .armaments,
        .implements,
        .relics,
    ]
}

extension Treasure: Codable, RawRepresentable {
    public init(rawValue: RawValue) {
        self = switch rawValue {
        case "any": .any
        case "individual": .individual
        case "arcana": .arcana
        case "armaments": .armaments
        case "implements": .implements
        case "relics": .relics
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .any: "any"
        case .individual: "individual"
        case .arcana: "arcana"
        case .armaments: "armaments"
        case .implements: "implements"
        case .relics: "relics"
        case let .other(rawValue): rawValue
        }
    }
}
