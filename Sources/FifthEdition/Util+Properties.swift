//
//  Util+Properties.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

public extension Speed.Alternate {
    subscript(_ mode: Speed.Mode) -> Set<Speed.Value>? {
        get { speeds[mode] }
        set { speeds[mode] = newValue }
    }
}

public extension Speed {
    subscript(_ mode: Mode) -> Value? {
        get { speeds[mode] }
        set { speeds[mode] = newValue }
    }
}
