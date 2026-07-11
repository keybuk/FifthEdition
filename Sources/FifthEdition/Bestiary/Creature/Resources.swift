//
//  Resources.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 8/22/26.
//

public extension Creature {
    /// Expendable resources.
    struct Resources: Equatable, Hashable, Sendable {
        /// Iniitial resource values.
        public var resources: [String: Resource]

        /// Initialize resources.
        public init(_ resources: [String: Resource]) {
            self.resources = resources
        }
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
