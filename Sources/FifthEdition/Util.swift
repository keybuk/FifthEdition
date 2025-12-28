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

public enum Page: Equatable, Hashable, Sendable {
    case number(Int)
    case numeral(String)
}

@MemberwiseInit(.public)
public struct Source: Codable, Equatable, Hashable, Sendable {
    public var source: String
    public var page: Page? = nil
}

public enum Edition: String, CaseIterable, Codable, Sendable {
    case classic
    case one
}

@MemberwiseInit(.public)
public struct Reprint: Equatable, Hashable, Sendable {
    public var uid: String
    public var tag: String? = nil
    public var edition: Edition? = nil
}

public enum Tag: Equatable, Hashable, Sendable {
    case tag(String)
    case prefixed(String, prefix: String)
}

@MemberwiseInit(.public)
public struct Speed: Equatable {
    public enum Value: Equatable, Hashable, Sendable {
        case speed(Int)
        case conditional(Int, condition: String)
        case walkingSpeed
    }

    public enum Mode: String, CaseIterable, Codable, Sendable {
        case walk
        case burrow
        case climb
        case fly
        case swim
    }

    @MemberwiseInit(.public)
    public struct Choice: Equatable, Codable, Sendable {
        public var from: Set<Mode>
        public var amount: Int
        public var note: String? = nil
    }

    @MemberwiseInit(.public)
    public struct Alternate: Equatable, Sendable {
        @Init(label: "_")
        public var speeds: [Mode: Set<Value>] = [:]

        public subscript(_ mode: Mode) -> Set<Value>? {
            get { speeds[mode] }
            set { speeds[mode] = newValue }
        }
    }

    @Init(label: "_")
    public var speeds: [Mode: Value] = [:]

    public var canHover: Bool? = nil

    public var choose: Choice? = nil
    public var alternate: Alternate? = nil
    public var hidden: Set<Mode>? = nil

    public static var varies: Speed { Speed() }

    public subscript(_ mode: Mode) -> Value? {
        get { speeds[mode] }
        set { speeds[mode] = newValue }
    }
}

public enum CreatureType: String, CaseIterable, Codable, Sendable {
    case aberration
    case beast
    case celestial
    case construct
    case dragon
    case elemental
    case fey
    case fiend
    case giant
    case humanoid
    case monstrosity
    case ooze
    case plant
    case undead
}

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

public enum Size: String, CaseIterable, Comparable, Sendable {
    case tiny
    case small
    case medium
    case large
    case huge
    case gargantuan

    public static func < (lhs: Size, rhs: Size) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

public enum Proficiency: Equatable, Sendable {
    case proficient
    case expertise
}

// MARK: - Codable

extension Page: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .number(value)
        } else {
            self = .numeral(try container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .number(let value): try container.encode(value)
        case .numeral(let value): try container.encode(value)
        }
    }
}

extension Reprint: Codable {
    enum CodingKeys: String, CodingKey {
        case uid
        case tag
        case edition
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(String.self)
        {
            uid = value
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            uid = try container.decode(String.self, forKey: .uid)
            tag = try container.decodeIfPresent(String.self, forKey: .tag)
            edition = try container.decodeIfPresent(Edition.self, forKey: .edition)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if tag == nil && edition == nil {
            var container = encoder.singleValueContainer()
            try container.encode(uid)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(uid, forKey: .uid)
            try container.encodeIfPresent(tag, forKey: .tag)
            try container.encodeIfPresent(edition, forKey: .edition)
        }
    }
}

extension Tag: Codable {
    enum CodingKeys: String, CodingKey {
        case tag
        case prefix
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            self = .tag(value)
        } else {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self = .prefixed(
                try values.decode(String.self, forKey: .tag),
                prefix: try values.decode(String.self, forKey: .prefix),
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .tag(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .prefixed(let tag, let prefix):
            var values = encoder.container(keyedBy: CodingKeys.self)
            try values.encode(tag, forKey: .tag)
            try values.encode(prefix, forKey: .prefix)
        }
    }
}

extension Speed.Value: Codable {
    enum CodingKeys: String, CodingKey {
        case number
        case condition
    }

    public init(from decoder: any Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            self = .speed(value)
        } else if let value = try? decoder.singleValueContainer().decode(Bool.self), value {
            self = .walkingSpeed
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self = .conditional(
                try container.decode(Int.self, forKey: .number),
                condition: try container.decode(String.self, forKey: .condition)
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .speed(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .conditional(let number, let condition):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(number, forKey: .number)
            try container.encode(condition, forKey: .condition)
        case .walkingSpeed:
            var container = encoder.singleValueContainer()
            try container.encode(true)
        }
    }
}

extension Speed.Alternate: Codable {
    enum CodingKeys: String, CodingKey {
        case walk
        case burrow
        case climb
        case fly
        case swim
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        for speed in Speed.Mode.allCases {
            if let value = try container.decodeIfPresent(Set<Speed.Value>.self, forKey: CodingKeys(rawValue: speed.rawValue)!) {
                speeds[speed] = value
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for speed in Speed.Mode.allCases {
            if let value = speeds[speed] {
                try container.encode(value, forKey: CodingKeys(rawValue: speed.rawValue)!)
            }
        }
    }
}

extension Speed: Codable {
    enum CodingKeys: String, CodingKey {
        case walk
        case burrow
        case climb
        case fly
        case swim

        case canHover
        case choose
        case alternate
        case hidden
    }

    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(Int.self)
        {
            speeds = [.walk: .speed(value)]
        } else if let container = try? decoder.singleValueContainer(),
                  let value = try? container.decode(String.self), value == "Varies"
        {
            self = .varies
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            for speed in Mode.allCases {
                if let value = try container.decodeIfPresent(Value.self, forKey: CodingKeys(rawValue: speed.rawValue)!) {
                    speeds[speed] = value
                }
            }

            canHover = try container.decodeIfPresent(Bool.self, forKey: .canHover)

            choose = try container.decodeIfPresent(Choice.self, forKey: .choose)
            alternate = try container.decodeIfPresent(Alternate.self, forKey: .alternate)
            hidden = try container.decodeIfPresent(Set<Mode>.self, forKey: .hidden)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if self == .varies {
            var container = encoder.singleValueContainer()
            try container.encode("Varies")
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            for speed in Mode.allCases {
                if let value = speeds[speed] {
                    try container.encode(value, forKey: CodingKeys(rawValue: speed.rawValue)!)
                }
            }

            try container.encodeIfPresent(canHover, forKey: .canHover)

            try container.encodeIfPresent(choose, forKey: .choose)
            try container.encodeIfPresent(alternate, forKey: .alternate)
            try container.encodeIfPresent(hidden, forKey: .hidden)
        }
    }
}

extension Alignment: Codable {
    public init(from decoder: any Decoder) throws {
        var alignment = Self()

        let container = try decoder.singleValueContainer()
        for value in try container.decode([String].self) {
            switch value {
            case "L":  alignment.insert(.lawful)
            case "C":  alignment.insert(.chaotic)
            case "NX": alignment.insert(.neutralLawfulChaotic)
            case "NY": alignment.insert(.neutralGoodEvil)
            case "N":  alignment.insert(.neutral)
            case "G":  alignment.insert(.good)
            case "E":  alignment.insert(.evil)
            case "U":  alignment = .unaligned
            case "A":  alignment = .any
            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unexpected alignment '\(value)'"
                )
            }
        }

        rawValue = alignment.rawValue
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        if self == .any {
            try container.encode("A")
        } else if self == .unaligned {
            try container.encode("U")
        } else {
            if contains(.lawful) {
                try container.encode("L")
            }
            if contains(.chaotic) {
                try container.encode("C")
            }
            if contains(.neutralLawfulChaotic) {
                try container.encode("NX")
            }
            if contains(.neutralGoodEvil) {
                try container.encode("NY")
            }
            if contains(.neutral) {
                try container.encode("N")
            }
            if contains(.good) {
                try container.encode("G")
            }
            if contains(.evil) {
                try container.encode("E")
            }
        }
    }
}

extension Size: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "T": self = .tiny
        case "S": self = .small
        case "M": self = .medium
        case "L": self = .large
        case "H": self = .huge
        case "G": self = .gargantuan
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown size: \(value)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .tiny: try container.encode("T")
        case .small: try container.encode("S")
        case .medium: try container.encode("M")
        case .large: try container.encode("L")
        case .huge: try container.encode("H")
        case .gargantuan: try container.encode("G")
        }
    }
}

extension Proficiency: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Int.self)

        switch value {
        case 1: self = .proficient
        case 2: self = .expertise
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown value: \(value)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .proficient: try container.encode(1)
        case .expertise: try container.encode(2)
        }
    }
}
