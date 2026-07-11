//
//  Creature.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

import Foundation
import MemberwiseInit

/// Monster or other creature.
///
/// ## Parsing
/// The collection of creatures in the 5etools data is obtained by parsing ``Bestiary`` and
/// iterating the ``Bestiary/monster`` collection.
@MemberwiseInit(.public, _optionalsDefaultNil: true)
public struct Creature: Equatable, Hashable, Sendable {
    // MARK: Name

    /// Name of the creature.
    public var name: String

    /// How to generate the shortened form of the creature name.
    public var shortNameForm: ShortName?

    /// Creature's name is their proper name.
    public var isNamedCreature: Bool = false

    /// Creature is an NPC.
    public var isNPC: Bool = false

    /// Other names the creature is known by.
    ///
    /// Used for searching.
    public var alias: Set<String> = []

    /// Groups creature is a member of.
    ///
    /// Used for searching, otherwise `"Lycanthrope"` would fail to find anything.
    public var group: Set<String> = []

    // MARK: Source

    /// Source identifier this creature comes from.
    public var source: String

    /// Human-readable hover text for ``source``.
    public var sourceHover: String?

    /// Page number in ``source``.
    public var page: Page?

    /// Whether this creature is present in SRD 5.1
    public var srd: Reference?

    /// Whether this creature is present in SRD 5.2
    public var srd52: Reference?

    /// Whether this creature is present in 5e/2014 Basic Rules.
    public var basicRules: Reference?

    /// Whether this creature is present in 5.5e/2024 Basic Rules
    public var basicRules2024: Reference?

    /// Other sources that the creature comes from.
    public var otherSources: Set<Source> = []

    /// Sources that provide additional information about the creature.
    public var additionalSources: Set<Source> = []

    /// Sources that reference the creature.
    public var referenceSources: Set<String> = []

    /// Where the creature is reprinted.
    public var reprintedAs: Set<Reprint> = []

    /// Whether the creature has been reprinted.
    public var hasReprint: Bool = false

    // MARK: Stats

    /// Sidekick role.
    ///
    /// ## Formatting
    /// ``Sidekick/FormatStyle`` formats ``sidekick`` in the representation used in stat blocks:
    /// ```swift
    /// Sidekick(level: 2, type: .spellcaster, tags: "wizard")
    ///     .formatted()
    /// // "7th-Level Spellcaster (Wizard)"
    /// ```
    public var sidekick: Sidekick?

    /// Size.
    ///
    /// A creature's size determines the area on a map that it effectively controls in combat and the area it needs to
    /// fight effectively. Where a creature has multiple possible sizes, each are given here, with the method of choice
    /// provided in human-readable text in the ``Sizes/note`` property.
    ///
    /// For convenience, ``size`` may be specified as an array of ``Size``:
    /// ```swift
    /// creature.size = [.small, .medium]
    /// ```
    ///
    /// ## Formatting
    /// ``Sizes/FormatStyle`` formats ``size`` in the representation used in stat blocks:
    /// ```swift
    /// Creature.Sizes(.medium, .large)
    ///     .formatted()
    /// // "Medium or Large"
    /// ```
    public var size: Sizes = []

    /// Type.
    ///
    /// Each creature has a type. Certain spells, magic items, class features, and other effects in the game interact in
    /// special ways with creatures of a particular type. Where a creature has multiple possible types, each are given
    /// here, with the method of choice provided in human-readable text in the ``Types/note`` property.
    ///
    /// For convenience, ``type`` may be specified as an array of ``CreatureType``:
    /// ```swift
    /// creature.type = [.fey, .monstrosity]
    /// ```
    ///
    /// ## Formatting
    /// ``Types/FormatStyle`` formats ``type`` in the representation used in stat blocks:
    /// ```swift
    /// Creature.Types(.dragon, tags: "chromatic")
    ///     .formatted()
    /// // "Dragon (Chromatic)"
    ///
    /// Creature.Types(.beast, swarmSize: .tiny)
    ///     .formatted()
    /// // "swarm of Tiny Beasts"
    /// ```
    public var type: Types = []

    /// Alignment.
    ///
    /// A creature’s alignment broadly describes its ethical attitudes and ideals. Alignment is a combination of two
    /// factors: one identifies morality (good, evil, or neutral), and the other describes attitudes toward order
    /// (lawful, chaotic, or neutral).
    ///
    /// For convenience, ``alignment`` may be specified as an array of ``Alignment/Alignment``:
    /// ```swift
    /// creature.aligmment = [.lawfulGood]
    /// ```
    ///
    /// ## Formatting
    /// ``Alignment/FormatStyle`` formats ``alignment`` in the representation used in stat blocks:
    /// ```swift
    /// Creature.Alignment(.lawfulGood, .chaoticGood)
    ///     .formatted()
    /// // "Lawful Good or Chaotic Good"
    /// ```
    public var alignment: Alignment = []

    /// Armor class.
    ///
    /// A creature’s Armor Class represents how well the creature avoids being wounded in combat, typically in the range
    /// `10...25` given in the associated value of ``ArmorClass/ac(_:from:condition:inParens:)``. Where a creature has
    /// multiple possible armor class values, each are given here, distinguished with human-readable text in the `from`
    /// and `condition` associated values.
    ///
    /// Special rules are given as human-readable text in the associated value of ``ArmorClass/special(_:)``.
    ///
    /// For convenience, ``ArmorClass`` values may be specified as integer and string literals:
    /// ```swift
    /// creature.armorClass = [17]
    /// ```
    ///
    /// ## Formatting
    /// ``ArmorClass/FormatStyle`` formats ``ArmorClass`` in the representation used in stat blocks, and
    /// ``ArmorClass/ListFormatStyle`` formats the ``armorClass`` list:
    /// ```swift
    /// ArmorClass.ac(12, from: ["natural armor"])
    ///     .formatted()
    /// // "12 (natural armor)"
    ///
    /// [
    ///     ArmorClass.ac(12, from: ["natural armor"]),
    ///     ArmorClass.ac(14, condition: "while in bear form", inParens: true),
    /// ]
    /// .formatted(.armorClasses())
    /// // "12 (natural armor; 14 while in bear form)"
    /// ```
    public var armorClass: [ArmorClass] = []

    /// Hit Points.
    ///
    /// Hit Points represent durability and the will to live, usually provided as a ``DiceNotation`` formula given in
    /// the associated value of ``HitPoints/hp(_:given:)``. The `given` associated value is `nil` if the creature's hit
    /// points matches the ``DiceNotation/average``, otherwise provides the actual hit points value.
    ///
    /// In the event the formula is not parseable, the average and formula are given in the associated values of
    /// ``HitPoints/other(_:formula:)``.
    ///
    /// Special rules are given as human-readable text in the associated value of ``HitPoints/special(_:)``.
    ///
    /// For convenience, ``HitPoints`` values may be specified as string literals:
    /// ```swift
    /// creature.hitPoints = "4d6 + 10"
    /// ```
    ///
    /// ## Formatting
    /// ``HitPoints/FormatStyle`` formats ``hitPoints`` in the representation used in stat blocks:
    /// ```swift
    /// HitPoints.hp("4d6 + 10")
    ///     .formatted()
    /// // "24 (4d6 + 10)"
    /// ```
    public var hitPoints: HitPoints?

    /// Speeds.
    ///
    /// On its turn, a creature can move a distance equal to its Speed or less. These different modes of movement can be
    /// combined, or they can constitute its entire move.
    ///
    /// For convenience, ``Speeds`` and ``Speed`` values may be specified as integer literals, and ``Speeds`` with a
    /// dictionary literal.
    /// ```swift
    /// creature.speeds = 30  // Walking speed
    ///
    /// creature.speeds = [
    ///     .walk: 30,
    ///     .fly: 45,
    /// ]
    /// ```
    ///
    /// ## Formatting
    /// ``Speeds/FormatStyle`` formats ``speeds`` in the representation used in stat blocks:
    /// ```swift
    /// Speeds([.walk: [30], .fly: [45]])
    ///     .formatted()
    /// // "30 ft., Fly: 40 ft."
    /// ```
    public var speeds: Speeds = [:]

    /// Ability scores.
    ///
    /// All creatures have six abilities that measure physical and mental characteristics, given as a score from
    /// `1...30` in the associated value of ``AbilityScore/score(_:)`` for that ``Ability``.
    ///
    /// Special rules are given as human-readable text in the associated value of ``AbilityScore/special(_:)``.
    ///
    /// For convenience, ``AbilityScore`` values may be specified as integer and string literals:
    /// ```swift
    /// creature.abilities[.strength] = 13
    /// ```
    ///
    /// Use ``Creature/subscript(_:)-(Ability)`` to obtain the derived ``AbilityModifier`` value:
    /// ```swift
    /// if (creature[.intelligence] < -3) {
    ///     // Cannot comprehend languages.
    /// }
    /// ```
    public var abilities: [Ability: AbilityScore] = [:]

    /// Saving throws.
    ///
    /// A saving throw—also called a save—represents an attempt to evade or or resist a threat. Where the
    /// ``AbilityModifier`` for a save is not the same as that derived from its ``abilities`` score, the alternate
    /// value is provided here.
    ///
    /// For convenience, ``AbilityModifier`` values may be specified as integer and string literals, and
    /// ``SavingThrows`` with a dictionary literal:
    /// ```swift
    /// creature.savingThrows = [
    ///     .dexterity: 4,
    ///     .wisdom: 2,
    /// ]
    /// ```
    ///
    /// Use ``Creature/subscript(savingThrow:)`` to obtain the provided or derived value:
    /// ```swift
    /// if (creature[savingThrow: .dexterity] > 5) {
    ///     // Cannot fail the save.
    /// }
    /// ```
    ///
    /// ## Formatting
    /// ``SavingThrows/FormatStyle`` formats ``savingThrows`` in the representation used in stat blocks:
    /// ```swift
    /// SavingThrows([.dexterity: 4, .wisdom: 2])
    ///     .formatted()
    /// // "Dex +4, Wis +2"
    /// ```
    public var savingThrows: SavingThrows = [:]

    /// Skills.
    ///
    /// Most ``Ability`` checks involve using a skill, which represents a category of things creatures try to do with an
    /// ability check. Where the ``AbilityModifier`` for such a check is not the same as that derived from its
    /// ``abilities`` score, the alternate value is provided here.
    ///
    /// For convenience, ``AbilityModifier`` values may be specified as integer and string literals, and ``Skills``
    /// with a dictionary literal:
    /// ```swift
    /// creature.skills = [
    ///     .deception: 4,
    ///     .sleightOfHand: 3,
    /// ]
    /// ```
    ///
    /// Use ``Creature/subscript(_:)-(Skill)`` to obtain the provided or derived value:
    /// ```swift
    /// if (creature[.sleightOfHand] < 2) {
    ///     // Always fails.
    /// }
    /// ```
    ///
    /// ## Formatting
    /// ``Skills/FormatStyle`` formats ``skills`` in the representation used in stat blocks:
    /// ```swift
    /// Skills([.deception: 4, .sleightOfHand: 3])
    ///     .formatted()
    /// // "Deception +4, Sleight Of Hand +3"
    /// ```
    public var skills: Skills = [:]

    /// Tools.
    ///
    /// If a creature has proficiency with a tool, it can add its Proficiency Bonus to any ability check made using the
    /// tool. The ``AbilityModifier`` for any such checks the creature can make is provided here.
    ///
    /// ## Formatting
    /// ``Tools/FormatStyle`` formats ``tools`` in the representation used in stat blocks:
    /// ```swift
    /// Tools([.brewersSupplies: 2, .theivesTools: 4])
    ///     .formatted()
    /// // "Brewer's Supplies +2, Thieves' Tools: +4"
    /// ```
    public var tools: Tools = [:]

    /// How an initiative roll is made.
    ///
    /// Initiative determines the order of turns during combat. Where such a check is not made using the creature's
    /// ``Ability/dexterity`` modifier, alternate modifier or rules are provided here.
    ///
    /// Use ``Creature/subscript(_:)-(InitiativeCheck)`` to obtain the provided or derived modifier value and
    /// ``Creature/subscript(passive:)-(InitiativeCheck)`` to obtain the derived passive score:
    /// ```swift
    /// if (creature[.initiative] < -1) {
    ///     // Low modifier.
    /// }
    ///
    /// if (creature[passive: .initiative] > 15) {
    ///     // High roll.
    /// }
    /// ```
    public var initiative: Initiative?

    /// Types of damage the creature is vulnerable to.
    ///
    /// If a creature has Vulnerability to a damage type, damage of that type is doubled against it.
    ///
    /// ## Formatting
    /// ``Susceptible/FormatStyle`` formats ``Susceptible`` in the representation used in stat blocks, and
    /// ``Susceptible/ListFormatStyle`` formats the ``damageVulnerabilities`` set:
    /// ```swift
    /// Suspectible.damage(.bludgeoning)
    ///     .formatted()
    /// // "Bludgeoning"
    ///
    /// [
    ///     Suspectible.damage(.bludgeoning),
    ///     Suspectible.damage(.piercing),
    ///     Suspectible.damage(.slashing),
    /// ]
    /// .formatted(.susceptibles())
    /// // "Blugeoning, Piercing, Slashing"
    /// ```
    public var damageVulnerabilities: Set<Susceptible> = []

    /// Types of damage the creature is resistant to.
    ///
    /// If a creature has Resistance to a damage type, damage of that type is halved against it (round down).
    ///
    /// ## Formatting
    /// ``Susceptible/FormatStyle`` formats ``Susceptible`` in the representation used in stat blocks, and
    /// ``Susceptible/ListFormatStyle`` formats the ``damageVulnerabilities`` set:
    /// ```swift
    /// Suspectible.damage(.bludgeoning)
    ///     .formatted()
    /// // "Bludgeoning"
    ///
    /// [
    ///     Suspectible.damage(.bludgeoning),
    ///     Suspectible.damage(.piercing),
    ///     Suspectible.damage(.slashing),
    /// ]
    /// .formatted(.susceptibles())
    /// // "Blugeoning, Piercing, Slashing"
    /// ```
    public var damageResistances: Set<Susceptible> = []

    /// Types of damage the creature is immune to.
    ///
    /// Immunity to a damage type means creatures don’t take damage of that type.
    ///
    /// ## Formatting
    /// ``Susceptible/FormatStyle`` formats ``Susceptible`` in the representation used in stat blocks, and
    /// ``Susceptible/ListFormatStyle`` formats the ``damageVulnerabilities`` set:
    /// ```swift
    /// Suspectible.damage(.bludgeoning)
    ///     .formatted()
    /// // "Bludgeoning"
    ///
    /// [
    ///     Suspectible.damage(.bludgeoning),
    ///     Suspectible.damage(.piercing),
    ///     Suspectible.damage(.slashing),
    /// ]
    /// .formatted(.susceptibles())
    /// // "Blugeoning, Piercing, Slashing"
    /// ```
    public var damageImmunities: Set<Susceptible> = []

    /// Conditions the creature is immune to.
    ///
    /// Immunity to a condition means creatures aren’t affected by it.
    ///
    /// ## Formatting
    /// ``Susceptible/FormatStyle`` formats ``Susceptible`` in the representation used in stat blocks, and
    /// ``Susceptible/ListFormatStyle`` formats the ``damageVulnerabilities`` set:
    /// ```swift
    /// Suspectible.condition(.blinded)
    ///     .formatted()
    /// // "Blinded"
    ///
    /// [
    ///     Suspectible.condition(.blinded),
    ///     Suspectible.condition(.paralyzed),
    ///     Suspectible.condition(.stunned),
    /// ]
    /// .formatted(.susceptibles())
    /// // "Blinded, Paralyzed, Stunned"
    /// ```
    public var conditionImmunities: Set<Susceptible> = []

    /// Gear
    ///
    /// Monsters have proficiency with their equipment. If a monster has equipment that can be given away or retrieved,
    /// the items are given here.
    ///
    /// ## Formatting
    /// ``Gear/FormatStyle`` formats ``Gear`` in the representation used in stat blocks, and
    /// ``Gear/ListFormatStyle`` formats the ``gear`` set:
    /// ```swift
    /// Gear(name: "Longbow", source: "XPHB", quantity: 2)
    ///     .formatted()
    /// // "Longbows (2)"
    ///
    /// [
    ///     Gear(name: "Longbow", source: "XPHB", quantity: 2),
    ///     Gear(name: "Manacles", source: "XPHB"),
    /// ]
    /// .formatted(.gears())
    /// // "Manacles, Longbows (2)"
    /// ```
    public var gear: Set<Gear> = []

    /// Senses.
    ///
    /// Some creatures have special senses that help them perceive things in certain situations, given in the associated
    /// values of ``Sense/sense(_:range:note:)`` where `range` provides the range of the sense in feet and `note`
    /// provides additional optional human-readable text.
    ///
    /// Special rules are given as human-readable text in the associated value of ``Sense/special(_:)``.
    ///
    /// ## Formatting
    /// ``Sense/FormatStyle`` formats ``Sense`` in the representation used in stat blocks, and
    /// ``Sense/ListFormatStyle`` formats the ``senses`` set:
    /// ```swift
    /// Creature.Sense(.darkvision, range: 60)
    ///     .formatted()
    /// // "Darkvision 60 ft."
    ///
    /// [
    ///     Creature.Sense(.darkvision, range: 60),
    ///     Creature,Sense(.tremorsense, range: 15),
    /// ]
    /// .formatted(.senses())
    /// // "Darkvision 60 ft., Tremorsense 15 ft."
    /// ```
    public var senses: Set<Sense> = []

    /// Passive perception.
    ///
    /// Passive Perception is a score that reflects a general awareness of surroundings. Where that score is not derived
    /// from the creature's ``Skill/perception`` modifier, the alternate score is provided here.
    ///
    /// For convenience, ``Passive`` values may be specified as integer and string literals:
    /// ```swift
    /// creature.passivePerception = 13
    /// ```
    ///
    /// Use ``Creature/subscript(passive:)-(Skill)`` to obtain the provided or derived value:
    /// ```swift
    /// if (creature[passive: .perception] > 15) {
    ///     // Notices the trap.
    /// }
    /// ```
    ///
    /// ## Formatting
    /// ``Passive/FormatStyle`` formats ``passivePerception`` in the representation used in stat blocks:
    /// ```swift
    /// Passive.passive(13)
    ///     .formatted()
    /// // "13"
    /// ```
    public var passivePerception: Passive?

    /// Languages spoken and understood.
    ///
    /// Knowledge of a language means the creature can communicate in it, either or both by speaking it or read ing and
    /// writing it.
    ///
    /// For convenience, ``languages`` may be specified as an array of ``Language``:
    /// ```swift
    /// creature.languages = [.common, .draconic]
    /// ```
    ///
    /// ## Formatting
    /// ``Languages/FormatStyle`` formats ``languages`` in the representation used in stat blocks:
    /// ```swift
    /// Languages(.common, draconic)
    ///     .formatted()
    /// // "Common, Draconic"
    ///
    /// Languages(understood: .abyssal, .infernal)
    ///     .formatted()
    /// // "Understands Abyssal and Infernal but can't speak"
    /// ```
    public var languages: Languages = []

    /// Challenge of defeating the creature.
    ///
    /// For convenience ``Challenge`` values may be specified as integer and string literals:
    /// ```swift
    /// creature.challenge = 17
    /// ```
    ///
    /// Use ``Creature/challengeRating`` to obtain the provided value, or ``Creature/proficiencyBonus`` to obtain the
    /// provided or derived proficiency bonus:
    /// ```swift
    /// if (creature.challengeRating > 7) {
    ///     // Can outright kill low-level players.
    /// }
    /// ```
    ///
    /// ## Formatting
    /// ``Challenge/FormatStyle`` formats ``challenge`` in the representation used in stat blocks:
    /// ```swift
    /// Challenge(15)
    ///     .formatted()
    /// // "15 (XP 13,000; PB +5)"
    /// ```
    public var challenge: Challenge?

    // MARK: Entry

    // MARK: Here

    public var spellcasting: [Spellcasting] = []
    public var trait: [Trait] = []

    public var actionNote: String?
    public var actionHeader: [Entry] = []
    public var action: [Action] = []

    public var bonusNote: String?
    public var bonusHeader: [Entry] = []
    public var bonus: [Action] = []

    public var reactionNote: String?
    public var reactionHeader: [Entry] = []
    public var reaction: [Action] = []

    public var legendaryGroup: LegendaryGroup? // FIXME: Name + Source
    public var legendaryActions: Int?
    public var legendaryActionsLair: Int?
    public var legendaryHeader: [Entry] = []
    public var legendary: [Action] = []

    public var mythicHeader: [Entry] = []
    public var mythic: [Action] = []

    public var footer: [Entry] = []

    /// Environments the creature may be found in.
    ///
    /// ## Formatting
    /// ``Habitat/FormatStyle`` formats ``Habitat`` in the representation used in stat blocks, and
    /// ``Habitat/ListFormatStyle`` formats the ``habitat`` set:
    /// ```swift
    /// Habitat.underdark
    ///     .formatted()
    /// // "Underdark"
    ///
    /// [
    ///     Habitat.coastal,
    ///     Habitat.desert,
    /// ]
    /// .formatted(.habitats())
    /// // "Coastal, Desert"
    /// ```
    public var habitat: Set<Habitat> = []

    /// Treasure awarded for defeating the creature.
    ///
    /// ## Formatting
    /// ``Treasure/FormatStyle`` formats ``Treasure`` in the representation used in stat blocks, and
    /// ``Treasure/ListFormatStyle`` formats the ``treasure`` set:
    /// ```swift
    /// Treasure.arcana
    ///     .formatted()
    /// // "Arcana"
    ///
    /// [
    ///     Treasure.arcana,
    ///     Treasure.relics,
    /// ]
    /// .formatted(.treasures())
    /// // "Arcana, Relics"
    /// ```
    public var treasure: Set<Treasure> = []

    /// Equipment carried.
    public var equipment: Set<Gear> = []

    public var dragonCastingColor: DragonColor?
    public var dragonAge: DragonAge?

    /// Creature can summoned as a familiar.
    public var canBeFamiliar: Bool = false

    public var summonedBySpell: String?
    public var summonedBySpellLevel: Int?
    public var summonedByClass: String?
    public var summonedScaleByPlayerLevel: Bool = false

    public var spellcastingTags: Set<SpellcastingTag> = []
    public var traitTags: Set<TraitTag> = []
    public var actionTags: Set<ActionTag> = []

    public var senseTags: Set<FifthEdition.Sense> = []
    public var languageTags: Set<LanguageTag> = []
    public var miscTags: Set<MiscTag> = []

    public var damageDealt: Set<Damage> = []
    public var damageDealtSpell: Set<Damage> = []
    public var damageDealtLegendary: Set<Damage> = []

    public var conditionInflict: Set<Condition> = []
    public var conditionInflictLegendary: Set<Condition> = []
    public var conditionInflictSpell: Set<Condition> = []

    public var savingThrowForced: Set<Ability> = []
    public var savingThrowForcedLegendary: Set<Ability> = []
    public var savingThrowForcedSpell: Set<Ability> = []

    // MARK: Media

    /// Whether the creature has a token image.
    public var hasToken: Bool = false

    /// Creator credit for token image.
    public var tokenCredit: String?

    /// Token is custom or otherwise unofficial.
    public var isTokenCustom: Bool = false

    public var token: CreatureToken?
    public var tokenHref: MediaHref?

    /// Scale applied to token in Foundry.
    public var foundryTokenScale: Float?

    public var art: [ArtItem] = [] // TODO: HERE
    public var soundClip: MediaHref?

    // TODO: brew externalSources
    // TODO: brew resource
    // TODO: brew fluff
    // TODO: brew foundryImg
    // TODO: brew foundryAdvice
    // TODO: brew foundryPrototypeToken

    // TODO: brew tokenUrl
    // TODO: brew tokenHref
    // TODO: brew tokenHref3d
    // TODO: brew foundryTokenSubjectHref
    // TODO: brew foundryTokenSubjectScale

    public var hasFluff: Bool = false
    public var hasFluffImages: Bool = false

    // TODO: _copy
    // TODO: variant
    // TODO: _versions
}

// MARK: - Here

public extension Creature {
    @MemberwiseInit(.public)
    struct Action: Codable, Equatable, Hashable, Sendable {
        @Init(label: "_")
        public var name: String
        public var entries: [Entry]
    }

    @MemberwiseInit(.public)
    struct LegendaryGroup: Codable, Equatable, Hashable, Sendable {
        public var name: String
        public var source: String
    }

    @MemberwiseInit(.public, _optionalsDefaultNil: true)
    struct Trait: Codable, Equatable, Hashable, Sendable {
        public enum TraitType: String, Codable, Sendable {
            case entries
            case inset
        }

        @Init(label: "_")
        public var name: String
        public var entries: [Entry]

        public var type: TraitType?
        public var sort: Int?
    }
}
