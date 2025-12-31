//
//  Util+PropertiesTests.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

import Testing
@testable import FifthEdition

struct SpeedSubscriptTests {

    @Test("Get speed by subscript")
    func getSubscript() {
        let speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        #expect(speed[.walk] == .speed(30))
    }

    @Test("Get unset speed by subscript")
    func getSubscriptUnset() {
        let speed = Speed([
            .walk: .speed(30),
            .climb: .speed(60),
        ])
        #expect(speed[.burrow] == nil)
    }

    @Test("Set speed by subscript")
    func setSubscript() {
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

    @Test("Change speed by subscript")
    func changeSubscript() {
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

    @Test("Get alternate speed by subscript")
    func getAlternateSubscript() {
        let speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        #expect(speed.alternate?[.climb] == [.speed(60), .speed(90)])
    }

    @Test("Get unset alternate speed by subscript")
    func getAlternateSubscriptUnset() {
        let speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
                .burrow: .speed(10),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        #expect(speed.alternate?[.burrow] == nil)
    }

    @Test("Set alternate speed by subscript")
    func setAlternateSubscript() {
        var speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
                .burrow: .speed(10),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        speed.alternate?[.burrow] = [.speed(10), .speed(20)]

        #expect(speed.alternate?.speeds == [
            .climb: [.speed(60), .speed(90)],
            .burrow: [.speed(10), .speed(20)],
        ])
    }

    @Test("Change alternate speed by subscript")
    func changeAlternateSubscript() {
        var speed = Speed(
            [
                .walk: .speed(30),
                .climb: .speed(30),
            ],
            alternate: .init([
                .climb: [.speed(60), .speed(90)],
            ])
        )
        speed.alternate?[.climb] = [.speed(60), .speed(120)]

        #expect(speed.alternate?.speeds == [
            .climb: [.speed(60), .speed(120)],
        ])
    }

}
