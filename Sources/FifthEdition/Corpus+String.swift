//
//  Corpus+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/2/26.
//

extension CorpusContents: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "headers", "ordinal",
            values: name, headers, ordinal,
        )
    }
}

extension CorpusContents.Header: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescriptionOf(
            String(describing: type(of: self)),
            names: "_", "depth", "index",
            values: header, depth, index,
        )
    }
}

extension CorpusContents.Ordinal: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .chapter(integerValue, stringValue):
            debugDescriptionOf(".chapter",
                               names: "integer", "string",
                               values: integerValue, stringValue)
        case let .appendix(integerValue, stringValue):
            debugDescriptionOf(".appendix",
                               names: "integer", "string",
                               values: integerValue, stringValue)
        case let .part(integerValue, stringValue):
            debugDescriptionOf(".part",
                               names: "integer", "string",
                               values: integerValue, stringValue)
        case let .episode(integerValue, stringValue):
            debugDescriptionOf(".episode",
                               names: "integer", "string",
                               values: integerValue, stringValue)
        case let .level(integerValue, stringValue):
            debugDescriptionOf(".level",
                               names: "integer", "string",
                               values: integerValue, stringValue)
        case let .section(integerValue, stringValue):
            debugDescriptionOf(".section",
                               names: "integer", "string",
                               values: integerValue, stringValue)
        }
    }
}
