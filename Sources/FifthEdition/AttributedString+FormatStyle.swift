//
//  AttributedString+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/4/26.
//

import Foundation

public struct AttributedStringStyle: FormatStyle, Sendable {
    public func format(_ value: AttributedString) -> AttributedString {
        value
    }
}

public extension AttributedString {
    func formatted<S: FormatStyle>(_ style: S) -> S.FormatOutput where S.FormatInput == Self {
        style.format(self)
    }
}
