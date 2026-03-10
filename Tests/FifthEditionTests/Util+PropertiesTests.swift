//
//  Util+PropertiesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Testing
@testable import FifthEdition

struct SpeedSubscriptTests {
    @Test
    func `Get speed by subscript`() {
        let speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        #expect(speed[.walk] == .speed(30))
    }

    @Test
    func `Get unset speed by subscript`() {
        let speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        #expect(speed[.burrow] == nil)
    }

    @Test
    func `Set speed by subscript`() {
        var speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        speed[.burrow] = .speed(10)

        #expect(speed.speeds == [
            .walk: .speed(30),
            .climb: .speed(60),
            .burrow: .speed(10),
        ])
    }

    @Test
    func `Change speed by subscript`() {
        var speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        speed[.climb] = .speed(120)

        #expect(speed.speeds == [
            .walk: .speed(30),
            .climb: .speed(120),
        ])
    }

    @Test
    func `Get alternate speed by subscript`() {
        let speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ]),
        )
        #expect(speed.alternate?[.climb] == [.speed(60), .speed(90)])
    }

    @Test
    func `Get unset alternate speed by subscript`() {
        let speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
                .burrow: .speed(10),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ]),
        )
        #expect(speed.alternate?[.burrow] == nil)
    }

    @Test
    func `Set alternate speed by subscript`() {
        var speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
                .burrow: .speed(10),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ]),
        )
        speed.alternate?[.burrow] = [.speed(10), .speed(20)]

        #expect(speed.alternate?.speeds == [
            .climb: [.speed(60), .speed(90)],
            .burrow: [.speed(10), .speed(20)],
        ])
    }

    @Test
    func `Change alternate speed by subscript`() {
        var speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ]),
        )
        speed.alternate?[.climb] = [.speed(60), .speed(120)]

        #expect(speed.alternate?.speeds == [
            .climb: [.speed(60), .speed(120)],
        ])
    }
}
