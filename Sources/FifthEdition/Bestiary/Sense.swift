//
//  Sense.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/20/26.
//

import RegexBuilder

/// Languages.
///
/// Knowledge of a language means the creature can communicate in it, either or both by speaking it or read ing and
/// writing it.
public enum Language: Comparable, Equatable, Hashable, Sendable {
    /// Speaks all languages.
    case all

    // Languages from official sources.
    case aarakocra
    case aartuk
    case abyssal
    case aquan
    case auran
    case blinkDog
    case bothii
    case bullywug
    case celestial
    case common
    case commonSignLanguage
    case deepCrow
    case deepSpeech
    case demodand
    case dohwar
    case draconic
    case druidic
    case dwarvish
    case elvish
    case endspeech
    case formian
    case giant
    case giantEagle
    case giantElk
    case giantOwl
    case gibberling
    case gith
    case gnoll
    case gnomish
    case goblin
    case grell
    case grung
    case hadozee
    case halfling
    case homarid
    case hookHorror
    case iceToad
    case ignan
    case infernal
    case ixitxachitl
    case kenderspeak
    case kraul
    case kruthik
    case leonin
    case maelephant
    case merfolk
    case modron
    case netherese
    case orc
    case otyugh
    case primordial
    case primordialAquan
    case primordialAuran
    case primordialIgnan
    case primordialTerran
    case quori
    case sahuagin
    case skitterwidget
    case slaad
    case solamnic
    case sphinx
    case sylvan
    case tasloi
    case terran
    case thayan
    case thievesCant
    case thriKreen
    case tletlahtolli
    case tlincalli
    case troglodyte
    case umberHulk
    case undercommon
    case vegepygmy
    case winterWolf
    case worg
    case yeti
    case yikaria
    case ziklight

    /// Custom homebrew value.
    case other(String)
}

extension Language: CaseIterable {
    public static let allCases: [Language] = [
        .all,

        .aarakocra,
        .aartuk,
        .abyssal,
        .aquan,
        .auran,
        .blinkDog,
        .bothii,
        .bullywug,
        .celestial,
        .common,
        .commonSignLanguage,
        .deepCrow,
        .deepSpeech,
        .demodand,
        .dohwar,
        .draconic,
        .druidic,
        .dwarvish,
        .elvish,
        .endspeech,
        .formian,
        .giant,
        .giantEagle,
        .giantElk,
        .giantOwl,
        .gibberling,
        .gith,
        .gnoll,
        .gnomish,
        .goblin,
        .grell,
        .grung,
        .hadozee,
        .halfling,
        .homarid,
        .hookHorror,
        .iceToad,
        .ignan,
        .infernal,
        .ixitxachitl,
        .kenderspeak,
        .kraul,
        .kruthik,
        .leonin,
        .maelephant,
        .merfolk,
        .modron,
        .netherese,
        .orc,
        .otyugh,
        .primordial,
        .primordialAquan,
        .primordialAuran,
        .primordialIgnan,
        .primordialTerran,
        .quori,
        .sahuagin,
        .skitterwidget,
        .slaad,
        .solamnic,
        .sphinx,
        .sylvan,
        .tasloi,
        .terran,
        .thayan,
        .thievesCant,
        .thriKreen,
        .tletlahtolli,
        .tlincalli,
        .troglodyte,
        .umberHulk,
        .undercommon,
        .vegepygmy,
        .winterWolf,
        .worg,
        .yeti,
        .yikaria,
        .ziklight,
    ]
}

extension Language: Codable, RawRepresentable {
    public init(rawValue: String) {
        self = switch rawValue {
        case "all": .all
        case "aarakocra": .aarakocra
        case "aartuk": .aartuk
        case "abyssal": .abyssal
        case "aquan": .aquan
        case "auran": .auran
        case "blink dog": .blinkDog
        case "bothii": .bothii
        case "bullywug": .bullywug
        case "celestial": .celestial
        case "common sign language": .commonSignLanguage
        case "common": .common
        case "deep crow": .deepCrow
        case "deep speech": .deepSpeech
        case "demodand": .demodand
        case "dohwar": .dohwar
        case "draconic": .draconic
        case "druidic": .druidic
        case "dwarvish": .dwarvish
        case "elvish": .elvish
        case "endspeech": .endspeech
        case "formian": .formian
        case "giant eagle": .giantEagle
        case "giant elk": .giantElk
        case "giant owl": .giantOwl
        case "giant": .giant
        case "gibberling": .gibberling
        case "gith": .gith
        case "gnoll": .gnoll
        case "gnomish": .gnomish
        case "goblin": .goblin
        case "grell": .grell
        case "grung": .grung
        case "hadozee": .hadozee
        case "halfling": .halfling
        case "homarid": .homarid
        case "hook horror": .hookHorror
        case "ice toad": .iceToad
        case "ignan": .ignan
        case "infernal": .infernal
        case "ixitxachitl": .ixitxachitl
        case "kenderspeak": .kenderspeak
        case "kraul": .kraul
        case "kruthik": .kruthik
        case "leonin": .leonin
        case "maelephant": .maelephant
        case "merfolk": .merfolk
        case "modron": .modron
        case "netherese": .netherese
        case "orc": .orc
        case "otyugh": .otyugh
        case "primordial (aquan)": .primordialAquan
        case "primordial (auran)": .primordialAuran
        case "primordial (ignan)": .primordialIgnan
        case "primordial (terran)": .primordialTerran
        case "primordial": .primordial
        case "quori": .quori
        case "sahuagin": .sahuagin
        case "skitterwidget": .skitterwidget
        case "slaad": .slaad
        case "solamnic": .solamnic
        case "sphinx": .sphinx
        case "sylvan": .sylvan
        case "tasloi": .tasloi
        case "terran": .terran
        case "thayan": .thayan
        case "thieves' cant": .thievesCant
        case "thri-kreen": .thriKreen
        case "tletlahtolli": .tletlahtolli
        case "tlincalli": .tlincalli
        case "troglodyte": .troglodyte
        case "umber hulk": .umberHulk
        case "undercommon": .undercommon
        case "vegepygmy": .vegepygmy
        case "winter wolf": .winterWolf
        case "worg": .worg
        case "yeti": .yeti
        case "yikaria": .yikaria
        case "ziklight": .ziklight
        default: .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .all: "all"
        case .aarakocra: "aarakocra"
        case .aartuk: "aartuk"
        case .abyssal: "abyssal"
        case .aquan: "aquan"
        case .auran: "auran"
        case .blinkDog: "blink dog"
        case .bothii: "bothii"
        case .bullywug: "bullywug"
        case .celestial: "celestial"
        case .common: "common"
        case .commonSignLanguage: "common sign language"
        case .deepCrow: "deep crow"
        case .deepSpeech: "deep speech"
        case .demodand: "demodand"
        case .dohwar: "dohwar"
        case .draconic: "draconic"
        case .druidic: "druidic"
        case .dwarvish: "dwarvish"
        case .elvish: "elvish"
        case .endspeech: "endspeech"
        case .formian: "formian"
        case .giant: "giant"
        case .giantEagle: "giant eagle"
        case .giantElk: "giant elk"
        case .giantOwl: "giant owl"
        case .gibberling: "gibberling"
        case .gith: "gith"
        case .gnoll: "gnoll"
        case .gnomish: "gnomish"
        case .goblin: "goblin"
        case .grell: "grell"
        case .grung: "grung"
        case .hadozee: "hadozee"
        case .halfling: "halfling"
        case .homarid: "homarid"
        case .hookHorror: "hook horror"
        case .iceToad: "ice toad"
        case .ignan: "ignan"
        case .infernal: "infernal"
        case .ixitxachitl: "ixitxachitl"
        case .kenderspeak: "kenderspeak"
        case .kraul: "kraul"
        case .kruthik: "kruthik"
        case .leonin: "leonin"
        case .maelephant: "maelephant"
        case .merfolk: "merfolk"
        case .modron: "modron"
        case .netherese: "netherese"
        case .orc: "orc"
        case .otyugh: "otyugh"
        case .primordial: "primordial"
        case .primordialAquan: "primordial (aquan)"
        case .primordialAuran: "primordial (auran)"
        case .primordialIgnan: "primordial (ignan)"
        case .primordialTerran: "primordial (terran)"
        case .quori: "quori"
        case .sahuagin: "sahuagin"
        case .skitterwidget: "skitterwidget"
        case .slaad: "slaad"
        case .solamnic: "solamnic"
        case .sphinx: "sphinx"
        case .sylvan: "sylvan"
        case .tasloi: "tasloi"
        case .terran: "terran"
        case .thayan: "thayan"
        case .thievesCant: "thieves' cant"
        case .thriKreen: "thri-kreen"
        case .tletlahtolli: "tletlahtolli"
        case .tlincalli: "tlincalli"
        case .troglodyte: "troglodyte"
        case .umberHulk: "umber hulk"
        case .undercommon: "undercommon"
        case .vegepygmy: "vegepygmy"
        case .winterWolf: "winter wolf"
        case .worg: "worg"
        case .yeti: "yeti"
        case .yikaria: "yikaria"
        case .ziklight: "ziklight"
        case let .other(rawValue): rawValue
        }
    }
}

/// Sense.
///
/// Some creatures have special senses that help them perceive things in certain situations
public enum Sense: String, CaseIterable, Sendable {
    case blindsight
    case darkvision
    case superiorDarkvision = "superior darkvision"
    case tremorsense
    case truesight
}

extension Sense: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// Telepathic range.
///
/// Telepathy is a magical ability that allows a creature to communicate mentally with another creature within a
/// specified range given in the associated value of ``telepathy(range:note:)``. Additional human-readable text may be
/// provided in `note`.
///
/// Special rules are given as human-readable text in the associated value of ``special(_:)``.
///
/// For convenience, ``init(integerLiteral:)`` and ``init(stringLiteral:)`` permit ``Telepathy`` values to be
/// specified as integer and string literals.
public enum Telepathy: Equatable, Hashable, Sendable {
    case telepathy(range: Int, note: String? = nil)
    case special(String)
}

extension Telepathy: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    /// Initialize ``telepathy(range:note:)`` from an integer literal.
    public init(integerLiteral value: Int) {
        self = .telepathy(range: value)
    }

    /// Initialize ``special(_:)`` from a string literal.
    public init(stringLiteral value: StringLiteralType) {
        self = .special(value)
    }
}

public extension Telepathy {
    /// Initialize from the given string.
    /// - Parameter string: The string representation of the telepathic range.
    /// - Returns: The parsed telepathy.
    init(string: String) {
        let rangeRegex = Regex {
            Capture {
                OneOrMore(.digit)
            } transform: { match in
                Int(match)!
            }
            ChoiceOf {
                Regex {
                    ZeroOrMore(.whitespace)
                    ChoiceOf {
                        "ft."
                        "ft"
                        "feet"
                    }
                }
                Anchor.endOfSubject
            }
        }
        .ignoresCase()

        let noteRegex = Regex {
            Capture {
                OneOrMore(.anyNonNewline)
            }
        }

        let regex = Regex {
            "telepathy"
            OneOrMore(.whitespace)
            Regex {
                rangeRegex
                Optionally {
                    OneOrMore(.whitespace)
                    noteRegex
                }
            }
        }
        .ignoresCase()

        if let match = string.wholeMatch(of: regex) {
            let (_, range, note) = match.output
            self = .telepathy(range: range, note: note.map(String.init))
        } else {
            self = .special(string)
        }
    }
}
