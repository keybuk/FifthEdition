//
//  Source+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/4/26.
//

extension Page: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is an integer or string.
        let container = try decoder.singleValueContainer()
        if let number = try? container.decode(Int.self) {
            self = .number(number)
        } else {
            self = try .numeral(container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .number(number): try container.encode(number)
        case let .numeral(numeral): try container.encode(numeral)
        }
    }
}

extension Reference: Codable {
    public init(from decoder: any Decoder) throws {
        // Value is true or a string.
        let container = try decoder.singleValueContainer()
        if let present = try? container.decode(Bool.self), present {
            self = .present
        } else {
            self = try .presentAs(container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .present: try container.encode(true)
        case let .presentAs(presentAs): try container.encode(presentAs)
        }
    }
}

extension Reprint: Codable {
    enum CodingKeys: String, CodingKey {
        case uid
        case entity = "tag"
        case edition
    }

    public init(from decoder: any Decoder) throws {
        // Value is a string in uid form, or an object.
        if let uid = try? decoder.singleValueContainer().decode(String.self) {
            self.init(uid: uid)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            try self.init(uid: container.decode(String.self, forKey: .uid),
                          entity: container.decodeIfPresent(Entity.self, forKey: .entity),
                          edition: container.decodeIfPresent(Edition.self, forKey: .edition))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if entity == nil, edition == nil {
            var container = encoder.singleValueContainer()
            try container.encode(uid)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(uid, forKey: .uid)
            try container.encodeIfPresent(entity, forKey: .entity)
            try container.encodeIfPresent(edition, forKey: .edition)
        }
    }
}
