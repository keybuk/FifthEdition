//
//  Corpus+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

extension CorpusContents.Header: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension CorpusContents.Ordinal.Identifier: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .integer(value): "\(value)"
        case let .string(value): value
        }
    }
}

extension CorpusContents.Ordinal.Identifier: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .integer(value)
    }
}

extension CorpusContents.Ordinal.Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}
