//
//  Collection+GitHub.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/24/25.
//

public extension Collection<GitHubRelease> {
    /// Latest release.
    ///
    /// Returns the most recently created release that is neither a draft nor pre-release.
    var latest: Element? {
        filter { release in
            !release.isDraft && !release.isPrerelease
        }
        .sorted { lhs, rhs in
            lhs.createdAt > rhs.createdAt
        }
        .first
    }

    subscript(name name: String) -> Element? {
        first { release in
            release.name == name && !release.isDraft && !release.isPrerelease
        }
    }
}

public extension Collection<GitHubAsset> {
    subscript(contentType contentType: String) -> Element? {
        first { asset in
            asset.contentType == contentType && asset.state == .uploaded
        }
    }
}
