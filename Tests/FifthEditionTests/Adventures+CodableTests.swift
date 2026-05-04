//
//  Adventures+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct AdventuresCodableTests {
    @Test
    func `Adventures list`() throws {
        try testCodable(
            json: """
            {
                "adventure": [
                    {
                        "name": "Lost Mine of Phandelver",
                        "id": "LMoP",
                        "source": "LMoP",
                        "group": "supplement",
                        "contents": [],
                        "level": {
                            "start": 1,
                            "end": 5
                        },
                        "published": "2014-07-15",
                        "storyline": "Starter Set"
                    }
                ]
            }
            """,
            value: Adventures(adventure: [
                Adventure(
                    name: "Lost Mine of Phandelver",
                    id: "LMoP",
                    source: "LMoP",
                    group: .supplement,
                    contents: [],
                    level: .range(1...5),
                    published: #require(DateComponents(calendar: Calendar(identifier: .iso8601),
                                                       year: 2014, month: 7, day: 15).date),
                    storyline: "Starter Set",
                ),
            ]),
        )
    }
}
