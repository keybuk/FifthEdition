//
//  Util.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//
//  Derived from schema/site/util.json
//  Version: 1.17.37

import EnumOptionSet
import MemberwiseInit

@EnumOptionSet
public enum AlignmentAxis: Sendable {
    case lawful
    case chaotic
    case neutralLawfulChaotic
    case neutralGoodEvil
    case neutral
    case good
    case evil
}

public typealias Alignment = AlignmentAxis.Set
extension Alignment: Hashable {
    static let unaligned: Self = []
    static let any: Self = .all
}

@MemberwiseInit(.public)
public struct IndexFile: Equatable, Sendable {
    public var entries: [String: String]
}

public enum Page: Equatable, Hashable, Sendable {
    case number(Int)
    case numeral(String)
}

public enum Proficiency: Equatable, Sendable {
    case proficient
    case expertise
}

@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Reprint: Equatable, Hashable, Sendable {
    public var uid: String
    public var tag: String?
    public var edition: Edition?
}

@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Source: Codable, Equatable, Hashable, Sendable {
    public var source: String
    public var page: Page?
}

@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Speed: Equatable, Sendable {
    @MemberwiseInit(.public)
    public struct Alternate: Equatable, Sendable {
        @Init(label: "_")
        public var speeds: [Mode: Set<Value>] = [:]
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct Choice: Equatable, Codable, Sendable {
        public var from: Set<Mode>
        public var amount: Int
        public var note: String?
    }

    public enum Mode: String, CaseIterable, Codable, Sendable {
        case walk
        case burrow
        case climb
        case fly
        case swim
    }

    public enum Value: Equatable, Hashable, Sendable {
        case speed(Int)
        case conditional(Int, condition: String)
        case walkingSpeed
    }

    @Init(label: "_")
    public var speeds: [Mode: Value] = [:]

    public var canHover: Bool?

    public var choose: Choice?
    public var alternate: Alternate?
    public var hidden: Set<Mode>?

    public static var varies: Speed { Speed() }
}

public enum SrdReference: Equatable, Hashable, Sendable {
    case present(Bool)
    case presentAs(String)
}

public enum Tag: Equatable, Hashable, Sendable {
    case tag(String)
    case prefixed(String, prefix: String)
}
