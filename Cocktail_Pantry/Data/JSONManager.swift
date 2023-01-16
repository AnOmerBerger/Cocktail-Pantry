//
//  JSONManager.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/13/23.
//

import Foundation

let jsonCocktails: JSONCocktails = Bundle.main.decode(file: "cocktailJSON.json")
let cocktailsCovertedFromJSON = convertJSONCocktailtoCocktailStruct(array: jsonCocktails.dataForParsing)


struct JSONCocktails: Codable {
    let dataForParsing: [DataForParsing]

    enum CodingKeys: String, CodingKey {
        case dataForParsing = "Data for Parsing"
    }
}

// MARK: - DataForParsing
struct DataForParsing: Codable {
    let name, methods, videoID: String
    let tutorialStart, history: String?
    let ingredientQuantities, ingredientTypes, ingredientNames, garnish: String
    let instructions, countryOfOrigin: String
    let inventedAt, inventedBy: String?
    let glass, ice, shakeStirTime, boozeLevel: String
    let flavorProfile, difficulty, backgroundColor: String
    let imageURL: String?
    let dryShake: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case methods = "Methods"
        case videoID = "Video ID"
        case tutorialStart = "Tutorial Start"
        case history = "History"
        case ingredientQuantities = "Ingredient Quantities"
        case ingredientTypes = "Ingredient Types"
        case ingredientNames = "Ingredient Names"
        case garnish = "Garnish"
        case instructions = "Instructions"
        case countryOfOrigin = "Country of origin"
        case inventedAt = "Invented at"
        case inventedBy = "Invented by"
        case glass = "Glass"
        case ice = "Ice"
        case shakeStirTime = "Shake / stir time"
        case boozeLevel = "Booze level"
        case flavorProfile = "Flavor profile"
        case difficulty = "Difficulty"
        case backgroundColor = "Background Color"
        case imageURL = "Image URL"
        case dryShake = "Dry shake"
    }
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find file \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load file \(file) in the project")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode file \(file) in the project")
        }
        
        return loadedData
    }
}


func convertJSONCocktailtoCocktailStruct(array: [DataForParsing]) -> [Cocktail] {
    var cocktails = [Cocktail]()
    for data1 in array {
        
        let name = data1.name
        let methods = turnStringtoArray(string: data1.methods).compactMap { Method(rawValue: $0) }
        let videoID = data1.videoID
        let tutorialStartTime = minutesStringtoSecondsInt(numberToConvert: data1.tutorialStart ?? "0")
        let imageURL = data1.imageURL
        let history = data1.history
        let ingQuantities = turnStringtoArray(string: data1.ingredientQuantities).compactMap { Double($0) }
        let ingTypes = turnStringtoArray(string: data1.ingredientTypes).compactMap { QuantityType(rawValue: $0) }
        let ingNames = turnStringtoArray(string: data1.ingredientNames)
        let garnish = turnStringtoArray(string: data1.garnish)
        let instructions = turnStringtoArray(string: data1.instructions)
        let countryOfOrigin = data1.countryOfOrigin
        let inventedAt = data1.inventedAt
        let inventedBy = data1.inventedBy
        let glassType = turnStringtoArray(string: data1.glass).compactMap { GlassType(rawValue: $0) }
        let iceType = IceType(rawValue: data1.ice)
        
        var shakeOrStirTime = ShakeOrStirTime(minTime: 0, maxTime: 0) // default value
        let shakeOrStirArray = turnStringtoIntArray(string: data1.shakeStirTime)
        if shakeOrStirArray.count == 2 { // if converted correctly, assign new values
            shakeOrStirTime = ShakeOrStirTime(minTime: shakeOrStirArray[0], maxTime: shakeOrStirArray[1])
        }
        
        let boozeLevel = BoozeLevel(rawValue: data1.boozeLevel)
        let flavorProfile = turnStringtoArray(string: data1.flavorProfile).compactMap { FlavorProfile(rawValue: $0) }
        
        var dryShake = false
        if let dryShakeText = data1.dryShake {
            if dryShakeText.lowercased() == "v" {
                dryShake = true
            }
        }
        
        
        let difficultyLevel = DifficultyLevel(rawValue: data1.difficulty)
        
        var backgroundColor = CodableColor(red: 255, green: 128, blue: 0) // assigning orange as default, and going through similar process as shakeOrStirTime
        let colorsArray = turnStringtoIntArray(string: data1.backgroundColor)
        if colorsArray.count == 3 {
            backgroundColor = CodableColor(red: CGFloat(colorsArray[0]), green: CGFloat(colorsArray[1]), blue: CGFloat(colorsArray[2]))
        }
        
        cocktails.append(Cocktail(
                 name: name,
                 methods: methods,
                 videoID: videoID,
                 tutorialStartTime: tutorialStartTime ,
                 imageURL: imageURL ?? nil,
                 history: history,
                 ingQuantities: ingQuantities,
                 ingTypes: ingTypes,
                 ingNames: ingNames,
                 garnish: garnish,
                 instructions: instructions,
                 countryOfOrigin: countryOfOrigin,
                 inventedAt: inventedAt,
                 inventedBy: inventedBy,
                 glassType: glassType,
                 iceType: iceType ?? .regular,
                 shakeOrStirTime: shakeOrStirTime,
                 boozeLevel: boozeLevel ?? .medium,
                 flavorProfile: flavorProfile,
                 dryShake: dryShake,
                 difficultyLevel: difficultyLevel ?? .medium,
                 backgroundColor: backgroundColor
        ))
    }
    return cocktails
}

func turnStringtoArray(string: String) -> [String] {
    print("**** original string ****")
    print(string)
    let array = string.components(separatedBy: ",")
    print("**** original array ****")
    print(array)
    var cleanArray = [String]()
    for element in array {
        print("unclean - \(element)")
        let cleanElement = element.trimmingCharacters(in: .whitespaces)
        print("clean - \(cleanElement)")
        cleanArray.append(cleanElement)
    }
    print("**** clean array ****")
    print(cleanArray)
    return cleanArray
}

func turnStringtoIntArray(string: String) -> [Int] {
//    print("**** original string ****")
//    print(string)
    let array = string.components(separatedBy: ",")
//    print("**** original array ****")
//    print(array)
    var cleanArray = [Int]()
    for element in array {
//        print("unclean - \(element)")
        let cleanElement = element.trimmingCharacters(in: .whitespaces)
//        print("clean - \(cleanElement)")
        cleanArray.append(Int(cleanElement)!)
    }
//    print("**** clean array ****")
//    print(cleanArray)
    return cleanArray
}
