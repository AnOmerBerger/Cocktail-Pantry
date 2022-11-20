//
//  ContentView.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/17/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State var ingredientSearchText = ""
    @State var cocktaileSearchText = ""
    @State var mainViewSelection: String = "ingredient"
    @State var customFilterSelection = "name"
    @State var viewInView: Bool = false
    @State var showTipView: Bool = false
    @State var showAlert: Bool = false
    
    @State var videoIDforVideoPlayer: String = "dQw4w9WgXcQ&t=1s"
    @State var showVideoPlayerOverlay: Bool = false
    
    @State var newVersionAvailabe: Double? = nil
    
    var mainViewSelections = ["ingredient", "custom"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
    //                Text("Cocktail Pantry").font(Font.largeTitle)
                    ZStack {
                        switch mainViewSelection {
                        case "ingredient":
                            IngredientSelectList(searchText: $ingredientSearchText, videoIDforVideoPlayer: $videoIDforVideoPlayer, showVideoPlayerOverlay: $showVideoPlayerOverlay).environmentObject(viewModel)
        //                case "cocktail":
        //                    SimpleSearchPage(searchText: $cocktaileSearchText).environmentObject(viewModel)
                        case "custom":
                            ChangeableFilteringList(selection: $customFilterSelection, cocktailSearchText: $cocktaileSearchText, videoIDforVideoPlayer: $videoIDforVideoPlayer, showVideoPlayerOverlay: $showVideoPlayerOverlay).environmentObject(viewModel)
                        default:
                            Text("ERROR IN LOADING PAGE")
                        }
//                        TipView(showTipView: $showTipView).environmentObject(viewModel)
//                            .opacity(showTipView ? 1 : 0)
//                        Text("Please God").coinify(isFaceUp: true, showTipView: $showTipView)
                    }
                    .alert("Update Available", isPresented: $showAlert,
                           actions: {
                        Button(action: { showAlert = false }, label: { Text("No") })
                        Button(action: {
                            viewModel.getCocktails(fromVersion: newVersionAvailabe!)
                        }, label: { Text("Yes").bold() })
                    }, message: { Text("an updated cocktail list is available. Warning: you will need to re-select your ingridients." ) })
                    
                    Picker(
                        selection: $mainViewSelection,
                        label: Text(""),
                        content: {
                            ForEach(mainViewSelections, id: \.self) { selection in
                                Text(selection)
                                    .tag(selection)
                            }
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                }
                .navigationTitle("Cocktail Pantry").padding()
                .navigationBarTitleDisplayMode(.inline)
                .onDisappear { viewModel.visitACocktailPage() }
                .onAppear {
//                    viewModel.fetchProducts()
                    if viewModel.numberOfCocktailPagesVisited % 3 == 0 && viewModel.numberOfCocktailPagesVisited != 0 {
                        showTipView = true
                    }
                }
                
                if showVideoPlayerOverlay {
                    Color.black.opacity(0.7)
                    VideoPlayerOverlay(id: $videoIDforVideoPlayer, showVideoPlayerOverlay: $showVideoPlayerOverlay)
                }
            }
            .task { await checkForNewVersion(currentVersion: viewModel.version) }
            .onDisappear { showVideoPlayerOverlay = false }
        }
    }
    
    
    
    func checkForNewVersion(currentVersion: Double) async {
        if let response = URL(string: "http://127.0.0.1:8080/versionCheck") {
            do {
                let serverVersion = try String(contentsOf: response)
    //            print(serverVersion)
                if currentVersion <  Double(serverVersion) ?? 0 {
                    self.newVersionAvailabe = Double(serverVersion)!
                    showAlert = true
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
    }
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
