//
//  Edition.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/4/26.
//

import Foundation

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

/// Common ``published`` property for source books and adventures.
public protocol PublishedCorpus {
    var published: Date { get set }
}

extension Adventure: PublishedCorpus {}
extension Book: PublishedCorpus {}

/// Date of publication of the 2024 (5.5e) Players Handbook.
private let modernEditionStartDate = DateComponents(calendar: Calendar(identifier: .iso8601),
                                                    year: 2024,
                                                    month: 9,
                                                    day: 17).date!

public extension PublishedCorpus {
    /// 5th edition ruleset content applies to.
    var edition: Edition {
        published < modernEditionStartDate ? .legacy : .modern
    }
}
