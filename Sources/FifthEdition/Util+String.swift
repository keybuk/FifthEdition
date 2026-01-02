//
//  Util+String.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/27/25.
//

extension Page: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .number(number): "\(number)"
        case let .numeral(numeral): numeral
        }
    }
}

extension Speed.Alternate: CustomDebugStringConvertible {
    public var debugDescription: String {
        String(describing: speeds)
    }
}

extension Speed: CustomDebugStringConvertible {
    public var debugDescription: String {
        if self == .varies {
            String(describing: type(of: self)) + ".varies"
        } else {
            debugDescriptionOf(
                String(describing: type(of: self)),
                names: "_", "canHover", "choose", "alternate", "hidden",
                values: speeds, canHover, choose, alternate, hidden,
            )
        }
    }
}
