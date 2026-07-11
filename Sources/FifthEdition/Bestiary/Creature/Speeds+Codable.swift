//
//  Speeds+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

extension Creature.Speeds: Codable {
    enum CodingKeys: String, CodingKey {
        case canHover
        case choose
        case alternate
    }

    enum ChooseCodingKeys: String, CodingKey {
        case from
        case amount
        case note
    }

    public init(from decoder: any Decoder) throws {
        // Value is an integer, or an object.
        if let value = try? decoder.singleValueContainer().decode(Int.self) {
            speeds[.walk] = [.speed(value)]
        } else {
            let container = try decoder.container(keyedBy: DynamicCodingKey.self)
            speeds = [:]
            for codingKey in container.allKeys {
                if let movement = Movement(codingKey: codingKey) {
                    try speeds[movement, default: []].insert(container.decode(Speed.self, forKey: codingKey), at: 0)
                } else if codingKey.stringValue == CodingKeys.canHover.stringValue,
                          try container.decode(Bool.self, forKey: codingKey) == true
                {
                    canHover = true
                } else if codingKey.stringValue == CodingKeys.choose.stringValue {
                    let nestedContainer = try container.nestedContainer(
                        keyedBy: ChooseCodingKeys.self,
                        forKey: codingKey,
                    )
                    chooseMovement = try nestedContainer.decode(Set<Movement>.self, forKey: .from)
                    choiceSpeed = try .speed(nestedContainer.decode(Int.self, forKey: .amount),
                                             condition: nestedContainer.decodeIfPresent(String.self, forKey: .note))
                } else if codingKey.stringValue == CodingKeys.alternate.stringValue {
                    for (movement, alternates) in try container.decode([Movement: [Speed]].self, forKey: codingKey) {
                        speeds[movement, default: []].append(contentsOf: alternates)
                    }
                }
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        var alternate: [Movement: [Speed]] = [:]
        for (movement, speed) in speeds {
            try container.encode(speed[0], forKey: DynamicCodingKey(stringValue: movement.codingKey.stringValue))
            if speed.count > 1 {
                alternate[movement, default: []].append(contentsOf: speed.dropFirst())
            }
        }
        try container.encodeIfPresent(
            !alternate.isEmpty ? alternate : nil,
            forKey: DynamicCodingKey(stringValue: CodingKeys.alternate.stringValue),
        )
        try container.encodeIfPresent(
            canHover ? true : nil,
            forKey: DynamicCodingKey(stringValue: CodingKeys.canHover.stringValue),
        )

        if !chooseMovement.isEmpty, case let .speed(speed, note) = choiceSpeed {
            var nestedContainer = container.nestedContainer(
                keyedBy: ChooseCodingKeys.self,
                forKey: DynamicCodingKey(stringValue: CodingKeys.choose.stringValue),
            )
            try nestedContainer.encode(chooseMovement, forKey: .from)
            try nestedContainer.encode(speed, forKey: .amount)
            try nestedContainer.encodeIfPresent(note, forKey: .note)
        }
    }
}
