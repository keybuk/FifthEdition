//
//  Alignments+FormatStyle.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/14/26.
//

import Foundation

public extension Creature.Alignment {
    struct FormatStyle: Foundation.FormatStyle {
        var `case`: FifthEdition.Alignment.Case
        var locale: Locale

        public init(case: FifthEdition.Alignment.Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            self.case = `case`
            self.locale = locale
        }

        public func format(_ value: Creature.Alignment) -> String {
            String(attributed.format(value).characters)
        }

        public func locale(_ locale: Locale) -> Self {
            var copy = self
            copy.locale = locale
            return copy
        }

        public var attributed: Attributed {
            Attributed(style: self)
        }
    }

    func formatted() -> String {
        formatted(FormatStyle())
    }

    func formatted<Style: Foundation.FormatStyle>(_ style: Style) -> Style.FormatOutput
        where Style.FormatInput == Creature.Alignment
    {
        style.format(self)
    }
}

public extension Creature.Alignment.FormatStyle {
    struct Attributed: Foundation.FormatStyle {
        var style: Creature.Alignment.FormatStyle

        public func format(_ value: Creature.Alignment) -> AttributedString {
            var attributed = value.alignment
                .map { alignment in
                    alignment.formatted(.alignment(case: style.case).locale(style.locale).attributed)
                }
                .formatted(.list(type: .or).locale(style.locale))

            if let prefix = value.prefix {
                attributed = switch style.case {
                case .capitalized: AttributedString(prefix.capitalized(with: style.locale)) + attributed
                case .lowercased: AttributedString(prefix.lowercased(with: style.locale)) + attributed
                }
            }

            attributed.creature.alignment = value
            return attributed
        }

        public func locale(_ locale: Locale) -> Self {
            Attributed(style: style.locale(locale))
        }
    }
}

public extension FormatStyle where Self == Creature.Alignment.FormatStyle {
    static func alignment(case: FifthEdition.Alignment.Case = .capitalized) -> Self {
        Creature.Alignment.FormatStyle(case: `case`)
    }
}

extension Creature.Alignment: CustomStringConvertible {
    public var description: String {
        formatted()
    }
}

public extension String.LocalizationValue.StringInterpolation {
    mutating func appendInterpolation(_ alignments: Creature.Alignment) {
        appendInterpolation(alignments.formatted(Creature.Alignment.FormatStyle().attributed))
    }
}

public extension Creature.Alignment.Alignment {
    struct FormatStyle: Foundation.FormatStyle {
        var `case`: Alignment.Case
        var locale: Locale

        public init(case: Alignment.Case = .capitalized, locale: Locale = .autoupdatingCurrent) {
            self.case = `case`
            self.locale = locale
        }

        public func format(_ value: Creature.Alignment.Alignment) -> String {
            String(attributed.format(value).characters)
        }

        public func locale(_ locale: Locale) -> Self {
            var copy = self
            copy.locale = locale
            return copy
        }

        public var attributed: Attributed {
            Attributed(style: self)
        }
    }

    func formatted() -> String {
        formatted(FormatStyle())
    }

    func formatted<Style: Foundation.FormatStyle>(_ style: Style) -> Style.FormatOutput
        where Style.FormatInput == Creature.Alignment.Alignment
    {
        style.format(self)
    }
}

public extension Creature.Alignment.Alignment.FormatStyle {
    struct Attributed: Foundation.FormatStyle {
        var style: Creature.Alignment.Alignment.FormatStyle

        public func format(_ value: Creature.Alignment.Alignment) -> AttributedString {
            var attributed: AttributedString
            switch value {
            case let .alignment(alignment, chance, note):
                attributed = alignment.formatted(.alignment(case: style.case).locale(style.locale).attributed)

                if let chance {
                    attributed += " "
                    attributed += chance.formatted(.group(style: .percent.locale(style.locale).attributed))
                }

                if let note {
                    let note = switch style.case {
                    case .capitalized: AttributedString(note.capitalized(with: style.locale))
                    case .lowercased: AttributedString(note.lowercased(with: style.locale))
                    }

                    attributed += " "
                    attributed += note.formatted(.group().locale(style.locale))
                }
            case let .special(special):
                attributed = switch style.case {
                case .capitalized: AttributedString(special.capitalized(with: style.locale))
                case .lowercased: AttributedString(special.lowercased(with: style.locale))
                }
            }

            attributed.creature.alignmentAlignment = value
            return attributed
        }

        public func locale(_ locale: Locale) -> Self {
            Attributed(style: style.locale(locale))
        }
    }
}

public extension FormatStyle where Self == Creature.Alignment.Alignment.FormatStyle {
    static func alignment(case: Alignment.Case = .capitalized) -> Self {
        Creature.Alignment.Alignment.FormatStyle(case: `case`)
    }
}

extension Creature.Alignment.Alignment: CustomStringConvertible {
    public var description: String {
        formatted()
    }
}

public extension String.LocalizationValue.StringInterpolation {
    mutating func appendInterpolation(_ alignment: Creature.Alignment.Alignment) {
        appendInterpolation(alignment.formatted(Creature.Alignment.Alignment.FormatStyle().attributed))
    }
}
