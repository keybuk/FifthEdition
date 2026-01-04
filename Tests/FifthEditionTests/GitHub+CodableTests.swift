//
//  GitHub+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct GitHubCodableTests {
    @Test("GitHubRelease is Decodable")
    func decodable() throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let releases = try decoder.decode([GitHubRelease].self, from: Data(contentsOf: url))
        let release = try #require(releases.first, "Missing release")
        #expect(release.name == "v1.0.0")

        let asset = try #require(release.assets.first, "Missing asset")
        #expect(asset.name == "example.zip")
    }

    @Test("GitHubRelease is Codable")
    func codable() throws {
        // Test this separately since we won't care how Date is encoded internally.
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let expectedValue = try decoder.decode([GitHubRelease].self, from: Data(contentsOf: url))

        let encodedJson = try #require(String(data: JSONEncoder().encode(expectedValue), encoding: .utf8))
        let decodedValue = try JSONDecoder().decode(
            [GitHubRelease].self,
            from: #require(encodedJson.data(using: .utf8)),
        )
        #expect(decodedValue == expectedValue)
    }
}
