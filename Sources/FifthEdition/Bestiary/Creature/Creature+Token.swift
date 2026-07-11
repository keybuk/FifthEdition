//
//  Creature+Token.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/23/26.
//

public extension Creature {
    /// Returns the expected token name.
    var tokenName: String {
        String((token?.name ?? name)
            .replacing("Æ", with: "AE")
            .replacing("æ", with: "ae")
            .replacing("\"", with: "")
            .decomposedStringWithCanonicalMapping
            .unicodeScalars
            .filter(\.isASCII))
    }

    /// Returns the expected token path.
    var tokenPath: String? {
        guard hasToken else { return nil }
        return "bestiary/tokens/\(token?.source ?? source)/\(tokenName).webp"
    }
}
