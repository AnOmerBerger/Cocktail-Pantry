//
//  FilteredCocktailList.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/3/23.
//

import SwiftUI

struct FilteredCocktailList: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    var filteringSelection: String
    var cocktails: [Cocktail] {
        switch title {
        case "Method":
            return viewModel.cocktails.filter { $0.methods.contains(where: { $0 == Method(rawValue: filteringSelection) }) }
        case "Booze Level":
            return viewModel.cocktails.filter { $0.boozeLevel == BoozeLevel(rawValue: filteringSelection) }
        case "Flavor Profile":
            return viewModel.cocktails.filter { $0.flavorProfile.contains(where: { $0 == FlavorProfile(rawValue: filteringSelection) }) }
        case "Difficulty Level":
            return viewModel.cocktails.filter { $0.difficultyLevel == DifficultyLevel(rawValue: filteringSelection) }
        case "Glass Type":
            return viewModel.cocktails.filter { $0.glassType.contains(where: { $0 == GlassType(rawValue: filteringSelection) }) }
        default:
            return viewModel.cocktails
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(cocktails.sorted(by: <)) { cocktail in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(cocktail.name).font(.custom(.semiBold, size: 25)).foregroundColor(.black).padding(.horizontal, 3)
                            NavigationLink(destination: CocktailPage(cocktail: cocktail).environmentObject(viewModel)) {
                                CocktailCardWithImage(cocktail: cocktail)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Cocktails").font(.headline)
                            Text(title + " - " + filteringSelection).font(.subheadline)
                        }
                    }
                }        .navigationBarItems(leading: ChevronBackButton(presentationMode: presentationMode))
        .navigationBarBackButtonHidden(true)
    }
}

struct FilteredCocktailList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredCocktailList(title: "Flavor Profile", filteringSelection: "refreshing").environmentObject(ViewModel())
    }
}
