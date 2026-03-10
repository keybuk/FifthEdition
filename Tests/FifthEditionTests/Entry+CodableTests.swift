//
//  Entry+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct MediaHrefCodableTests {
    @Test
    func `Internal path`() throws {
        try testCodable(
            json: """
            {
                "type": "internal",
                "path": "bestiary/aboleth.mp3"
            }
            """,
            value: MediaHref.path("bestiary/aboleth.mp3"),
        )
    }

    @Test
    func `Internal path without type`() throws {
        try testCodable(
            json: """
            {
                "path": "bestiary/aboleth.mp3"
            }
            """,
            value: MediaHref.path("bestiary/aboleth.mp3"),
        )
    }

    @Test
    func `External URL`() throws {
        try testCodable(
            json: """
            {
                "type": "external",
                "url": "https://5e.tools/bestiary/aboleth.mp3"
            }
            """,
            value: MediaHref.url(
                #require(URL(string: "https://5e.tools/bestiary/aboleth.mp3")),
            ),
        )
    }

    @Test
    func `External URL without type`() throws {
        try testCodable(
            json: """
            {
                "url": "https://5e.tools/bestiary/aboleth.mp3"
            }
            """,
            value: MediaHref.url(
                #require(URL(string: "https://5e.tools/bestiary/aboleth.mp3")),
            ),
        )
    }
}
