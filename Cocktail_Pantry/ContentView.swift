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
    @State var mainViewSelection: Int = 0
    @State var customFilterSelection = "name"
    @State var viewInView: Bool = false
    @State var showTipView: Bool = false
    @State var showAlert: Bool = false
    
    @State var newVersionAvailabe: Double? = nil
    
    var mainViewSelections = ["ingredient", "custom"]
    
    var body: some View {
        NavigationView {
            ZStack {
//                Text("Cocktail Pantry").font(Font.largeTitle)
                TabView(selection: $mainViewSelection) {
                    IngredientSelectList(searchText: $ingredientSearchText).environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }.tag(0)
                    SavedTab().environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "star")
                            Text("Saved")
                        }.tag(1)
                    ExploreTab().environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "globe")
                            Text("Explore")
                        }.tag(2)
                    VStack {
                        StoreTab()
                    }
                    .tabItem {
                        Image(systemName: "bag")
                        Text("Store")
                    }.tag(3)
                }
                .alert("Update Available", isPresented: $showAlert,
                       actions: {
                    Button(action: { showAlert = false }, label: { Text("No") })
                    Button(action: {
                        viewModel.getCocktails(fromVersion: newVersionAvailabe!)
                    }, label: { Text("Yes").bold() })
                }, message: { Text("an updated cocktail list is available. Warning: you will need to re-select your ingredients." ) })
                
            DoubleSidedCoin(showTipView: $showTipView).environmentObject(viewModel)
            }
            .task { await checkForNewVersion(currentVersion: viewModel.version) }
            .navigationTitle("Cocktail Pantry").padding()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.numberOfCocktailPagesVisited % 3 == 0 && viewModel.numberOfCocktailPagesVisited != 0 && !viewModel.tipOptions.isEmpty {
                    showTipView = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    
    func checkForNewVersion(currentVersion: Double) async {
        guard let response = URL(string: "http://127.0.0.1:8080/versionCheck") else {
            print("invalid url")
            return
        }
            do {
                let (serverData, _) = try await URLSession.shared.data(from: response)
                if let serverVersion = try? JSONDecoder().decode(CodedString.self, from: serverData) {
//                    let serverVersion2 = String(contentsOf: response)
                    print("****** \(serverVersion) *******")
                    if currentVersion <  Double(serverVersion.string) ?? 0 {
                        self.newVersionAvailabe = Double(serverVersion.string)!
                        showAlert = true
                    }
                } else {
                    print("*** Couldn't Decode ***")
                }
            } catch {
                // contents could not be loaded
            }
        
    }
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
