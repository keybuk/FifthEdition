//
//  GitHub+URL.swift
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
    internal static func urlFor(owner: String, name: String) -> URL {
        URL(string: "https://api.github.com/repos/\(owner)/\(name)/releases")!
    }

    /// Fetch releases from GitHub API.
    /// - Parameter url: GitHub releases API URL.
    /// - Returns: Array of releases from the given API URL.
    internal static func releasesFrom(url: URL) async throws -> [GitHubRelease] {
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue(apiVersion, forHTTPHeaderField: "X-GitHub-Api-Version")

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([GitHubRelease].self, from: data)
    }

    /// Fetch releases from GitHub API.
    /// - Parameters:
    ///   - owner: Repository owner.
    ///   - name: Repository name.
    /// - Returns: Array of releases for the given repository.
    public static func releasesFor(owner: String, name: String) async throws -> [GitHubRelease] {
        let url = Self.urlFor(owner: owner, name: name)
        return try await Self.releasesFrom(url: url)
    }
}

extension GitHubAsset {
    public enum AssetError: Error {
        case digestMismatch
    }

    /// Download the asset into a target URL, verifying the digest.
    /// - Parameter url: Target URL for file.
    ///
    /// The file is downloaded from the asset source URL into the target directory, with the same name as the asset itself. The directory must already exist before calling this function.
    ///
    /// If the file already exists, the digest is checked, and if the same, the download is skipped. If the downloaded file has the wrong asset, an error is thrown.
    public func downloadInto(_ url: URL) async throws {
        // If the target already exists, and the digest matches that in the asset, we can avoid downloading again.
        if let handle = try? FileHandle(forReadingFrom: url) {
            // TODO: Progress reporting
            print("Validating existing file")
            if let digest, digest.hasPrefix("sha256:"),
               try handle.sha256Digest() == digest
            {
                return
            }

            try FileManager.default.removeItem(at: url)
        }

        // Download and then verify the digest.
        // TODO: Progress reporting
        let (downloadedURL, _) = try await URLSession.shared.download(from: browserDownloadURL)
        if let digest, digest.hasPrefix("sha256:") {
            let handle = try FileHandle(forReadingFrom: downloadedURL)
            guard try handle.sha256Digest() == digest else {
                try FileManager.default.removeItem(at: downloadedURL)
                throw AssetError.digestMismatch
            }
        }

        try FileManager.default.moveItem(at: downloadedURL, to: url)
    }
}
