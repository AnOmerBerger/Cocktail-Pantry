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
                PhotoOnlyCard(cocktail: viewModel.randomCocktail).environmentObject(viewModel).padding(.vertical, 5)
            }
            Divider()
            Divider()
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    ExploreCardHorizontalContainer(title: "Method", selectionAndAssociatedImage:
                                                    [("stirred", "stirred_drink_small"), ("shaken", "shaken_drink_small"), ("built", "built_drink_small")]).environmentObject(viewModel)
                    ExploreCardHorizontalContainer(title: "Booze Level", selectionAndAssociatedImage:
                                                    [("low", "low_alcohol_drink_small"), ("medium", "medium_drink_small"), ("high", "high_alcohol_drink_small")]).environmentObject(viewModel)
                    ExploreCardHorizontalContainer(title: "Flavor Profile", selectionAndAssociatedImage:
                                                    [("fruity", "fruity_drink_small"), ("light", "light_drink_small"), ("strong", "boozy_drink_small"), ("refreshing", "refreshing_drink_small"), ("aromatic", "difficult_drink_small"), ("citrusy", "citrusy_drink_small"), ("dry", "dry_drink_small"), ("sparkling", "sparkling_drink_small"), ("sweet", "sweet_drink2_small"), ("sour", "sour_drink_small"), ("bitter", "bitter_drink_small"), ("creamy", "creamy_drink_small")] ).environmentObject(viewModel)
                    ExploreCardHorizontalContainer(title: "Difficulty Level", selectionAndAssociatedImage: [("easy", "easy_drink_small"), ("medium", "coupe_drink_small"), ("difficult", "torched_drink_small")])
                    ExploreCardHorizontalContainer(title: "Glass Type", selectionAndAssociatedImage: [("rocks glass", "rocks_drink_small"), ("martini glass", "martini_small"), ("coupe", "espresso_martini_small"), ("copper cup", "copper_cup_small"), ("highball", "highball_drink_small"), ("beer glass", "beer_glass_small")])
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
        .padding(.vertical, 3)
//        .frame(height: 180)
    }
}

struct ExploreCard: View {
    var text: String
    var imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0).foregroundColor(.white).frame(width: 130, height: 100)
            VStack {
                Image(imageName)
                    .resizable().scaledToFill().frame(width: 130, height: 100).clipped()
                Text(text).padding(.bottom, 8).foregroundColor(.black).frame(height: 30)
            }
            .frame(width: 130, height: 130)
            RoundedRectangle(cornerRadius: 0).stroke(lineWidth: 1.5).foregroundColor(.gray).frame(width: 130, height: 130)
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
                }        .navigationBarItems(leading: Image(systemName: "chevron.left").onTapGesture { self.presentationMode.wrappedValue.dismiss() })
        .navigationBarBackButtonHidden(true)
    }
}
