//
//  Homebrew.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/5/26.
//
//  Derived from schema-template/homebrew.json
//  Version: 1.12.0

import Foundation
import MemberwiseInit

/// Homebrew.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Homebrew: Equatable, Sendable {
    /// Metadata.
    public var meta: Meta

    /// List of adventures.
    public var adventure: [Adventure] = []

    /// List of monsters.
    public var monster: [Creature] = []

    /// List of books.
    public var book: [Book] = []
}

public extension Homebrew {
    /// Homebrew Metadata.
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct Meta: Equatable, Sendable {
        /// Sources defined by the homebrew.
        public var sources: Set<Source>

        /// When the homebrew was added to the repository.
        ///
        /// Not guaranteed to be anywhere near accurate.
        public var added: Date

        /// When the homebrew was last modified.
        ///
        /// Not guaranteed to be anywhere near accurate.
        public var lastModified: Date

        /// File hash.
        ///
        /// Used to automatically update the value of ``lastModified``.
        public var lastModifiedHash: String?

        /// Dependencies.
        ///
        /// Entities from these sources can be extended/referenced in this homebrew for the given entity type.
        ///
        /// - Note: When copying classes/subclasses/class features/subclass features, the values set should consist of
        ///   class identifies matching the keys in the class index.
        public var dependencies: [Entity: Set<String>] = [:]

        /// Includes.
        ///
        /// Additional dependency sources to be included for the given entity type when using this homebrew.
        ///
        /// - Note: When copying classes/subclasses/class features/subclass features, the values set should consist of
        ///   class identifies matching the keys in the class index.
        public var includes: [Entity: Set<String>] = [:]

        /// Internal copies.
        ///
        /// Entities that are copied from within the current homebrew.
        public var internalCopies: Set<Entity> = []

        /// Whether this homebrew should be ignored by any indexer.
        public var isUnlisted: Bool = false

        /// Status of the homebrew.
        public var status: Status?

        /// Rules edition this homebrew is compatible with.
        public var edition: Edition
    }
}

public extension Homebrew.Meta {
    /// Description of a source.
    ///
    /// A source could be, for example, a homebrew PDF, book, or blog post.
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct Source: Equatable, Hashable, Sendable {
        /// Source identifier.
        public var source: String

        /// Abbreviated form of the source.
        public var abbreviation: String

        /// HTML hex color code this source should use when displayed in lists, e.g. 'ff00ff'.
        public var color: String?

        /// As ``color``, but for night mode themes.
        public var colorNight: String?

        /// Full title of the source.
        public var name: String

        /// List of authors who created the homebrew source.,
        public var authors: [String] = []

        /// List of people who contributed to converting the source to 5etools format.
        public var convertedBy: [String] = []

        /// Date of release of the source,
        public var released: Date?

        /// Source version.
        ///
        /// e.g. "1.2.3".
        public var version: String

        /// Direct link to the source, if available in web form or on a store.
        public var url: URL?

        /// Whether this is a partnered source.
        ///
        /// Usually shown under the "Partnered" section of "https://www.dndbeyond.com/sources".
        public var isPartnered: Bool = false
    }
}

public extension Homebrew.Meta {
    /// Status of the homebrew.
    enum Status: String, CaseIterable, Codable, Equatable, Hashable, Sendable {
        /// Homebrew is ready for use, and is in an internally consistent state.
        case ready

        /// Homebrew is e.g. incomplete, or partially migrated between versions of the source document(s).
        case wip

        /// Using this homebrew is inadvisable, because while it is schema-passing, it breaks clients which attempt to
        /// use it.
        case invalid

        /// Homebrew is ready for use, but that using it is inadvisable, because e.g. it has been superseded by another
        /// brew.
        case deprecated
    }
}
