//
//  Sense.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/20/26.
//

import RawRepresentableOptions

/// Languages.
///
/// Knowledge of a language means the creature can communicate in it, either or both by speaking it or read ing and
/// writing it.
@RawRepresentableOptions
public struct Language: CaseIterable, Codable, Equatable, Hashable, Sendable {
    private enum Options: String {
        /// Speaks all languages.
        case all

        // Languages from official sources.
        case aarakocra
        case aartuk
        case abyssal
        case aquan
        case auran
        case blinkDog = "blink dog"
        case bothii
        case bullywug
        case celestial
        case common
        case commonSignLanguage = "common sign language"
        case deepCrow = "deep crow"
        case deepSpeech = "deep speech"
        case demodand
        case dohwar
        case draconic
        case druidic
        case dwarvish
        case elvish
        case endspeech
        case formian
        case giant
        case giantEagle = "giant eagle"
        case giantElk = "giant elk"
        case giantOwl = "giant owl"
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
        case hookHorror = "hook horror"
        case iceToad = "ice toad"
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
        case primordialAquan = "primordial (aquan)"
        case primordialAuran = "primordial (auran)"
        case primordialIgnan = "primordial (ignan)"
        case primordialTerran = "primordial (terran)"
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
        case thievesCant = "thieves' cant"
        case thriKreen = "thri-kreen"
        case tletlahtolli
        case tlincalli
        case troglodyte
        case umberHulk = "umber hulk"
        case undercommon
        case vegepygmy
        case winterWolf = "winter wolf"
        case worg
        case yeti
        case yikaria
        case ziklight
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
    public init(stringLiteral value: String) {
        self = .special(value)
    }
}
