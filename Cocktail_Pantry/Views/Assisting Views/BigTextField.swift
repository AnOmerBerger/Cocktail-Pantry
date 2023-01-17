//
//  BigTextField.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/9/23.
//

import SwiftUI

struct bigTextField: View {
    var title: String
    @State var isSearching = false
    @Binding var text: String
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill().foregroundColor(.gray.opacity(0.3))
                RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.blue)
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.blue.opacity(0.6))
                    TextField(title, text: $text)
                        .font(.overpass(.light, size: 13))
                        .autocorrectionDisabled(true)
                        .onTapGesture { isSearching = true }
                    if !text.isEmpty {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.blue.opacity(0.6))
                            .onTapGesture { text = ""  }
                    }
                }.padding()
            }
            if isSearching {
                Button("Cancel") {
                    isSearching = false
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .frame(maxHeight: 50)
    }
}
