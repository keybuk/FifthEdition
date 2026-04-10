//
//  GitHub+DownloadingTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Foundation
import Synchronization
import Testing
@testable import FifthEdition

final class URLProtocolMock: URLProtocol {
    static let responses = Mutex<[URL: Data]>([:])

    static func urlSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [Self.self]
        return URLSession(configuration: configuration)
    }

    override class func canInit(with _: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url else { return }

        let data = Self.responses.withLock { $0[url] }
        if let response = HTTPURLResponse(url: url,
                                          statusCode: data != nil ? 200 : 404,
                                          httpVersion: nil,
                                          headerFields: nil)
        {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data ?? Data())
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}

struct GitHubDownloadingTests {
    @Test
    func `urlFor(owner:name:)`() {
        let url = GitHubRelease.urlFor(owner: "octocat", name: "Hello-World")
        #expect(url == URL(string: "https://api.github.com/repos/octocat/Hello-World/releases")!)
    }

    @Test
    func `releasesFrom(url:) returns releases`() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases.first, "Missing release")
        #expect(release.name == "v1.0.0")

        let asset = try #require(release.assets.first, "Missing asset")
        #expect(asset.name == "example.zip")
    }

    @Test
    func `releasesFor(owner:name:) returns releases`() async throws {
        let testURL = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                                   "Missing test data")
        let testData = try Data(contentsOf: testURL)

        let url = GitHubRelease.urlFor(owner: "octocat", name: "Hello-World")
        URLProtocolMock.responses.withLock {
            $0[url] = testData
        }

        let releases = try await GitHubRelease.releasesFor(
            owner: "octocat",
            name: "Hello-World",
            urlSession: URLProtocolMock.urlSession(),
        )

        let release = try #require(releases.first, "Missing release")
        #expect(release.name == "v1.0.0")

        let asset = try #require(release.assets.first, "Missing asset")
        #expect(asset.name == "example.zip")
    }

    @Test
    func `releasesFor(owner:name:) throws error on 404`() async throws {
        let error = await #expect(throws: URLError.self) {
            try await GitHubRelease.releasesFor(
                owner: "octocat",
                name: "Goodbye-Stars",
                urlSession: URLProtocolMock.urlSession(),
            )
        }
        #expect(error?.code == .badServerResponse)
    }

    @Test
    func `latest returns latest release`() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases.latest)
        #expect(release.name == "v1.0.0")
    }

    @Test
    func `subscript(name:) returns release from collection`() async throws {
        let url = try #require(Bundle.module.url(forResource: "releases", withExtension: "json"),
                               "Missing test data")

        let releases = try await GitHubRelease.releasesFrom(url: url)
        let release = try #require(releases[name: "v1.0.0"])
        #expect(release.name == "v1.0.0")

        #expect(releases[name: "v2.0.0"] == nil)
    }

    @Test
    func `subscript(contentType:) returns asset of content type from collection`() async throws {
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

    @Test
    func `sha256 digest`() throws {
        let digest = try FileHandle(forReadingFrom: Self.exampleZipURL).sha256Digest()
        #expect(digest == Self.exampleZipDigest)
    }

    @Test
    func `downloadInto(_:) for asset with digest`() async throws {
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

    @Test
    func `downloadInto(_:) skips downloading existing asset with digest`() async throws {
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

    @Test
    func `downloadInto(_:) re-downloads asset with incorrect digest`() async throws {
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

    @Test
    func `downloadInto(_:) for asset without digest`() async throws {
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

    @Test
    func `downloadInto(_:) re-downloads asset without digest`() async throws {
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

    @Test
    func `downloadInto(_:) throws error on 404`() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        let asset = try await Self.exampleAsset

        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        let error = await #expect(throws: URLError.self) {
            try await asset.downloadInto(targetURL, configuration: URLProtocolMock.urlSession().configuration)
        }
        #expect(error?.code == .badServerResponse)
    }

    @Test
    func `downloadInto(_:) throws error if download fails`() async throws {
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
        asset.browserDownloadURL = targetDirectory.appending(path: UUID().uuidString, directoryHint: .notDirectory)
        asset.digest = Self.exampleZipDigest

        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        let error = await #expect(throws: URLError.self) {
            try await asset.downloadInto(targetURL)
        }
        #expect(error?.code == .fileDoesNotExist)
    }

    @Test
    func `downloadInto(_:) throws error if downloaded asset has wrong digest`() async throws {
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
        asset.browserDownloadURL = try Self.badExampleZipURL
        asset.digest = Self.exampleZipDigest

        let targetURL = targetDirectory.appending(component: asset.name, directoryHint: .notDirectory)
        await #expect(throws: GitHubAsset.AssetError.digestMismatch) {
            try await asset.downloadInto(targetURL)
        }
    }
}
