//
//  Creature+Properties.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//


extension Creature {
    /// Returns the uid used to reference this creature.
    public var uid: String? {
        guard let name, let source else {
            return nil
        }

        return "\(name.localizedLowercase)|\(source.localizedLowercase)"
    }

    /// Returns the expected token path.
    public var tokenPath: String? {
        guard let name = token?.name ?? name,
              let source = token?.source ?? source else {
            return nil
        }

        let tokenName = String(
            name
                .replacingOccurrences(of: "Æ", with: "AE")
                .replacingOccurrences(of: "æ", with: "ae")
                .replacingOccurrences(of: "\"", with: "")
                .decomposedStringWithCanonicalMapping
                .unicodeScalars
                .filter { $0.isASCII }
        )

        return "bestiary/tokens/\(source)/\(tokenName).webp"
    }
}

extension Creature.SkillSet {
    public subscript(_ skill: Skill) -> String? {
        get { skills[skill] }
        set { skills[skill] = newValue }
    }
}

extension Creature.ToolSet {
    public subscript(_ tool: Tool) -> String? {
        get { tools[tool] }
        set { tools[tool] = newValue }
    }
}
