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
    @State var searchMode: SearchMode = .ingredient
    @State var pantryFilter: Bool = true
    @State var showTipView: Bool = false
    
    var mainViewSelections = ["ingredient", "custom"]
    
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $mainViewSelection) {
                    HomeTab(searchMode: $searchMode, ingredientSearchText: $ingredientSearchText, cocktaileSearchText: $cocktaileSearchText, pantryFilter: $pantryFilter).environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }.tag(0)
                    SavedTab(mainViewSelection: $mainViewSelection, pantryFilter: $pantryFilter).environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "star")
                            Text("Favorites")
                        }.tag(1)
                    ExploreTab().environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "globe")
                            Text("Explore")
                        }.tag(2)
                    VStack {
                        StoreTab().environmentObject(viewModel)
                    }
                    .tabItem {
                        Image(systemName: "bag")
                        Text("Store")
                    }.tag(3)
                }
                .alert("More Cocktails!", isPresented: $viewModel.showAlert,
                       actions: {
                    Button(action: { viewModel.showAlert = false }, label: { Text("No") })
                    Button(action: {
                        viewModel.getCocktails(fromVersion: viewModel.newVersionAvailable!)
                    }, label: { Text("Yes").bold() })
                }, message: { Text("an updated cocktail list is available. Warning: some selected ingredients and saved cocktails may be lost." ) })
                
                
                DoubleSidedCoin(showTipView: $showTipView).environmentObject(viewModel)
            }
            .navigationTitle("Cocktail Pantry").padding(.vertical, 3)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    Text(pantryFilter ? "pantry mode" : "simple search")
                .font(.caption).fontWeight(.semibold).foregroundColor(pantryFilter ? .purple : .gray).opacity(mainViewSelection == 0 ? 1 : 0),
                                trailing:
                                    Toggle("", isOn: $pantryFilter)
                .toggleStyle(SwitchToggleStyle(tint: .purple)).opacity(mainViewSelection == 0 ? 1 : 0))
            .onAppear {
//                printFonts()
                UITabBar.appearance().backgroundColor = UIColor(.white.opacity(0.92))
                if viewModel.numberOfCocktailPagesVisited % 9 == 0 && viewModel.numberOfCocktailPagesVisited != 0 && !viewModel.tipOptions.isEmpty {
                    showTipView = true
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
