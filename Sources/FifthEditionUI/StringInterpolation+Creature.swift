//
//  StringInterpolation+Creature.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/14/26.
//

import FifthEdition
import SwiftUI

public extension LocalizedStringKey.StringInterpolation {
    // MARK: Alignments

    mutating func appendInterpolation(_ alignment: Creature.Alignment) {
        appendInterpolation(alignment, format: .alignment().attributed)
    }

    mutating func appendInterpolation(_ alignment: Creature.Alignment, format: Creature.Alignment.FormatStyle) {
        appendInterpolation(alignment, format: format.attributed)
    }

    mutating func appendInterpolation(_ alignment: Creature.Alignment.Alignment) {
        appendInterpolation(alignment, format: .alignment().attributed)
    }

    mutating func appendInterpolation(_ alignment: Creature.Alignment.Alignment,
                                      format: Creature.Alignment.Alignment.FormatStyle)
    {
        appendInterpolation(alignment, format: format.attributed)
    }

    // MARK: Challenge

    mutating func appendInterpolation(_ challenge: Creature.Challenge) {
        appendInterpolation(challenge, format: .challenge().attributed)
    }

    mutating func appendInterpolation(_ challenge: Creature.Challenge, format: Creature.Challenge.FormatStyle) {
        appendInterpolation(challenge, format: format.attributed)
    }

    mutating func appendInterpolation(_ encounter: Creature.Challenge.Encounter) {
        appendInterpolation(encounter, format: .challengeEncounter().attributed)
    }

    mutating func appendInterpolation(_ encounter: Creature.Challenge.Encounter,
                                      format: Creature.Challenge.Encounter.FormatStyle)
    {
        appendInterpolation(encounter, format: format.attributed)
    }

    // MARK: Languages

    mutating func appendInterpolation(_ languages: Creature.Languages) {
        appendInterpolation(languages, format: .languages().attributed)
    }

    mutating func appendInterpolation(_ languages: Creature.Languages, format: Creature.Languages.FormatStyle) {
        appendInterpolation(languages, format: format.attributed)
    }

    // MARK: SavingThrows

    mutating func appendInterpolation(_ savingThrows: Creature.SavingThrows) {
        appendInterpolation(savingThrows, format: .savingThrows().attributed)
    }

    mutating func appendInterpolation(_ savingThrows: Creature.SavingThrows,
                                      format: Creature.SavingThrows.FormatStyle)
    {
        appendInterpolation(savingThrows, format: format.attributed)
    }

    // MARK: Senses

    mutating func appendInterpolation(_ sense: Creature.Sense) {
        appendInterpolation(sense, format: .sense().attributed)
    }

    mutating func appendInterpolation(_ sense: Creature.Sense, format: Creature.Sense.FormatStyle) {
        appendInterpolation(sense, format: format.attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ senses: C) where C.Element == Creature.Sense {
        appendInterpolation(senses, format: .senses().attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ senses: C,
                                                                 format: Creature.Sense.ListFormatStyle<C>)
        where C.Element == Creature.Sense
    {
        appendInterpolation(senses, format: format.attributed)
    }

    // MARK: Sizes

    mutating func appendInterpolation(_ sizes: Creature.Sizes) {
        appendInterpolation(sizes, format: .sizes().attributed)
    }

    mutating func appendInterpolation(_ sizes: Creature.Sizes, format: Creature.Sizes.FormatStyle) {
        appendInterpolation(sizes, format: format.attributed)
    }

    // MARK: Skills

    mutating func appendInterpolation(_ skills: Creature.Skills) {
        appendInterpolation(skills, format: .skills().attributed)
    }

    mutating func appendInterpolation(_ skills: Creature.Skills, format: Creature.Skills.FormatStyle) {
        appendInterpolation(skills, format: format.attributed)
    }

    // MARK: Speeds

    mutating func appendInterpolation(_ speeds: Creature.Speeds) {
        appendInterpolation(speeds, format: .speeds().attributed)
    }

    mutating func appendInterpolation(_ speeds: Creature.Speeds, format: Creature.Speeds.FormatStyle) {
        appendInterpolation(speeds, format: format.attributed)
    }

    // MARK: Types

    mutating func appendInterpolation(_ types: Creature.Types) {
        appendInterpolation(types, format: .types().attributed)
    }

    mutating func appendInterpolation(_ types: Creature.Types, format: Creature.Types.FormatStyle) {
        appendInterpolation(types, format: format.attributed)
    }

    mutating func appendInterpolation(_ sidekick: Creature.Sidekick) {
        appendInterpolation(sidekick, format: .sidekick().attributed)
    }

    mutating func appendInterpolation(_ sidekick: Creature.Sidekick, format: Creature.Sidekick.FormatStyle) {
        appendInterpolation(sidekick, format: format.attributed)
    }

    // MARK: Tools

    mutating func appendInterpolation(_ tools: Creature.Tools) {
        appendInterpolation(tools, format: .tools().attributed)
    }

    mutating func appendInterpolation(_ tools: Creature.Tools, format: Creature.Tools.FormatStyle) {
        appendInterpolation(tools, format: format.attributed)
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("Alignment")
                .font(.headline)
                .padding(.top, 8)
            let alignment = Creature.Alignment(.anyChaotic)
            Text("\(alignment)")
            Text("\(alignment, format: .alignment(case: .lowercased))")

            let alignmentChoice = Creature.Alignment([.lawfulGood, .lawfulEvil], prefix: "Typically ")
            Text("\(alignmentChoice)")
            Text("\(alignmentChoice, format: .alignment(case: .lowercased))")

            Text("Alignment.Alignment")
                .font(.headline)
                .padding(.top, 8)
            let alignmentChance = Creature.Alignment.Alignment.alignment(.lawfulEvil, chance: 75)
            Text("\(alignmentChance)")
            Text("\(alignmentChance, format: .alignment(case: .lowercased))")

            let alignmentNote = Creature.Alignment.Alignment.alignment(.chaoticEvil, note: "when fed after midnight")
            Text("\(alignmentNote)")
            Text("\(alignmentNote, format: .alignment(case: .lowercased))")

            Text("Challenge")
                .font(.headline)
                .padding(.top, 8)
            let challenge: Creature.Challenge = 15
            Text("\(challenge)")
            Text("\(challenge, format: .challenge(detail: .expanded))")

            let challengeLairModern = Creature.Challenge(6, lair: .xp(2900))
            let challengeLairLegacy = Creature.Challenge(6, lair: .cr(7))
            Text("\(challengeLairModern)")
            Text("\(challengeLairLegacy, format: .challenge(detail: .expanded))")

            let challengeCovenModern = Creature.Challenge(6, coven: .xp(2900))
            let challengeCovenLegacy = Creature.Challenge(6, coven: .cr(7))
            Text("\(challengeCovenModern)")
            Text("\(challengeCovenLegacy, format: .challenge(detail: .expanded))")

            Text("Challenge.Encounter")
                .font(.headline)
                .padding(.top, 8)
            let encounter = Creature.Challenge.Encounter(challengeRating: 7)
            Text("\(encounter)")
            Text("\(encounter, format: .challengeEncounter(width: .wide))")

            let encounterBoth = Creature.Challenge.Encounter(challengeRating: 7, experiencePoints: 2950)
            Text("\(encounterBoth)")
            Text("\(encounterBoth, format: .challengeEncounter(width: .wide))")

            let encounterXP = Creature.Challenge.Encounter(experiencePoints: 2950)
            Text("\(encounterXP)")
            Text("\(encounterXP, format: .challengeEncounter(width: .wide))")

            Text("Languages")
                .font(.headline)
                .padding(.top, 8)
            let languages = Creature.Languages([.common, .elvish], understood: [.draconic])
            Text("\(languages)")
            Text("\(languages, format: .languages(case: .lowercased))")

            let languagesCount = Creature.Languages(spoken: 2, understood: 3)
            Text("\(languagesCount)")
            Text("\(languagesCount, format: .languages(case: .lowercased))")

            let languagesWithTelepathy = Creature.Languages([.abyssal, .infernal],
                                                            plus: 1,
                                                            note: "usually Common",
                                                            telepathy: 60)
            Text("\(languagesWithTelepathy)")
            Text("\(languagesWithTelepathy, format: .languages(case: .lowercased))")

            Text("SavingThrows")
                .font(.headline)
                .padding(.top, 8)
            let savingThrows: Creature.SavingThrows = [
                .strength: 3,
                .charisma: 4,
            ]
            Text("\(savingThrows)")
            Text("\(savingThrows, format: .savingThrows(case: .lowercased))")
            Text("\(savingThrows, format: .savingThrows(width: .standard))")

            Text("Sense")
                .font(.headline)
                .padding(.top, 8)
            let sense = Creature.Sense.sense(.darkvision, range: 120)
            Text("\(sense)")
            Text("\(sense, format: .sense(case: .lowercased))")

            let senses: Set<Creature.Sense> = [
                .sense(.blindsight, range: 60),
                .sense(.tremorsense, range: 300, note: "while raging"),
            ]
            Text("\(senses)")
            Text("\(senses, format: .senses(case: .lowercased))")

            Text("Sidekick")
                .font(.headline)
                .padding(.top, 8)
            let sidekick = Creature.Sidekick(level: 4, type: .spellcaster, tags: "wizard")
            Text("\(sidekick)")
            Text("\(sidekick, format: .sidekick(case: .lowercased))")

            Text("Sizes")
                .font(.headline)
                .padding(.top, 8)
            let size = Creature.Sizes(.huge)
            Text("\(size)")
            Text("\(size, format: .sizes(case: .lowercased))")

            let sizes = Creature.Sizes([.small, .medium], note: "depending on age")
            Text("\(sizes)")
            Text("\(sizes, format: .sizes(case: .lowercased))")

            Text("Skills")
                .font(.headline)
                .padding(.top, 8)
            let skills: Creature.Skills = [
                .deception: .modifier(4),
                .intimidation: .modifier(3),
            ]
            Text("\(skills)")
            Text("\(skills, format: .skills(case: .lowercased))")

            let otherSkills = Creature.Skills(
                [
                    .deception: .modifier(4),
                    .intimidation: .modifier(3),
                ],
                [
                    .athletics: .modifier(2),
                    .acrobatics: .modifier(2),
                ],
            )
            Text("\(otherSkills)")
            Text("\(otherSkills, format: .skills(case: .lowercased))")

            Text("Speeds")
                .font(.headline)
                .padding(.top, 8)
            let walkingSpeed: Creature.Speeds = 30
            Text("\(walkingSpeed)")
            Text("\(walkingSpeed, format: .speeds(case: .lowercased))")

            let flySpeeds = Creature.Speeds(
                [
                    .walk: [30],
                    .fly: [40],
                ],
                canHover: true,
            )
            Text("\(flySpeeds)")
            Text("\(flySpeeds, format: .speeds(case: .lowercased))")

            let alternateSpeeds: Creature.Speeds = [
                .walk: [
                    30,
                    .speed(40, condition: "(in bear form)"),
                ],
                .climb: [
                    .speed(40, condition: "(in bear form)"),
                ],
            ]
            Text("\(alternateSpeeds)")
            Text("\(alternateSpeeds, format: .speeds(case: .lowercased))")

            let chooseSpeeds = Creature.Speeds([.walk: [30]],
                                               choose: [.climb, .fly],
                                               speed: 30,
                                               note: "(DM's choice)")
            Text("\(chooseSpeeds)")
            Text("\(chooseSpeeds, format: .speeds(case: .lowercased))")

            let hiddenSpeeds = Creature.Speeds(
                [
                    .walk: [.speed(30)],
                    .climb: [.speed(40)],
                    .fly: [.speed(40)],
                ],
                hidden: [.fly],
            )
            Text("\(hiddenSpeeds)")
            Text("\(hiddenSpeeds, format: .speeds(case: .lowercased))")

            Text("Tools")
                .font(.headline)
                .padding(.top, 8)
            let tools: Creature.Tools = [
                .brewersSupplies: .modifier(2),
                .item(name: "Manacles", source: "XPHB"): .modifier(3),
            ]
            Text("\(tools)")

            Text("Types")
                .font(.headline)
                .padding(.top, 8)
            let type = Creature.Types(.aberration)
            Text("\(type)")
            Text("\(type, format: .types(case: .lowercased))")

            let types = Creature.Types([.fiend, .monstrosity], note: "depending on time of day")
            Text("\(types)")
            Text("\(types, format: .types(case: .lowercased))")

            let typeTag = Creature.Types(.dragon, tags: ["chromatic"])
            Text("\(typeTag)")
            Text("\(typeTag, format: .types(case: .lowercased))")

            let typeSwarm = Creature.Types(.beast, swarmSize: .tiny)
            Text("\(typeSwarm)")
            Text("\(typeSwarm, format: .types(case: .lowercased))")
            Text("\(typeSwarm, format: .types(case: .lowercased, size: .lowercased))")
        }
    }
    .padding()
}
