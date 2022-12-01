//
//  ChangeableFilteringList.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/30/22.
//

import SwiftUI

struct ChangeableFilteringList: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var selection: String
//    @Binding var cocktailSearchText: String
//    @Binding var videoIDforVideoPlayer: String
//    @Binding var showVideoPlayerOverlay: Bool
    
    let selectionOptions = ["method", "flavor", "booziness", "difficulty"]
    let columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 2)
    
    @State var methodSelection = Method.shaken.rawValue
    @State var flavorProfileSelection = FlavorProfile.refreshing.rawValue
    @State var glass = GlassType.rocks.rawValue
    @State var booziness = BoozeLevel.medium.rawValue
    @State var difficulty = DifficultyLevel.medium.rawValue
    
    var body: some View {
        VStack {
            Text("choose your criteria").bold()
            Picker(selection: $selection, label: Text("choose your criteria")) {
                ForEach(selectionOptions, id: \.self) { selection in
                    Text(selection).tag(selection)
                }
            }
            .pickerStyle(.segmented).padding(5)
            switch selection {
//            case "name":
//                SimpleSearchPage(searchText: $cocktailSearchText).environmentObject(viewModel)
            case "method":
                AbstractBasedCocktailList(selection: $methodSelection, selectionOptions: ["shaken", "stirred", "built"], arrayToBeFiltered: viewModel.cocktails, filteringThrow: { $0.methods.contains(where: { $0 == Method(rawValue: methodSelection) }) }, columns: columns)
            case "flavor":
                AbstractBasedCocktailList(selection: $flavorProfileSelection, selectionOptions: ["refreshing", "boozy", "sweet", "sour", "bitter"], arrayToBeFiltered: viewModel.cocktails, filteringThrow: { $0.flavorProfile.contains(where: { $0 == FlavorProfile(rawValue: flavorProfileSelection) }) }, columns: columns)
            case "booziness":
                AbstractBasedCocktailList(selection: $booziness, selectionOptions: ["low", "medium", "high"], arrayToBeFiltered: viewModel.cocktails, filteringThrow: { $0.boozeLevel == BoozeLevel(rawValue: booziness) }, columns: columns)
            case "difficulty":
                AbstractBasedCocktailList(selection: $difficulty, selectionOptions: ["easy", "medium", "difficult"], arrayToBeFiltered: viewModel.cocktails, filteringThrow: { $0.difficultyLevel == DifficultyLevel(rawValue: difficulty) }, columns: columns)
            default:
                Text("TBD")
//                case "glass":
            //                    AbstractBasedCocktailList(selection: $glass, selectionOptions: ["rocks glass", "martini glass", "coupe", "copper cup", "highball", "beer glass"], arrayToBeFiltered: viewModel.cocktails, filteringThrow: { $0.glassType.contains(where: { $0 == GlassType(rawValue: glass) }) }, columns: columns)
            }
        }
    }
}

struct AbstractBasedCocktailList<T: Identifiable>: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var selection: String
    let selectionOptions: [String]
    var arrayToBeFiltered: [T]
    var filteringThrow: (T) throws -> Bool
    var columns: [GridItem]
    
    var body: some View {
        VStack {
            Picker(selection: $selection, label: Text("")) {
                ForEach(selectionOptions, id: \.self) { selection in
                    Text(selection).tag(selection)
                }
            }
            .pickerStyle(.segmented).padding()
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(try! arrayToBeFiltered.filter(filteringThrow)) { item in
                        NavigationLink(destination: CocktailPage(cocktail: item as! Cocktail).environmentObject(viewModel)) {
                            VStack(alignment: .leading, spacing: 3) {
                                //                                Text(cocktail.name).font(.headline).foregroundColor(.black).padding(.horizontal, 3)
                                CocktailCardWithImage(cocktail: item as! Cocktail)
                            }
                        }
                    }
                }
            }
        }
    }
}


//struct ChangeableFilteringList_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeableFilteringList()
//    }
//}

//MARK: - case specific lists
//
//struct MethodBasedCocktailList: View {
//    @EnvironmentObject var viewModel: ViewModel
//    @Binding var selection: String
//    let selectionOptions = ["shaken", "stirred", "built"]
//    var columns: [GridItem]
//
//    var body: some View {
//        VStack {
//            Picker(selection: $selection, label: Text("")) {
//                ForEach(selectionOptions, id: \.self) { selection in
//                    Text(selection).tag(selection)
//                }
//            }
//            .pickerStyle(.segmented).padding()
//            ScrollView(.vertical) {
//                LazyVGrid(columns: columns) {
//                    ForEach(viewModel.cocktails.filter({ $0.methods.contains(where: { $0 == Method(rawValue: selection) }) })) { cocktail in
//                        CocktailCard(cocktail: cocktail)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct FlavorProfileBasedCocktailList: View {
//    @EnvironmentObject var viewModel: ViewModel
//    @Binding var selection: String
//    let selectionOptions = ["refreshing", "fruity", "light", "strong", "boozy", "aromatic", "citrusy", "dry", "sparkling", "sweet", "sour", "bitter", "creamy"]
//    var columns: [GridItem]
//
//    var body: some View {
//        VStack {
//            Picker(selection: $selection, label: Text("")) {
//                ForEach(selectionOptions, id: \.self) { selection in
//                    Text(selection).tag(selection)
//                }
//            }
//            .pickerStyle(.segmented).padding()
//            ScrollView(.vertical) {
//                LazyVGrid(columns: columns) {
//                    ForEach(viewModel.cocktails.filter({ $0.flavorProfile.contains(where: { $0 == FlavorProfile(rawValue: selection) }) })) { cocktail in
//                        CocktailCard(cocktail: cocktail)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct GlassBasedCocktailList: View {
//    @EnvironmentObject var viewModel: ViewModel
//    @Binding var selection: String
//    let selectionOptions = ["rocks glass", "martini glass", "coupe", "copper cup", "highball", "beer glass"]
//    var columns: [GridItem]
//
//    var body: some View {
//        VStack {
//            Picker(selection: $selection, label: Text("")) {
//                ForEach(selectionOptions, id: \.self) { selection in
//                    Text(selection).tag(selection)
//                }
//            }
//            .pickerStyle(.segmented).padding()
//            ScrollView(.vertical) {
//                LazyVGrid(columns: columns) {
//                    ForEach(viewModel.cocktails.filter({ $0.glassType.contains(where: { $0 == GlassType(rawValue: selection) }) })) { cocktail in
//                        CocktailCard(cocktail: cocktail)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct BoozeLevelBasedCocktailList: View {
//    @EnvironmentObject var viewModel: ViewModel
//    @Binding var selection: String
//    let selectionOptions = ["low", "medium", "high"]
//    var columns: [GridItem]
//
//    var body: some View {
//        VStack {
//            Picker(selection: $selection, label: Text("")) {
//                ForEach(selectionOptions, id: \.self) { selection in
//                    Text(selection).tag(selection)
//                }
//            }
//            .pickerStyle(.segmented).padding()
//            ScrollView(.vertical) {
//                LazyVGrid(columns: columns) {
//                    ForEach(viewModel.cocktails.filter { $0.boozeLevel == BoozeLevel(rawValue: selection) }) { cocktail in
//                        CocktailCard(cocktail: cocktail)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct DifficultyLevelBasedCocktailList: View {
//    @EnvironmentObject var viewModel: ViewModel
//    @Binding var selection: String
//    let selectionOptions = ["easy", "medium", "hard"]
//    var columns: [GridItem]
//
//    var body: some View {
//        VStack {
//            Picker(selection: $selection, label: Text("")) {
//                ForEach(selectionOptions, id: \.self) { selection in
//                    Text(selection).tag(selection)
//                }
//            }
//            .pickerStyle(.segmented).padding()
//            ScrollView(.vertical) {
//                LazyVGrid(columns: columns) {
//                    ForEach(viewModel.cocktails.filter { $0.difficultyLevel == DifficultyLevel(rawValue: selection) }) { cocktail in
//                        CocktailCard(cocktail: cocktail)
//                    }
//                }
//            }
//        }
//    }
//}
