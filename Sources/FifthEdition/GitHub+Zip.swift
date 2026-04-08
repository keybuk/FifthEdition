//
//  GitHub+Zip.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 1/1/26.
//

public extension GitHubRelease {
    static let zipContentType = "application/zip"
    static let zipPartContentType = "application/octet-stream"

    var zipAssets: [GitHubAsset] {
        assets.filter { asset in
            asset.contentType == Self.zipContentType && asset.state == .uploaded
        }
    }

    var zipPartAssets: [GitHubAsset] {
        assets.filter { asset in
            (asset.contentType == Self.zipContentType || asset.contentType == Self.zipPartContentType) &&
                asset.state == .uploaded
        }
    }
}
