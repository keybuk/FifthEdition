//
//  Stat.swift
//  FifthEdition
//
//  Created by Scott James Remnant on 6/26/26.
//

import SwiftUI

struct Stat: View {
    private let text: Text
    private let title: Text

    init(_ title: LocalizedStringKey,
         _ text: LocalizedStringKey,
         tableName: String? = nil,
         bundle: Bundle? = nil,
         comment: StaticString? = nil)
    {
        self.title = Text(title, tableName: tableName, bundle: bundle, comment: comment)
            .fontWeight(.bold)
            .foregroundStyle(.tint)
        self.text = Text(text, tableName: tableName, bundle: bundle, comment: comment)
    }

    var body: some View {
        Text("\(title) \(text)")
            .hangingIndent(10)
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Stat("Armor Class", "12")
            Stat("Languages",
                 "Common, Draconic, Elvlish; understands Abyssal and Infernal but can't speak them; telepathy 60 ft.")
        }
    }
    .textSelection(.enabled)
    .tint(.statBlock)
    .padding()
}
