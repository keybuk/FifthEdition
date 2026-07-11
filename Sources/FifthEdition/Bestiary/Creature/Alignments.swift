//
//  Alignments.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import MemberwiseInit

public extension Creature {
    /// Alignment.
    ///
    /// A creature’s alignment broadly describes its ethical attitudes and ideals, given in the associated value of
    /// ``alignment(_:chance:note:)``, which may be a single alignment such as ``FifthEdition/Alignment/lawfulGood`` or
    /// a set of possible alignments to choose from.
    ///
    /// Where a creature has multiple such possible choices, `chance` provides the probaility of the creature having a
    /// given alignment and `note` provides human-readable text about the choice.
    ///
    /// Special rules are given as human-readable text in the associated value of ``Alignment/special(_:)``.
    enum Alignment: Equatable, Hashable, Sendable {
        case alignment(Set<FifthEdition.Alignment>, chance: Int? = nil, note: String? = nil)
        case special(String)
    }
}

extension Creature.Alignment: ExpressibleByStringLiteral {
    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: String) {
        self = .special(value)
    }
}

public extension Creature.Alignment {
    static let lawfulGood: Self = .alignment(.lawfulGood)
    static let lawfulNeutral: Self = .alignment(.lawfulNeutral)
    static let lawfulEvil: Self = .alignment(.lawfulEvil)
    static let neutralGood: Self = .alignment(.neutralGood)
    static let neutral: Self = .alignment(.neutral)
    static let neutralEvil: Self = .alignment(.neutralEvil)
    static let chaoticGood: Self = .alignment(.chaoticGood)
    static let chaoticNeutral: Self = .alignment(.chaoticNeutral)
    static let chaoticEvil: Self = .alignment(.chaoticEvil)

    static let unaligned: Self = .alignment(.unaligned)
    static let any: Self = .alignment(.any)
    static let anyLawful: Self = .alignment(.anyLawful)
    static let anyNonLawful: Self = .alignment(.anyNonLawful)
    static let anyNeutralOrder: Self = .alignment(.anyNeutralOrder)
    static let anyChaotic: Self = .alignment(.anyChaotic)
    static let anyNonChaotic: Self = .alignment(.anyNonChaotic)
    static let anyGood: Self = .alignment(.anyGood)
    static let anyNonGood: Self = .alignment(.anyNonGood)
    static let anyNeutralMorality: Self = .alignment(.anyNeutralMorality)
    static let anyEvil: Self = .alignment(.anyEvil)
    static let anyNonEvil: Self = .alignment(.anyNonEvil)
    static let anyNeutral: Self = .alignment(.anyNeutral)
}

public extension Creature {
    /// Alignments the creature may have.
    ///
    /// A creature’s alignment broadly describes its ethical attitudes and ideals.
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct Alignments: Equatable, Hashable, Sendable {
        /// One or more alignments the creature may have.
        @Init(label: "_")
        public var alignments: [Alignment]

        /// Human-readable text to prepend to ``alignment``.
        public var prefix: String?

        /// Initialize creature's alignment.
        /// - Parameters:
        ///   - alignment: The creature's alignment.
        ///   - prefix: Human-readable text to prepend to ``alignment``.
        public init(_ alignment: Alignment,
                    prefix: String? = nil)
        {
            self.init([alignment], prefix: prefix)
        }
    }
}

extension Creature.Alignments: ExpressibleByArrayLiteral {
    /// Initialize ``alignments`` from an array literal.
    public init(arrayLiteral elements: Creature.Alignment...) {
        self.init(elements)
    }
}

public extension Creature.Alignments {
    var isEmpty: Bool {
        alignments.isEmpty
    }
}
