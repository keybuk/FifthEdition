//
//  Book+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 4/8/26.
//

extension Book: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case alias
        case id
        case source
        case parentSource
        // isLegacy omitted as not present in data.
        case group
        case author
        case published
        case revised
        case cover
        case contents
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        alias = try container.decodeIfPresent([String].self, forKey: .alias) ?? []
        id = try container.decode(String.self, forKey: .id)
        source = try container.decode(String.self, forKey: .source)
        parentSource = try container.decodeIfPresent(String.self, forKey: .parentSource)
        group = try container.decode(Group.self, forKey: .group)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        published = try container.decode(ISO8601DateCoding.self, forKey: .published).value
        revised = try container.decodeIfPresent(ISO8601DateCoding.self, forKey: .revised)?.value
        cover = try container.decodeIfPresent(MediaHref.self, forKey: .cover)
        contents = try container.decode([CorpusContents].self, forKey: .contents)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(!alias.isEmpty ? alias : nil, forKey: .alias)
        try container.encode(id, forKey: .id)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(parentSource, forKey: .parentSource)
        try container.encode(group, forKey: .group)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encode(ISO8601DateCoding(published), forKey: .published)
        try container.encodeIfPresent(ISO8601DateCoding(revised), forKey: .revised)
        try container.encodeIfPresent(cover, forKey: .cover)
        try container.encode(contents, forKey: .contents)
    }
}
