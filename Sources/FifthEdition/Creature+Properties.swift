//
//  Creature+Properties.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/25/25.
//

public extension Creature {
    /// Number of grid squares for this creature.
    ///
    /// Where the creature has multiple sizes, the smallest is returned.
    var gridSquares: Int {
        guard let size = size?.sorted().first else { return 1 }

        switch size {
        case .tiny: return 1
        case .small: return 1
        case .medium: return 1
        case .large: return 2
        case .huge: return 3
        case .gargantuan: return 4
        }
    }

    /// Returns the expected token path.
    var tokenPath: String? {
        guard hasToken ?? false,
              let name = token?.name ?? name,
              let source = token?.source ?? source
        else {
            return nil
        }

        let tokenName = String(
            name
                .replacingOccurrences(of: "Æ", with: "AE")
                .replacingOccurrences(of: "æ", with: "ae")
                .replacingOccurrences(of: "\"", with: "")
                .decomposedStringWithCanonicalMapping
                .unicodeScalars
                .filter(\.isASCII),
        )

        return "bestiary/tokens/\(source)/\(tokenName).webp"
    }

    /// Returns the uid used to reference this creature.
    var uid: String? {
        guard let name, let source else {
            return nil
        }

        return "\(name.localizedLowercase)|\(source.localizedLowercase)"
    }
}

public extension Creature.SkillSet {
    subscript(_ skill: Skill) -> String? {
        get { skills[skill] }
        set { skills[skill] = newValue }
    }
}

public extension Creature.ToolSet {
    subscript(_ tool: Tool) -> String? {
        get { tools[tool] }
        set { tools[tool] = newValue }
    }
}
