//
//  Macros.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 5/10/26.
//

@attached(member, names: named(Wrapper))
macro EnumWrapper() = #externalMacro(module: "FifthEditionMacros", type: "EnumWrapperMacro")
