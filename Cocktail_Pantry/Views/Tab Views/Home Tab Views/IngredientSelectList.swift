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
    @Binding var showIngredientsList: Bool
    @State var searchTextForAllIngredients: String = ""

    var body: some View {
        // rows setting for horizontal ingredient display
        let rows: [GridItem] =
                Array(repeating: .init(.flexible()), count: 2)

        VStack {
            if showIngredientsList {
                bigTextField(title: "search ingredients", text: $searchText).padding(.horizontal).padding(.top, 3)
                Text("select ingredients to add them to your pantry").font(.overpass(.semiBold, size: 15))
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 7) {
                        ForEach((viewModel.ingredients).filter({ "\($0.name)".contains(searchText.lowercased()) || searchText.isEmpty }).sorted(by: <)) { ingredient in
                            ClickForIngredient(ingredient: ingredient)
                                .onTapGesture { viewModel.select(ingredient: ingredient) }
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
                    .frame(maxHeight: 120)
                }
                .layoutPriority(1)
            }
            Divider().opacity(showIngredientsList ? 0 : 1)
            showIngredientsListTexts
            if !viewModel.selected.isEmpty {
                Divider()
                HStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.selected) { ingredient in
                                ClickForIngredient(ingredient: ingredient)
                                    .onTapGesture { viewModel.select(ingredient: ingredient) }
                                }
                            }
                        }
                    Button(action: { viewModel.clearSelectedIngredients() }) { Text("clear").font(.caption) }
                }
                .padding(.vertical)
                .padding(.horizontal, 5)
                .frame(maxHeight: 50)
            }
            
            if viewModel.cocktailsFilteredThroughSelectedIngredients.isEmpty {
                noIngredientSelectedText
            } else {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        Divider().id(1.1)
                        ForEach(viewModel.cocktailsFilteredThroughSelectedIngredients, id: \.numberOfMissingIngredients) { numberAndCocktailGroup in
                            HStack(spacing: 4) {
                                if numberAndCocktailGroup.numberOfMissingIngredients == 0 { Text("good to go!").foregroundColor(.green.opacity(0.75))
                                } else {
                                    Text("missing")
                                    Text("\(numberAndCocktailGroup.numberOfMissingIngredients) ingredients").foregroundColor(.red.opacity(0.75))
                                }
                            }
                            .font(.overpass(.semiBold, size: 16))
                            .padding(.horizontal, 6).padding(.top, 2)
                            
                                ForEach(numberAndCocktailGroup.cocktailList) { cocktail in
                                    VStack(alignment: .center, spacing: 1) {
                                        let missingIngredients = returnMissingIngredientsForCocktail(cocktail: cocktail, selectedIngredients: viewModel.selected)
                                        let missingIngredientsString = missingIngredients.joined(separator: ", ")
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack {
                                                Text(cocktail.name).font(.overpass(.bold, size: 22))
                                                if !missingIngredientsString.isEmpty {
                                            Text("(\(missingIngredientsString))").font(.overpass(.regular, size: 15)).foregroundColor(.red.opacity(0.75))
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 3)
                                        .foregroundColor(.black)
                                        NavigationLink(destination: CocktailPage(cocktail: cocktail, missingIngredients: missingIngredients).environmentObject(viewModel)) {
                                            CocktailCardWithImage(cocktail: cocktail)
                                        }
                                    }
                                    .padding(.horizontal, 3)
                                    .padding(.vertical, 5)
                                }
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



//MARK: - view extensions

extension IngredientSelectList {
    var showIngredientsListTexts: some View {
        HStack {
            Button(action: {
                withAnimation(Animation.linear(duration: 0.15)) {
                    showIngredientsList.toggle()
                }
            } ) {
                HStack(spacing: 2) {
                    Text(showIngredientsList ? "hide" : "show")
                    Image(systemName: showIngredientsList ? "chevron.up" : "chevron.down")
                }.opacity(viewModel.selected.isEmpty ? 0 : 1)
            }
            Spacer()
            NavigationLink(destination: AllIngredientsPage(searchText: $searchTextForAllIngredients).environmentObject(viewModel)) {
                HStack(spacing: 4) {
                    Text("view all").foregroundColor(.blue)
                    Image(systemName: "chevron.right")
                }
            }
        }
        .font(.caption)
        .padding(.vertical, 1)
        .padding(.horizontal, 7)
    }

    var noIngredientSelectedText: some View {
        VStack {
            Divider()
            Spacer()
            Text("What ingredients do you have?").font(.overpass(.black, size: 30)).multilineTextAlignment(.center)
            Spacer()
        }
    }
}
