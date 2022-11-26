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
            self.model = Model(version: retrievedModel.version, cocktails: retrievedModel.allCocktails, ingredients: retrievedModel.allIngredients, selectedIngredients: retrievedModel.allSelectedIngredients, numberOfCocktailPagesVisited: retrievedModel.numberOfCocktailPagesVisited)
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
    
    func tip(amount: Product) async {
        do {
            _ = try await amount.purchase()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Access to Model
    var version: Double { model.version }
    var cocktails: [Cocktail] { model.allCocktails }
    var ingredients: [Ingredient] { model.allIngredients }
    var selected: [Ingredient] { model.allSelectedIngredients }
    var cocktailsFilteredThroughSelectedIngredients: [Model.NumOfMissingIngredientsAndAssociatedCocktailList] { model.cocktailsFilteredThroughSelectedIngredients }
    var numberOfCocktailPagesVisited: Int { model.numberOfCocktailPagesVisited }
    
    // MARK: - Intents
    
    func select(ingredient: Ingredient) {
        model.addRemoveFromSelected(ingredient: ingredient)
    }
    func visitACocktailPage() { model.addOneToNumberOfCocktailPagesVisited() }
}
