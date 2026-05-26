//
//  Corpus+Published.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Foundation

/// Common ``published`` property for source books and adventures.
public protocol PublishedCorpus {
    var published: Date { get set }
}

extension Adventure: PublishedCorpus {}
extension Book: PublishedCorpus {}

/// Date of publication of the 2024 (5.5e) Players Handbook.
private let modernEditionStartDate = DateComponents(calendar: Calendar(identifier: .iso8601),
                                                    year: 2024, month: 9, day: 17).date!

public extension PublishedCorpus {
    /// 5th edition ruleset content applies to.
    var edition: Edition {
        published < modernEditionStartDate ? .legacy : .modern
    }
}
