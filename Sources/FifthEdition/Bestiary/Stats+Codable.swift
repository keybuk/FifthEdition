//
//  Stats+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/19/26.
//

extension ArmorClass: Codable {
    enum CodingKeys: String, CodingKey {
        case ac
        case from
        case condition
        case inParens = "braces"
        case special
    }

    public init(from decoder: any Decoder) throws {
        // Value is an integer, or an object, or a special object.
        if let ac = try? decoder.singleValueContainer().decode(Int.self) {
            self = .ac(ac)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let special = try container.decodeIfPresent(String.self, forKey: .special) {
                self = .special(special)
            } else {
                self = try .ac(container.decode(Int.self, forKey: .ac),
                               from: container.decodeIfPresent([String].self, forKey: .from),
                               condition: container.decodeIfPresent(String.self, forKey: .condition),
                               inParens: container.decodeIfPresent(Bool.self, forKey: .inParens) ?? false)
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .ac(ac, nil, nil, false):
            var container = encoder.singleValueContainer()
            try container.encode(ac)
        case let .ac(ac, from, condition, inParens):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ac, forKey: .ac)
            try container.encodeIfPresent(from, forKey: .from)
            try container.encodeIfPresent(condition, forKey: .condition)
            try container.encodeIfPresent(inParens ? true : nil, forKey: .inParens)
        case let .special(special):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(special, forKey: .special)
        }
    }
}

extension HitPoints: Codable {
    enum CodingKeys: String, CodingKey {
        case average
        case formula
        case special
    }

    public init(from decoder: any Decoder) throws {
        // Value is an object with the formula field parsed into a DiceNotation, or a special object,
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let special = try container.decodeIfPresent(String.self, forKey: .special) {
            self = .special(special)
        } else {
            let formula = try container.decode(String.self, forKey: .formula)
            let average = try container.decode(Int.self, forKey: .average)

            if let notation = DiceNotation(string: formula) {
                self = .hp(notation, given: average != notation.average ? average : nil)
            } else {
                self = .other(average, formula: formula)
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .hp(notation, given):
            try container.encode(notation, forKey: .formula)
            try container.encode(given ?? notation.average, forKey: .average)
        case let .other(average, formula):
            try container.encode(formula, forKey: .formula)
            try container.encode(average, forKey: .average)
        case let .special(special):
            try container.encode(special, forKey: .special)
        }
    }
}

extension Speed: Codable {
    enum CodingKeys: String, CodingKey {
        case number
        case condition
    }

    public init(from decoder: any Decoder) throws {
        // Value is true, an integer, or an object.
        if let value = try? decoder.singleValueContainer().decode(Bool.self), value {
            self = .walkingSpeed
        } else if let speed = try? decoder.singleValueContainer().decode(Int.self) {
            self = .speed(speed)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self = try .speed(container.decode(Int.self, forKey: .number),
                              condition: container.decodeIfPresent(String.self, forKey: .condition))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case let .speed(speed, nil):
            var container = encoder.singleValueContainer()
            try container.encode(speed)
        case let .speed(speed, condition):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(speed, forKey: .number)
            try container.encodeIfPresent(condition, forKey: .condition)
        case .walkingSpeed:
            var container = encoder.singleValueContainer()
            try container.encode(true)
        }
    }
}
