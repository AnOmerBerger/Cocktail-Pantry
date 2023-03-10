//
//  SavedTab.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/29/22.
//

import SwiftUI

struct SavedTab: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var mainViewSelection: Int
    @Binding var pantryFilter: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            if !viewModel.savedCocktails.isEmpty {
                ScrollView(.vertical) {
                    Header.id(2.1)
                    LazyVStack(spacing: 22) {
                        ForEach(viewModel.savedCocktails) { cocktail in
                            NavigationLink(destination: CocktailPage(cocktail: cocktail).environmentObject(viewModel)) {
                                VStack(alignment: .center, spacing: 0) {
                                    HStack {
                                        Text(cocktail.name).font(.overpass(.bold, size: 22)).foregroundColor(.black).padding(.leading, 8)
                                        Spacer()
                                        Button(action: { viewModel.saveOrRemoveCocktail(cocktail: cocktail) }) {
                                            Image(systemName: "star.slash")
                                        }
                                        .foregroundColor(.red.opacity(0.6))
                                        .padding(.trailing, 15)
                                    }
                                    CocktailCardWithImage(cocktail: cocktail)
                                }
                            }
                        }
                    }
                }
            } else {
                Header
                Spacer()
                Button(action: { mainViewSelection = 0 ; pantryFilter = false }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous).opacity(0.6)
                            HStack {
                                Text("Select your first cocktail")
                                Image(systemName: "hand.tap")
                                    .font(.largeTitle)
                            }
                            .foregroundColor(.white)
                        }
                    }
                    .foregroundColor(.blue)
                    .frame(width: 200, height: 80)
                Spacer()
            }
        }
    }
}

extension SavedTab {
    var Header: some View {
        HStack {
            Image(systemName: "star").imageScale(.medium)
            Image(systemName: "star.leadinghalf.fill").imageScale(.medium).rotationEffect(Angle(degrees: 90))
            Text("YOUR COCKTAILS").font(.overpass(.black ,size: 26))
            Image(systemName: "star.leadinghalf.fill").imageScale(.medium).rotationEffect(Angle(degrees: 270))
            Image(systemName: "star.fill").imageScale(.medium)
        }
    }
}


//struct SavedTab_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedTab().environmentObject(ViewModel())
//    }
//}
