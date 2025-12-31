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

    @Test("Internal path")
    func internalPath() throws {
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

    @Test("Internal path without type")
    func internalPathOnly() throws {
        try testCodable(
            json: """
            {
                "path": "bestiary/aboleth.mp3"
            }
            """,
            value: MediaHref.path("bestiary/aboleth.mp3"),
        )
    }

    @Test("External URL")
    func externalURL() throws {
        try testCodable(
            json: """
            {
                "type": "external",
                "url": "https://5e.tools/bestiary/aboleth.mp3"
            }
            """,
            value: MediaHref.url(
                URL(string: "https://5e.tools/bestiary/aboleth.mp3")!
            ),
        )
    }

    @Test("External URL without type")
    func externalURLOnly() throws {
        try testCodable(
            json: """
            {
                "url": "https://5e.tools/bestiary/aboleth.mp3"
            }
            """,
            value: MediaHref.url(
                URL(string: "https://5e.tools/bestiary/aboleth.mp3")!
            ),
        )
    }

}
