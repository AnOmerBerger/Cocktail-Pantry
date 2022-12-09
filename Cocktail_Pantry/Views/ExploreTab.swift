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
            Text("Try one of our favorites!").foregroundColor(.black).fontWeight(.heavy)
            NavigationLink(destination: CocktailPage(cocktail: viewModel.randomCocktail).environmentObject(viewModel)) {
                PhotoOnlyCard(cocktail: viewModel.randomCocktail).environmentObject(viewModel)
            }
            Divider()
            Divider()
//            ChangeableFilteringList(selection: $selection).environmentObject(viewModel)
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    ExploreCardHorizontalContainer(title: "Method", selectionAndAssociatedImage:
                                                    [("stirred", "stirred_drink"), ("shaken", "shaken_drink"), ("built", "built_drink")]).environmentObject(viewModel)
                    ExploreCardHorizontalContainer(title: "Booze Level", selectionAndAssociatedImage:
                                                    [("low", "low_alcohol_drink"), ("medium", "medium_drink"), ("high", "high_alcohol_drink")]).environmentObject(viewModel)
                    ExploreCardHorizontalContainer(title: "Flavor Profile", selectionAndAssociatedImage:
                                                    [("fruity", "fruity_drink"), ("light", "medium_drink"), ("strong", "boozy_drink"), ("refreshing", "refreshing_drink"), ("aromatic", "difficult_drink"), ("citrusy", "citrusy_drink")]).environmentObject(viewModel)
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

//struct ExploreTab_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreTab()
//    }
//}


struct ExploreCardHorizontalContainer: View {
    @EnvironmentObject var viewModel: ViewModel
    var title: String
    var selectionAndAssociatedImage: [(String, String)]
    
    var body: some View {
        VStack {
            Text(title).font(.headline).bold()
            ScrollView(.horizontal) {
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
        .frame(height: 150)
    }
}

struct ExploreCard: View {
    var text: String
    var imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0).foregroundColor(.white).frame(width: 100, height: 100)
            VStack {
                Image(imageName)
                    .resizable().scaledToFill().padding(2).frame(width:100, height: 70).clipped()
//                Divider()
                Text(text).padding(.bottom, 8).foregroundColor(.black).frame(height: 30)
            }
            .frame(width: 100, height: 100)
            RoundedRectangle(cornerRadius: 0).stroke(lineWidth: 1).foregroundColor(.gray).frame(width: 100, height: 100)
        }
    }
}

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
                }        .navigationBarItems(leading: Image(systemName: "chevron.left").onTapGesture { self.presentationMode.wrappedValue.dismiss() })
        .navigationBarBackButtonHidden(true)
    }
}
