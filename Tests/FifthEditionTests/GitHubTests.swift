//
//  GitHubTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct GitHubTests {

    @Test("GitHubRelease is Decodable")
    func decodable() throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let releases = try decoder.decode([GitHubRelease].self, from: try Data(contentsOf: url))
        let release = try #require(releases.first, "Missing release")
        #expect(release.name == "v1.0.0")

        let asset = try #require(release.assets.first, "Missing asset")
        #expect(asset.name == "example.zip")
    }

    @Test("Construct API URL")
    func releasesURL() throws {
        let url = GitHubRelease.urlFor(owner: "octocat", name: "Hello-World")
        #expect(url == URL(string: "https://api.github.com/repos/octocat/Hello-World/releases")!)
    }

    @Test("Obtain releases from API")
    func releasesFrom() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases.first, "Missing release")
        #expect(release.name == "v1.0.0")

        let asset = try #require(release.assets.first, "Missing asset")
        #expect(asset.name == "example.zip")
    }

    @Test("Latest release from collection")
    func latest() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases.latest)
        #expect(release.name == "v1.0.0")
    }

    @Test("Named release from collection")
    func nameSubscript() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases[name: "v1.0.0"])
        #expect(release.name == "v1.0.0")

        #expect(releases[name: "v2.0.0"] == nil)
    }

    @Test("Asset of content type from collection")
    func contentTypeSubscript() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases[name: "v1.0.0"])

        let asset = try #require(release.assets[contentType: "application/zip"])
        #expect(asset.name == "example.zip")

        #expect(release.assets[contentType: "image/png"] == nil)
    }

}
