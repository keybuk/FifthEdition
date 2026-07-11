//
//  Corpus.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import MemberwiseInit

/// Table of contents.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct CorpusContents: Equatable, Sendable {
    /// Name of the entry in the table of contents.
    @Init(label: "_")
    public var name: String

    /// Type and ordinal of the entry.
    public var ordinal: CorpusOrdinal?

    /// Headings within the entry.
    public var headers: [CorpusHeader] = []
}

/// Sub-headings of the table of contents
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct CorpusHeader: Equatable, Sendable {
    /// Heading.
    @Init(label: "_")
    public var header: String

    /// Depth of heading.
    public var depth: Int?

    /// Relative index of heading.
    ///
    /// For example, if there are two `"Treasure"` headings with a table of contents entry, and you wish the entry to
    /// link to the second instance, set ``index`` to `1`.
    public var index: Int?
}

extension CorpusHeader: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Type and ordinal of an entry in the table of contents.
public enum CorpusOrdinal: Equatable, Sendable {
    case chapter(Ordinal? = nil)
    case appendix(Ordinal? = nil)
    case part(Ordinal? = nil)
    case episode(Ordinal? = nil)
    case level(Ordinal? = nil)
    case section(Ordinal? = nil)
}

/// D&D edition.
///
/// Identifies the 5th edition ruleset that a given entity is written for, either the ``legacy`` 5e (2014) rules, or the
/// ``modern`` 5.5e (2024) rules.
public enum Edition: String, CaseIterable, Codable, Sendable {
    /// 5e (2014) rules.
    case legacy = "classic"

    /// 5.5e (2014) rules.
    case modern = "one"

    /// Alias for the ``legacy`` 5e (2014) edition, as used in the 5etools schema.
    public static let classic = Edition.legacy

    /// Alias for the ``modern`` 5.5e (2024) edition, as used in the 5etools schema.
    public static let one = Edition.modern
}
