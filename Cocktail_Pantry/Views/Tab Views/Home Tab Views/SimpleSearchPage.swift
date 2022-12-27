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
//        let columns: [GridItem] =
//                Array(repeating: .init(.flexible()), count: 2)
        VStack(spacing: 30) {
            bigTextField(title: "filter cocktails", text: $searchText).padding(.horizontal).padding(.vertical, 3)
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach((viewModel.cocktails).filter({ "\($0.name)".lowercased().contains(searchText.lowercased()) || "\($0.ingNames)".contains(searchText.lowercased()) || searchText.isEmpty }).sorted(by: <)) { cocktail in
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
    }
}


//struct SimpleSearchPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleSearchPage(searchText: Binding.constant("")).environmentObject(ViewModel())
//    }
//}
