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
        while let chunk = try read(upToCount: SHA256.blockByteCount) {
            hasher.update(data: chunk)
        }

        return "sha256:" + Data(hasher.finalize()).map { byte in
            String(format: "%02x", byte)
        }.joined()
    }
}
