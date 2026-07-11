//
//  Meta.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/25/26.
//

/// Metadata.
public struct Meta: Equatable, Sendable {
    /// Dependencies.
    ///
    /// Values are a set of sources that this depends on. For example if `dependencies[.monster] = ["MM"]` then this
    /// source depends on monsters from the "MM" bestiary.
    public var dependencies: [Entity: Set<String>]

    /// Internal copies.
    ///
    /// Entities that are copied from within the current source.
    public var internalCopies: Set<Entity>

    /// Other sources to be loaded.
    ///
    /// Values are map from sources to be loaded to other sources from that source to search for. For example,
    /// if `otherSources[.monster] = ["MM": "CoS"]` then creatures in the "MM" bestiary with a "CoS" entry in
    /// ``Creature/otherSources`` should be included.
    public var otherSources: [Entity: [String: String]]

    /// Initialize metadata.
    /// - Parameters:
    ///   - dependencies: Dependencies.
    ///   - internalCopies: Internal copies.
    ///   - otherSources: Other sources to be loaded.
    public init(dependencies: [Entity: Set<String>] = [:],
                internalCopies: Set<Entity> = [],
                otherSources: [Entity: [String: String]] = [:])
    {
        self.dependencies = dependencies
        self.internalCopies = internalCopies
        self.otherSources = otherSources
    }
}
