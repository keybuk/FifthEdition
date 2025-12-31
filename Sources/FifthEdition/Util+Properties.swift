//
//  Util+Properties.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

extension Speed.Alternate {
    public subscript(_ mode: Speed.Mode) -> Set<Speed.Value>? {
        get { speeds[mode] }
        set { speeds[mode] = newValue }
    }
}

extension Speed {
    public subscript(_ mode: Mode) -> Value? {
        get { speeds[mode] }
        set { speeds[mode] = newValue }
    }
}
