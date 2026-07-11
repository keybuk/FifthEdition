//
//  Alignments.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

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

extension Creature.Alignment {
    /// Parse alignments from array of strings.
    /// - Parameters:
    ///   - strings: Strings of encoded alignment set.
    ///   - chance: Probability creature has this alignment.
    ///   - note: Human-readable text about the choice.
    public init(strings: Set<String>,
                chance: Int? = nil,
                note: String? = nil)
    {
        var order: Set<Alignment> = []
        var morality: Set<Alignment> = []
        var isNeutral = false

        for string in strings {
            switch string {
            case "L": order.formUnion(Set<Alignment>.anyLawful)
            case "NX": order.formUnion(Set<Alignment>.anyNeutralOrder)
            case "C": order.formUnion(Set<Alignment>.anyChaotic)
            case "G": morality.formUnion(Set<Alignment>.anyGood)
            case "NY": morality.formUnion(Set<Alignment>.anyNeutralMorality)
            case "E": morality.formUnion(Set<Alignment>.anyEvil)
            case "N":
                // Process neutral later.
                isNeutral = true
            case "A":
                // Fill both axes.
                order.formUnion(Set<Alignment>.any)
                morality.formUnion(Set<Alignment>.any)
            case "U":
                // Empty both axes.
                order.removeAll()
                morality.removeAll()
            default:
                // Ignore unknown alignment.
                break
            }
        }

        // "N" when it appears along with values for both axes (NX, NY usually) means "Any Neutral", when it appears
        // with values for only one axis it means neutral in the other axis, and when it appears on its own it means
        // "True Neutral".
        if isNeutral, !order.isEmpty, !morality.isEmpty {
            order.formUnion(Set<Alignment>.anyNeutralMorality)
            morality.formUnion(Set<Alignment>.anyNeutralOrder)
        }
        if isNeutral, order.isEmpty {
            order.formUnion(Set<Alignment>.anyNeutralOrder)
        }
        if isNeutral, morality.isEmpty {
            morality.formUnion(Set<Alignment>.anyNeutralMorality)
        }

        self = .alignment(order.intersection(morality), chance: chance, note: note)
    }

    /// Returns the encoded strings of the alignment set.
    var strings: Set<String> {
        switch self {
        case .alignment(.anyNeutral, _, _):
            return ["N", "NX", "NY"]
        case .alignment(.unaligned, _, _):
            return ["U"]
        case .alignment(.any, _, _):
            return ["A"]
        case let .alignment(alignments, _, _):
            var strings: Set<String> = []

            if !alignments.isDisjoint(with: .anyLawful) {
                strings.insert("L")
            }
            if !alignments.isDisjoint(with: .anyNeutralOrder) {
                if alignments.count == 1 {
                    strings.insert("N")
                } else {
                    strings.insert("NX")
                }
            }
            if !alignments.isDisjoint(with: .anyChaotic) {
                strings.insert("C")
            }

            if !alignments.isDisjoint(with: .anyGood) {
                strings.insert("G")
            }
            if !alignments.isDisjoint(with: .anyNeutralMorality) {
                if alignments.count == 1 {
                    strings.insert("N")
                } else {
                    strings.insert("NY")
                }
            }
            if !alignments.isDisjoint(with: .anyEvil) {
                strings.insert("E")
            }

            return strings
        case .special:
            return []
        }
    }
}

public extension Creature {
    /// Alignments the creature may have.
    ///
    /// A creature’s alignment broadly describes its ethical attitudes and ideals.
    struct Alignments: Equatable, Hashable, Sendable {
        /// One or more alignments the creature may have.
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

        /// Initialize creature's alignments.
        /// - Parameters:
        ///   - alignments: One or more alignments the creature may have.
        ///   - prefix: Human-readable text to prepend to ``alignment``.
        public init(_ alignments: [Alignment],
                    prefix: String? = nil)
        {
            self.alignments = alignments
            self.prefix = prefix
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
