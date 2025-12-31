//
//  Entry+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

extension MediaHref: CustomStringConvertible {
    public var description: String {
        switch self {
        case .url(let url): url.absoluteString
        case .path(let path): path
        }
    }
}
