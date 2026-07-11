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
            .replacingOccurrences(of: "Æ", with: "AE")
            .replacingOccurrences(of: "æ", with: "ae")
            .replacingOccurrences(of: "\"", with: "")
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
