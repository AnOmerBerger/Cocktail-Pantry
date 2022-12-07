//
//  Global Structs+Enums.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/17/22.
//

import SwiftUI

struct CodedString: Codable {
    var string: String
}

struct Ingredient: Identifiable, Hashable, Comparable, Codable {
    static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        if lhs.name < rhs.name {
            return true
        } else {
            return false
        }
    }
    
    var id = UUID()
    var name: String
    var isSelected: Bool = false
}

struct Cocktail: Identifiable, Equatable, Comparable, Codable {
    static func < (lhs: Cocktail, rhs: Cocktail) -> Bool {
        if lhs.name < rhs.name {
            return true
        } else {
            return false
        }
    }
    
    static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
        if lhs.name == rhs.name {
            return true
        }
        return false
    }
    
    
    
    var id = UUID()
    var name: String
    var methods: [Method]
    var videoID: String
    var tutorialStartTime: Int = 0
    var imageURL: String?
    var history: String?
    var ingQuantities: [Double]
    var ingTypes: [QuantityType]
    var ingNames: [String]
    var garnish: [String]?
    var instructions: [String]
    var countryOfOrigin: String?
    var inventedAt: String?
    var inventedBy: String?
    var glassType: [GlassType]
    var iceType: IceType
    var shakeOrStirTime: ShakeOrStirTime
    var boozeLevel: BoozeLevel
    var flavorProfile: [FlavorProfile]
    var dryShake: Bool
    var difficultyLevel: DifficultyLevel
    var backgroundColor: CodableColor
    
}

enum Method: String, Codable {
    case stirred = "stirred", shaken = "shaken", built = "built"
}

enum QuantityType: String, Codable {
    case oz = "oz", dash = "dash", none = "", cube = "cube", top = "top with"
}

enum GlassType: String, Codable {
    case rocks = "rocks glass", martini = "martini glass", coupe = "coupe", copper = "copper cup", highball = "highball", beer = "beer glass"
}

enum IceType: String, Codable {
    case big = "big rock", regular = "regular ice", pebble = "pebble ice", crushed = "crushed ice", neat = "neat"
}

enum BoozeLevel: String, Codable {
    case low = "low", medium = "medium", high = "high"
}

enum FlavorProfile: String, Codable {
    case fruity = "fruity", light = "light", strong = "strong", refreshing = "refreshing", boozy = "boozy", aromatic = "aromatic", citrusy = "citrusy", dry = "dry", sparkling = "sparkling", sweet = "sweet", sour = "sour", bitter = "bitter", creamy = "creamy"
}

enum DifficultyLevel: String, Codable {
    case easy = "easy", medium = "medium", difficult = "difficult"
}

struct ShakeOrStirTime: Codable {
    let minTime: Int
    let maxTime: Int
}

struct CodableColor: Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
//    var alpha: CGFloat?

//    var cgColor: CGColor {
//        return CGColor(red: red, green: green, blue: blue, alpha: alpha ?? 1)
//    }
}


extension Double {
    func turnDoubleToStringUnlessZero() -> String {
        if abs(self) < 0.001 {
            return ""
        } else {
            return self.isDoubleAnInt() ? String(Int(self)) : String(self)
        }
    }
}

extension Double {
    func isDoubleAnInt() -> Bool {
        let floor = floor(self)
        if abs(self - floor) < 0.001 {
            return true
        } else {
            return false
        }
    }
}

func minutesStringtoSecondsInt(numberToConvert: String) -> Int {
    // converts a string of minutes and seconds written in the following scheme - "00:00" - into the Int sum of its seconds.
    // example: input -> "04:13" output -> 253
    guard numberToConvert.count == 5 else { return 0 }
    let minutes = Int(numberToConvert[..<numberToConvert.index(numberToConvert.startIndex, offsetBy: 2)])!
    let seconds = Int(numberToConvert[numberToConvert.index(numberToConvert.startIndex, offsetBy: 3)...numberToConvert.index(numberToConvert.startIndex, offsetBy: 4)])!
    
    return ((minutes * 60) + seconds)
}

public enum StoreError: Error {
    case failedVerification
}

enum SearchMode {
    case ingredient, cocktail
}
