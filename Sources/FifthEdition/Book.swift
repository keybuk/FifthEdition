//
//  Book.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/8/26.
//
//  Derived from schema-template/books.json
//  Version: 1.2.19

import Foundation
import MemberwiseInit

@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Book: Equatable, Sendable {
    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    public struct Contents: Codable, Equatable, Sendable {
        @MemberwiseInit(.public, _optionalsDefaultNil: true)
        public struct Header: Equatable, Sendable {
            @Init(label: "_")
            public var header: String
            public var depth: Int?
            public var index: Int?
        }

        @MemberwiseInit(.public, _optionalsDefaultNil: true)
        public struct Ordinal: Codable, Equatable, Sendable {
            public enum OrdinalType: String, Codable, Equatable, Sendable {
                case chapter
                case appendix
                case part
                case episode
                case level
                case section
            }

            public enum Identifier: Equatable, Sendable {
                case integer(Int)
                case string(String)
            }

            @Init(label: "_")
            public var type: OrdinalType
            public var identifier: Identifier?
        }

        @Init(label: "_")
        public var name: String
        public var headers: [Header]?
        public var ordinal: Ordinal?
    }

    public var name: String
    public var alias: [String]?
    public var id: String
    public var source: String
    public var parentSource: String?
    public var isLegacy: Bool?
    public var group: BookGroup

    public var author: String?
    public var published: Date
    public var revised: Date?

    public var cover: MediaHref?
    public var contents: [Contents]
}
