//
//  GitHub+ZipTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 1/1/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct GitHubZipTests {

    @Test("Obtain ZIP asset from release")
    func zipAssetFrom() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases.first, "Missing release")

        let asset = try #require(release.zipAsset)
        #expect(asset.name == "example.zip")
    }

    @Test("Obtain ZIP part assets from release")
    func zipPartAssetsFrom() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        var release = try #require(releases.first, "Missing release")

        var extraAsset = try #require(release.assets.first)
        extraAsset.name = "example.z01"
        extraAsset.contentType = "application/octet-stream"
        release.assets.append(extraAsset)

        let assets = release.zipPartAssets
        #expect(assets.count == 2)

        #expect(assets[0].name == "example.zip")
        #expect(assets[0].contentType == "application/zip")

        #expect(assets[1].name == "example.z01")
        #expect(assets[1].contentType == "application/octet-stream")
    }

}
