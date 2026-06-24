//
//  Index+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/7/26.
//

import Testing
@testable import FifthEdition

struct IndexCodableTests {
    @Test
    func `Index with list`() throws {
        try testCodable(
            json: """
            {
              "XDMG" : "foo-xdmg.json",
              "XMM" : "foo-xmm.json",
              "XPHB" : "foo-xphb.json"
            }
            """,
            value: Index(entries: [
                "XDMG": "foo-xdmg.json",
                "XMM": "foo-xmm.json",
                "XPHB": "foo-xphb.json",
            ]),
        )
    }
}
