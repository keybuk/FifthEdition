//
//  Corpus+Expressible.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

extension CorpusContents.Header: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
