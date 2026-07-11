//
//  Sizes.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Size of creature.
    ///
    /// A creature's size determines the area on a map that it effectively controls in combat and the area it needs to
    /// fight
    /// effectively.
    struct Sizes: Equatable, Hashable, Sendable {
        /// One or more size the creature may have.
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

        /// Initialize creature's sizes.
        /// - Parameters:
        ///   - sizes: One or more size the creature may have.
        ///   - note: Human-readable text appended to ``size``.
        public init(_ sizes: Set<Size>,
                    note: String? = nil)
        {
            self.sizes = sizes
            self.note = note
        }
    }
}

extension Creature.Sizes: ExpressibleByArrayLiteral {
    /// Initialize ``sizes`` from an array literal.
    public init(arrayLiteral elements: Size...) {
        self.init(Set(elements))
    }
}
