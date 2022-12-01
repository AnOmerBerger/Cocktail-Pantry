//
//  ExploreTab.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/30/22.
//

import SwiftUI

struct ExploreTab: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var selection: String = "method"
    var body: some View {
        VStack {
            Text("Try something new!").foregroundColor(.black).fontWeight(.heavy)
            NavigationLink(destination: CocktailPage(cocktail: viewModel.randomCocktail).environmentObject(viewModel)) {
                PhotoOnlyCard(cocktail: viewModel.randomCocktail).environmentObject(viewModel)
            }
            Divider()
            Divider()
            ChangeableFilteringList(selection: $selection).environmentObject(viewModel)
        }
    }
}

//struct ExploreTab_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreTab()
//    }
//}
