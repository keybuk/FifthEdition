//
//  Adventure.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//
//  Implements schema-template/adventures.json
//  Version: 1.10.35

import Foundation
import MemberwiseInit

/// Information about a published adventure.
///
/// ## Parsing
/// The collection of published adventure information in the 5etools data is obtained by parsing ``Adventures`` and
/// iterating the ``Adventures/adventure`` collection.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Adventure: Equatable, Sendable {
    /// Name of the adventure.
    public var name: String

    /// Other names the adventure is known by.
    ///
    /// Usually used to prefix with a collection name, for example:
    /// - ``name``: `"Light of Xaryxis"`
    /// - ``alias``: `["Spelljammer: Light of Xaryxis"]`
    ///
    /// Also sometimes used to provide the collection name, for example:
    /// - ``name``: `"Turn of Fortune's Wheel"`
    /// - ``alias``: `["Planescape: Adventures in the Multiverse"]`
    public var alias: [String] = []

    /// Unique identifier used to reference this adventure in links.
    ///
    /// This is distinct from ``source`` since a single source might contain multiple adventures.
    public var id: String

    /// Source identifier this adventure belongs to.
    public var source: String

    /// Source identifier of the collection this adventure belongs to.
    ///
    /// Used for sources which contain multiple adventures, e.g. `"TftYP"`.
    public var parentSource: String?

    /// Kind of publication, used for grouping.
    public var group: AdventureGroup

    /// Date of publication.
    public var published: Date

    /// Date of most recent revision.
    public var revised: Date?

    /// Sorting order within a single source.
    public var publishedOrder: Int?

    /// Author name.
    public var author: String?

    /// Range of character levels players will play through.
    public var level: AdventureLevel

    /// Adventurers League average player level.
    ///
    /// - Note: For use in homebrew.
    public var alAveragePlayerLevel: Int?

    /// Adventurers League length in hours.
    ///
    /// - Note: For use in homebrew.
    public var alLength: ClosedRange<Int>?

    /// Adventurers League identifier.
    ///
    /// - Note: For use in homebrew.
    public var alId: String?

    /// Name of the storyline common to one or more adventures.
    public var storyline: String

    /// Cover image.
    ///
    /// Preferred sizes are 300 × 300px or 600 × 600px.
    public var cover: MediaHref?

    /// Table of contents.
    public var contents: [CorpusContents] = []
}

/// Kinds of adventure publications, used for grouping.
public enum AdventureGroup: String, CaseIterable, Codable, Sendable {
    case supplement
    case supplementAlt = "supplement-alt"
    case prerelease
    case homebrew
    case organizedPlay = "organized-play"
    case other
}

/// Character levels that the adventure ranges across.
public enum AdventureLevel: Equatable, Sendable {
    case range(ClosedRange<Int>)
    case special(String)
}

extension AdventureLevel: CustomStringConvertible, ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .special(value)
    }

    public var description: String {
        switch self {
        case let .range(range): "\(range.lowerBound)–\(range.upperBound)"
        case let .special(special): special
        }
    }
}
