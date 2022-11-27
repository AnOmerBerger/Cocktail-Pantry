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
                            IngredientSelectList(searchText: $ingredientSearchText).environmentObject(viewModel)
        //                case "cocktail":
        //                    SimpleSearchPage(searchText: $cocktaileSearchText).environmentObject(viewModel)
                        case "custom":
                            ChangeableFilteringList(selection: $customFilterSelection, cocktailSearchText: $cocktaileSearchText).environmentObject(viewModel)
                        default:
                            Text("ERROR IN LOADING PAGE")
                        }
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
                    if viewModel.numberOfCocktailPagesVisited % 3 == 0 && viewModel.numberOfCocktailPagesVisited != 0 && !viewModel.tipOptions.isEmpty {
                        showTipView = true
                    }
                }
                DoubleSidedCoin(showTipView: $showTipView).environmentObject(viewModel)
            }
            .task { await checkForNewVersion(currentVersion: viewModel.version) }
        }
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
