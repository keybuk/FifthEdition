//
//  FileHandle+Crypto.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/24/25.
//

import CryptoKit
import Foundation

public extension FileHandle {
    func sha256Digest() throws -> String {
        var hasher = SHA256()
        while let chunk = try read(upToCount: 64 * 1024), !chunk.isEmpty {
            hasher.update(data: chunk)
        }

        return hasher.finalize().digestString
    }
}

public extension SHA256.Digest {
    var digestString: String {
        "sha256:" + Data(self).map { byte in
            String(format: "%02x", byte)
        }.joined()
    }
}
