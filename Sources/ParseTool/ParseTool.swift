//
//  ParseTool.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/8/26.
//

import ArgumentParser
import FifthEdition
import Foundation

@main
struct ParseTool: ParsableCommand {
    @Option(help: "5etools source directory.", transform: URL.init(fileURLWithPath:))
    var dataDirectory: URL

    @Option(help: "Homebrew directory.", transform: URL.init(fileURLWithPath:))
    var homebrewDirectory: URL?

    @Option(help: "Homebrew file to parse.", transform: URL.init(fileURLWithPath:))
    var homebrewFile: URL?

    func validate() throws {
        guard FileManager.default.fileExists(atPath: dataDirectory.path(percentEncoded: false)) else {
            throw ValidationError("\(dataDirectory.path(percentEncoded: false)) does not exist")
        }

        let bestiaryURL = dataDirectory.appending(path: Bestiary.jsonIndexPath)
        guard FileManager.default.fileExists(atPath: bestiaryURL.path(percentEncoded: false)) else {
            throw ValidationError("\(dataDirectory.path(percentEncoded: false)) is not 5etools source")
        }

        if let homebrewDirectory {
            guard FileManager.default.fileExists(atPath: homebrewDirectory.path(percentEncoded: false)) else {
                throw ValidationError("\(homebrewDirectory.path(percentEncoded: false)) does not exist")
            }

            let sourcesIndexURL = homebrewDirectory.appending(path: "_generated/index-sources.json")
            guard FileManager.default.fileExists(atPath: sourcesIndexURL.path(percentEncoded: false)) else {
                throw ValidationError("\(dataDirectory.path(percentEncoded: false)) is not 5etools homebrew")
            }
        }

        if let homebrewFile {
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: homebrewFile.path(percentEncoded: false),
                                                 isDirectory: &isDirectory),
                isDirectory.boolValue == false
            else {
                throw ValidationError("\(homebrewFile.path(percentEncoded: false)) does not exist or is not a file")
            }
        }
    }

    func run() throws {
        try parseDataDirectory()
        try parseHomebrewDirectory()
        try parseHomebrewFile()
    }

    func parseDataDirectory() throws {
        let decoder = JSONDecoder()

        do {
            let adventuresURL = dataDirectory.appending(path: Adventures.jsonPath)
            let adventuresData = try Data(contentsOf: adventuresURL)
            let adventures = try decoder.decode(Adventures.self, from: adventuresData)

            for adventure in adventures.adventure {
                checkAdventure(adventure)
            }
        } catch {
            fputs("\(Adventures.jsonPath): \(error)\n", stderr)
        }

        do {
            let booksURL = dataDirectory.appending(path: Books.jsonPath)
            let booksData = try Data(contentsOf: booksURL)
            let books = try decoder.decode(Books.self, from: booksData)

            for book in books.book {
                checkBook(book)
            }
        } catch {
            fputs("\(Books.jsonPath): \(error)\n", stderr)
        }

        do {
            let bestiaryIndexURL = dataDirectory.appending(path: Bestiary.jsonIndexPath)
            let bestiaryIndexData = try Data(contentsOf: bestiaryIndexURL)
            let bestiaryIndex = try decoder.decode(Index.self, from: bestiaryIndexData)

            for (source, path) in bestiaryIndex.entries {
                print()
                print("🦍 \(source)")

                do {
                    let bestiaryURL = bestiaryIndexURL.deletingLastPathComponent().appending(path: path)
                    let bestiaryData = try Data(contentsOf: bestiaryURL)
                    let bestiary = try decoder.decode(Bestiary.self, from: bestiaryData)

                    for monster in bestiary.monster {
                        checkCreature(monster)
                    }
                } catch {
                    fputs("\(path): \(error)\n", stderr)
                }
            }
        } catch {
            fputs("\(Bestiary.jsonIndexPath) \(error)\n", stderr)
        }
    }

    func parseHomebrewDirectory() throws {
        guard let homebrewDirectory else { return }

        let decoder = JSONDecoder()

        do {
            let homebrewIndexURL = homebrewDirectory.appending(path: "_generated/index-sources.json")
            let homebrewIndexData = try Data(contentsOf: homebrewIndexURL)
            let homebrewIndex = try decoder.decode(Index.self, from: homebrewIndexData)

            for (source, path) in homebrewIndex.entries {
                print()
                print("🍻 \(source)")

                do {
                    let homebrewURL = homebrewDirectory.appending(path: path)
                    let homebrewData = try Data(contentsOf: homebrewURL)
                    let homebrew = try decoder.decode(Homebrew.self, from: homebrewData)

                    checkHomebrew(homebrew)
                } catch {
                    fputs("\(path): \(error)\n", stderr)
                }
            }
        } catch {
            fputs("index-sources.json: \(error)\n", stderr)
        }
    }

    func parseHomebrewFile() throws {
        guard let homebrewFile else { return }

        let decoder = JSONDecoder()

        do {
            let homebrewData = try Data(contentsOf: homebrewFile)
            let homebrew = try decoder.decode(Homebrew.self, from: homebrewData)

            checkHomebrew(homebrew)
        } catch {
            fputs("\(homebrewFile.lastPathComponent): \(error)\n", stderr)
        }
    }

    func checkHomebrew(_ homebrew: Homebrew) {
        for adventure in homebrew.adventure {
            checkAdventure(adventure)
        }

        for book in homebrew.book {
            checkBook(book)
        }

        for monster in homebrew.monster {
            checkCreature(monster)
        }
    }

    func checkAdventure(_ adventure: Adventure) {
        print("📗 \(adventure.name)")
    }

    func checkBook(_ book: Book) {
        print("📕 \(book.name)")
    }

    func checkCreature(_ creature: Creature) {
        print("🧌 \(creature.name)")
        for language in creature.languages.spoken {
            switch language {
            case let .other(rawValue): print("  Language spoken OTHER: '\(rawValue)`")
            default: print("  Language spoken: '\(language.rawValue)`")
            }
        }
        if let plus = creature.languages.additionalSpokenCount {
            print("  Language spoken PLUS \(plus)")
        }
        if let note = creature.languages.additionalSpokenNote {
            print("  Language spoken NOTE \(note)")
        }
        for language in creature.languages.understood {
            switch language {
            case let .other(rawValue): print("  Language understood OTHER: '\(rawValue)`")
            default: print("  Language understood: '\(language.rawValue)`")
            }
        }
        if let plus = creature.languages.additionalUnderstoodCount {
            print("  Language understood PLUS \(plus)")
        }
        if let note = creature.languages.additionalUnderstoodNote {
            print("  Language understood NOTE \(note)")
        }
        if let telepathy = creature.languages.telepathy {
            switch telepathy {
            case let .telepathy(range: _, note: note) where note != nil:
                print("  Language telepathy NOTE \(telepathy)")
            case .telepathy(range: _, note: _):
                print("  Language \(telepathy)")
            case .special:
                print("  Language telepathy SPECIAL \(telepathy)")
            }
        }
    }
}
