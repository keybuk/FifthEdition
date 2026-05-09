//
//  Corpus.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//
//  Derived from schema-template/corpus-shared.json
//  Version: 1.0.1

import MemberwiseInit

/// Table of contents.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct CorpusContents: Equatable, Sendable {
    /// Name of the chapter.
    @Init(label: "_")
    public var name: String

    /// Type and ordinal of chapter.
    public var ordinal: Ordinal?

    /// Headings within the chapter.
    public var headers: [Header] = []
}

public extension CorpusContents {
    /// Chapter header.
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct Header: Equatable, Sendable {
        /// Header title.
        @Init(label: "_")
        public var header: String

        /// Depth of header within chapter..
        public var depth: Int?

        /// Relative index.
        ///
        /// The relative index of this header in the current chapter, i.e. if "Treasure" appears twice and you wish the
        /// contents entry to link to the second instance, set the "index" to 1.
        public var index: Int?
    }
}

public extension CorpusContents {
    /// Chapter type and ordinal.
    enum Ordinal: Equatable, Sendable {
        case chapter(Identifier? = nil)
        case appendix(Identifier? = nil)
        case part(Identifier? = nil)
        case episode(Identifier? = nil)
        case level(Identifier? = nil)
        case section(Identifier? = nil)
    }
}

public extension CorpusContents.Ordinal {
    /// Chapter ordinal identifier.
    enum Identifier: Equatable, Sendable {
        case integer(Int)
        case string(String)
    }
}
