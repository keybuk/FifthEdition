//
//  AttributeScopes.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/7/26.
//

import Foundation

extension AttributeScopes {
    struct FifthEditionAttributes: AttributeScope {
        struct CreatureAttributes: AttributeScope {
            enum AlignmentAttribute: AttributedStringKey {
                typealias Value = Creature.Alignment
                static let name = "Creature.Alignment"
            }

            enum AlignmentAlignmentAttribute: AttributedStringKey {
                typealias Value = Creature.Alignment.Alignment
                static let name = "Creature.Alignment.Alignment"
            }

            enum ChallengeAttribute: AttributedStringKey {
                typealias Value = Creature.Challenge
                static let name = "Creature.Challenge"
            }

            enum ChallengeEncounterAttribute: AttributedStringKey {
                typealias Value = Creature.Challenge.Encounter
                static let name = "Creature.Challenge.Encounter"
            }

            enum LanguagesAttribute: AttributedStringKey {
                typealias Value = Creature.Languages
                static let name = "Creature.Languages"
            }

            enum SavingThrowsAttribute: AttributedStringKey {
                typealias Value = Creature.SavingThrows
                static let name = "Creature.SavingThrows"
            }

            enum SenseAttribute: AttributedStringKey {
                typealias Value = Creature.Sense
                static let name = "Creature.Sense"
            }

            enum SidekickAttribute: AttributedStringKey {
                typealias Value = Creature.Sidekick
                static let name = "Creature.Sidekick"
            }

            enum SidekickLevelAttribute: AttributedStringKey {
                typealias Value = Int
                static let name = "SidekickLevel"
            }

            enum SizesAttribute: AttributedStringKey {
                typealias Value = Creature.Sizes
                static let name = "Creature.Sizes"
            }

            enum SkillsAttribute: AttributedStringKey {
                typealias Value = Creature.Skills
                static let name = "Creature.Skills"
            }

            enum SpeedsAttribute: AttributedStringKey {
                typealias Value = Creature.Speeds
                static let name = "Creature.Speeds"
            }

            enum ToolsAttribute: AttributedStringKey {
                typealias Value = Creature.Tools
                static let name = "Creature.Tools"
            }

            enum TypesAttribute: AttributedStringKey {
                typealias Value = Creature.Types
                static let name = "Creature.Types"
            }

            let alignment: AlignmentAttribute
            let alignmentAlignment: AlignmentAlignmentAttribute
            let challenge: ChallengeAttribute
            let challengeEncounter: ChallengeEncounterAttribute
            let languages: LanguagesAttribute
            let savingThrows: SavingThrowsAttribute
            let sense: SenseAttribute
            let sidekick: SidekickAttribute
            let sidekickLevel: SidekickLevelAttribute
            let sizes: SizesAttribute
            let skills: SkillsAttribute
            let speeds: SpeedsAttribute
            let tools: ToolsAttribute
            let types: TypesAttribute
        }

        enum AbilityAttribute: AttributedStringKey {
            typealias Value = Ability
            static let name = "Ability"
        }

        enum AbilityModifierAttribute: AttributedStringKey {
            typealias Value = AbilityModifier
            static let name = "AbilityModifier"
        }

        enum AbilityScoreAttribute: AttributedStringKey {
            typealias Value = AbilityScore
            static let name = "AbilityScore"
        }

        enum AlignmentAttribute: AttributedStringKey {
            typealias Value = Alignment
            static let name = "Alignment"
        }

        enum ArmorClassAttribute: AttributedStringKey {
            typealias Value = ArmorClass
            static let name = "ArmorClass"
        }

        enum ChallengeRatingAttribute: AttributedStringKey {
            typealias Value = ChallengeRating
            static let name = "ChallengeRating"
        }

        enum ConditionAttribute: AttributedStringKey {
            typealias Value = Condition
            static let name = "Condition"
        }

        enum CreatureTypeAttribute: AttributedStringKey {
            typealias Value = CreatureType
            static let name = "CreatureType"
        }

        enum DamageAttribute: AttributedStringKey {
            typealias Value = Damage
            static let name = "Damage"
        }

        enum DiceAttribute: AttributedStringKey {
            typealias Value = Dice
            static let name = "Dice"
        }

        enum DiceNotationAttribute: AttributedStringKey {
            typealias Value = DiceNotation
            static let name = "DiceNotation"
        }

        enum DieAttribute: AttributedStringKey {
            typealias Value = Die
            static let name = "Die"
        }

        enum ExperiencePointsAttribute: AttributedStringKey {
            typealias Value = ExperiencePoints
            static let name = "ExperiencePoints"
        }

        enum GearAttribute: AttributedStringKey {
            typealias Value = Gear
            static let name = "Gear"
        }

        enum HabitatAttribute: AttributedStringKey {
            typealias Value = Habitat
            static let name = "Habitat"
        }

        enum HitPointsAttribute: AttributedStringKey {
            typealias Value = HitPoints
            static let name = "HitPoints"
        }

        enum LanguageAttribute: AttributedStringKey {
            typealias Value = Language
            static let name = "Language"
        }

        enum MovementAttribute: AttributedStringKey {
            typealias Value = Movement
            static let name = "Movement"
        }

        enum PassiveAttribute: AttributedStringKey {
            typealias Value = Passive
            static let name = "Passive"
        }

        enum ProficiencyBonusAttribute: AttributedStringKey {
            typealias Value = ProficiencyBonus
            static let name = "ProficiencyBonus"
        }

        enum SenseAttribute: AttributedStringKey {
            typealias Value = Sense
            static let name = "Sense"
        }

        enum SidekickTypeAttribute: AttributedStringKey {
            typealias Value = SidekickType
            static let name = "SidekickType"
        }

        enum SizeAttribute: AttributedStringKey {
            typealias Value = Size
            static let name = "Size"
        }

        enum SkillAttribute: AttributedStringKey {
            typealias Value = Skill
            static let name = "Skill"
        }

        enum SpeedAttribute: AttributedStringKey {
            typealias Value = Speed
            static let name = "Speed"
        }

        enum SusceptibleAttribute: AttributedStringKey {
            typealias Value = Susceptible
            static let name = "Susceptible"
        }

        enum TagAttribute: AttributedStringKey {
            typealias Value = Tag
            static let name = "Tag"
        }

        enum TelepathyAttribute: AttributedStringKey {
            typealias Value = Telepathy
            static let name = "Telepathy"
        }

        enum ToolAttribute: AttributedStringKey {
            typealias Value = Tool
            static let name = "Tool"
        }

        enum TreasureAttribute: AttributedStringKey {
            typealias Value = Treasure
            static let name = "Treasure"
        }

        let ability: AbilityAttribute
        let abilityModifier: AbilityModifierAttribute
        let abilityScore: AbilityScoreAttribute
        let alignment: AlignmentAttribute
        let armorClass: ArmorClassAttribute
        let challengeRating: ChallengeRatingAttribute
        let condition: ConditionAttribute
        let creatureType: CreatureTypeAttribute
        let damage: DamageAttribute
        let dice: DiceAttribute
        let diceNotation: DiceNotationAttribute
        let die: DieAttribute
        let experiencePoints: ExperiencePointsAttribute
        let gear: GearAttribute
        let habitat: HabitatAttribute
        let hitPoints: HitPointsAttribute
        let language: LanguageAttribute
        let movement: MovementAttribute
        let passive: PassiveAttribute
        let proficiencyBonus: ProficiencyBonusAttribute
        let sense: SenseAttribute
        let sidekickType: SidekickTypeAttribute
        let size: SizeAttribute
        let skill: SkillAttribute
        let speed: SpeedAttribute
        let susceptible: SusceptibleAttribute
        let tag: TagAttribute
        let telepathy: TelepathyAttribute
        let tool: ToolAttribute
        let treasure: TreasureAttribute
    }

    var fifthEditionAttributes: FifthEditionAttributes.Type {
        FifthEditionAttributes.self
    }

    var creature: FifthEditionAttributes.CreatureAttributes.Type {
        FifthEditionAttributes.CreatureAttributes.self
    }
}

extension AttributeDynamicLookup {
    subscript<T: AttributedStringKey>(dynamicMember _: KeyPath<AttributeScopes.FifthEditionAttributes, T>) -> T {
        self[T.self]
    }
}
