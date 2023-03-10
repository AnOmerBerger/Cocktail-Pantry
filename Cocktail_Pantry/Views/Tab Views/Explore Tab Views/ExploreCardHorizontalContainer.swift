//
//  ExploreCardHorizontalContainer.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/3/23.
//

import SwiftUI

struct ExploreCardHorizontalContainer: View {
    @EnvironmentObject var viewModel: ViewModel
    var title: String
    var selectionAndAssociatedImage: [(String, String)]
    
    var body: some View {
        VStack(spacing: 3) {
            Text(title).font(.overpass(.bold, size: 19))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(selectionAndAssociatedImage, id: \.self.0) { selection, imageName in
                        NavigationLink(destination: FilteredCocktailList(title: self.title,
                                                                         filteringSelection: selection).environmentObject(viewModel)) {
                            ExploreCard(text: selection, imageName: imageName)
                        }
                    }
                }
            }
            Divider()
            Divider()
        }
        .padding(.vertical, 3)
    }
}

