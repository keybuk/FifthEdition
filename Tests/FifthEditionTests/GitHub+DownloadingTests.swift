//
//  GitHub+DownloadingTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Foundation
import Testing
@testable import FifthEdition

struct GitHubDownloadingTests {
    @Test("Construct API URL")
    func releasesURL() {
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

struct AssetDownloadTests {
    static var exampleZipURL: URL {
        get throws {
            try #require(Bundle.module.url(forResource: "example", withExtension: "zip"),
                         "Missing test data")
        }
    }

    static let exampleZipDigest = "sha256:0379aacbd3c3552c15843dac8705d9b27e6751b2dbd3262ccfe40d993ce0d07c"

    static var badExampleZipURL: URL {
        get throws {
            try #require(Bundle.module.url(forResource: "bad_example", withExtension: "zip"),
                         "Missing test data")
        }
    }

    static var exampleAsset: GitHubAsset {
        get async throws {
            let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                                   "Missing test data")
            let releases = try await GitHubRelease.releasesFrom(url: url)
            return try #require(releases[name: "v1.0.0"]?.assets[contentType: "application/zip"])
        }
    }

    @Test("FileHandle SHA256 digest")
    func fileHandleSHA256Digest() throws {
        let digest = try FileHandle(forReadingFrom: Self.exampleZipURL).sha256Digest()
        #expect(digest == Self.exampleZipDigest)
    }

    @Test("Download asset with digest")
    func downloadAssetWithDigest() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        // Override download URL and digest to match test data since we're using the GitHub examples releases.json
        // otherwise.
        var asset = try await Self.exampleAsset
        asset.browserDownloadURL = try Self.exampleZipURL
        asset.digest = Self.exampleZipDigest

        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        try await asset.downloadInto(targetURL)

        try #require(targetURL.checkPromisedItemIsReachable() == true)

        // Verify the digest again ourselves.
        #expect(try FileHandle(forReadingFrom: targetURL).sha256Digest() == Self.exampleZipDigest)
    }

    @Test("Skip downloading asset with digest")
    func skipDownloadAssetWithDigest() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        // Override download URL to give the wrong asset, but the right digest, this makes sure we skipped downloading.
        var asset = try await Self.exampleAsset
        asset.browserDownloadURL = try Self.badExampleZipURL
        asset.digest = Self.exampleZipDigest

        // Copy the example.zip into the target directory first.
        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        try FileManager.default.copyItem(at: Self.exampleZipURL, to: targetURL)

        try await asset.downloadInto(targetURL)

        // Verify the digest is correct, meaning the download of the wrong asset didn't happen.
        #expect(try FileHandle(forReadingFrom: targetURL).sha256Digest() == Self.exampleZipDigest)
    }

    @Test("Repeat downloading asset with incorrect digest")
    func repeatDownloadAssetWithDigest() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        // Override download URL with the correct asset and digest.
        var asset = try await Self.exampleAsset
        asset.browserDownloadURL = try Self.exampleZipURL
        asset.digest = Self.exampleZipDigest

        // Copy the bad example.zip into the target directory, but with the asset's name, this should get removed and
        // overwritten.
        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        try FileManager.default.copyItem(at: Self.badExampleZipURL, to: targetURL)

        try await asset.downloadInto(targetURL)

        // Verify the digest is correct, meaning the wrong file was replaced by the right one.
        #expect(try FileHandle(forReadingFrom: targetURL).sha256Digest() == Self.exampleZipDigest)
    }

    @Test("Download asset without digest")
    func downloadAssetWithoutDigest() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        // Override download URL to match test data.
        var asset = try await Self.exampleAsset
        asset.browserDownloadURL = try Self.exampleZipURL
        asset.digest = nil

        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        try await asset.downloadInto(targetURL)

        try #require(targetURL.checkPromisedItemIsReachable() == true)

        // Verify the digest to make sure it downloaded the file.
        #expect(try FileHandle(forReadingFrom: targetURL).sha256Digest() == Self.exampleZipDigest)
    }

    @Test("Repeat download asset without digest")
    func repeatDownloadAssetWithoutDigest() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        // Override download URL to match test data.
        var asset = try await Self.exampleAsset
        asset.browserDownloadURL = try Self.exampleZipURL
        asset.digest = nil

        // Copy the bad example.zip into the target directory, but with the asset's name, this should get removed and
        // overwritten.
        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        try FileManager.default.copyItem(at: Self.badExampleZipURL, to: targetURL)

        try await asset.downloadInto(targetURL)

        // Verify the digest is correct, meaning the wrong file was replaced by the right one.
        #expect(try FileHandle(forReadingFrom: targetURL).sha256Digest() == Self.exampleZipDigest)
    }
}
