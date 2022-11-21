//
//  IngredientSelectList.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/19/22.
//

import SwiftUI

struct IngredientSelectList: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var searchText: String
    @Binding var videoIDforVideoPlayer: String
    @Binding var showVideoPlayerOverlay: Bool

    var body: some View {
        // rows setting for horizontal ingredient display
        let rows: [GridItem] =
                Array(repeating: .init(.flexible()), count: 2)
        // colums for cocktail cards display
//        let columns: [GridItem] =
//                Array(repeating: .init(.flexible()), count: 2)

        VStack {
            bigTextField(title: "search ingredients", text: $searchText).padding(.horizontal)
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 5) {
                    ForEach((viewModel.ingredients).filter({ "\($0.name)".contains(searchText.lowercased()) || searchText.isEmpty }).sorted(by: <)) { ingredient in
                        ClickForIngredient(ingredient: ingredient)
                            .onTapGesture { viewModel.select(ingredient: ingredient) }
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 5)
                .frame(maxHeight: 100)
            }
            Divider()
            ScrollView(.horizontal) {
                HStack {
                    Image(systemName: "checkmark.square.fill")
                    ForEach(viewModel.selected) { ingredient in
                        ClickForIngredient(ingredient: ingredient)
                            .layoutPriority(1)
                            .onTapGesture { viewModel.select(ingredient: ingredient) }
                    }
                }
                .padding()
                .frame(maxHeight: 50)
            }
            Divider()
            if viewModel.cocktailsFilteredThroughSelectedIngredients.isEmpty {
                Spacer()
                Text("What ingredients do you have?").font(.largeTitle).multilineTextAlignment(.center)
                Spacer()
            } else {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.cocktailsFilteredThroughSelectedIngredients, id: \.numberOfMissingIngredients) { numberAndCocktailGroup in
                            Text("missing \(numberAndCocktailGroup.numberOfMissingIngredients) ingredients").padding(.horizontal, 5).foregroundColor(numberAndCocktailGroup.numberOfMissingIngredients == 0 ? .green : .black)
//                            LazyVGrid(columns: columns) {
                                ForEach(numberAndCocktailGroup.cocktailList) { cocktail in
                                    VStack(alignment: .leading, spacing: 2) {
                                        let missingIngredientsString = returnMissingIngredientsForCocktail(cocktail: cocktail, selectedIngredients: viewModel.selected).joined(separator: ", ")
                                        ScrollView(.horizontal) {
                                            HStack {
                                                Text(cocktail.name).font(.headline)
//                                                Text("(missing: ")
                                                Text("(\(missingIngredientsString))").foregroundColor(.red)
                                            }
                                            .foregroundColor(.black)
                                        }
                                        NavigationLink(destination: CocktailPage(cocktail: cocktail)) {
                                            CocktailCardWithImage(cocktail: cocktail)
                                        }
                                    }
                                    .padding(.vertical, 5)
                                }
//                            }
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

func returnMissingIngredientsForCocktail(cocktail: Cocktail, selectedIngredients: [Ingredient]) -> [String] {
    var missingIngredients = [String]()
    
    for ing1 in cocktail.ingNames {
        var iHaveThisIngredient = false
        for ing2 in selectedIngredients {
            if ing1 == ing2.name {
                iHaveThisIngredient = true
            }
        }
        if !iHaveThisIngredient {
            missingIngredients.append(ing1)
        }
    }
    return missingIngredients
}

struct ClickForIngredient: View {
    var ingredient: Ingredient
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(ingredient.isSelected ? Color.green : Color.blue).opacity(0.3)
            HStack {
                Text(ingredient.name)
            }
            .padding(7)
        }
        .padding(.vertical)
    }
}

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
