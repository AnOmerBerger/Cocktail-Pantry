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
    
    var body: some View {
        VStack {
            if pantryFilter {
                IngredientSelectList(searchText: $ingredientSearchText).environmentObject(viewModel)
            } else {
                SimpleSearchPage(searchText: $cocktaileSearchText).environmentObject(viewModel)
            }
        }
    }
    
    
    
    
//    struct filterToggle: View {
//        @Binding var isOn: Bool
//
//        var body: some View {
//            ZStack {
//                RoundedRectangle(cornerRadius: 10).foregroundColor(.gray)
//                    .frame(width: 160, height: 40)
//                RoundedRectangle(cornerRadius: 0).foregroundColor(.white)
//                    .frame(width: 150, height: 30)
//                    .overlay {
//                        Toggle(isOn: $isOn) {
//                            HStack {
//                                Image(systemName: "slider.vertical.3").imageScale(.small)
//                                Text(isOn ? "pantry mode" : "simple search").font(.caption)
//                            }
//                        }
//                        .toggleStyle(.button)
//                        .padding()
//                    }
//            }
//            .padding(.horizontal)
//        }
//    }
}
