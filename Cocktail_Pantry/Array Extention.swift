//
//  Array Extention.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/19/22.
//

import Foundation

extension Array where Element: Identifiable {

    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}


extension RandomAccessCollection where Element == [Int: [Cocktail]] {
    
}
