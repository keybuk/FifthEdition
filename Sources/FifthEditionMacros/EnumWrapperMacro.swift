//
//  EnumWrapperMacro.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/10/26.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

public struct EnumWrapperMacro {}

extension EnumWrapperMacro: MemberMacro {
    public static func expansion(of _: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax,
                                 conformingTo _: [TypeSyntax],
                                 in _: some MacroExpansionContext)
        throws -> [DeclSyntax]
    {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroExpansionErrorMessage("@EnumWrapper can only be applied to enums.")
        }

        var access = enumDecl.modifiers
            .first {
                switch $0.name.tokenKind {
                case .keyword(.public): true
                default: false
                }
            }
        access?.trailingTrivia = .space

        let rawValueType = enumDecl.inheritanceClause?.inheritedTypes.first?.type ?? "String"

        let caseElements = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap(\.elements)

        var protocols: [String] = ["Equatable", "Hashable", "Codable", "CodingKeyRepresentable"]
        if enumDecl.inheritanceClause?.inheritedTypes.contains(where: {
            $0.type.trimmedDescription == "Sendable"
        }) == true {
            protocols.append("Sendable")
        }

        let enumVariables = try caseElements.map { element in
            try VariableDeclSyntax("\(access)static let \(element.name.trimmed) = Wrapper(.\(element.name.trimmed))")
        }

        protocols.append("CaseIterable")
        let allCases =
            try VariableDeclSyntax(
                "\(access)static let allCases: [Wrapper] = [\(raw: caseElements.map { ".\($0.name.text)" }.joined(separator: ", "))]",
            )

        let enumInitializer = try InitializerDeclSyntax("init(_ value: \(enumDecl.name))") {
            """
            rawValue = value.rawValue
            """
        }

        protocols.append("RawRepresentable")
        let rawValue = try VariableDeclSyntax("\(access)let rawValue: \(rawValueType)")

        let rawValueInitializer = try InitializerDeclSyntax("\(access)init(rawValue: \(rawValueType))") {
            """
            self.rawValue = rawValue
            """
        }

        var literalInitializer: InitializerDeclSyntax?
        var description: VariableDeclSyntax?
        if rawValueType.trimmedDescription == "String" {
            protocols.append("CustomStringConvertible")
            protocols.append("ExpressibleByStringLiteral")

            literalInitializer = try InitializerDeclSyntax("\(access)init(stringLiteral value: \(rawValueType))") {
                """
                rawValue = value
                """
            }

            description = try VariableDeclSyntax("\(access) var description: String") {
                """
                rawValue
                """
            }
        } else if rawValueType.trimmedDescription == "Int" {
            protocols.append("ExpressibleByIntegerLiteral")

            literalInitializer = try InitializerDeclSyntax("\(access)init(integerLiteral value: \(rawValueType))") {
                """
                rawValue = value
                """
            }
        }

        let wrapperStruct =
            try StructDeclSyntax(
                "\(access)struct Wrapper: \(raw: protocols.joined(separator: ", "))",
            ) {
                enumVariables
                allCases
                enumInitializer
                rawValue
                rawValueInitializer
                if let literalInitializer { literalInitializer }
                if let description { description }
            }

        return [
            DeclSyntax(wrapperStruct),
        ]
    }
}

@main
struct FifthEditionMacros: CompilerPlugin {
    let providingMacros: [Macro.Type] = [EnumWrapperMacro.self]
}
