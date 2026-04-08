//
//  URLTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/6/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct URLDownloadTests {
    @Test
    func `download(to:) downloads the file`() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        let sourceURL = try #require(Bundle.module.url(forResource: "example", withExtension: "zip"),
                                     "Missing test data")
        let targetURL = targetDirectory.appending(component: sourceURL.lastPathComponent, directoryHint: .notDirectory)

        try await sourceURL.download(to: targetURL)

        try #require(targetURL.checkPromisedItemIsReachable() == true)
    }

    @Test
    func `download(to:) reports progress while downloading`() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        let sourceURL = try #require(Bundle.module.url(forResource: "example", withExtension: "zip"),
                                     "Missing test data")
        let targetURL = targetDirectory.appending(component: sourceURL.lastPathComponent, directoryHint: .notDirectory)

        nonisolated(unsafe) var progressReports: [(Int64, Int64)] = []
        try await sourceURL.download(to: targetURL) { bytesWritten, bytesExpected in
            progressReports.append((bytesWritten, bytesExpected))
        }

        #expect(!progressReports.isEmpty)
    }

    @Test
    func `download(to:) returns URLResponse`() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        let sourceURL = try #require(Bundle.module.url(forResource: "example", withExtension: "zip"),
                                     "Missing test data")
        let targetURL = targetDirectory.appending(component: sourceURL.lastPathComponent, directoryHint: .notDirectory)

        let response = try await sourceURL.download(to: targetURL)
        #expect(response != nil)
        #expect(response?.url == sourceURL)
    }

    @Test
    func `download(to:) throws error if download fails`() async throws {
        let targetDirectory = try FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true,
        )
        defer { try? FileManager.default.removeItem(at: targetDirectory) }

        let sourceURL = targetDirectory.appending(component: UUID().uuidString, directoryHint: .notDirectory)
        let targetURL = targetDirectory.appending(component: UUID().uuidString, directoryHint: .notDirectory)

        await #expect {
            try await sourceURL.download(to: targetURL)
        } throws: { error in
            (error as NSError).domain == NSURLErrorDomain
                && (error as NSError).code == NSURLErrorFileDoesNotExist
        }
    }
}
