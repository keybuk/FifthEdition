//
//  Coding.swift
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

    init?(intValue _: Int) { nil }
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
        value = Value(rawValue: stringValue)
        self.stringValue = stringValue
    }

    /// Creates a new instance from the given enumeration value.
    /// - Parameter value: The enumeration value of the desired key.
    init(_ value: Value) {
        self.value = value
        stringValue = value.rawValue
    }

    init?(intValue _: Int) { nil }
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

/// Wrapper around Set<Element> in order to provide an alternate Codable implementation.
public struct TagSet<Element>: Collection, ExpressibleByArrayLiteral, Hashable, Sequence, SetAlgebra
    where Element: Hashable
{
    private var wrappedSet: Set<Element>

    public init<S>(_ sequence: S) where S: Sequence, Element == S.Element {
        wrappedSet = Set(sequence)
    }

    // ExpressibleByArrayLiteral

    public init(arrayLiteral elements: Element...) {
        wrappedSet = Set(elements)
    }

    // Collection

    public typealias Element = Element
    public typealias Index = Set<Element>.Index

    public var startIndex: Index { wrappedSet.startIndex }

    public var endIndex: Index { wrappedSet.endIndex }

    public func index(after i: Index) -> Index {
        wrappedSet.index(after: i)
    }

    public subscript(i: Index) -> Element { wrappedSet[i] }

    // Sequence

    public typealias Iterator = Set<Element>.Iterator

    public func makeIterator() -> Iterator {
        wrappedSet.makeIterator()
    }

    // SetAlgebra

    public init() {
        wrappedSet = []
    }

    public var isEmpty: Bool { wrappedSet.isEmpty }

    public func contains(_ member: Element) -> Bool {
        wrappedSet.contains(member)
    }

    @discardableResult
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        wrappedSet.insert(newMember)
    }

    @discardableResult
    public mutating func update(with newMember: Element) -> Element? {
        wrappedSet.update(with: newMember)
    }

    @discardableResult
    public mutating func remove(_ member: Element) -> Element? {
        wrappedSet.remove(member)
    }

    public mutating func formIntersection(_ other: TagSet<Element>) {
        wrappedSet.formIntersection(other)
    }

    public mutating func formSymmetricDifference(_ other: TagSet<Element>) {
        wrappedSet.formSymmetricDifference(other)
    }

    public mutating func formUnion(_ other: TagSet<Element>) {
        wrappedSet.formUnion(other)
    }

    public func intersection(_ other: TagSet<Element>) -> TagSet<Element> {
        TagSet(wrappedSet.intersection(other.wrappedSet))
    }

    public func symmetricDifference(_ other: TagSet<Element>) -> TagSet<Element> {
        TagSet(wrappedSet.symmetricDifference(other.wrappedSet))
    }

    public func union(_ other: TagSet<Element>) -> TagSet<Element> {
        TagSet(wrappedSet.union(other.wrappedSet))
    }
}

extension TagSet: Equatable where Element: Equatable {}
extension TagSet: Sendable where Element: Sendable {}

extension TagSet: CustomStringConvertible
    where Set<Element>: CustomStringConvertible
{
    public var description: String { wrappedSet.description }
}

extension TagSet: CustomDebugStringConvertible
    where Set<Element>: CustomDebugStringConvertible
{
    public var debugDescription: String { wrappedSet.debugDescription }
}

/// Maps a value of itself to a tag.
public protocol TagCoding {
    associatedtype Tag

    static var tags: [(Self, Tag)] { get }
}

extension TagCoding
    where Tag: Equatable
{
    static func value(for tag: Tag) -> Self? {
        tags.first { this in
            this.1 == tag
        }?.0
    }
}

extension TagCoding
    where Self: Equatable
{
    static func tag(for value: Self) -> Tag? {
        tags.first { this in
            this.0 == value
        }?.1
    }
}

extension TagSet: Decodable
    where Element: Equatable,
    Element: TagCoding,
    Element.Tag: Decodable,
    Element.Tag: Equatable
{
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var values = Self()
        while let tag = try? container.decode(Element.Tag.self) {
            guard let value = Element.value(for: tag) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unknown tag: \(tag)",
                )
            }

            values.insert(value)
        }

        self = values
    }
}

extension TagSet: Encodable
    where Element: Equatable,
    Element: TagCoding,
    Element.Tag: Encodable,
    Element.Tag: Equatable
{
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        for value in self {
            guard let tag = Element.tag(for: value) else {
                throw EncodingError.invalidValue(
                    value, EncodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "No tag for value: \(value)",
                    ),
                )
            }

            try container.encode(tag)
        }
    }
}

/// Wrapper around Value in order to provide an alternate Codable implementation.
public struct Tagged<Value>
    where Value: TagCoding
{
    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }

    public init?(_ value: Value?) {
        guard let value else { return nil }

        self.value = value
    }
}

extension Tagged: Equatable where Value: Equatable {}
extension Tagged: Hashable where Value: Hashable {}
extension Tagged: Sendable where Value: Sendable {}

extension Tagged: CustomStringConvertible
    where Value: CustomStringConvertible
{
    public var description: String { value.description }
}

extension Tagged: CustomDebugStringConvertible
    where Value: CustomDebugStringConvertible
{
    public var debugDescription: String { value.debugDescription }
}

extension Tagged: Decodable
    where Value: Equatable,
    Value.Tag: Decodable,
    Value.Tag: Equatable
{
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let tag = try container.decode(Value.Tag.self)
        guard let value = Value.value(for: tag) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown tag: \(tag)",
            )
        }

        self.value = value
    }
}

extension Tagged: Encodable
    where Value: Equatable,
    Value.Tag: Encodable,
    Value.Tag: Equatable
{
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        guard let tag = Value.tag(for: value) else {
            throw EncodingError.invalidValue(
                value, EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "No tag for value: \(value)",
                ),
            )
        }

        try container.encode(tag)
    }
}
