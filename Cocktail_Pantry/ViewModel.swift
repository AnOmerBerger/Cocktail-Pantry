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
            self.model = Model(version: retrievedModel.version, cocktails: retrievedModel.allCocktails, ingredients: retrievedModel.allIngredients, selectedIngredients: retrievedModel.allSelectedIngredients, numberOfCocktailPagesVisited: retrievedModel.numberOfCocktailPagesVisited, savedCocktails: retrievedModel.savedCocktails)
        } else {
            print("starting with starter-pack")
            self.model = Model(cocktails: starterPack)
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
    }
    
    //MARK: - Call to Server
    func getCocktails(fromVersion: Double) {
        print("got to function")
        if let response = URL(string: "http://127.0.0.1:8080/cocktailList") {
            do {
                guard let cocktailData = try? Data(contentsOf: response) else { return }
                if let decodedCocktails = try? JSONDecoder().decode([Cocktail].self, from: cocktailData) {
                    print("starting with server data")
                    self.model = Model(version: fromVersion, cocktails: decodedCocktails, numberOfCocktailPagesVisited: model.numberOfCocktailPagesVisited)
                    print("current version: \(self.model.version)")
                }
            }
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
    func visitACocktailPage() { model.addOneToNumberOfCocktailPagesVisited() }
    func saveOrRemoveCocktail(cocktail: Cocktail) {
        model.saveOrRemoveCocktail(cocktail: cocktail)
        
    }
}
