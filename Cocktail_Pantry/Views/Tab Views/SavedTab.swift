//
//  SavedTab.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/29/22.
//

import SwiftUI

struct SavedTab: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Image(systemName: "star").imageScale(.medium)
                Image(systemName: "star").imageScale(.medium)
                Text("YOUR COCKTAILS").font(.title).bold()
                Image(systemName: "star").imageScale(.medium)
                Image(systemName: "star").imageScale(.medium)
            }
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.savedCocktails) { cocktail in
                        NavigationLink(destination: CocktailPage(cocktail: cocktail).environmentObject(viewModel)) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(cocktail.name).font(.headline).foregroundColor(.black).padding(.horizontal, 3)
                                CocktailCardWithImage(cocktail: cocktail)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SavedTab_Previews: PreviewProvider {
    static var previews: some View {
        SavedTab()
    }
}
