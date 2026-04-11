//
//  Book+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/11/26.
//

extension Book.Contents: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "headers", "ordinal",
            values: name, headers, ordinal,
        )
    }
}

extension Book.Contents.Header: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "depth", "index",
            values: header, depth, index,
        )
    }
}

extension Book.Contents.Ordinal: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: Swift.type(of: self)),
            names: "_", "identifier",
            values: type, identifier,
        )
    }
}

extension Book.Contents.Ordinal.Identifier: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .integer(integer): "\(integer)"
        case let .string(string): string
        }
    }
}

extension Book.Level: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .range(range): "\(range)"
        case let .custom(custom): custom
        }
    }
}
