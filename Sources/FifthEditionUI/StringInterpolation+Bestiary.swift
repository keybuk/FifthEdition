//
//  StringInterpolation+Bestiary.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/14/26.
//

import FifthEdition
import SwiftUI

public extension LocalizedStringKey.StringInterpolation {
    // MARK: Ability

    mutating func appendInterpolation(_ ability: Ability) {
        appendInterpolation(ability, format: .ability().attributed)
    }

    mutating func appendInterpolation(_ ability: Ability, format: Ability.FormatStyle) {
        appendInterpolation(ability, format: format.attributed)
    }

    mutating func appendInterpolation(_ abilityModifier: AbilityModifier) {
        appendInterpolation(abilityModifier, format: .abilityModifier.attributed)
    }

    mutating func appendInterpolation(_ abilityModifier: AbilityModifier, format: AbilityModifier.FormatStyle) {
        appendInterpolation(abilityModifier, format: format.attributed)
    }

    mutating func appendInterpolation(_ abilityScore: AbilityScore) {
        appendInterpolation(abilityScore, format: .abilityScore.attributed)
    }

    mutating func appendInterpolation(_ abilityScore: AbilityScore, format: AbilityScore.FormatStyle) {
        appendInterpolation(abilityScore, format: format.attributed)
    }

    mutating func appendInterpolation(_ passive: Passive) {
        appendInterpolation(passive, format: .passive.attributed)
    }

    mutating func appendInterpolation(_ passive: Passive, format: Passive.FormatStyle) {
        appendInterpolation(passive, format: format.attributed)
    }

    mutating func appendInterpolation(_ skill: Skill) {
        appendInterpolation(skill, format: .skill().attributed)
    }

    mutating func appendInterpolation(_ skill: Skill, format: Skill.FormatStyle) {
        appendInterpolation(skill, format: format.attributed)
    }

    // MARK: Alignment

    mutating func appendInterpolation(_ alignment: FifthEdition::Alignment) {
        appendInterpolation(alignment, format: .alignment().attributed)
    }

    mutating func appendInterpolation(_ alignment: FifthEdition::Alignment,
                                      format: FifthEdition::Alignment.FormatStyle)
    {
        appendInterpolation(alignment, format: format.attributed)
    }

    // MARK: Armor

    mutating func appendInterpolation(_ armorClass: ArmorClass) {
        appendInterpolation(armorClass, format: .armorClass.attributed)
    }

    mutating func appendInterpolation(_ armorClass: ArmorClass, format: ArmorClass.FormatStyle) {
        appendInterpolation(armorClass, format: format.attributed)
    }

    mutating func appendInterpolation<S: Sequence & Equatable>(_ armorClass: S) where S.Element == ArmorClass {
        appendInterpolation(armorClass, format: .armorClasses().attributed)
    }

    mutating func appendInterpolation<S: Sequence & Equatable>(_ armorClass: S, format: ArmorClass.ListFormatStyle<S>)
        where S.Element == ArmorClass
    {
        appendInterpolation(armorClass, format: format.attributed)
    }

    mutating func appendInterpolation(_ hitPoints: HitPoints) {
        appendInterpolation(hitPoints, format: .hitPoints.attributed)
    }

    mutating func appendInterpolation(_ hitPoints: HitPoints, format: HitPoints.FormatStyle) {
        appendInterpolation(hitPoints, format: format.attributed)
    }

    // MARK: ChallengeRating

    mutating func appendInterpolation(_ challengeRating: ChallengeRating) {
        appendInterpolation(challengeRating, format: .challengeRating.attributed)
    }

    mutating func appendInterpolation(_ challengeRating: ChallengeRating, format: ChallengeRating.FormatStyle) {
        appendInterpolation(challengeRating, format: format.attributed)
    }

    mutating func appendInterpolation(_ experiencePoints: ExperiencePoints) {
        appendInterpolation(experiencePoints, format: .experiencePoints.attributed)
    }

    mutating func appendInterpolation(_ experiencePoints: ExperiencePoints, format: ExperiencePoints.FormatStyle) {
        appendInterpolation(experiencePoints, format: format.attributed)
    }

    mutating func appendInterpolation(_ proficiencyBonus: ProficiencyBonus) {
        appendInterpolation(proficiencyBonus, format: .proficiencyBonus.attributed)
    }

    mutating func appendInterpolation(_ proficiencyBonus: ProficiencyBonus, format: ProficiencyBonus.FormatStyle) {
        appendInterpolation(proficiencyBonus, format: format.attributed)
    }

    // MARK: CreatureType

    mutating func appendInterpolation(_ creatureType: CreatureType) {
        appendInterpolation(creatureType, format: .creatureType().attributed)
    }

    mutating func appendInterpolation(_ creatureType: CreatureType, format: CreatureType.FormatStyle) {
        appendInterpolation(creatureType, format: format.attributed)
    }

    mutating func appendInterpolation(_ sidekickType: SidekickType) {
        appendInterpolation(sidekickType, format: .sidekickType().attributed)
    }

    mutating func appendInterpolation(_ sidekickType: SidekickType, format: SidekickType.FormatStyle) {
        appendInterpolation(sidekickType, format: format.attributed)
    }

    mutating func appendInterpolation(_ tag: Tag) {
        appendInterpolation(tag, format: .tag().attributed)
    }

    mutating func appendInterpolation(_ tag: Tag, format: Tag.FormatStyle) {
        appendInterpolation(tag, format: format.attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ tags: C) where C.Element == Tag {
        appendInterpolation(tags, format: .tags().attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ tags: C, format: Tag.ListFormatStyle<C>)
        where C.Element == Tag
    {
        appendInterpolation(tags, format: format.attributed)
    }

    // MARK: Language

    mutating func appendInterpolation(_ language: Language) {
        appendInterpolation(language, format: .language().attributed)
    }

    mutating func appendInterpolation(_ language: Language, format: Language.FormatStyle) {
        appendInterpolation(language, format: format.attributed)
    }

    mutating func appendInterpolation(_ telepathy: Telepathy) {
        appendInterpolation(telepathy, format: .telepathy.attributed)
    }

    mutating func appendInterpolation(_ telepathy: Telepathy, format: Telepathy.FormatStyle) {
        appendInterpolation(telepathy, format: format.attributed)
    }

    // MARK: Resource

    mutating func appendInterpolation(_ gear: Gear) {
        appendInterpolation(gear, format: .gear.attributed)
    }

    mutating func appendInterpolation(_ gear: Gear, format: Gear.FormatStyle) {
        appendInterpolation(gear, format: format.attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ gear: C) where C.Element == Gear {
        appendInterpolation(gear, format: .gears().attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ gear: C, format: Gear.ListFormatStyle<C>)
        where C.Element == Gear
    {
        appendInterpolation(gear, format: format.attributed)
    }

    mutating func appendInterpolation(_ habitat: Habitat) {
        appendInterpolation(habitat, format: .habitat.attributed)
    }

    mutating func appendInterpolation(_ habitat: Habitat, format: Habitat.FormatStyle) {
        appendInterpolation(habitat, format: format.attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ habitat: C) where C.Element == Habitat {
        appendInterpolation(habitat, format: .habitats().attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ habitat: C, format: Habitat.ListFormatStyle<C>)
        where C.Element == Habitat
    {
        appendInterpolation(habitat, format: format.attributed)
    }

    mutating func appendInterpolation(_ tool: Tool) {
        appendInterpolation(tool, format: .tool().attributed)
    }

    mutating func appendInterpolation(_ tool: Tool, format: Tool.FormatStyle) {
        appendInterpolation(tool, format: format.attributed)
    }

    mutating func appendInterpolation(_ treasure: Treasure) {
        appendInterpolation(treasure, format: .treasure.attributed)
    }

    mutating func appendInterpolation(_ treasure: Treasure, format: Treasure.FormatStyle) {
        appendInterpolation(treasure, format: format.attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ treasure: C) where C.Element == Treasure {
        appendInterpolation(treasure, format: .treasures().attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ treasure: C, format: Treasure.ListFormatStyle<C>)
        where C.Element == Treasure
    {
        appendInterpolation(treasure, format: format.attributed)
    }

    // MARK: Sense

    mutating func appendInterpolation(_ sense: Sense) {
        appendInterpolation(sense, format: .sense().attributed)
    }

    mutating func appendInterpolation(_ sense: Sense, format: Sense.FormatStyle) {
        appendInterpolation(sense, format: format.attributed)
    }

    // MARK: Size

    mutating func appendInterpolation(_ size: Size) {
        appendInterpolation(size, format: .size().attributed)
    }

    mutating func appendInterpolation(_ size: Size, format: Size.FormatStyle) {
        appendInterpolation(size, format: format.attributed)
    }

    // MARK: Speed

    mutating func appendInterpolation(_ movement: Movement) {
        appendInterpolation(movement, format: .movement().attributed)
    }

    mutating func appendInterpolation(_ movement: Movement, format: Movement.FormatStyle) {
        appendInterpolation(movement, format: format.attributed)
    }

    mutating func appendInterpolation(_ speed: Speed) {
        appendInterpolation(speed, format: .speed.attributed)
    }

    mutating func appendInterpolation(_ speed: Speed, format: Speed.FormatStyle) {
        appendInterpolation(speed, format: format.attributed)
    }

    // MARK: Susceptible

    mutating func appendInterpolation(_ condition: Condition) {
        appendInterpolation(condition, format: .condition().attributed)
    }

    mutating func appendInterpolation(_ condition: Condition, format: Condition.FormatStyle) {
        appendInterpolation(condition, format: format.attributed)
    }

    mutating func appendInterpolation(_ damage: Damage) {
        appendInterpolation(damage, format: .damage().attributed)
    }

    mutating func appendInterpolation(_ damage: Damage, format: Damage.FormatStyle) {
        appendInterpolation(damage, format: format.attributed)
    }

    mutating func appendInterpolation(_ susceptible: Susceptible) {
        appendInterpolation(susceptible, format: .susceptible().attributed)
    }

    mutating func appendInterpolation(_ susceptible: Susceptible, format: Susceptible.FormatStyle) {
        appendInterpolation(susceptible, format: format.attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ susceptible: C) where C.Element == Susceptible {
        appendInterpolation(susceptible, format: .susceptibles().attributed)
    }

    mutating func appendInterpolation<C: Collection & Equatable>(_ susceptible: C,
                                                                 format: Susceptible.ListFormatStyle<C>)
        where C.Element == Susceptible
    {
        appendInterpolation(susceptible, format: format.attributed)
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("Ability")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Ability.charisma)")
            Text("\(.charisma, format: .ability(case: .lowercased))")
            Text("\(.charisma, format: .ability(width: .short))")
            Text("\(.charisma, format: .ability(case: .uppercased))")
            Text("\(.charisma, format: .ability(case: .uppercased, width: .short))")

            Text("AbilityModifier")
                .font(.headline)
                .padding(.top, 8)
            Text("\(AbilityModifier.modifier(4))")
            Text("\(AbilityModifier.modifier(0))")
            Text("\(AbilityModifier.modifier(-1))")

            Text("AbilityScore")
                .font(.headline)
                .padding(.top, 8)
            Text("\(AbilityScore.score(15))")

            Text("Passive")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Passive.passive(13))")

            Text("Skill")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Skill.sleightOfHand)")
            Text("\(.sleightOfHand, format: .skill(case: .lowercased))")

            Divider()

            Text("Alignment")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Alignment.chaoticGood)")
            Text("\(Alignment.chaoticGood, format: .alignment(case: .lowercased))")

            Divider()

            Text("ArmorClass")
                .font(.headline)
                .padding(.top, 8)
            Text("\(ArmorClass.ac(12))")
            Text("\(ArmorClass.ac(12, from: ["natural armor"]))")
            Text("\(ArmorClass.ac(12, condition: "in bear form"))")

            let armorClass: [ArmorClass] = [
                .ac(12, from: ["natural armor"]),
                .ac(14, condition: "in dim light", inParens: true),
            ]
            Text("\(armorClass)")

            Text("HitPoints")
                .font(.headline)
                .padding(.top, 8)
            Text("\(HitPoints.hp(DiceNotation(.d6, count: 4, modifier: 10)))")

            Divider()

            Text("ChallengeRating")
                .font(.headline)
                .padding(.top, 8)
            Text("\(ChallengeRating.cr(0))")
            Text("\(ChallengeRating.cr(1 / 2))")
            Text("\(ChallengeRating.cr(5))")

            Text("ExperiencePoints")
                .font(.headline)
                .padding(.top, 8)
            Text("\(ExperiencePoints.xp(13000))")

            Text("ProficiencyBonus")
                .font(.headline)
                .padding(.top, 8)
            Text("\(ProficiencyBonus.bonus(6))")

            Divider()

            Text("CreatureType")
                .font(.headline)
                .padding(.top, 8)
            Text("\(CreatureType.monstrosity)")
            Text("\(.monstrosity, format: .creatureType(case: .lowercased))")
            Text("\(.monstrosity, format: .creatureType(form: .plural))")
            Text("\(.monstrosity, format: .creatureType(case: .lowercased, form: .plural))")

            Text("SidekickType")
                .font(.headline)
                .padding(.top, 8)
            Text("\(SidekickType.spellcaster)")
            Text("\(SidekickType.spellcaster, format: .sidekickType(case: .lowercased))")

            Text("Tag")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Tag("human"))")
            Text("\(Tag("human"), format: .tag(case: .lowercased))")

            Text("\(Tag("human", prefix: "chondathan"))")
            Text("\(Tag("human", prefix: "chondathan"), format: .tag(case: .lowercased))")

            let tags: Set<Tag> = [
                Tag("dragon", prefix: "chromatic", isHidden: true),
                Tag("shapechanger"),
            ]
            Text("\(tags)")
            Text("\(tags, format: .tags(case: .lowercased))")

            Divider()

            Text("Language")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Language.thievesCant)")
            Text("\(.thievesCant, format: .language(case: .lowercased))")

            Text("Telepathy")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Telepathy.telepathy(range: 60))")
            Text("\(Telepathy.telepathy(range: 120, note: "(only with its summoner)"))")

            Divider()

            Text("Gear")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Gear(name: "Manacles", source: "XPHB"))")
            Text("\(Gear(name: "Dagger", source: "XPHB", quantity: 2))")

            let gear: Set<Gear> = [
                Gear(name: "Dagger", source: "XPHB", quantity: 2),
                Gear(name: "Longsword", source: "XPHB"),
                Gear(name: "Shortbow", source: "XPHB"),
            ]
            Text("\(gear)")

            Text("Habitat")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Habitat.desert)")

            let habitat: Set<Habitat> = [.underdark, .planarAir]
            Text("\(habitat)")

            Text("Tool")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Tool.brewersSupplies)")
            Text("\(Tool.item(name: "Manacles", source: "XPHB"))")

            Text("Treasure")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Treasure.arcana)")

            let treasure: Set<Treasure> = [.arcana, .relics]
            Text("\(treasure)")

            Divider()

            Text("Sense")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Sense.blindsight)")
            Text("\(.blindsight, format: .sense(case: .lowercased))")

            Divider()

            Text("Size")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Size.medium)")
            Text("\(.medium, format: .size(case: .lowercased))")

            Divider()

            Text("Movement")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Movement.fly)")
            Text("\(.fly, format: .movement(case: .lowercased))")

            Text("Speed")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Speed.speed(30))")
            Text("\(Speed.speed(40, condition: "(in bear form)"))")
            Text("\(Speed.walkingSpeed)")

            Divider()

            Text("Condition")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Condition.blinded)")
            Text("\(.blinded, format: .condition(case: .lowercased))")

            Text("Damage")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Damage.necrotic)")
            Text("\(.necrotic, format: .damage(case: .lowercased))")

            Text("Susceptible")
                .font(.headline)
                .padding(.top, 8)
            Text("\(Susceptible.susceptible([.condition(.blinded)]))")
            Text("\(.susceptible([.condition(.blinded)]), format: .susceptible(case: .lowercased))")

            let susceptible = Susceptible.susceptible(
                [
                    .damage(.bludgeoning),
                    .damage(.piercing),
                    .damage(.slashing),
                ],
                note: "from nonmagical weapons that aren't silvered",
                isConditional: true,
            )
            Text("\(susceptible)")
            Text("\(susceptible, format: .susceptible(case: .lowercased))")

            let susceptibles: Set<Susceptible> = [
                .damage(.cold),
                .damage(.fire),
                susceptible,
            ]
            Text("\(susceptibles)")
            Text("\(susceptibles, format: .susceptibles(case: .lowercased))")
        }
    }
    .padding()
}
