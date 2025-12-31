//
//  Collection+GitHub.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/24/25.
//

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
