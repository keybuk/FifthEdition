//
//  Resources.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 8/22/26.
//

import MemberwiseInit

public extension Creature {
    /// Expendable resources.
    @MemberwiseInit(.public)
    struct Resources: Equatable, Hashable, Sendable {
        /// Iniitial resource values.
        @Init(label: "_")
        public var resources: [String: Resource]
    }
}

extension Creature.Resources: ExpressibleByDictionaryLiteral {
    /// Initialize ``resources`` from a dictionary literal.
    public init(dictionaryLiteral elements: (String, Resource)...) {
        self.init(Dictionary(uniqueKeysWithValues: elements))
    }
}

public extension Creature.Resources {
    var isEmpty: Bool {
        resources.isEmpty
    }

    subscript(key: String) -> Resource? {
        resources[key]
    }
}
