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
    
//    @State var newVersionAvailable: Double? = nil
    
    var mainViewSelections = ["ingredient", "custom"]
    
    var body: some View {
        NavigationView {
            ZStack {
//                Text("Cocktail Pantry").font(Font.largeTitle)
                TabView(selection: $mainViewSelection) {
                    HomeTab(searchMode: $searchMode, ingredientSearchText: $ingredientSearchText, cocktaileSearchText: $cocktaileSearchText, pantryFilter: $pantryFilter).environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }.tag(0)
                    SavedTab().environmentObject(viewModel)
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
//            .task { await checkForNewVersion(currentVersion: viewModel.version) }
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
    
    func printFonts() {
        for familyName in UIFont.familyNames {
            print("-------")
            print("Font family name -> [\(familyName)]")
            print("Font names ==> [\(UIFont.fontNames(forFamilyName: familyName))]")
        }
    }
    
//    func checkForNewVersion(currentVersion: Double) async {
//        guard let response = URL(string: "http://127.0.0.1:8080/versionCheck") else {
//            print("invalid url")
//            return
//        }
//            do {
//                let (serverData, _) = try await URLSession.shared.data(from: response)
//                if let serverVersion = try? JSONDecoder().decode(CodedString.self, from: serverData) {
//                    print("****** \(serverVersion) *******")
//                    if currentVersion <  Double(serverVersion.string) ?? 0 {
//                        self.newVersionAvailable = Double(serverVersion.string)!
//                        showAlert = true
//                    }
//                } else {
//                    print("*** Couldn't Decode ***")
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//
//    }
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
