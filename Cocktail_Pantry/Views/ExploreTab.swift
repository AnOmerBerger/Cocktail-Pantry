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
                    ExploreCardHorizontalContainer(title: "Methods", selectionAndAssociatedImage:
                                                    [("stirred", "stirred_drink"), ("shaken", "shaken_drink"), ("built", "built_drink")])
                    ExploreCardHorizontalContainer(title: "Booze Level", selectionAndAssociatedImage:
                                                    [("low", "low_alcohol_drink"), ("medium", "medium_drink"), ("high", "high_alcohol_drink")])
                    ExploreCardHorizontalContainer(title: "Flavor Profile", selectionAndAssociatedImage:
                                                    [("fruity", "fruity_drink"), ("light", "medium_drink"), ("strong", "boozy_drink"), ("refreshing", "refreshing_drink"), ("aromatic", "difficult_drink"), ("citrusy", "citrusy_drink")])
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
    var title: String
    var selectionAndAssociatedImage: [(String, String)]
    
    var body: some View {
        VStack {
            Text(title).font(.headline).bold()
            ScrollView(.horizontal) {
                HStack(spacing: 30) {
                    ForEach(selectionAndAssociatedImage, id: \.self.0) { selection, imageName in
                        NavigationLink(destination: FilteredCocktailList(title: self.title + " - " + selection)) {
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
            RoundedRectangle(cornerRadius: 5).foregroundColor(.white).frame(width: 100, height: 100)
            RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1).foregroundColor(.gray).frame(width: 100, height: 100)
            VStack {
                Image(imageName)
                    .resizable().scaledToFill().padding(2).frame(width:100, height: 70).clipped()
                Divider()
                Text(text).padding(.bottom, 8).foregroundColor(.black)
            }
            .frame(width: 100, height: 100)
        }
    }
}

struct FilteredCocktailList: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.headline)
            Text("Cocktails").font(.title).bold()
        }
        .multilineTextAlignment(.leading)
        .navigationBarItems(leading: Image(systemName: "chevron.left").onTapGesture { self.presentationMode.wrappedValue.dismiss() })
        .navigationBarBackButtonHidden(true)
    }
}
