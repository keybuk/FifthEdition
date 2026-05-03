//
//  Adventure.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//
//  Derived from schema-template/adventures.json
//  Version: 1.10.34

import Foundation
import MemberwiseInit

/// Published adventure.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Adventure: Equatable, Sendable {
    /// Adventure name.
    public var name: String

    /// Other names the adventure is known by.
    ///
    /// Usually used to prefix with a collection name.
    public var alias: [String] = []

    /// Unique identifier used to reference this adventure.
    public var id: String

    /// Source identifier this adventure belongs to.
    public var source: String

    /// Source identifier of the collection this adventure belongs to.
    ///
    /// Used for sources which contain multiple adventures, e.g. "TftYP", or _packages_ of related books, e.g. "SAiS".
    public var parentSource: String?

    /// The group under which this adventure should be listed.
    public var group: Group

    /// Author of the adventure.
    public var author: String?

    /// Table of contents.
    public var contents: [CorpusContents]

    /// The character levels that the adventure ranges across.
    public var level: Level

    /// Date of publication.
    public var published: Date

    /// Date the adventure was most recently revised.
    public var revised: Date?

    /// Sorting order for adventures within a single source.
    public var publishedOrder: Int?

    /// Cover image.
    ///
    /// Preferred sizes are 300 x 300px or 600 x 600px.
    public var cover: MediaHref?

    /// Storyline to which this adventure belongs.
    public var storyline: String
}

public extension Adventure {
    /// Adventure grouping.
    enum Group: String, CaseIterable, Codable, Sendable {
        case supplement
        case supplementAlt = "supplement-alt"
        case prerelease
        case homebrew
        case organizedPlay = "organized-play"
        case other
    }
}

public extension Adventure {
    /// Character levels that the adventure ranges across.
    enum Level: Equatable, Sendable {
        case range(ClosedRange<Int>)
        case custom(String)
    }
}
