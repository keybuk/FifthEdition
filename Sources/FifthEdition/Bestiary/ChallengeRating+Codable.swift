//
//  ChallengeRating+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/26/26.
//

extension ChallengeRating: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string that we parse into a CR, or a special string.
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        if let cr = Int(stringValue) {
            self = .cr(Double(cr))
        } else if stringValue == "1/8" {
            self = .cr(1 / 8)
        } else if stringValue == "1/4" {
            self = .cr(1 / 4)
        } else if stringValue == "1/2" {
            self = .cr(1 / 2)
        } else {
            self = .special(stringValue)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .cr(1 / 4): try container.encode("1/4")
        case .cr(1 / 8): try container.encode("1/8")
        case .cr(1 / 2): try container.encode("1/2")
        case let .cr(cr): try container.encode("\(Int(cr))")
        case let .special(special): try container.encode(special)
        }
    }
}

extension ExperiencePoints: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is an XP integer.
        self = try .xp(decoder.singleValueContainer().decode(Int.self))
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .xp(xp): try container.encode(xp)
        }
    }
}

extension ProficiencyBonus: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is a string that may be parsed as an integer bonus or a special string.
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        if let bonus = Int(stringValue) {
            self = .bonus(bonus)
        } else {
            self = .special(stringValue)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .bonus(bonus): try container.encode(bonus.formatted(.number.sign(strategy: .always())))
        case let .special(special): try container.encode(special)
        }
    }
}
