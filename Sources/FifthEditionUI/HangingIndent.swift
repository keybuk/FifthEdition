//
//  HangingIndent.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/26/26.
//

import SwiftUI

/// Renders text with a hanging indent.
public struct HangingIndentRenderer: TextRenderer {
    /// Size of the hanging indent.
    public let indent: CGFloat

    public init(indent: CGFloat) {
        self.indent = indent
    }

    public func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        if let line = layout.first {
            var context = context
            context.translateBy(x: -indent, y: 0)
            context.draw(line)
        }

        for line in layout.dropFirst() {
            context.draw(line)
        }
    }
}

/// Modifiers a view such that any text views within it will have a hanging indent.
public struct HangingIndent: ViewModifier {
    /// Size of the hanging indent.
    public let indent: CGFloat

    public init(indent: CGFloat) {
        self.indent = indent
    }

    public func body(content: Content) -> some View {
        content
            .padding(.leading, indent)
            .textRenderer(HangingIndentRenderer(indent: indent))
    }
}

public extension View {
    /// Returns a new view such that any text views within it will have a hanging indent.
    /// - Parameter indent: Size of the indent.
    /// - Returns: Modified view.
    func hangingIndent(_ indent: CGFloat) -> some View {
        modifier(HangingIndent(indent: indent))
    }
}

#Preview {
    ScrollView {
        Text("This is a very long line of text that will need line wrapping to fit within the view. "
            + "The first line will appear at the normal position, then each subsequently wrapped line will have "
            + "the specified hanging indent.")
            .hangingIndent(20)
    }
    .frame(maxWidth: 300, maxHeight: 100)
    .padding()
}
