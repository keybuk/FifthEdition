//
//  GitHub.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/24/25.
//

import CryptoKit
import Foundation

/// Release published on GitHub.
public struct GitHubRelease {
    static let apiVersion = "2022-11-28"

    public var url: URL
    public var htmlURL: URL
    public var assetsURL: URL
    public var uploadURL: URL
    public var tarballURL: URL?
    public var zipballURL: URL?

    public var id: Int
    public var nodeID: String
    public var tagName: String
    public var targetCommitish: String
    public var name: String?
    public var body: String?

    public var isDraft: Bool
    public var isPrerelease: Bool
    public var isImmutable: Bool?

    public var createdAt: Date
    public var publishedAt: Date?
    public var updatedAt: Date?

    public var author: GitHubSimpleUser
    public var assets: [GitHubAsset]

    public var bodyHTML: String?
    public var bodyText: String?

    public var mentionsCount: Int?
    public var discussionURL: URL?
    public var reactions: GitHubReaction?

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

/// Data releases to a release.
///
/// Usually a downloadable asset.
public struct GitHubAsset {
    public enum State: String, Decodable {
        case open
        case uploaded
    }

    public var url: URL
    public var browserDownloadURL: URL

    public var id: Int
    public var nodeID: String
    public var name: String
    public var label: String?

    public var state: State

    public var contentType: String
    public var size: Int
    public var digest: String?
    public var downloadCount: Int
    public var createdAt: Date
    public var updatedAt: Date

    public var uploader: GitHubSimpleUser?

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
            if let digest, digest.hasPrefix("sha256:"),
               try handle.sha256Digest() == digest
            {
                return
            }

            try FileManager.default.removeItem(at: url)
        }

        // Download and then verify the digest.
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

/// User on GitHub.
public struct GitHubSimpleUser {
    public var name: String?
    public var email: String?
    public var login: String
    public var id: Int
    public var nodeID: String

    public var avatarURL: URL
    public var gravatarID: String?

    public var url: URL
    public var htmlURL: URL
    public var followersURL: URL
    public var followingURL: URL
    public var gistsURL: URL
    public var starredURL: URL
    public var subscriptionsURL: URL
    public var organizationsURL: URL
    public var reposURL: URL
    public var eventsURL: URL
    public var receivedEventsURL: URL

    public var type: String
    public var siteAdmin: Bool
    public var starredAt: String?
    public var userViewType: String?
}

/// Reactions to the release.
public struct GitHubReaction {
    public var url: URL

    public var totalCount: Int
    public var plusOne: Int
    public var minusOne: Int

    public var laugh: Int
    public var confused: Int
    public var heart: Int
    public var hooray: Int
    public var eyes: Int
    public var rocket: Int
}

// MARK: Collections

extension Collection where Element == GitHubRelease {

    /// Latest release.
    ///
    /// Returns the most recently created release that is neither a draft nor pre-release.
    public var latest: Element? {
        self
            .filter { release in
                !release.isDraft && !release.isPrerelease
            }
            .sorted { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            }
            .first
    }

    public subscript(name name: String) -> Element? {
        self
            .first { release in
                release.name == name && !release.isDraft && !release.isPrerelease
            }
    }

}

extension Collection where Element == GitHubAsset {

    public subscript(contentType contentType: String) -> Element? {
        self
            .first { asset in
                asset.contentType == contentType && asset.state == .uploaded
            }
    }

}

// MARK: - FileHandle digest

extension FileHandle {
    public func sha256Digest() throws -> String {
        var hasher = SHA256()
        while let chunk = try read(upToCount: SHA256.blockByteCount) {
            hasher.update(data: chunk)
        }

        return "sha256:" + Data(hasher.finalize()).map { byte in
            String(format: "%02x", byte)
        }.joined()
    }
}

// MARK: - Codable

extension GitHubRelease: Decodable {
    enum CodingKeys: String, CodingKey {
        case url
        case htmlURL = "html_url"
        case assetsURL = "assets_url"
        case uploadURL = "upload_url"
        case tarballURL = "tarball_url"
        case zipballURL = "zipball_url"

        case id
        case nodeID = "node_id"
        case tagName = "tag_name"
        case targetCommitish = "target_commitish"
        case name
        case body

        case isDraft = "draft"
        case isPrerelease = "prerelease"
        case isImmutable = "immutable"

        case createdAt = "created_at"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"

        case author
        case assets

        case bodyHTML = "body_html"
        case bodyText = "body_text"

        case mentionsCount = "mentions_count"
        case discussionURL = "discussions_url"
        case reactions
    }
}

extension GitHubAsset: Decodable {
    enum CodingKeys: String, CodingKey {
        case url
        case browserDownloadURL = "browser_download_url"

        case id = "id"
        case nodeID = "node_id"
        case name
        case label
        case state

        case contentType = "content_type"
        case size
        case digest
        case downloadCount = "download_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"

        case uploader
    }
}

extension GitHubSimpleUser: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case login
        case id
        case nodeID = "node_id"

        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"

        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"

        case type
        case siteAdmin = "site_admin"
        case starredAt = "starred_at"
        case userViewType = "user_view_type"
    }
}

extension GitHubReaction: Decodable {
    enum CodingKeys: String, CodingKey {
        case url
        case totalCount = "total_count"
        case plusOne = "+1"
        case minusOne = "-1"
        case laugh
        case confused
        case heart
        case hooray
        case eyes
        case rocket
    }
}
