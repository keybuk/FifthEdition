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
    public var entries: [String: String] = [:]
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
    public var tag: String? = nil
    public var edition: Edition? = nil
}

@MemberwiseInit(.public)
public struct Source: Codable, Equatable, Hashable, Sendable {
    public var source: String
    public var page: Page? = nil
}

@MemberwiseInit(.public)
public struct Speed: Equatable, Sendable {
    @MemberwiseInit(.public)
    public struct Alternate: Equatable, Sendable {
        @Init(label: "_")
        public var speeds: [Mode: Set<Value>] = [:]

        public subscript(_ mode: Mode) -> Set<Value>? {
            get { speeds[mode] }
            set { speeds[mode] = newValue }
        }
    }

    @MemberwiseInit(.public)
    public struct Choice: Equatable, Codable, Sendable {
        public var from: Set<Mode>
        public var amount: Int
        public var note: String? = nil
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

public enum SrdReference: Equatable, Hashable, Sendable {
    case present(Bool)
    case presentAs(String)
}

public enum Tag: Equatable, Hashable, Sendable {
    case tag(String)
    case prefixed(String, prefix: String)
}


// MARK: - Codable

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

extension IndexFile: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        entries = try container.decode([String: String].self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(entries)
    }
}

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

extension Speed.Alternate: Codable {
    typealias CodingKeys = EnumCodingKey<Speed.Mode>

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        for key in container.allKeys {
            guard let value = key.value else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Unknown speed: \(key)")
            }
            speeds[value] = try container.decodeIfPresent(Set<Speed.Value>.self, forKey: key)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for key in CodingKeys.allCases {
            try container.encodeIfPresent(speeds[key.value!], forKey: key)
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
                speeds[speed] = try container.decodeIfPresent(Value.self, forKey: CodingKeys(rawValue: speed.rawValue)!)
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
                try container.encodeIfPresent(speeds[speed], forKey: CodingKeys(rawValue: speed.rawValue)!)
            }

            try container.encodeIfPresent(canHover, forKey: .canHover)

            try container.encodeIfPresent(choose, forKey: .choose)
            try container.encodeIfPresent(alternate, forKey: .alternate)
            try container.encodeIfPresent(hidden, forKey: .hidden)
        }
    }
}

extension SrdReference: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .presentAs(value)
        } else {
            self = .present(try container.decode(Bool.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .present(let value): try container.encode(value)
        case .presentAs(let value): try container.encode(value)
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

// MARK: - String conversion

extension Page: CustomStringConvertible {
    public var description: String {
        switch self {
        case .number(let number): "\(number)"
        case .numeral(let numeral): numeral
        }
    }
}

extension Speed.Alternate: CustomDebugStringConvertible {
    public var debugDescription: String {
        String(describing: speeds)
    }
}

extension Speed: CustomDebugStringConvertible {
    public var debugDescription: String {
        if self == .varies {
            String(describing: type(of: self)) + ".varies"
        } else {
            debugDescriptionOf(
                String(describing: type(of: self)),
                names: "_", "canHover", "choose", "alternate", "hidden",
                values: speeds, canHover, choose, alternate, hidden,
            )
        }
    }
}
