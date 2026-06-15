//
//  MetaTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/25/26.
//

import Testing
@testable import FifthEdition

struct MetaCodableTests {
    @Test
    func `Meta with dependencies`() throws {
        try testCodable(json: """
                        {
                            "dependencies": {
                                "monster": [
                                    "MM",
                                    "VRGR"
                                ]
                            }
                        }
                        """,
                        value: Meta(dependencies: [.monster: ["MM", "VRGR"]]))
    }

    @Test
    func `Meta with internalCopies`() throws {
        try testCodable(json: """
                        {
                            "internalCopies": [
                                "monster",
                                "monsterFluff"
                            ]
                        }
                        """,
                        value: Meta(internalCopies: [.monster, .monsterFluff]))
    }

    @Test
    func `Meta with otherSources`() throws {
        try testCodable(json: """
                        {
                            "otherSources": {
                                "monster": {
                                    "MM": "CoS",
                                    "VRGR": "CoS"
                                }
                            }
                        }
                        """,
                        value: Meta(otherSources: [.monster: ["MM": "CoS", "VRGR": "CoS"]]))
    }
}
