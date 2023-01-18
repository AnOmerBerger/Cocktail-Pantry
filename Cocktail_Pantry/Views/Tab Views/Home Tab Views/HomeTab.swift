//
//  HomeTab.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 12/6/22.
//

import SwiftUI

struct HomeTab: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var searchMode: SearchMode
    @Binding var ingredientSearchText: String
    @Binding var cocktaileSearchText: String
    @Binding var pantryFilter: Bool
    @State var showIngredientsList: Bool = true
    
    var body: some View {
        VStack {
            if pantryFilter {
                IngredientSelectList(searchText: $ingredientSearchText, showIngredientsList: $showIngredientsList).environmentObject(viewModel)
            } else {
                SimpleSearchPage(searchText: $cocktaileSearchText).environmentObject(viewModel)
            }
        }
    }    
}
