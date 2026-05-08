//
//  Corpus+Properties.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

import Foundation

/// Common ``published`` property for books/adventures.
public protocol PublishedCorpus {
    var published: Date { get set }
}

extension Adventure: PublishedCorpus {}
extension Book: PublishedCorpus {}

private let modernEditionStartDate = DateComponents(calendar: Calendar(identifier: .iso8601),
                                                    year: 2024, month: 9, day: 17).date!

public extension PublishedCorpus {
    /// Edition that this book/adventure belongs to.
    var edition: Edition {
        published < modernEditionStartDate ? .legacy : .modern
    }
}
