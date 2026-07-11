//
//  Speeds.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Speeds.
    ///
    /// On its turn, a creature can move a distance equal to its Speed or less. These different modes of movement can be
    /// combined, or they can constitute its entire move.
    ///
    /// For convenience, ``init(integerLiteral:)`` permits walking speed to be specified as an integer literal.
    struct Speeds: Equatable, Hashable, Sendable {
        /// Speeds.
        ///
        /// Provides one or more ``Speed`` for each mode of ``Movement`` the creature may use.
        public var speeds: [Movement: [Speed]] = [:]

        /// Additional movement types that can be chosen.
        public var chooseMovement: Set<Movement> = []

        /// Speed for ``chooseMovement``.
        public var choiceSpeed: Speed?

        /// Whether the creature can hover.
        public var canHover: Bool = false

        /// Speeds that should be hidden.
        public var hidden: Set<Movement> = []

        /// Initialize speeds.
        /// - Parameters:
        ///   - speeds: Speeds.
        ///   - canHover: Whether the creature can hover.
        ///   - hidden: Speeds that should be hidden.
        public init(_ speeds: [Movement: [Speed]],
                    canHover: Bool = false,
                    hidden: Set<Movement> = [])
        {
            self.speeds = speeds
            self.canHover = canHover
            self.hidden = hidden
        }

        /// Initialize speeds with a choice.
        /// - Parameters:
        ///   - speeds: Speeds
        ///   - movement: Additional movement types that can be chosen.
        ///   - speed: Speed for `movement` choice.
        ///   - note: Human-readable text concerning `movement` choice.
        ///   - canHover: Whether the creature can hover.
        ///   - hidden: Speeds that should be hidden.
        public init(_ speeds: [Movement: [Speed]] = [:],
                    choose movement: Set<Movement>,
                    speed: Int,
                    note: String? = nil,
                    canHover: Bool = false,
                    hidden: Set<Movement> = [])
        {
            self.speeds = speeds
            chooseMovement = movement
            choiceSpeed = .speed(speed, condition: note)
            self.canHover = canHover
            self.hidden = hidden
        }
    }
}

extension Creature.Speeds: ExpressibleByDictionaryLiteral, ExpressibleByIntegerLiteral {
    /// Initialize walking speed from an integer literal.
    public init(integerLiteral value: Int) {
        self.init([.walk: [.speed(value)]])
    }

    /// Initialize ``speeds`` from a dictionary literal.
    public init(dictionaryLiteral elements: (Movement, [Speed])...) {
        self.init(Dictionary(uniqueKeysWithValues: elements))
    }
}

public extension Creature.Speeds {
    var isEmpty: Bool {
        Set(speeds.keys).subtracting(hidden).isEmpty && chooseMovement.isEmpty
    }

    subscript(key: Movement) -> [Speed]? {
        speeds[key]
    }
}
