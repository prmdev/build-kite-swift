//
//  SearchField.swift
//  Buildkite
//
//  Created by prmdev on 7/1/20.
//

import SwiftUI

struct SearchField: View {
    @Binding var text: String
    var placeholder: LocalizedStringKey = "Search"

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .padding(.horizontal, 20)
                .background(Color(.systemGray))
                .cornerRadius(6)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   alignment: .leading)
                            .padding(.leading, 8)
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""

                            }) {
                                Label("Cancel", systemImage: "multiply.circle.fill")
                                    .labelStyle(IconOnlyLabelStyle())
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: SearchField(text: .constant("Previewing"))) {
                    SearchField(text: .constant(""))
                    SearchField(text: .constant("Previewing"))
                    Text("Row content")
                }
            }
        }
    }
}
