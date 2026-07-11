//
//  Alignments.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Alignments the creature may have.
    struct Alignment: Equatable, Hashable, Sendable {
        /// One or more alignments the creature may have.
        public var alignment: [Alignment]

        /// Human-readable text to prepend to ``alignment``.
        public var prefix: String?

        /// Initialize creature's alignment.
        /// - Parameters:
        ///   - alignment: The creature's alignment'.
        ///   - prefix: Human-readable text to prepend to ``alignment``.
        public init(_ alignment: Alignment,
                    prefix: String? = nil)
        {
            self.init([alignment], prefix: prefix)
        }

        /// Initialize creature's alignments.
        /// - Parameters:
        ///   - alignments: One or more alignments the creature may have.
        ///   - prefix: Human-readable text to prepend to ``alignment``.
        public init(_ alignments: [Alignment],
                    prefix: String? = nil)
        {
            alignment = alignments
            self.prefix = prefix
        }
    }
}

extension Creature.Alignment: ExpressibleByArrayLiteral {
    /// Initialize ``alignment`` from an array literal.
    public init(arrayLiteral elements: Alignment...) {
        self.init(elements)
    }
}

public extension Creature.Alignment {
    var isEmpty: Bool {
        alignment.isEmpty
    }
}

public extension Creature.Alignment {
    /// Alignment.
    ///
    /// A creature’s alignment broadly describes its ethical attitudes and ideals.
    ///
    /// A creature may have one or more possible alignments, represented by ``alignment(_:chance:note:)``, where the
    /// associated value provides either a single alignment such as ``Alignment/lawfulGood`` or a broader set such as
    /// ``Alignment/anyLawful``. Where multiple options are available, the `chance` value provide the probability
    /// distribution amongst all creatures of the type, and `note` provides human-readable text for selecting.
    ///
    /// Special rules are given as human-readable text in the associated value of ``special(_:)``.
    enum Alignment: Equatable, Hashable, Sendable {
        case alignment(FifthEdition.Alignment, chance: Int? = nil, note: String? = nil)
        case special(String)
    }
}

public extension Creature.Alignment.Alignment {
    static let unaligned: Self = .alignment(.unaligned)
    static let any: Self = .alignment(.any)

    static let lawful: Self = .alignment(.lawful)
    static let chaotic: Self = .alignment(.chaotic)
    static let neutral: Self = .alignment(.neutral)
    static let good: Self = .alignment(.good)
    static let evil: Self = .alignment(.evil)

    static let lawfulGood: Self = .alignment(.lawfulGood)
    static let lawfulNeutral: Self = .alignment(.lawfulNeutral)
    static let lawfulEvil: Self = .alignment(.lawfulEvil)
    static let neutralGood: Self = .alignment(.neutralGood)
    static let neutralEvil: Self = .alignment(.neutralEvil)
    static let chaoticGood: Self = .alignment(.chaoticGood)
    static let chaoticNeutral: Self = .alignment(.chaoticNeutral)
    static let chaoticEvil: Self = .alignment(.chaoticEvil)

    static let anyNeutral: Self = .alignment(.anyNeutral)
    static let anyLawful: Self = .alignment(.anyLawful)
    static let anyChaotic: Self = .alignment(.anyChaotic)
    static let anyGood: Self = .alignment(.anyGood)
    static let anyEvil: Self = .alignment(.anyEvil)
    static let anyNonLawful: Self = .alignment(.anyNonLawful)
    static let anyNonChaotic: Self = .alignment(.anyNonChaotic)
    static let anyNonGood: Self = .alignment(.anyNonGood)
    static let anyNonEvil: Self = .alignment(.anyNonEvil)
}

extension Creature.Alignment.Alignment: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .special(value)
    }
}
