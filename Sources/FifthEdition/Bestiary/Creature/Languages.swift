//
//  Languages.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

public extension Creature {
    /// Languages a creature can speak or understand.
    ///
    /// Knowledge of a language means the creature can communicate in it, either or both by speaking it or read ing and
    /// writing it.
    struct Languages: Equatable, Hashable, Sendable {
        /// Languages spoken.
        public var spoken: Set<Language>

        /// Languages understood
        public var understood: Set<Language>

        /// Number of additional languages the creature speaks.
        public var additionalSpokenCount: Int?

        /// Human-readable text concerning ``additionalSpokenCount``.
        public var additionalSpokenNote: String?

        /// Number of additional languages the creature understands.
        public var additionalUnderstoodCount: Int?

        /// Human-readable text concerning ``additionalUnderstoodCount``.
        public var additionalUnderstoodNote: String?

        /// Range of telepathy, if capable.
        public var telepathy: Telepathy?

        /// Initialize from number of languages.
        /// - Parameters:
        ///   - spoken: Number of languages spoken.
        ///   - understood: Number of languages understood.
        ///   - telepathy: Range of telepathy, if capable.
        public init(spoken: Int? = nil,
                    understood: Int? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = []
            additionalSpokenCount = spoken
            self.understood = []
            additionalUnderstoodCount = understood
            self.telepathy = telepathy
        }

        /// Initialize from spoken languages.
        /// - Parameters:
        ///   - spoken: Languages spoken.
        ///   - additionalSpokenCount: Number of additional languages spoken.
        ///   - additionalSpokenNote: Human-readable text concerning `additionalSpokenCount`.
        ///   - understood: Number of languages understood.
        ///   - telepathy: Range of telepathy, if capable.
        public init(_ spoken: Set<Language>,
                    plus additionalSpokenCount: Int? = nil,
                    note additionalSpokenNote: String? = nil,
                    understood: Int? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = spoken
            self.additionalSpokenCount = additionalSpokenCount
            self.additionalSpokenNote = additionalSpokenNote
            self.understood = []
            additionalUnderstoodCount = understood
            self.telepathy = telepathy
        }

        /// Initialize from understood languages.
        /// - Parameters:
        ///   - spoken: Number of languages spoken.
        ///   - understood: Languages understood.
        ///   - additionalUnderstoodCount: Number of additional languages understood.
        ///   - additionalUnderstoodNote: Human-readable text concerning `additionalUnderstoodCount`.
        ///   - telepathy: Range of telepathy, if capable.
        public init(spoken: Int? = nil,
                    understood: Set<Language>,
                    plus additionalUnderstoodCount: Int? = nil,
                    note additionalUnderstoodNote: String? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = []
            additionalSpokenCount = spoken
            self.understood = understood
            self.additionalUnderstoodCount = additionalUnderstoodCount
            self.additionalUnderstoodNote = additionalUnderstoodNote
            self.telepathy = telepathy
        }

        /// Initialize from understood languages.
        /// - Parameters:
        ///   - spoken: Languags spoken.
        ///   - understood: Languages understood.
        ///   - additionalUnderstoodCount: Number of additional languages understood.
        ///   - additionalUnderstoodNote: Human-readable text concerning `additionalUnderstoodCount`.
        ///   - telepathy: Range of telepathy, if capable..
        public init(_ spoken: Set<Language>,
                    understood: Set<Language>,
                    plus additionalUnderstoodCount: Int? = nil,
                    note additionalUnderstoodNote: String? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = spoken
            self.understood = understood
            self.additionalUnderstoodCount = additionalUnderstoodCount
            self.additionalUnderstoodNote = additionalUnderstoodNote
            self.telepathy = telepathy
        }

        /// Initialize from spoken and understood languages.
        /// - Parameters:
        ///   - spoken: Languages spoken.
        ///   - additionalSpokenCount: Number of additional languages spoken.
        ///   - additionalSpokenNote: Human-readable text concerning `additionalSpokenCount`.
        ///   - understood: Languages understood.
        ///   - additionalUnderstoodCount: Number of additional languages understood.
        ///   - additionalUnderstoodNote: Human-readable text concerning `additionalUnderstoodCount`.
        ///   - telepathy: Range of telepathy, if capable..
        public init(_ spoken: Set<Language>,
                    plus additionalSpokenCount: Int? = nil,
                    note additionalSpokenNote: String? = nil,
                    understood: Set<Language>,
                    plus additionalUnderstoodCount: Int? = nil,
                    note additionalUnderstoodNote: String? = nil,
                    telepathy: Telepathy? = nil)
        {
            self.spoken = spoken
            self.additionalSpokenCount = additionalSpokenCount
            self.additionalSpokenNote = additionalSpokenNote
            self.understood = understood
            self.additionalUnderstoodCount = additionalUnderstoodCount
            self.additionalUnderstoodNote = additionalUnderstoodNote
            self.telepathy = telepathy
        }
    }
}

extension Creature.Languages: ExpressibleByArrayLiteral {
    /// Initialize ``spoken`` from an array literal.
    public init(arrayLiteral elements: Language...) {
        self.init(Set(elements))
    }
}

public extension Creature.Languages {
    var isEmpty: Bool {
        spoken.isEmpty && understood.isEmpty && telepathy == nil
    }
}
