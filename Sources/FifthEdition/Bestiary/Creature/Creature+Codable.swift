//
//  Creature+Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

extension Creature: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case shortNameForm = "shortName"
        case alias
        case group // TODO: null
        case level
        case size
        case sizeNote
        case type
        case source
        case sourceHover = "sourceSub"
        case otherSources
        case referenceSources
        case reprintedAs
        case hasReprint = "isReprinted"
        case alignment
        case alignmentPrefix
        case armorClass = "ac"
        case hitPoints = "hp"
        case speeds = "speed"
        case initiative
        case str // TODO: null
        case dex // TODO: null
        case con // TODO: null
        case int // TODO: null
        case wis // TODO: null
        case cha // TODO: null
        case savingThrows = "save"
        case skills = "skill"
        case tools = "tool"
        case gear
        case senses // TODO: null
        case passivePerception = "passive" // TODO: null
        case languages // TODO: null
        case proficiencyBonus = "pbNote"
        case challenge = "cr"
        case damageVulnerabilities = "vulnerable" // TODO: null
        case damageResistances = "resist" // TODO: null
        case damageImmunities = "immune" // TODO: null
        case conditionImmunities = "conditionImmune" // TODO: null

        // MARK: Here

        case spellcasting // TODO: null
        case trait // TODO: null
        case actionNote
        case actionHeader
        case action // TODO: null
        case bonusNote
        case bonusHeader
        case bonus // TODO: null
        case reactionNote
        case reactionHeader
        case reaction // TODO: null
        case legendaryGroup
        case legendaryActions
        case legendaryActionsLair
        case legendaryHeader
        case legendary // TODO: null
        case mythicHeader
        case mythic // TODO: null

        // TODO: variant

        // DONE
        case page
        case canBeFamiliar = "familiar"
        case additionalSources

        case hasToken
        case tokenCredit
        case isTokenCustom = "tokenCustom"
        case foundryTokenScale
        case art = "altArt"
        // TODO: brew externalSources
        // TODO: brew resource
        // TODO: brew fluff
        // TODO: brew foundryImg
        // TODO: brew foundryAdvice
        // TODO: brew foundryPrototypeToken
        case token
        // TODO: brew tokenUrl
        // TODO: brew tokenHref
        // TODO: brew tokenHref3d
        // TODO: brew foundryTokenSubjectHref
        // TODO: brew foundryTokenSubjectScale
        case tokenHref
        case isNamedCreature
        case isNPC
        case habitat = "environment"
        case treasure
        case soundClip
        case dragonCastingColor
        case dragonAge
        case traitTags
        case actionTags
        case languageTags
        case senseTags
        case spellcastingTags
        case damageDealt = "damageTags"
        case damageDealtLegendary = "damageTagsLegendary"
        case damageDealtSpell = "damageTagsSpell"
        case miscTags
        case equipment = "attachedItems"
        case conditionInflict
        case conditionInflictLegendary
        case conditionInflictSpell
        case savingThrowForced
        case savingThrowForcedLegendary
        case savingThrowForcedSpell
        case footer

        case srd
        case srd52
        case basicRules
        case basicRules2024
        // isLegacy omitted as not in data.

        case summonedBySpell
        case summonedBySpellLevel
        case summonedByClass
        case summonedScaleByPlayerLevel
        // _isCopy omitted as internal only.
        // TODO: _versions
        case hasFluff
        case hasFluffImages
    }

    enum TypeCodingKeys: String, CodingKey {
        case type
        case swarmSize
        case tags
        case sidekickType
        case sidekickTags
        case sidekickHidden
        case note
    }

    enum ChooseCodingKeys: String, CodingKey {
        case choose
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        shortNameForm = try container.decodeIfPresent(ShortName.self, forKey: .shortNameForm)
        group = try container.decodeIfPresent(Set<String>.self, forKey: .group) ?? []
        alias = try container.decodeIfPresent(Set<String>.self, forKey: .alias) ?? []
        size.sizes = try container.decodeIfPresent(Set<Size>.self, forKey: .size) ?? []
        size.note = try container.decodeIfPresent(String.self, forKey: .sizeNote)

        // type is an object or a CreatureType string, initializing both type and sidekick properties.
        if let _ = try? container.decode(String.self, forKey: .type) {
            type = try Types(container.decode(CreatureType.self, forKey: .type))
        } else if container.contains(.type) {
            let nestedContainer = try container.nestedContainer(keyedBy: TypeCodingKeys.self, forKey: .type)
            // type is an object containing an array of CreatureType or a CreatureType string.
            if let value = try? nestedContainer.decode(CreatureType.self, forKey: .type) {
                type = Types(value)
            } else {
                let chooseContainer = try nestedContainer.nestedContainer(keyedBy: ChooseCodingKeys.self, forKey: .type)
                type = try Types(chooseContainer.decode(
                    Set<CreatureType>.self,
                    forKey: .choose,
                ))
            }

            type.swarmSize = try nestedContainer.decodeIfPresent(Size.self, forKey: .swarmSize)
            type.tags = try nestedContainer.decodeIfPresent(Set<Tag>.self, forKey: .tags) ?? []
            type.note = try nestedContainer.decodeIfPresent(String.self, forKey: .note)

            // sidekick fields set Sidekick properties.
            if nestedContainer.contains(.sidekickType) || nestedContainer.contains(.sidekickTags) || nestedContainer
                .contains(.sidekickHidden)
            {
                sidekick = try Sidekick(type: nestedContainer.decodeIfPresent(SidekickType.self, forKey: .sidekickType),
                                        isHidden: nestedContainer
                                            .decodeIfPresent(Bool.self, forKey: .sidekickHidden) ?? false)
                sidekick!.tags = try nestedContainer.decodeIfPresent(Set<Tag>.self, forKey: .sidekickTags) ?? []
            }
        }

        // level is a value stored in the Sidekick type.
        if let level = try container.decodeIfPresent(Int.self, forKey: .level) {
            if sidekick != nil {
                sidekick?.level = level
            } else {
                sidekick = Sidekick(level: level)
            }
        }

        source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        sourceHover = try container.decodeIfPresent(String.self, forKey: .sourceHover)
        otherSources = try container.decodeIfPresent(Set<Source>.self, forKey: .otherSources) ?? []
        referenceSources = try container.decodeIfPresent(Set<String>.self, forKey: .referenceSources) ?? []
        reprintedAs = try container.decodeIfPresent(Set<Reprint>.self, forKey: .reprintedAs) ?? []
        hasReprint = try container.decodeIfPresent(Bool.self, forKey: .hasReprint) ?? false
        alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? []
        alignment.prefix = try container.decodeIfPresent(String.self, forKey: .alignmentPrefix)
        armorClass = try container.decodeIfPresent([ArmorClass].self, forKey: .armorClass) ?? []
        hitPoints = try container.decodeIfPresent(HitPoints.self, forKey: .hitPoints)
        speeds = try container.decodeIfPresent(Speeds.self, forKey: .speeds) ?? [:]
        initiative = try container.decodeIfPresent(Initiative.self, forKey: .initiative)
        abilities[.strength] = try container.decodeIfPresent(AbilityScore.self, forKey: .str)
        abilities[.dexterity] = try container.decodeIfPresent(AbilityScore.self, forKey: .dex)
        abilities[.constitution] = try container.decodeIfPresent(AbilityScore.self, forKey: .con)
        abilities[.intelligence] = try container.decodeIfPresent(AbilityScore.self, forKey: .int)
        abilities[.wisdom] = try container.decodeIfPresent(AbilityScore.self, forKey: .wis)
        abilities[.charisma] = try container.decodeIfPresent(AbilityScore.self, forKey: .cha)
        savingThrows = try container.decodeIfPresent(SavingThrows.self, forKey: .savingThrows) ?? [:]
        skills = try container.decodeIfPresent(Skills.self, forKey: .skills) ?? [:]
        tools = try container.decodeIfPresent(Tools.self, forKey: .tools) ?? [:]
        gear = try container.decodeIfPresent(Set<Gear>.self, forKey: .gear) ?? []
        senses = try container.decodeIfPresent(Set<Sense>.self, forKey: .senses) ?? []
        passivePerception = try container.decodeIfPresent(Passive.self, forKey: .passivePerception)
        languages = try container.decodeIfPresent(Languages.self, forKey: .languages) ?? []
        challenge = try container.decodeIfPresent(Challenge.self, forKey: .challenge)

        if let proficiencyBonus = try container.decodeIfPresent(ProficiencyBonus.self, forKey: .proficiencyBonus) {
            if challenge != nil {
                challenge?.proficiencyBonus = proficiencyBonus
            } else {
                challenge = Challenge(proficiencyBonus: proficiencyBonus)
            }
        }

        // TODO: handle the null value case properly
        damageVulnerabilities = try (container.decodeIfPresent(Set<Susceptible>?.self,
                                                               forKey: .damageVulnerabilities,
                                                               configuration: .damageVulnerability) ?? []) ?? []
        damageResistances = try (container.decodeIfPresent(Set<Susceptible>?.self,
                                                           forKey: .damageResistances,
                                                           configuration: .damageResistance) ?? []) ?? []
        damageImmunities = try (container.decodeIfPresent(Set<Susceptible>?.self,
                                                          forKey: .damageImmunities,
                                                          configuration: .damageImmunity) ?? []) ?? []
        conditionImmunities = try (container.decodeIfPresent(Set<Susceptible>?.self,
                                                             forKey: .conditionImmunities,
                                                             configuration: .conditionImmunity) ?? []) ?? []

        // MARK: Here

        conditionInflict = try container.decodeIfPresent(Set<Condition>.self, forKey: .conditionInflict) ?? []
        conditionInflictLegendary = try container.decodeIfPresent(Set<Condition>.self,
                                                                  forKey: .conditionInflictLegendary) ?? []
        conditionInflictSpell = try container.decodeIfPresent(Set<Condition>.self, forKey: .conditionInflictSpell) ?? []
        savingThrowForced = try container.decodeIfPresent(Set<Ability>.self, forKey: .savingThrowForced) ?? []
        savingThrowForcedLegendary = try container.decodeIfPresent(Set<Ability>.self,
                                                                   forKey: .savingThrowForcedLegendary) ?? []
        savingThrowForcedSpell = try container.decodeIfPresent(Set<Ability>.self, forKey: .savingThrowForcedSpell) ?? []
        damageDealt = try container.decodeIfPresent(AlternateSetCoding<Damage>.self, forKey: .damageDealt)?.value ?? []
        damageDealtLegendary = try container.decodeIfPresent(AlternateSetCoding<Damage>.self,
                                                             forKey: .damageDealtLegendary)?.value ?? []
        damageDealtSpell = try container.decodeIfPresent(AlternateSetCoding<Damage>.self,
                                                         forKey: .damageDealtSpell)?
            .value ?? []
        habitat = try container.decodeIfPresent(Set<Habitat>.self, forKey: .habitat) ?? []
        spellcasting = try container.decodeIfPresent([Spellcasting].self, forKey: .spellcasting) ?? []
        trait = try container.decodeIfPresent([Trait].self, forKey: .trait) ?? []
        actionNote = try container.decodeIfPresent(String.self, forKey: .actionNote)
        actionHeader = try container.decodeIfPresent([Entry].self, forKey: .actionHeader) ?? []
        action = try container.decodeIfPresent([Action].self, forKey: .action) ?? []
        bonusNote = try container.decodeIfPresent(String.self, forKey: .bonusNote)
        bonusHeader = try container.decodeIfPresent([Entry].self, forKey: .bonusHeader) ?? []
        bonus = try container.decodeIfPresent([Action].self, forKey: .bonus) ?? []
        reactionNote = try container.decodeIfPresent(String.self, forKey: .reactionNote)
        reactionHeader = try container.decodeIfPresent([Entry].self, forKey: .reactionHeader) ?? []
        reaction = try container.decodeIfPresent([Action].self, forKey: .reaction) ?? []
        legendaryGroup = try container.decodeIfPresent(LegendaryGroup.self, forKey: .legendaryGroup)
        legendaryActions = try container.decodeIfPresent(Int.self, forKey: .legendaryActions)
        legendaryActionsLair = try container.decodeIfPresent(Int.self, forKey: .legendaryActionsLair)
        legendaryHeader = try container.decodeIfPresent([Entry].self, forKey: .legendaryHeader) ?? []
        legendary = try container.decodeIfPresent([Action].self, forKey: .legendary) ?? []
        mythicHeader = try container.decodeIfPresent([Entry].self, forKey: .mythicHeader) ?? []
        mythic = try container.decodeIfPresent([Action].self, forKey: .mythic) ?? []
        footer = try container.decodeIfPresent([Entry].self, forKey: .footer) ?? []
        equipment = try container.decodeIfPresent(Set<Gear>.self, forKey: .equipment) ?? []
        treasure = try container.decodeIfPresent(Set<Treasure>.self, forKey: .treasure) ?? []
        actionTags = try container.decodeIfPresent(Set<ActionTag>.self, forKey: .actionTags) ?? []
        languageTags = try container.decodeIfPresent(AlternateSetCoding<LanguageTag>.self, forKey: .languageTags)?
            .value ?? []
        miscTags = try container.decodeIfPresent(AlternateSetCoding<MiscTag>.self, forKey: .miscTags)?.value ?? []
        senseTags = try container.decodeIfPresent(Set<FifthEdition.Sense>.self, forKey: .senseTags) ?? []
        spellcastingTags = try container.decodeIfPresent(AlternateSetCoding<SpellcastingTag>.self,
                                                         forKey: .spellcastingTags)?.value ?? []
        traitTags = try container.decodeIfPresent(Set<TraitTag>.self, forKey: .traitTags) ?? []
        dragonCastingColor = try container.decodeIfPresent(DragonColor.self, forKey: .dragonCastingColor)
        dragonAge = try container.decodeIfPresent(DragonAge.self, forKey: .dragonAge)

        // DONE:
        page = try container.decodeIfPresent(Page.self, forKey: .page)
        canBeFamiliar = try container.decodeIfPresent(Bool.self, forKey: .canBeFamiliar) ?? false
        additionalSources = try container.decodeIfPresent(Set<Source>.self, forKey: .additionalSources) ?? []
        isNamedCreature = try container.decodeIfPresent(Bool.self, forKey: .isNamedCreature) ?? false
        isNPC = try container.decodeIfPresent(Bool.self, forKey: .isNPC) ?? false
        hasToken = try container.decodeIfPresent(Bool.self, forKey: .hasToken) ?? false

        token = try container.decodeIfPresent(CreatureToken.self, forKey: .token)
        tokenHref = try container.decodeIfPresent(MediaHref.self, forKey: .tokenHref)
        tokenCredit = try container.decodeIfPresent(String.self, forKey: .tokenCredit)
        isTokenCustom = try container.decodeIfPresent(Bool.self, forKey: .isTokenCustom) ?? false
        foundryTokenScale = try container.decodeIfPresent(Float.self, forKey: .foundryTokenScale)
        art = try container.decodeIfPresent([ArtItem].self, forKey: .art) ?? []
        soundClip = try container.decodeIfPresent(MediaHref.self, forKey: .soundClip)

        // DONE:
        srd = try container.decodeIfPresent(Reference.self, forKey: .srd)
        srd52 = try container.decodeIfPresent(Reference.self, forKey: .srd52)
        basicRules = try container.decodeIfPresent(Reference.self, forKey: .basicRules)
        basicRules2024 = try container.decodeIfPresent(Reference.self, forKey: .basicRules2024)

        summonedBySpell = try container.decodeIfPresent(String.self, forKey: .summonedBySpell)
        summonedBySpellLevel = try container.decodeIfPresent(Int.self, forKey: .summonedBySpellLevel)
        summonedByClass = try container.decodeIfPresent(String.self, forKey: .summonedByClass)
        summonedScaleByPlayerLevel = try container
            .decodeIfPresent(Bool.self, forKey: .summonedScaleByPlayerLevel) ?? false

        hasFluff = try container.decodeIfPresent(Bool.self, forKey: .hasFluff) ?? false
        hasFluffImages = try container.decodeIfPresent(Bool.self, forKey: .hasFluffImages) ?? false
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(shortNameForm, forKey: .shortNameForm)
        try container.encodeIfPresent(!alias.isEmpty ? alias : nil, forKey: .alias)
        try container.encodeIfPresent(!group.isEmpty ? group : nil, forKey: .group)
        try container.encodeIfPresent(!size.sizes.isEmpty ? size.sizes : nil, forKey: .size)
        try container.encodeIfPresent(size.note, forKey: .sizeNote)

        // CreatureType is encoded as a single CreatureType, or together with Sidekick in the type object.
        if type.types.count == 1, type.swarmSize == nil, type.tags.isEmpty, type.note == nil,
           sidekick?.type == nil, sidekick?.tags.isEmpty ?? true, !(sidekick?.isHidden == true)
        {
            try container.encode(type.types.first, forKey: .type)
        } else {
            var nestedContainer = container.nestedContainer(keyedBy: TypeCodingKeys.self, forKey: .type)
            // type is encoded as a single CreatureType, or an object containing an array of CreatureType.
            if type.types.count == 1 {
                try nestedContainer.encode(type.types.first, forKey: .type)
            } else {
                var chooseContainer = nestedContainer.nestedContainer(keyedBy: ChooseCodingKeys.self, forKey: .type)
                try chooseContainer.encode(type.types, forKey: .choose)
            }

            try nestedContainer.encodeIfPresent(type.swarmSize, forKey: .swarmSize)
            try nestedContainer.encodeIfPresent(!type.tags.isEmpty ? type.tags : nil, forKey: .tags)
            try nestedContainer.encodeIfPresent(type.note, forKey: .note)

            // Sidekick fields are encoded in type object,
            if let sidekick {
                try nestedContainer.encodeIfPresent(sidekick.type, forKey: .sidekickType)
                try nestedContainer.encodeIfPresent(!sidekick.tags.isEmpty ? sidekick.tags : nil, forKey: .sidekickTags)
                try nestedContainer.encodeIfPresent(sidekick.isHidden ? true : nil, forKey: .sidekickHidden)
            }
        }

        try container.encodeIfPresent(sidekick?.level, forKey: .level)

        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(sourceHover, forKey: .sourceHover)
        try container.encodeIfPresent(!otherSources.isEmpty ? otherSources : nil, forKey: .otherSources)
        try container.encodeIfPresent(!referenceSources.isEmpty ? referenceSources : nil, forKey: .referenceSources)
        try container.encodeIfPresent(!reprintedAs.isEmpty ? reprintedAs : nil, forKey: .reprintedAs)
        try container.encodeIfPresent(hasReprint ? true : nil, forKey: .hasReprint)
        try container.encodeIfPresent(!alignment.isEmpty ? alignment : nil, forKey: .alignment)
        try container.encodeIfPresent(alignment.prefix, forKey: .alignmentPrefix)
        try container.encodeIfPresent(!armorClass.isEmpty ? armorClass : nil, forKey: .armorClass)
        try container.encodeIfPresent(hitPoints, forKey: .hitPoints)
        try container.encodeIfPresent(speeds, forKey: .speeds)
        try container.encodeIfPresent(initiative, forKey: .initiative)
        try container.encodeIfPresent(abilities[.strength], forKey: .str)
        try container.encodeIfPresent(abilities[.dexterity], forKey: .dex)
        try container.encodeIfPresent(abilities[.constitution], forKey: .con)
        try container.encodeIfPresent(abilities[.intelligence], forKey: .int)
        try container.encodeIfPresent(abilities[.wisdom], forKey: .wis)
        try container.encodeIfPresent(abilities[.charisma], forKey: .cha)
        try container.encodeIfPresent(!savingThrows.isEmpty ? savingThrows : nil, forKey: .savingThrows)
        try container.encodeIfPresent(!skills.isEmpty ? skills : nil, forKey: .skills)
        try container.encodeIfPresent(!tools.isEmpty ? tools : nil, forKey: .tools)
        try container.encodeIfPresent(!gear.isEmpty ? gear : nil, forKey: .gear)
        try container.encodeIfPresent(!senses.isEmpty ? senses : nil, forKey: .senses)
        try container.encodeIfPresent(passivePerception, forKey: .passivePerception)
        try container.encodeIfPresent(!languages.isEmpty ? languages : nil, forKey: .languages)
        if challenge?.encounter != nil || challenge?.lair != nil || challenge?.coven != nil {
            try container.encodeIfPresent(challenge, forKey: .challenge)
        }
        try container.encodeIfPresent(challenge?.proficiencyBonus, forKey: .proficiencyBonus)
        try container.encodeIfPresent(!damageVulnerabilities.isEmpty ? damageVulnerabilities : nil,
                                      forKey: .damageVulnerabilities,
                                      configuration: .damageVulnerability)
        try container.encodeIfPresent(!damageResistances.isEmpty ? damageResistances : nil,
                                      forKey: .damageResistances,
                                      configuration: .damageResistance)
        try container.encodeIfPresent(!damageImmunities.isEmpty ? damageImmunities : nil,
                                      forKey: .damageImmunities,
                                      configuration: .damageImmunity)
        try container.encodeIfPresent(!conditionImmunities.isEmpty ? conditionImmunities : nil,
                                      forKey: .conditionImmunities,
                                      configuration: .conditionImmunity)

        // MARK: Here

        try container.encodeIfPresent(!conditionInflict.isEmpty ? conditionInflict : nil, forKey: .conditionInflict)
        try container.encodeIfPresent(
            !conditionInflictLegendary.isEmpty ? conditionInflictLegendary : nil,
            forKey: .conditionInflictLegendary,
        )
        try container.encodeIfPresent(
            !conditionInflictSpell.isEmpty ? conditionInflictSpell : nil,
            forKey: .conditionInflictSpell,
        )
        try container.encodeIfPresent(!savingThrowForced.isEmpty ? savingThrowForced : nil, forKey: .savingThrowForced)
        try container.encodeIfPresent(
            !savingThrowForcedLegendary.isEmpty ? savingThrowForcedLegendary : nil,
            forKey: .savingThrowForcedLegendary,
        )
        try container.encodeIfPresent(
            !savingThrowForcedSpell.isEmpty ? savingThrowForcedSpell : nil,
            forKey: .savingThrowForcedSpell,
        )
        try container.encodeIfPresent(
            !damageDealt.isEmpty ? AlternateSetCoding(damageDealt) : nil,
            forKey: .damageDealt,
        )
        try container.encodeIfPresent(
            !damageDealtLegendary.isEmpty ? AlternateSetCoding(damageDealtLegendary) : nil,
            forKey: .damageDealtLegendary,
        )
        try container.encodeIfPresent(
            !damageDealtSpell.isEmpty ? AlternateSetCoding(damageDealtSpell) : nil,
            forKey: .damageDealtSpell,
        )
        try container.encodeIfPresent(!habitat.isEmpty ? habitat : nil, forKey: .habitat)
        try container.encodeIfPresent(!spellcasting.isEmpty ? spellcasting : nil, forKey: .spellcasting)
        try container.encodeIfPresent(!trait.isEmpty ? trait : nil, forKey: .trait)
        try container.encodeIfPresent(actionNote, forKey: .actionNote)
        try container.encodeIfPresent(actionHeader, forKey: .actionHeader)
        try container.encodeIfPresent(!action.isEmpty ? action : nil, forKey: .action)
        try container.encodeIfPresent(bonusNote, forKey: .bonusNote)
        try container.encodeIfPresent(bonusHeader, forKey: .bonusHeader)
        try container.encodeIfPresent(!bonus.isEmpty ? bonus : nil, forKey: .bonus)
        try container.encodeIfPresent(reactionNote, forKey: .reactionNote)
        try container.encodeIfPresent(reactionHeader, forKey: .reactionHeader)
        try container.encodeIfPresent(!reaction.isEmpty ? reaction : nil, forKey: .reaction)
        try container.encodeIfPresent(legendaryGroup, forKey: .legendaryGroup)
        try container.encodeIfPresent(legendaryActions, forKey: .legendaryActions)
        try container.encodeIfPresent(legendaryActionsLair, forKey: .legendaryActionsLair)
        try container.encodeIfPresent(legendaryHeader, forKey: .legendaryHeader)
        try container.encodeIfPresent(!legendary.isEmpty ? legendary : nil, forKey: .legendary)
        try container.encodeIfPresent(mythicHeader, forKey: .mythicHeader)
        try container.encodeIfPresent(!mythic.isEmpty ? mythic : nil, forKey: .mythic)
        try container.encodeIfPresent(!footer.isEmpty ? footer : nil, forKey: .footer)
        try container.encodeIfPresent(!equipment.isEmpty ? equipment : nil, forKey: .equipment)
        try container.encodeIfPresent(!treasure.isEmpty ? treasure : nil, forKey: .treasure)
        try container.encodeIfPresent(!actionTags.isEmpty ? actionTags : nil, forKey: .actionTags)
        try container.encodeIfPresent(
            !languageTags.isEmpty ? AlternateSetCoding(languageTags) : nil,
            forKey: .languageTags,
        )
        try container.encodeIfPresent(!miscTags.isEmpty ? AlternateSetCoding(miscTags) : nil, forKey: .miscTags)
        try container.encodeIfPresent(!senseTags.isEmpty ? senseTags : nil, forKey: .senseTags)
        try container.encodeIfPresent(
            !spellcastingTags.isEmpty ? AlternateSetCoding(spellcastingTags) : nil,
            forKey: .spellcastingTags,
        )
        try container.encodeIfPresent(!traitTags.isEmpty ? traitTags : nil, forKey: .traitTags)
        try container.encodeIfPresent(dragonCastingColor, forKey: .dragonCastingColor)
        try container.encodeIfPresent(dragonAge, forKey: .dragonAge)
        try container.encodeIfPresent(summonedBySpell, forKey: .summonedBySpell)
        try container.encodeIfPresent(summonedBySpellLevel, forKey: .summonedBySpellLevel)
        try container.encodeIfPresent(summonedByClass, forKey: .summonedByClass)
        try container.encodeIfPresent(summonedScaleByPlayerLevel, forKey: .summonedScaleByPlayerLevel)

        // DONE
        try container.encodeIfPresent(page, forKey: .page)
        try container.encodeIfPresent(canBeFamiliar ? true : nil, forKey: .canBeFamiliar)
        try container.encodeIfPresent(!additionalSources.isEmpty ? additionalSources : nil, forKey: .additionalSources)
        try container.encodeIfPresent(isNamedCreature ? true : nil, forKey: .isNamedCreature)
        try container.encodeIfPresent(isNPC ? true : nil, forKey: .isNPC)
        try container.encodeIfPresent(hasToken ? true : nil, forKey: .hasToken)

        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(tokenHref, forKey: .tokenHref)
        try container.encodeIfPresent(tokenCredit, forKey: .tokenCredit)
        try container.encodeIfPresent(isTokenCustom ? true : nil, forKey: .isTokenCustom)
        try container.encodeIfPresent(foundryTokenScale, forKey: .foundryTokenScale)
        try container.encodeIfPresent(hasFluff ? true : nil, forKey: .hasFluff)
        try container.encodeIfPresent(hasFluffImages ? true : nil, forKey: .hasFluffImages)
        try container.encodeIfPresent(!art.isEmpty ? art : nil, forKey: .art)
        try container.encodeIfPresent(soundClip, forKey: .soundClip)

        // DONE
        try container.encodeIfPresent(srd, forKey: .srd)
        try container.encodeIfPresent(srd52, forKey: .srd52)
        try container.encodeIfPresent(basicRules, forKey: .basicRules)
        try container.encodeIfPresent(basicRules2024, forKey: .basicRules2024)
    }
}
