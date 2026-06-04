//
//  Book.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/8/26.
//
//  Implements schema-template/books.json
//  Version: 1.2.19

import Foundation
import MemberwiseInit

/// Information about a published source book.
///
/// ## Parsing
/// The collection of published source book information in the 5etools data is obtained by parsing ``Books`` and
/// iterating the ``Books/book`` collection.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Book: Equatable, Sendable {
    /// Name of the book.
    public var name: String

    /// Other names the book is known by.
    ///
    /// Usually used to prefix with a collection name, for example:
    /// - ``name``: `"Astral Adventurer's Guide"`
    /// - ``alias``: `["Spelljammer: Astral Adventurer's Guide"]`
    ///
    /// Also sometimes used to provide the collection name, for example:
    /// - ``name``: `"Sigil and the Outlands"`
    /// - ``alias``: `["Planescape: Adventures in the Multiverse"]`
    public var alias: [String] = []

    /// Unique identifier used to reference this book in links.
    ///
    /// Usually identical to ``source`` with a few exceptions for legacy data reaons.
    public var id: String

    /// Source identifier this book belongs to.
    public var source: String

    /// Source identifier of the collection this book belongs to.
    ///
    /// Used for _packages_ of related books, e.g. `"SAiS"`.
    public var parentSource: String?

    /// Kind of publication, used for grouping.
    public var group: BookGroup

    /// Date of publication.
    public var published: Date

    /// Date of most recent revision.
    public var revised: Date?

    /// Author name.
    public var author: String?

    /// Cover image.
    ///
    /// Preferred sizes are 300 × 300px or 600 × 600px.
    public var cover: MediaHref?

    /// Table of contents.
    public var contents: [CorpusContents] = []
}
