//
//  EntryTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/3/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct MediaHrefStringTests {
    @Test
    func `description for path`() {
        #expect(String(describing: MediaHref.path("image/test.webp")) == "image/test.webp")
    }

    @Test
    func `description for url`() throws {
        let url = try #require(URL(string: "https://netsplit.com/materialplane/"))
        #expect(String(describing: MediaHref.url(url)) == url.absoluteString)
    }
}
