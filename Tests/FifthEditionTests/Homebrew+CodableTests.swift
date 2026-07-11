//
//  Homebrew+CodableTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/5/26.
//

import Foundation
import Testing
@testable import FifthEdition

struct HomebrewCodableTests {
    @Test
    func `Homebrew with required fields`() throws {
        try testCodable(
            json: """
            {
                "_meta": {
                    "sources": [
                        {
                            "json": "SandsOfDoom",
                            "abbreviation": "SoD'24",
                            "full": "Sands of Doom",
                            "version": "1.0"
                        }
                    ],
                    "dateAdded": 1763070112,
                    "dateLastModified": 1773323977,
                    "edition": "one"
                }
            }
            """,
            value: Homebrew(meta: .init(sources: [
                    .init(source: "SandsOfDoom",
                          abbreviation: "SoD'24",
                          name: "Sands of Doom",
                          version: "1.0"),
                ],
                added: Date(timeIntervalSince1970: 1_763_070_112),
                lastModified: Date(timeIntervalSince1970: 1_773_323_977),
                edition: .one)),
        )
    }

    @Test
    func `Homebrew with adventure`() throws {
        try testCodable(
            json: """
            {
                "_meta": {
                    "sources": [
                        {
                            "json": "SandsOfDoom",
                            "abbreviation": "SoD'24",
                            "full": "Sands of Doom",
                            "version": "1.0"
                        }
                    ],
                    "dateAdded": 1763070112,
                    "dateLastModified": 1773323977,
                    "edition": "one"
                },
                "adventure": [
                    {
                        "name": "Sands of Doom",
                        "id": "SandsOfDoom",
                        "source": "SandsOfDoom",
                        "group": "supplement",
                        "published": "2022-05-02",
                        "storyline": "Sands of Doom",
                        "contents": [],
                        "level": {
                            "start": 1,
                            "end": 11
                        }
                    }
                ]
            }
            """,
            value: Homebrew(meta: .init(sources: [
                                .init(source: "SandsOfDoom",
                                      abbreviation: "SoD'24",
                                      name: "Sands of Doom",
                                      version: "1.0"),
                            ],
                            added: Date(timeIntervalSince1970: 1_763_070_112),
                            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
                            edition: .one),
                            adventure: [
                                Adventure(name: "Sands of Doom",
                                          id: "SandsOfDoom",
                                          source: "SandsOfDoom",
                                          group: .supplement,
                                          published: #require(DateComponents(
                                              calendar: Calendar(identifier: .iso8601),
                                              year: 2022,
                                              month: 5,
                                              day: 2,
                                          ).date),
                                          level: .range(1...11),
                                          storyline: "Sands of Doom",
                                          contents: []),
                            ]),
        )
    }

    @Test
    func `Homebrew with monster`() throws {
        try testCodable(
            json: """
            {
                "_meta": {
                    "sources": [
                        {
                            "json": "SandsOfDoom",
                            "abbreviation": "SoD'24",
                            "full": "Sands of Doom",
                            "version": "1.0"
                        }
                    ],
                    "dateAdded": 1763070112,
                    "dateLastModified": 1773323977,
                    "edition": "one"
                },
                "monster": [
                    {
                        "name": "Anubian Footman",
                        "size": [
                            "M"
                        ],
                        "type": "humanoid",
                        "source": "SandsOfDoom"
                    }
                ]
            }
            """,
            value: Homebrew(meta: .init(sources: [
                                .init(source: "SandsOfDoom",
                                      abbreviation: "SoD'24",
                                      name: "Sands of Doom",
                                      version: "1.0"),
                            ],
                            added: Date(timeIntervalSince1970: 1_763_070_112),
                            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
                            edition: .one),
                            monster: [
                                Creature(name: "Anubian Footman",
                                         source: "SandsOfDoom",
                                         size: [.medium],
                                         type: [.humanoid]),
                            ]),
        )
    }

    @Test
    func `Homebrew with book`() throws {
        try testCodable(
            json: """
            {
                "_meta": {
                    "sources": [
                        {
                            "json": "FleeMortals",
                            "abbreviation": "FM!",
                            "full": "Flee, Mortals!",
                            "version": "1.1"
                        }
                    ],
                    "dateAdded": 1692310105,
                    "dateLastModified": 1772404109,
                    "edition": "classic"
                },
                "book": [
                    {
                        "name": "Flee, Mortals!",
                        "id": "FleeMortals",
                        "source": "FleeMortals",
                        "group": "supplement-alt",
                        "published": "2022-04-02",
                        "contents": []
                    }
                ]
            }
            """,
            value: Homebrew(meta: .init(sources: [
                                .init(source: "FleeMortals",
                                      abbreviation: "FM!",
                                      name: "Flee, Mortals!",
                                      version: "1.1"),
                            ],
                            added: Date(timeIntervalSince1970: 1_692_310_105),
                            lastModified: Date(timeIntervalSince1970: 1_772_404_109),
                            edition: .legacy),
                            book: [
                                Book(name: "Flee, Mortals!",
                                     id: "FleeMortals",
                                     source: "FleeMortals",
                                     group: .supplementAlt,
                                     published: #require(DateComponents(
                                         calendar: Calendar(identifier: .iso8601),
                                         year: 2022,
                                         month: 4,
                                         day: 2,
                                     ).date),
                                     contents: []),
                            ]),
        )
    }
}

struct HomebrewMetaCodableTests {
    @Test
    func `Meta with required fields`() throws {
        try testCodable(
            json: """
            {
                "sources": [
                    {
                        "json": "SandsOfDoom",
                        "abbreviation": "SoD'24",
                        "full": "Sands of Doom",
                        "version": "1.0"
                    }
                ],
                "dateAdded": 1763070112,
                "dateLastModified": 1773323977,
                "edition": "one"
            }
            """,
            value: Homebrew.Meta(sources: [
                .init(source: "SandsOfDoom",
                      abbreviation: "SoD'24",
                      name: "Sands of Doom",
                      version: "1.0"),
            ],
            added: Date(timeIntervalSince1970: 1_763_070_112),
            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
            edition: .one),
        )
    }

    @Test
    func `Meta with additional status fields`() throws {
        try testCodable(
            json: """
            {
                "sources": [
                    {
                        "json": "SandsOfDoom",
                        "abbreviation": "SoD'24",
                        "full": "Sands of Doom",
                        "version": "1.0"
                    }
                ],
                "dateAdded": 1763070112,
                "dateLastModified": 1773323977,
                "_dateLastModifiedHash": "27d771d7e4",
                "status": "ready",
                "edition": "one"
            }
            """,
            value: Homebrew.Meta(sources: [
                .init(source: "SandsOfDoom",
                      abbreviation: "SoD'24",
                      name: "Sands of Doom",
                      version: "1.0"),
            ],
            added: Date(timeIntervalSince1970: 1_763_070_112),
            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
            lastModifiedHash: "27d771d7e4",
            status: .ready,
            edition: .one),
        )
    }

    @Test
    func `Meta for unlisted`() throws {
        try testCodable(
            json: """
            {
                "sources": [
                    {
                        "json": "SandsOfDoom",
                        "abbreviation": "SoD'24",
                        "full": "Sands of Doom",
                        "version": "1.0"
                    }
                ],
                "dateAdded": 1763070112,
                "dateLastModified": 1773323977,
                "unlisted": true,
                "edition": "one"
            }
            """,
            value: Homebrew.Meta(sources: [
                .init(source: "SandsOfDoom",
                      abbreviation: "SoD'24",
                      name: "Sands of Doom",
                      version: "1.0"),
            ],
            added: Date(timeIntervalSince1970: 1_763_070_112),
            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
            isUnlisted: true,
            edition: .one),
        )
    }

    @Test
    func `Meta with dependencies`() throws {
        try testCodable(
            json: """
            {
                "sources": [
                    {
                        "json": "SandsOfDoom",
                        "abbreviation": "SoD'24",
                        "full": "Sands of Doom",
                        "version": "1.0"
                    }
                ],
                "dateAdded": 1763070112,
                "dateLastModified": 1773323977,
                "edition": "one",
                "dependencies": {
                    "monster": [
                        "MM",
                        "VRGR"
                    ]
                }
            }
            """,
            value: Homebrew.Meta(sources: [
                .init(source: "SandsOfDoom",
                      abbreviation: "SoD'24",
                      name: "Sands of Doom",
                      version: "1.0"),
            ],
            added: Date(timeIntervalSince1970: 1_763_070_112),
            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
            dependencies: [.monster: ["MM", "VRGR"]],
            edition: .one),
        )
    }

    #if FIXME
    @Test
    func `Meta with includes`() throws {
        try testCodable(
            json: """
            {
                "sources": [
                    {
                        "json": "SandsOfDoom",
                        "abbreviation": "SoD'24",
                        "full": "Sands of Doom",
                        "version": "1.0"
                    }
                ],
                "dateAdded": 1763070112,
                "dateLastModified": 1773323977,
                "edition": "one",
                "includes": {
                    "monster": [
                        "HumblewoodCampaignSetting",
                    ],
                    "spell": [
                        "HumblewoodCampaignSetting",
                    ]
                }
            }
            """,
            value: Homebrew.Meta(sources: [
                .init(source: "SandsOfDoom",
                      abbreviation: "SoD'24",
                      name: "Sands of Doom",
                      version: "1.0"),
            ],
            added: Date(timeIntervalSince1970: 1_763_070_112),
            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
            includes: [
                .monster: ["HumblewoodCampaignSetting"],
                .spell: ["HumblewoodCampaignSetting"],
            ],
            edition: .one),
        )
    }
    #endif

    @Test
    func `Meta with internalCopies`() throws {
        try testCodable(
            json: """
            {
                "sources": [
                    {
                        "json": "SandsOfDoom",
                        "abbreviation": "SoD'24",
                        "full": "Sands of Doom",
                        "version": "1.0"
                    }
                ],
                "dateAdded": 1763070112,
                "dateLastModified": 1773323977,
                "edition": "one",
                "internalCopies": [
                    "monster",
                    "monsterFluff"
                ]
            }
            """,
            value: Homebrew.Meta(sources: [
                .init(source: "SandsOfDoom",
                      abbreviation: "SoD'24",
                      name: "Sands of Doom",
                      version: "1.0"),
            ],
            added: Date(timeIntervalSince1970: 1_763_070_112),
            lastModified: Date(timeIntervalSince1970: 1_773_323_977),
            internalCopies: [.monster, .monsterFluff],
            edition: .one),
        )
    }
}

struct HomebrewMetaSourceCodableTests {
    @Test
    func `Source with required fields`() throws {
        try testCodable(
            json: """
            {
                "json": "SandsOfDoom",
                "abbreviation": "SoD'24",
                "full": "Sands of Doom",
                "version": "1.0"
            }
            """,
            value: Homebrew.Meta.Source(source: "SandsOfDoom",
                                        abbreviation: "SoD'24",
                                        name: "Sands of Doom",
                                        version: "1.0"),
        )
    }

    @Test
    func `Source with all fields`() throws {
        try testCodable(
            json: """
            {
                "json": "SandsOfDoom",
                "abbreviation": "SoD'24",
                "color": "9a6633",
                "colorNight": "8a5b2d",
                "full": "Sands of Doom",
                "authors": [
                    "Fermin Caballero (MrRhexx)"
                ],
                "convertedBy": [
                    "JuliTutu",
                    "yonatands"
                ],
                "dateReleased": "2022-05-02",
                "version": "1.0",
                "url": "https://mrrhexx.store/products/sands-of-doom-pdf-version-copy?srsltid=AfmBOorDMpaEWnDbiPOqYGD0LS0WnTI4ZM4ahKWvg9Quy-NgSXRmpGc-"
            }
            """,
            value: Homebrew.Meta.Source(source: "SandsOfDoom",
                                        abbreviation: "SoD'24",
                                        color: "9a6633",
                                        colorNight: "8a5b2d",
                                        name: "Sands of Doom",
                                        authors: [
                                            "Fermin Caballero (MrRhexx)",
                                        ],
                                        convertedBy: [
                                            "JuliTutu",
                                            "yonatands",
                                        ],
                                        released: DateComponents(calendar: Calendar(identifier: .iso8601),
                                                                 year: 2022,
                                                                 month: 5,
                                                                 day: 2).date,
                                        version: "1.0",
                                        url: URL(
                                            string: "https://mrrhexx.store/products/sands-of-doom-pdf-version-copy?srsltid=AfmBOorDMpaEWnDbiPOqYGD0LS0WnTI4ZM4ahKWvg9Quy-NgSXRmpGc-",
                                        )),
        )
    }

    @Test
    func `Source for partnered content`() throws {
        try testCodable(
            json: """
            {
                "json": "FleeMortals",
                "abbreviation": "FM!",
                "full": "Flee, Mortals!",
                "version": "1.1",
                "partnered": true
            }
            """,
            value: Homebrew.Meta.Source(source: "FleeMortals",
                                        abbreviation: "FM!",
                                        name: "Flee, Mortals!",
                                        version: "1.1",
                                        isPartnered: true),
        )
    }
}

struct HomebrewMetaStatusCodableTests {
    @Test(arguments: Homebrew.Meta.Status.allCases)
    func `Homebrew statuses`(status: Homebrew.Meta.Status) throws {
        try testCodable(
            json: """
            "\(status.rawValue)"
            """,
            value: status,
        )
    }
}
