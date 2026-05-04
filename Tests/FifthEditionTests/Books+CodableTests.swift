//
//  Books+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct BooksCodableTests {
    @Test
    func `Books list`() throws {
        try testCodable(
            json: """
            {
                "book": [
                    {
                        "name": "Player's Handbook",
                        "id": "PHB",
                        "source": "PHB",
                        "group": "core",
                        "published": "2014-08-19",
                        "contents": []
                    }
                ]
            }
            """,
            value: Books(book: [
                Book(
                    name: "Player's Handbook",
                    id: "PHB",
                    source: "PHB",
                    group: .core,
                    published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                       year: 2014, month: 8, day: 19).date),
                    contents: [],
                ),
            ]),
        )
    }
}
