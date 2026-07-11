//
//  Types.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import MemberwiseInit

public extension Creature {
    /// Type of creature.
    ///
    /// Each creature has a type. Certain spells, magic items, class features, and other effects in the game interact in
    /// special ways with creatures of a particular type.
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct Types: Equatable, Hashable, Sendable {
        /// One or more types the creature may have.
        @Init(label: "_")
        public var types: Set<CreatureType>

        /// Tags accompanying ``type``.
        public var tags: Set<Tag> = []

        /// Human-readable text to append to ``type``.
        ///
        /// Typically used to provide human-readable text for choosing between multiple types in ``type``.
        public var note: String?

        /// Size of the individual creatures that make up a swarm.
        public var swarmSize: Size?

        /// Initialize a creature's type.
        /// - Parameters:
        ///   - type: The creature's type.
        ///   - tags: Tags accompanying ``type``.
        ///   - note: Human-readable text to append to ``type``.
        ///   - swarmSize: Size of the individual creatures that make up a swarm.
        public init(_ type: CreatureType,
                    tags: Set<Tag> = [],
                    note: String? = nil,
                    swarmSize: Size? = nil)
        {
            self.init([type], tags: tags, note: note, swarmSize: swarmSize)
        }
    }
}

extension Creature.Types: ExpressibleByArrayLiteral {
    /// Initialize ``types`` from an array literal.
    public init(arrayLiteral elements: CreatureType...) {
        self.init(Set(elements))
    }
}

public extension Creature {
    /// Creature's sidekick role.
    struct Sidekick: Equatable, Hashable, Sendable {
        /// Equivalent character's level.
        public var level: Int?

        /// Type of sidekick.
        public var type: SidekickType?

        /// Tags.
        public var tags: Set<Tag>

        /// Whether the sidekick details should be hidden.
        public var isHidden: Bool

        /// Initialize a sidekick.
        /// - Parameters:
        ///   - level: Level.
        ///   - type: Type.
        ///   - isHidden: Whether is hidden.
        public init(level: Int? = nil,
                    type: SidekickType? = nil,
                    isHidden: Bool = false)
        {
            self.level = level
            self.type = type
            tags = []
            self.isHidden = isHidden
        }

        /// Initialize a sidekick with tags.
        /// - Parameters:
        ///   - level: Level.
        ///   - type: Type.
        ///   - tags: Tags.
        ///   - isHidden: Whether is hidden.
        public init(level: Int? = nil,
                    type: SidekickType? = nil,
                    tags: Tag...,
                    isHidden: Bool = false)
        {
            self.level = level
            self.type = type
            self.tags = Set(tags)
            self.isHidden = isHidden
        }
    }
}
