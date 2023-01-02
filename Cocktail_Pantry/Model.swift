//
//  Model.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/17/22.
//

import Foundation

struct Model: Codable {
    
    // current version
    var version: Double = 0.0
    
    // a array where all Cocktails are stored
    var allCocktails: [Cocktail]
    
    // a array where all Ingredients are stored
    var allIngredients: [Ingredient]
    
    // an array that keeps all Ingredients where isSelected == true
    var allSelectedIngredients: [Ingredient] {
        didSet { // whenever this array is updated, it automatically re-filters cocktailsFilteredThroughSelectedIngredients
            print("from model")
            for ing in allSelectedIngredients {
                print(ing.name)
            }
            print("---------")
            cocktailsFilteredThroughSelectedIngredients = filterCocktailsWithListOfIngredients(withList: allSelectedIngredients)
        }
    }
    
    // an array of Cocktails which have been filtered through the allSelectedIngredients
    var cocktailsFilteredThroughSelectedIngredients: [NumOfMissingIngredientsAndAssociatedCocktailList]
    
    var numberOfCocktailPagesVisited: Int
    
    var savedCocktails: [Cocktail]
    
    var randomCocktail: Cocktail
    
    init(cocktails: [Cocktail]) { // starting initializer, when all you have is a list of cocktails
        self.allCocktails = cocktails
        self.allIngredients = [Ingredient]()
        self.allSelectedIngredients = [Ingredient]()
        self.cocktailsFilteredThroughSelectedIngredients = [NumOfMissingIngredientsAndAssociatedCocktailList]()
        self.numberOfCocktailPagesVisited = 0
        self.savedCocktails = [Cocktail]()
        self.randomCocktail = allCocktails[Int.random(in: 0..<allCocktails.count)]
        buildAllIngredients()
    }
    init(version: Double, cocktails: [Cocktail], ingredients: [Ingredient], selectedIngredients: [Ingredient], numberOfCocktailPagesVisited: Int, savedCocktails: [Cocktail]) { // initializer for after the program has run at least once, or if can't locate save
        self.version = version
        self.allCocktails = cocktails
        self.allIngredients = ingredients
        self.allSelectedIngredients = selectedIngredients
        self.numberOfCocktailPagesVisited = numberOfCocktailPagesVisited
        self.savedCocktails = savedCocktails
        self.randomCocktail = allCocktails[Int.random(in: 0..<allCocktails.count)]
        self.cocktailsFilteredThroughSelectedIngredients = [NumOfMissingIngredientsAndAssociatedCocktailList]()
        cocktailsFilteredThroughSelectedIngredients = filterCocktailsWithListOfIngredients(withList: allSelectedIngredients)
    }
    init(version: Double, cocktails: [Cocktail], previouslySelectedIngredients: [Ingredient], numberOfCocktailPagesVisited: Int, previouslySavedCocktails: [Cocktail]) { // initializer for when you do a version update
        self.version = version
        self.allCocktails = cocktails
        self.allIngredients = [Ingredient]()
        self.allSelectedIngredients = [Ingredient]()
        self.cocktailsFilteredThroughSelectedIngredients = [NumOfMissingIngredientsAndAssociatedCocktailList]()
        self.numberOfCocktailPagesVisited = numberOfCocktailPagesVisited
        self.savedCocktails = [Cocktail]()
        self.randomCocktail = allCocktails[Int.random(in: 0..<allCocktails.count)]
        buildAllIngredients()
        //updating
        allSelectedIngredients = updateSelectedIngredientsForNewVersion(oldSelected: previouslySelectedIngredients)
        savedCocktails = updateSavedCocktailsForNewVersion(oldSaved: previouslySavedCocktails)
        cocktailsFilteredThroughSelectedIngredients = filterCocktailsWithListOfIngredients(withList: allSelectedIngredients)
    }
    
    //MARK: - mutating functions
    
    // a function iterating over allCocktails, creating and adding all ingredients within them to allIngredients
    mutating func buildAllIngredients() {
        for cocktail in allCocktails {
            for ing1 in cocktail.ingNames {
                var exists = false
                for ing2 in allIngredients { //makes sure not to make duplicates
                    if ing1.lowercased() == ing2.name.lowercased() {
                        exists = true
                        break
                    }
                }
                if !exists {
                    allIngredients.append(Ingredient(name: ing1))
                }
            }
        }
        for ing in allIngredients { // internal print for review
            print(ing.name)
        }
    }
    
    // a function taking ingredients from AllIngredients and adding/removing them from allSelectedIngredients
    mutating func addRemoveFromSelected(ingredient: Ingredient) {
        if let index1 = allIngredients.firstIndex(matching: ingredient) {
            if let index2 = allSelectedIngredients.firstIndex(matching: ingredient) {
                allIngredients[index1].isSelected = false
                allSelectedIngredients.remove(at: index2)
            } else {
                allIngredients[index1].isSelected = true
                allSelectedIngredients.append(allIngredients[index1])
            }
        }
    }
    
    mutating func clearSelectedIngredients() {
        for index in allIngredients.indices {
            if allIngredients[index].isSelected == true {
                allIngredients[index].isSelected = false
            }
        }
        allSelectedIngredients = [Ingredient]()
    }
    
    mutating func filterCocktailsWithListOfIngredients(withList: [Ingredient]) -> [NumOfMissingIngredientsAndAssociatedCocktailList] {
        var tempCockList = [NumOfMissingIngredientsAndAssociatedCocktailList]()
        for cock1 in allCocktails {
            var numberOfMissingIngredients = cock1.ingNames.count
            for ing1 in withList {
                for ing2 in cock1.ingNames {
                    if ing1.name == ing2 {
                        numberOfMissingIngredients -= 1
                    }
                }
            }
            if numberOfMissingIngredients < cock1.ingNames.count {
                if let indexOfCocktailsMissingThisAmountOfIngredients = tempCockList.firstIndex(where: { $0.numberOfMissingIngredients == numberOfMissingIngredients }) {
                    tempCockList[indexOfCocktailsMissingThisAmountOfIngredients].cocktailList.append(cock1)
                } else {
                    tempCockList.append(NumOfMissingIngredientsAndAssociatedCocktailList(numberOfMissingIngredients: numberOfMissingIngredients, cocktailList: [cock1]))
                }
            }
        }
        return tempCockList.sorted(by: { $0.numberOfMissingIngredients < $1.numberOfMissingIngredients })
    }
    
    mutating func addOneToNumberOfCocktailPagesVisited() {
        numberOfCocktailPagesVisited += 1
    }
    mutating func saveOrRemoveCocktail(cocktail: Cocktail) {
        if let index1 = savedCocktails.firstIndex(matching: cocktail) {
            savedCocktails.remove(at: index1)
        } else {
            savedCocktails.append(cocktail)
        }
    }
    
    
    mutating func updateSelectedIngredientsForNewVersion(oldSelected: [Ingredient]) -> [Ingredient] {
        var newSelected = [Ingredient]()
        for ing1 in oldSelected {
            if let index1 = allIngredients.firstIndexByIngName(matching: ing1) {
                allIngredients[index1].isSelected = true
                newSelected.append(allIngredients[index1])
            }
        }
        return newSelected
    }
    
    mutating func updateSavedCocktailsForNewVersion(oldSaved: [Cocktail]) -> [Cocktail] {
        var newSaved = [Cocktail]()
        for cock1 in oldSaved {
            if let index1 = allCocktails.firstIndexByCockName(matching: cock1) {
                newSaved.append(allCocktails[index1])
            }
        }
        return newSaved
    }
// MARK: - additional structs
    
    struct NumOfMissingIngredientsAndAssociatedCocktailList: Codable {
        var numberOfMissingIngredients: Int
        var cocktailList: [Cocktail]
    }
    
}
