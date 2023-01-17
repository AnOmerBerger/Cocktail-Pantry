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
            ScrollView(.vertical, showsIndicators: false) {
                VStack() {
                    HStack(spacing: 20) {
                        VStack {
                            Text("""
Cocktail
Of the
Day
""")
                        }
                        .font(.overpass(.black, size: 18)).opacity(0.62)
                        NavigationLink(destination: CocktailPage(cocktail: viewModel.randomCocktail).environmentObject(viewModel)) {
                            HStack {
                                PhotoOnlyCard(cocktail: viewModel.randomCocktail).environmentObject(viewModel).padding(.vertical, 5)
                                Image(systemName: "chevron.compact.right")
                                    .imageScale(.large)
                                    .foregroundColor(.black.opacity(0.62))
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    Divider()
                    Divider()
                    
                    ExploreCardHorizontalContainer(title: "Method", selectionAndAssociatedImage:
                                                    [("stirred", "stirred_drink_small"), ("shaken", "shaken_drink_small"), ("built", "built_drink_small")]).environmentObject(viewModel)
                    ExploreCardHorizontalContainer(title: "Booze Level", selectionAndAssociatedImage:
                                                    [("low", "low_alcohol_drink_small"), ("medium", "medium_drink_small"), ("high", "high_alcohol_drink_small")]).environmentObject(viewModel)
                    ExploreCardHorizontalContainer(title: "Flavor Profile", selectionAndAssociatedImage:
                                                    [("fruity", "fruity_drink_small"), ("light", "light_drink_small"), ("boozy", "boozy_drink_small"), ("refreshing", "refreshing_drink_small"), ("aromatic", "difficult_drink_small"), ("citrusy", "citrusy_drink_small"), ("dry", "dry_drink_small"), ("sparkling", "sparkling_drink_small"), ("sweet", "sweet_drink2_small"), ("sour", "sour_drink_small"), ("bitter", "bitter_drink_small"), ("creamy", "creamy_drink_small")] ).environmentObject(viewModel)
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
