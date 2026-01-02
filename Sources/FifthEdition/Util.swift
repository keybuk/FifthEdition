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

@MemberwiseInit(.public)
public struct Reprint: Equatable, Hashable, Sendable {
    public var uid: String
    @Init(default: nil) public var tag: String?
    @Init(default: nil) public var edition: Edition?
}

@MemberwiseInit(.public)
public struct Source: Codable, Equatable, Hashable, Sendable {
    public var source: String
    @Init(default: nil) public var page: Page?
}

@MemberwiseInit(.public)
public struct Speed: Equatable, Sendable {
    @MemberwiseInit(.public)
    public struct Alternate: Equatable, Sendable {
        @Init(label: "_") public var speeds: [Mode: Set<Value>] = [:]
    }

    @MemberwiseInit(.public)
    public struct Choice: Equatable, Codable, Sendable {
        public var from: Set<Mode>
        public var amount: Int
        @Init(default: nil) public var note: String?
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

    @Init(label: "_") public var speeds: [Mode: Value] = [:]

    @Init(default: nil) public var canHover: Bool?

    @Init(default: nil) public var choose: Choice?
    @Init(default: nil) public var alternate: Alternate?
    @Init(default: nil) public var hidden: Set<Mode>?

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
