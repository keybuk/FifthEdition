//
//  GitHub+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/24/25.
//

import CryptoKit
import Foundation

extension GitHubRelease {
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

extension GitHubAsset {
    enum CodingKeys: String, CodingKey {
        case url
        case browserDownloadURL = "browser_download_url"

        case id
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

extension GitHubSimpleUser {
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

extension GitHubReaction {
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
