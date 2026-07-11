//
//  Sizes.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import MemberwiseInit

public extension Creature {
    /// Size of creature.
    ///
    /// A creature's size determines the area on a map that it effectively controls in combat and the area it needs to
    /// fight
    /// effectively.
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct Sizes: Equatable, Hashable, Sendable {
        /// One or more size the creature may have.
        @Init(label: "_")
        public var sizes: Set<Size>

        /// Human-readable text appended to ``size``.
        ///
        /// Typically used to provide human-readable text for choosing between multiple sizes in ``size``.
        public var note: String?

        /// Initialize a creature's size.
        /// - Parameters:
        ///   - size: The creature's size.
        ///   - note: Human-readable text appended to ``size``.
        public init(_ size: Size,
                    note: String? = nil)
        {
            self.init([size], note: note)
        }
    }
}

extension Creature.Sizes: ExpressibleByArrayLiteral {
    /// Initialize ``sizes`` from an array literal.
    public init(arrayLiteral elements: Size...) {
        self.init(Set(elements))
    }
}
