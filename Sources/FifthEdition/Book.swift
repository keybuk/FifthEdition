//
//  Book.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/8/26.
//
//  Derived from schema-template/books.json
//  Version: 1.2.19

import Foundation
import MemberwiseInit

/// Published source book.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Book: Equatable, Sendable {
    /// Book name.
    public var name: String

    /// Other names the book is known by.
    ///
    /// Usually used to prefix with a collection name.
    public var alias: [String] = []

    /// Unique identifier used to reference this book.
    public var id: String

    /// Source identifier this book belongs to.
    public var source: String

    /// Source identifier of the collection this book belongs to.
    ///
    /// Used for sources which contain multiple adventures, e.g. "TftYP", or _packages_ of related books, e.g. "SAiS".
    public var parentSource: String?

    /// Whether this is a legacy book.
    public var isLegacy: Bool = false

    /// The group under which this book should be listed.
    public var group: Group

    /// Author of the book.
    public var author: String?

    /// Date of publication.
    public var published: Date

    /// Date the book was most recently revised.
    public var revised: Date?

    /// Cover image.
    ///
    /// Preferred sizes are 300 x 300px or 600 x 600px.
    public var cover: MediaHref?

    /// Table of contents.
    public var contents: [CorpusContents]
}

public extension Book {
    /// Book grouping.
    enum Group: String, CaseIterable, Codable, Sendable {
        case core
        case supplement
        case supplementAlt = "supplement-alt"
        case setting
        case settingAlt = "setting-alt"
        case prerelease
        case homebrew
        case screen
        case organizedPlay = "organized-play"
        case recipe
        case other
    }
}
