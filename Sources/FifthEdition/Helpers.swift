//
//  Helpers.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/29/25.
//

/// Produces an init-call style debugDescription.
/// - Parameters:
///   - prefix: Class name or other prefix.
///   - names: Names of arguments, `"_"` may be used to omit an argument name,.
///   - values: Values of arguments.
/// - Returns: Debug description in an init-call style.
public func debugDescriptionOf(
    _ prefix: String? = nil,
    names: String...,
    values: Any?...,
) -> String {
    [
        prefix,
        "(",
        zip(names, values)
            .compactMap { name, arg in
                arg.map { (name != "_" ? name + ": " : "") + String(describing: $0) }
            }
            .joined(separator: ", "),
        ")",
    ]
    .compactMap(\.self)
    .joined()
}
