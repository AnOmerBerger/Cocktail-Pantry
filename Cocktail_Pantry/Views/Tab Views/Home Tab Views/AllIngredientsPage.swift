//
//  AllIngredientsPage.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 12/28/22.
//

import SwiftUI

struct AllIngredientsPage: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var searchText: String
    
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        
        VStack {
//            Text("ALL INGREDIENTS").font(.largeTitle).bold()
            ScrollView(.vertical) {
                VStack {
                    bigTextField(title: "filter ingredients", text: $searchText).padding(.horizontal).padding(.vertical, 5)
                }
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach((viewModel.ingredients).filter({ "\($0.name)".contains(searchText.lowercased()) || searchText.isEmpty }).sorted(by: <)) { ingredient in
                        ClickForIngredient(ingredient: ingredient)
                            .onTapGesture { viewModel.select(ingredient: ingredient) }
                    }
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("ALL INGREDIENTS")
        .navigationBarItems(leading: Image(systemName: "chevron.left").onTapGesture { self.presentationMode.wrappedValue.dismiss() })
        .navigationBarBackButtonHidden(true)
    }
}

struct AllIngredientsPage_Previews: PreviewProvider {
    static var previews: some View {
        AllIngredientsPage(searchText: Binding.constant("")).environmentObject(ViewModel())
    }
}
