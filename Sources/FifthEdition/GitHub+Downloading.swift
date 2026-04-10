//
//  GitHub+Downloading.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/24/25.
//

import Foundation

extension GitHubRelease {
    /// Construct URL for GitHub releases API.
    /// - Parameters:
    ///   - owner: Repository owner.
    ///   - name: Repository name.
    /// - Returns: GitHub releases API URL for the given parameters..
    static func urlFor(owner: String, name: String) -> URL {
        URL(string: "https://api.github.com/repos/\(owner)/\(name)/releases")!
    }

    /// Fetch releases from GitHub API.
    /// - Parameters:
    ///   - url: GitHub releases API URL.
    ///   - session: `URLSession` to use, defaults to `.shared`.
    /// - Returns: Array of releases from the given API URL.
    static func releasesFrom(url: URL, session urlSession: URLSession = .shared) async throws -> [GitHubRelease] {
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue(apiVersion, forHTTPHeaderField: "X-GitHub-Api-Version")

        let (data, response) = try await urlSession.data(for: request)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200
        {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([GitHubRelease].self, from: data)
    }

    /// Fetch releases from GitHub API.
    /// - Parameters:
    ///   - owner: Repository owner.
    ///   - name: Repository name.
    ///   - urlSession: `URLSession` to use, defaults to `.shared`.
    /// - Returns: Array of releases for the given repository.
    public static func releasesFor(owner: String, name: String,
                                   urlSession: URLSession = .shared)
        async throws -> [GitHubRelease]
    {
        let url = Self.urlFor(owner: owner, name: name)
        return try await Self.releasesFrom(url: url, session: urlSession)
    }
}

public extension GitHubAsset {
    enum AssetError: Error {
        case digestMismatch
    }

    enum DownloadProgress {
        case downloading(Int64, Int64)
        case validating
    }

    /// Download the asset into a target URL, verifying the digest.
    /// - Parameters:
    ///   - url: Target URL for file.
    ///   - configuration: `URLSession` configuration to use, defaults to `.default`.
    ///   - progress: Called to report progress.
    ///
    /// The file is downloaded from the asset source URL into the target directory, with the same name as the asset
    /// itself. The directory must already exist before calling this function.
    ///
    /// If the file already exists, the digest is checked, and if the same, the download is skipped. If the downloaded
    /// file has the wrong asset, an error is thrown.
    func downloadInto(_ url: URL, configuration: URLSessionConfiguration = .default,
                      progress: @escaping @Sendable (DownloadProgress) -> Void = { _ in })
        async throws
    {
        // If the target already exists, and the digest matches that in the asset, we can avoid downloading again.
        if let handle = try? FileHandle(forReadingFrom: url) {
            progress(.validating)
            if let digest, digest.hasPrefix("sha256:"),
               try handle.sha256Digest() == digest
            {
                return
            }

            try FileManager.default.removeItem(at: url)
        }

        // Download and then verify the digest.
        let response = try await browserDownloadURL
            .download(to: url, configuration: configuration) { bytesWritten, bytesExpected in
                progress(.downloading(bytesWritten, bytesExpected))
            }
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200
        {
            throw URLError(.badServerResponse)
        }

        if let digest, digest.hasPrefix("sha256:") {
            progress(.validating)
            let handle = try FileHandle(forReadingFrom: url)
            guard try handle.sha256Digest() == digest else {
                try FileManager.default.removeItem(at: url)
                throw AssetError.digestMismatch
            }
        }
    }
}
