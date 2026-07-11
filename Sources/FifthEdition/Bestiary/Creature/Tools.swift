//
//  Tools.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import MemberwiseInit

public extension Creature {
    /// Tools.
    ///
    /// If a creature has proficiency with a tool, it can add its Proficiency Bonus to any ability check made using the
    /// tool. The ``AbilityModifier`` for any such checks the creature can make is provided here.
    @MemberwiseInit(.public)
    struct Tools: Equatable, Hashable, Sendable {
        /// Tool proficiency modifiers.
        @Init(label: "_")
        public var tools: [Tool: AbilityModifier]
    }
}

extension Creature.Tools: ExpressibleByDictionaryLiteral {
    /// Initialize ``tools`` from a dictionary literal.
    public init(dictionaryLiteral elements: (Tool, AbilityModifier)...) {
        self.init(Dictionary(uniqueKeysWithValues: elements))
    }
}

public extension Creature.Tools {
    var isEmpty: Bool {
        tools.isEmpty
    }

    subscript(key: Tool) -> AbilityModifier? {
        tools[key]
    }
}
