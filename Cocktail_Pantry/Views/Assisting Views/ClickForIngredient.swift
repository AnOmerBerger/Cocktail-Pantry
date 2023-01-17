//
//  ClickForIngredient.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/9/23.
//

import SwiftUI

struct ClickForIngredient: View {
    var ingredient: Ingredient
    var body: some View {
        ZStack {
            Capsule(style: .continuous)
                .foregroundColor(ingredient.isSelected ? Color.green : Color.blue).opacity(0.3)
            HStack {
                Text(ingredient.name).font(.overpass(.regular, size: 13))
                if ingredient.isSelected {
                    Image(systemName: "x.square.fill").imageScale(.small)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        .frame(minHeight: 42)
    }
}
