//
//  String+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/28/26.
//

import Foundation

public struct StringStyle: FormatStyle, Sendable {
    public func format(_ value: String) -> String {
        value
    }
}
