//
//  Array Extentions.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/19/22.
//

import Foundation

//MARK: firstIndex extensions
extension Array where Element: Identifiable {

    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
    
    func firstIndexByIngName(matching: Element) -> Int? where Element == Ingredient {
        for index in 0..<self.count {
            if self[index].name == matching.name {
                return index
            }
        }
        return nil
    }
    
    func firstIndexByCockName(matching: Element) -> Int? where Element == Cocktail {
        for index in 0..<self.count {
            if self[index].name == matching.name {
                return index
            }
        }
        return nil
    }
}


//MARK: turning enum arrays into string arrays for filtering
extension Array where Element: RawRepresentable, Element.RawValue == String {
    var stringArray: [String] {
        var tempArray = [String]()
        for element in self {
            tempArray.append(element.rawValue)
        }
        return tempArray
    }
}
