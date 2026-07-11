//
//  DynamicCodingKey.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 7/4/26.
//

/// A type that can be used as a key for encoding and decoding any container.
///
/// This can be used in place of the usual ``CodingKeys`` enumeration when the set of key names is only known at
/// runtime, or derived entirely from the source data.
///
/// ```swift
/// typealias CodingKeys = DynamicCodingKey
/// ```
///
/// Use the type to access the container, and use the type's initializer to obtain a key for any string. This can be
/// particularly powerful when combined with the container's ``allKeys`` property.
///
/// When decoding:
/// ```swift
/// let container = try decoder.container(keyedBy: CodingKeys.self)
/// value = try container.decode(Value.self, forKey: CodingKeys("any key"))
/// ```
///
/// When encoding:
/// ```swift
/// var container = encoder.container(keyedBy: CodingKeys.self)
/// try container.encode(value, forKey: CodingKeys("any key"))
/// ```
struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }

    init?(intValue: Int) {
        stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
