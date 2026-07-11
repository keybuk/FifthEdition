//
//  Tools.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Tools.
    ///
    /// If a creature has proficiency with a tool, it can add its Proficiency Bonus to any ability check made using the
    /// tool. The ``AbilityModifier`` for any such checks the creature can make is provided here.
    struct Tools: Equatable, Hashable, Sendable {
        /// Tool proficiency modifiers.
        public var tools: [Tool: AbilityModifier]

        /// Initialize tools.
        public init(_ tools: [Tool: AbilityModifier]) {
            self.tools = tools
        }
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
