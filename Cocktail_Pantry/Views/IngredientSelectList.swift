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
//    @Binding var videoIDforVideoPlayer: String
//    @Binding var showVideoPlayerOverlay: Bool

    var body: some View {
        // rows setting for horizontal ingredient display
        let rows: [GridItem] =
                Array(repeating: .init(.flexible()), count: 2)

        VStack {
            bigTextField(title: "filter ingredients", text: $searchText).padding(.horizontal).padding(.vertical, 3)
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 5) {
                    ForEach((viewModel.ingredients).filter({ "\($0.name)".contains(searchText.lowercased()) || searchText.isEmpty }).sorted(by: <)) { ingredient in
                        ClickForIngredient(ingredient: ingredient)
                            .onTapGesture { viewModel.select(ingredient: ingredient) }
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 5)
                .frame(maxHeight: 120)
            }
            Divider()
            HStack {
                Image(systemName: "checkmark.square.fill")
                ScrollView(.horizontal) {
                    HStack {
                        if viewModel.selected.isEmpty {
                            Text("press ingredients to add them to your pantry").font(.caption).opacity(0.3)
                        }
                        ForEach(viewModel.selected) { ingredient in
                            ClickForIngredient(ingredient: ingredient)
                                .onTapGesture { viewModel.select(ingredient: ingredient) }
                        }
                    }
                }
                if !viewModel.selected.isEmpty {
                    Button(action: { viewModel.clearSelectedIngredients() }) { Text("clear").font(.caption) }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 3)
            .frame(maxHeight: 50)
            
            Divider()
            if viewModel.cocktailsFilteredThroughSelectedIngredients.isEmpty {
                Spacer()
                Text("What ingredients do you have?").font(.custom(.regular, size: 40)).kerning(0.7).multilineTextAlignment(.center)
                Spacer()
            } else {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.cocktailsFilteredThroughSelectedIngredients, id: \.numberOfMissingIngredients) { numberAndCocktailGroup in
                            Text(numberAndCocktailGroup.numberOfMissingIngredients == 0 ? "good to go!" : "missing \(numberAndCocktailGroup.numberOfMissingIngredients) ingredients").fontWeight(.semibold).kerning(0.3).padding(.horizontal, 6).foregroundColor(numberAndCocktailGroup.numberOfMissingIngredients == 0 ? .green : .black).padding(.top, 2)
//                            LazyVGrid(columns: columns) {
                                ForEach(numberAndCocktailGroup.cocktailList) { cocktail in
                                    VStack(alignment: .center, spacing: 1) {
                                        let missingIngredients = returnMissingIngredientsForCocktail(cocktail: cocktail, selectedIngredients: viewModel.selected)
                                        let missingIngredientsString = missingIngredients.joined(separator: ", ")
                                        ScrollView(.horizontal) {
                                            HStack {
                                                Text(cocktail.name).font(.custom(.semiBold, size: 25))
                                                if !missingIngredientsString.isEmpty {
                                            Text("(\(missingIngredientsString))").font(.custom(.regular, size: 20)).foregroundColor(.red.opacity(0.75))
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
        .padding(3)
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
