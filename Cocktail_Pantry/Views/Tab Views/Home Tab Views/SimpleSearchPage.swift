//
//  SimpleSearchPage.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/30/22.
//

import SwiftUI

struct SimpleSearchPage: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 30) {
            ScrollView(.vertical) {
                LazyVStack(spacing: 22) {
                    bigTextField(title: "search cocktails by name, ingredients, flavor, etc.", text: $searchText).padding(.horizontal).padding(.vertical, 3).id(1.2)
                    ForEach((viewModel.cocktails).filter({
                        "\($0.name)".lowercased().contains(searchText.lowercased()) || "\($0.ingNames)".contains(searchText.lowercased()) || "\($0.flavorProfile.stringArray)".contains(searchText.lowercased()) ||
                        "\($0.methods.stringArray)".contains(searchText.lowercased()) ||
                        "\($0.difficultyLevel.rawValue)".contains(searchText.lowercased()) ||
                        searchText.isEmpty }).sorted(by: <)) { cocktail in
                        VStack(alignment: .leading, spacing: 1) {
                            Text(cocktail.name).font(.overpass(.bold, size: 22)).padding(.horizontal, 3)
                            NavigationLink(destination: CocktailPage(cocktail: cocktail).environmentObject(viewModel)) {
                                CocktailCardWithImage(cocktail: cocktail)
                            }
                        }
                    }
                }
            }
        }
    }
}


//struct SimpleSearchPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleSearchPage(searchText: Binding.constant("")).environmentObject(ViewModel())
//    }
//}
