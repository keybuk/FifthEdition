//
//  Entry.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

import Foundation

public enum MediaHref: Equatable, Sendable {
    case path(String)
    case url(URL)
}

// MARK: - Codable

extension MediaHref: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case path
        case url
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let url = try? container.decode(URL.self, forKey: .url) {
            self = .url(url)
        } else {
            self = .path(try container.decode(String.self, forKey: .path))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .url(let url):
            try container.encode("external", forKey: .type)
            try container.encode(url, forKey: .url)
        case .path(let path):
            try container.encode("internal", forKey: .type)
            try container.encode(path, forKey: .path)
        }
    }
}

// MARK: - String conversion

extension MediaHref: CustomStringConvertible {
    public var description: String {
        switch self {
        case .url(let url): url.absoluteString
        case .path(let path): path
        }
    }
}
