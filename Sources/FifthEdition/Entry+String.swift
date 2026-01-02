//
//  Entry+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

extension MediaHref: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .url(url): url.absoluteString
        case let .path(path): path
        }
    }
}
