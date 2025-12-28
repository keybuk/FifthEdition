//
//  Codable.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 12/28/25.
//

/// A type that can be used as a key for encoding and decoding any container.
///
/// This can be used in place of the usual ``CodingKeys`` enumeration when the set of key names is only known at runtime, or derived entirely from the source data.
///
/// ```swift
/// typealias CodingKeys = DynamicCodingKey
/// ```
///
/// Use the type to access the container, and use the type's initializer to obtain a key for any string. This can be particularly powerful when combined with the container's ``allKeys`` property.
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
    var intValue: Int? { nil }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    /// Creates a new instance from the given string.
    /// - Parameter stringValue: The string value of the desired key.
    init(_ stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) { nil }
}

/// A type that can be used as a key for encoding and decoding a container with some keys from another enum.
///
/// This can be used in place of the usual ``CodingKeys`` enumeration when the set of key names should be derived from another enumeration without confirming it to ``CodingKey``, or if additional keys may be present in addition to those in the enumeration.
///
/// If the key is a valid member of `T` then the enum value is available in `value`, otherwise it will be `nil` but the coding key remains a valid value.
///
/// ```swift
/// typealias CodingKeys = EnumCodingKey<SomeEnum>
/// ```
///
/// The type's initializers may be used to obtain a key for a given enumeration value, or for any other string. If the enumeration conforms to ``CaseIterable``, then an ``allCases`` property exists that yields key-typed equivalents. Unknown cases can be discovered using the container's ``allKeys`` property.
///
/// When decoding:
/// ```swift
/// let container = try decoder.container(keyedBy: CodingKeys.self)
/// value = try container.decode(Value.self, forKey: CodingKeys(.someCase))
/// unknown = try container.decode(Unknown.self, forKey: CodingKeys(stringValue: "unknown key")
/// ```
///
////// When encoding:
/// ```swift
/// var container = encoder.container(keyedBy: CodingKeys.self)
/// try container.encode(value, forKey: CodingKeys(.someCase))
/// try container.encode(unknown, forKey: CodingKeys(stringValue: "unknown key"))
/// ```
struct EnumCodingKey<Value>: CodingKey
where Value: RawRepresentable, Value.RawValue == String
{
    /// The equivalent enumeration value, if valid, otherwise `nil`.
    var value: Value?
    var stringValue: String
    var intValue: Int? { nil }

    init(stringValue: String) {
        self.value = Value(rawValue: stringValue)
        self.stringValue = stringValue
    }

    /// Creates a new instance from the given enumeration value.
    /// - Parameter value: The enumeration value of the desired key.
    init(_ value: Value) {
        self.value = value
        self.stringValue = value.rawValue
    }

    init?(intValue: Int) { nil }
}

extension EnumCodingKey: Sendable
where Value: Sendable {}

extension EnumCodingKey: CaseIterable
where Value: CaseIterable
{
    /// A collection of all keys for the underlying enumeration type.
    static var allCases: [EnumCodingKey<Value>] {
        Value.allCases.map { value in Self(value) }
    }
}
