//
//  ViewModel.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/19/22.
//

import Foundation
import SwiftUI
import Disk
import Combine
import StoreKit

class ViewModel: ObservableObject {
    @Published var model: Model
    
    var autoSave: AnyCancellable?
    
    init() {
        if let retrievedModel = try? Disk.retrieve("model.json", from: .caches, as: Model.self) {
            print("starting with saved model")
            self.model = Model(version: retrievedModel.version, cocktails: (retrievedModel.allCocktails), ingredients: retrievedModel.allIngredients, selectedIngredients: retrievedModel.allSelectedIngredients, numberOfCocktailPagesVisited: retrievedModel.numberOfCocktailPagesVisited, savedCocktails: retrievedModel.savedCocktails)
        } else {
            print("starting with starter-pack")
            self.model = Model(cocktails: (starterPack + cocktailsCovertedFromJSON))
        }
        
        autoSave = $model.sink { _ in
            print("selected ingredients:")
            try? Disk.save(self.model, to: .caches, as: "model.json")
            print("from viewModel")
            for ing in self.model.allSelectedIngredients {
                print(ing.name)
            }
//            print("saved version: \(self.model.version)")
            print("---------")
            
        }
        Task {
            //During store initialization, request products from the App Store.
            await fetchProducts()
        }
        Task {
            await checkForNewVersion(currentVersion: model.version)
        }
    }
    
    //MARK: - Calls to Server
    var newVersionAvailable: Double? = nil
    var showAlert: Bool = false
    
    func getCocktails(fromVersion: Double) {
        if let response = URL(string: "https://cocktail-pantry-vapor-dataset.herokuapp.com/cocktailList") {
            do {
                guard let cocktailData = try? Data(contentsOf: response) else { print("failed guard") ; return}
                if let decodedCocktails = try? JSONDecoder().decode([Cocktail].self, from: cocktailData) {
                    print("starting with server data")
                    //relaunching model
                    self.model = Model(version: fromVersion, cocktails: decodedCocktails, previouslySelectedIngredients: self.selected, numberOfCocktailPagesVisited: self.numberOfCocktailPagesVisited, previouslySavedCocktails: self.savedCocktails)
                    print("current version: \(self.model.version)")
                    
                    autoSave = $model.sink { _ in // redoing autosave to ensure immediate save
                        print("selected ingredients:")
                        try? Disk.save(self.model, to: .caches, as: "model.json")
                        print("from viewModel")
                        for ing in self.model.allSelectedIngredients {
                            print(ing.name)
                        }
            //            print("saved version: \(self.model.version)")
                        print("---------")
                        
                    }
                    
                } else {
                    print("failed decoding") ; return
                }
            }
        }
    }
    
    func checkForNewVersion(currentVersion: Double) async {
        guard let response = URL(string: "https://cocktail-pantry-vapor-dataset.herokuapp.com/versionCheck") else {
            print("invalid url")
            return
        }
            do {
                let (serverData, _) = try await URLSession.shared.data(from: response)
                if let serverVersion = try? JSONDecoder().decode(CodedString.self, from: serverData) {
                    print("****** \(currentVersion) *******")
                    print("****** \(serverVersion) *******")
                    if currentVersion <  Double(serverVersion.string) ?? 0 {
                        print("server version greater")
                        self.newVersionAvailable = Double(serverVersion.string)!
                        showAlert = true
                        print("\(showAlert)")
                    }
                } else {
                    print("*** Couldn't Decode ***")
                }
            } catch {
                print(error.localizedDescription)
            }
        
    }
    // MARK: - inApp Purchase
    var tipOptions: [Product] = []
    
    @MainActor
    func fetchProducts() async {
        do {
            print("running fetchProducts")
            let products = try await Product.products(for: ["1.tip.id", "2.tip.id", "5.tip.id"])
            self.tipOptions = products
        } catch {
            print(error)
        }
    }
    
    func tip(amount: Product) async -> StoreKit.Transaction? {
        do {
            let result = try await amount.purchase()
            
            switch result {
            case .success(let verification) :
                let transaction = try checkVerified(verification)
                await transaction.finish()
                return transaction
            case .userCancelled, .pending:
                return nil
            default:
                return nil
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    
    //MARK: - Tracking View
//    var showTabLoadingView: Bool = false
    
    var showingHomeTab: Bool = false
    var showingSavedTab: Bool = false
    var showingExploreTab: Bool = false
    var showingStoreTab: Bool = false
    
    // MARK: - Access to Model
    var version: Double { model.version }
    var cocktails: [Cocktail] { model.allCocktails }
    var ingredients: [Ingredient] { model.allIngredients }
    var selected: [Ingredient] { model.allSelectedIngredients }
    var cocktailsFilteredThroughSelectedIngredients: [Model.NumOfMissingIngredientsAndAssociatedCocktailList] { model.cocktailsFilteredThroughSelectedIngredients }
    var numberOfCocktailPagesVisited: Int { model.numberOfCocktailPagesVisited }
    var savedCocktails: [Cocktail] { model.savedCocktails }
    var randomCocktail: Cocktail { model.randomCocktail }
    
    // MARK: - Intents
    
    func select(ingredient: Ingredient) {
        model.addRemoveFromSelected(ingredient: ingredient)
    }
    func clearSelectedIngredients() { model.clearSelectedIngredients() }
    func visitACocktailPage() { model.addOneToNumberOfCocktailPagesVisited() }
    func saveOrRemoveCocktail(cocktail: Cocktail) {
        model.saveOrRemoveCocktail(cocktail: cocktail)
        
    }
}
