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
            Capsule()
                .foregroundColor(ingredient.isSelected ? Color.green : Color.blue).opacity(0.3)
            HStack {
                Text(ingredient.name).font(.custom(.light, size: 20))
                if ingredient.isSelected {
                    Image(systemName: "x.square.fill").imageScale(.small)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        .padding(.horizontal, 3)
    }
}
