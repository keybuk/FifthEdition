//
//  GitHub.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/24/25.
//

import Foundation

/// Release published on GitHub.
public struct GitHubRelease: Decodable {
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
}

/// Data releases to a release.
///
/// Usually a downloadable asset.
public struct GitHubAsset: Decodable {
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
}

/// User on GitHub.
public struct GitHubSimpleUser: Decodable {
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
public struct GitHubReaction: Decodable {
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
