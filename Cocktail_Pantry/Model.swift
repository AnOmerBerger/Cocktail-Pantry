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
    
    init(cocktails: [Cocktail]) { // starting initializer, when all you have is a list of cocktails
        self.allCocktails = cocktails
        self.allIngredients = [Ingredient]()
        self.allSelectedIngredients = [Ingredient]()
        self.cocktailsFilteredThroughSelectedIngredients = [NumOfMissingIngredientsAndAssociatedCocktailList]()
        self.numberOfCocktailPagesVisited = 0
        buildAllIngredients()
    }
    init(version: Double, cocktails: [Cocktail], ingredients: [Ingredient], selectedIngredients: [Ingredient], numberOfCocktailPagesVisited: Int) { // initializer for after the program has run at least once, or if can't locate save
        self.version = version
        self.allCocktails = cocktails
        self.allIngredients = ingredients
        self.allSelectedIngredients = selectedIngredients
        self.numberOfCocktailPagesVisited = numberOfCocktailPagesVisited
        self.cocktailsFilteredThroughSelectedIngredients = [NumOfMissingIngredientsAndAssociatedCocktailList]()
        cocktailsFilteredThroughSelectedIngredients = filterCocktailsWithListOfIngredients(withList: allSelectedIngredients)
    }
    init(version: Double, cocktails: [Cocktail], numberOfCocktailPagesVisited: Int) { // initializer for when you do a version update
        self.version = version
        self.allCocktails = cocktails
        self.allIngredients = [Ingredient]()
        self.allSelectedIngredients = [Ingredient]()
        self.cocktailsFilteredThroughSelectedIngredients = [NumOfMissingIngredientsAndAssociatedCocktailList]()
        self.numberOfCocktailPagesVisited = numberOfCocktailPagesVisited
        buildAllIngredients()
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
    
// MARK: - additionaly structs
    
    struct NumOfMissingIngredientsAndAssociatedCocktailList: Codable {
        var numberOfMissingIngredients: Int
        var cocktailList: [Cocktail]
    }
    
}

// MARK: - Data entry

let starterPack = [daiquiri, daiquiriHemingway, ginFizz, manhattan, margaritaOriginal, margaritaTommy, moscowMule, negroni, oldFashioned, sazerac, whiskeySour]

let daiquiri = Cocktail(name: "Daiquiri", methods: [.shaken], videoID: "fyZ4bwuPuiI", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "03:14"), imageURL: "https://i0.wp.com/theeducatedbarfly.com/wp-content/uploads/2022/11/daiquiri-web.jpg?w=1920&ssl=1", history: """
    The history of this drink's ingredients is far older than the drink itself. The mixture of Rum, Lime and Sugar traces it's history waaaaay back to the 17th Century when the British began importing it back to England from the west indies. It wasn't very long before the seafaring folk doing the actual importing figured out how delicious it was to make punches by adding these things together. Once imported to England though, only the rich could afford these rarified ingredients. I haven't done the research to prove this but I'm pretty sure this mixture of alcohol citrus and sugar did it's part in the creation of Pirates. The sailors risking their lives to import a product they couldn't afford I'm sure pissed them off enough to rebel and take hold of these valuable commodities for themselves.
    
    Fast Forward to 1740 when British Navy Admiral Edward "Old Grog" Vernon ordered that all Rum rations for the men be mixed with Limes (they'd figured out that it was a cure for scurvy by now) and sugar to dilute the potent spirit. At the time England was at war with Spain and now that the British were a little more healthy and a tad more sober than their Spanish counterparts  which  gave them a small advantage. But still the modern day daiquiri wasn't made until...
    
    ...Another war with Spain was underway, this time the Spanish-American War around 1898. The story goes that an American mining engineer stationed in Cuba named Jennings Cox created the drink to help protect his workers from Yellow Fever. There were rumors that Cox created the drink at a dinner party when he ran out of Gin and only had Rum left. Several decades after that another man by the name of P.D. Pagliuchi claimed that he was in fact the creator of the Daiquiri and retold the dinner party story. We'll probably never know the true history but we can all mull it over while we're drinking this fantastic cocktail.
    """
                        , ingQuantities: [2, 1, 0.75], ingTypes: [.oz, .oz, .oz], ingNames: ["rum", "lime juice", "simple syrup"], garnish: ["lime wheel"], instructions: ["pour all ingredients into shaker","add ice and shake","double strain into chilled glass"], countryOfOrigin: "Cuba", glassType: [.coupe, .martini], iceType: .neat, shakeOrStirTime: ShakeOrStirTime(minTime: 8, maxTime: 12), boozeLevel: .medium, flavorProfile: [.refreshing], dryShake: false, difficultyLevel: .medium, backgroundColor: CodableColor(red: 153, green: 255, blue: 204))

let daiquiriHemingway = Cocktail(name: "Hemingway Daiquiri", methods: [.shaken], videoID: "pKbISuGkKBI", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "00:39"), imageURL: "https://i0.wp.com/theeducatedbarfly.com/wp-content/uploads/2022/11/hemmingway-daiquiri-web.jpg?w=1920&ssl=1", history: """
    Ernest Hemingway is something of a legend in the annals of cocktail history. He has written extensively on his travels and the drinks imbibed on those adventures. He is said to have had his first Daiquiri at La Floridita. For those of you who don't know La Floridita is a famous restaurant and cocktail bar in Havana's historic district. It first opened it's doors in 1817 under the name "La Piña de la Plata" (The Silver Pineapple in Spanish). This bar was one of Hemingways favorite haunts and is said to have had his first Daiquiri there. After trying the Daiquiri for the first time he remarked: "That's good, nut I prefer mine with twice the rum and no sugar." effectively asking for a double rum with a squeeze of lime. Hemingway's nickname at the bar was "Papa" and this drink became known as the "Papa Doble." Over time the drink evolved to include Maraschino and Grapefruit Juice and became known as the La Floridita Daiquiri #3 then later as "Hemingway's Special Daiquiri". Most bartenders nowadays know this drink as the Hemingway Daiquiri, dropping the word  "Special" from the name.
    """
                                 , ingQuantities: [1.5, 0.75, 1, 0.5], ingTypes: [.oz, .oz, .oz, .oz], ingNames: ["rum", "maraschino liqueur", "grapefruit juice", "lime juice"], garnish: ["lime wheel"], instructions: ["pour all ingredients into shaker","add ice and shake","double strain into chilled glass"], countryOfOrigin: "Cuba", inventedAt: "la floridita", inventedBy: "Constantino Ribalaigua Vert", glassType: [.coupe, .martini], iceType: .neat, shakeOrStirTime: ShakeOrStirTime(minTime: 8, maxTime: 12), boozeLevel: .medium, flavorProfile: [.dry, .citrusy], dryShake: false, difficultyLevel: .medium, backgroundColor: CodableColor(red: 51, green: 255, blue: 153))

let ginFizz = Cocktail(name: "Gin Fizz", methods: [.shaken], videoID: "obGhGNUKx30", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "00:44"), imageURL: "https://i0.wp.com/theeducatedbarfly.com/wp-content/uploads/2021/01/Ramos-Gin-Fizz.jpg?w=1920&ssl=1", history: nil,
                       ingQuantities: [1.5, 0.75, 0.75, 1, 0], ingTypes: [.oz, .oz, .oz, .none, .top], ingNames: ["gin", "lemon juice", "simple syrup", "egg white", "seltzer"], instructions: ["add egg white into big tin of shaker", "pour gin, lemon juice and simple syrup into small tin", "combine and close tins together.", "let sit for 10 seconds then shake for 10", "add big rock of ice and shake hard", "double strain into chilled glass", "top with soda"], countryOfOrigin: "United States", glassType: [.highball], iceType: .neat, shakeOrStirTime: ShakeOrStirTime(minTime: 10, maxTime: 20), boozeLevel: .low, flavorProfile: [.refreshing, .sparkling], dryShake: true, difficultyLevel: .hard, backgroundColor: CodableColor(red: 204, green: 255, blue: 255))

let manhattan = Cocktail(name: "Manhattan", methods: [.stirred], videoID: "wiOxt4J5zaM", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "01:32"), imageURL: "https://i0.wp.com/theeducatedbarfly.com/wp-content/uploads/2020/01/newark-clean-scaled.jpg?resize=2048%2C1152&ssl=1",
                         history: """
    Like Most Cocktails the origin story of the Manhattan is veiled and uncertain. Nobody really knows exactly when it was created but the most credible puts its creation at New York's Manhattan Club somewhere in the vicinity of 1880. Give or take a couple of years. If that is the case then the 2:1 ratio the cocktail has today was slightly different than the one it had at it's inception. According to the club's history which was chronicled in Henry Watterson's History of the Manhattan Club: A Narrative of the Activities of Half a Century, the cocktail called for equal portions Sweet Vermouth cancan then further estimate that the original recipe was made with Rye Whiskey which was the preferred whiskey of the Northern States at that time.
    Much like everything else, this cocktail changed over time with the 2:1 ratio yielding a much more balanced drink, the orange bitters gave way to angostura to kick up the spice and that all culminated in this video on how to make a proper Manhattan (see what I did there?).
    
    It's a note worth making that although a Bourbon Manhattan is quite popular, the original was done with Rye. And it's not that accurate to say that Rye should be used just to be annoyingly exacting in recreating classic drinks. Rye is a much spicer style of whiskey and balances the flavor of sweet vermouth much better. also Sweet vermouth selection is key, while Carpano Antica is very popular and many bartenders swear by it, unless you're using overproof Rye such as Rittenhouse, this vermouth will overpower the main spirit, killing the cocktail. Carpano is also an old style Italian vermouth in the "vermouth alla viniglia" style which contains too much vanilla and will yield a strange tasting manhattan. If you want to add a few dashes of Orange bitters to make a more historic version go ahead, but make sure that you garnish with a twist of lemon, to knock up the citrus notes.
    """,
                         ingQuantities: [2, 1, 4], ingTypes: [.oz, .oz, .dash], ingNames: ["rye whiskey", "sweet vermouth", "angostura bitters"], garnish: ["brandied cherry"], instructions: ["pour all ingreidients into mixing glass", "add ice and stir until chilled", "strain into chilled glass and garnish"], countryOfOrigin: "United States", glassType: [.martini], iceType: .neat, shakeOrStirTime: ShakeOrStirTime(minTime: 15, maxTime: 20), boozeLevel: .high, flavorProfile: [.boozy, .sweet], dryShake: false, difficultyLevel: .easy, backgroundColor: CodableColor(red: 153, green: 0, blue: 0))

let margaritaOriginal = Cocktail(name: "Original Margarita", methods: [.shaken], videoID: "OWD2FAZ9IOQ", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "00:22"), history: nil,
                                 ingQuantities: [2, 0.75, 0.75], ingTypes: [.oz, .oz, .oz] , ingNames: ["blanco tequila", "lime juice", "cointreau"], garnish: ["lime wheel"], instructions: ["chill glass then salt rim", "pour all ingredients into shaker", "add ice and shake", "strain into prepared glass and garnish"], countryOfOrigin: "Mexico", inventedAt: "Rancho La Gloria", inventedBy: "Carlos 'Danny' Herrera", glassType: [.coupe], iceType: .neat, shakeOrStirTime: ShakeOrStirTime(minTime: 8, maxTime: 10), boozeLevel: .medium, flavorProfile: [.sour], dryShake: false, difficultyLevel: .medium, backgroundColor: CodableColor(red: 204, green: 255, blue: 153))

let margaritaTommy = Cocktail(name: "Tommy's Margarita", methods: [.shaken], videoID: "OWD2FAZ9IOQ", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "03:38"), history: nil,
                              ingQuantities: [2, 1, 0.5], ingTypes: [.oz, .oz, .oz] , ingNames: ["reposado tequila", "lime juice", "agave"], garnish: ["lime"], instructions: ["prepare glass with salted rim", "Pour all ingredients into shaker", "add ice and shake", "strain into prepared glass and garnish"], countryOfOrigin: "United States", inventedAt: "Tommy's Mexican Restaurant", inventedBy: "Julio Bermejo", glassType: [.rocks], iceType: .regular, shakeOrStirTime: ShakeOrStirTime(minTime: 8, maxTime: 10), boozeLevel: .medium, flavorProfile: [.sweet, .sour, .refreshing], dryShake: false, difficultyLevel: .medium, backgroundColor: CodableColor(red: 178, green: 255, blue: 102))

let moscowMule = Cocktail(name: "Moscow Mule", methods: [.built], videoID: "69wSCFe4GAI", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "04:12"), imageURL: "https://i0.wp.com/theeducatedbarfly.com/wp-content/uploads/2020/07/Moscow-Mule-Center-scaled.jpg?w=2088&ssl=1",
                          history: """
    The Moscow Mule is said to have been invented at Los Angeles' Cock'n Bull bar on Sunset Boulevard somewhere around 1941. The story goes that John G. Martin an executive at the Heublein drinks company and Jack Morgan owner of the Cock'n Bull Bar invented the drink together. Subsequently, reliable information has come to light that surprise surprise it was really the bartender Wes Price who probably actually invented the drink. I have been working in bars for many years and I have yet to meet any owner who has ever invented anything. And of course a marketing exec will take credit too! We also find out from Ted Haigh in his book "Vintage Spirits and Forgotten Cocktails" that Jack Morgan's girlfriend owned a company which made copper products, so it was she who probably supplied the copper mug to the equation.
    """
                          , ingQuantities: [2, 0.75, 4], ingTypes: [.oz, .oz, .oz], ingNames: ["vodka", "lime juice", "ginger beer"], garnish: ["lime wheel"], instructions: ["pour lime juice and vodka into shaker", "add ice", "top with ginger beer and garnish"], countryOfOrigin: "United States", inventedAt: "Cock'n Bull", inventedBy: "Wes Price", glassType: [.copper], iceType: .regular, shakeOrStirTime: ShakeOrStirTime(minTime: 0, maxTime: 0), boozeLevel: .medium, flavorProfile: [.refreshing], dryShake: false, difficultyLevel: .easy, backgroundColor: CodableColor(red: 255, green: 178, blue: 102))

let negroni = Cocktail(name: "Negroni", methods: [.built, .stirred], videoID: "sAyK8_MySWw", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "02:47"), imageURL: "https://i0.wp.com/theeducatedbarfly.com/wp-content/uploads/2018/05/Negroni-web.jpg?w=1920&ssl=1", history: """
    The Negroni was invented at Cafe Cassoni in Florence Italy around 1919. Legend has it that Count Camillio Negroni asked his friend the bartender Forsco Scarselli to spike his Americano cocktail with an ounce of Gin and to take out the soda water. Then shortly thereafter whenever anyone would order an Americano (Then all the rage) they would ask for it "The Negroni Way"
    The Family was quick to capitalize on the success of the cocktail, founding the Negroni distillery in 1919 in Treviso Italy where they produced a ready made version of the drink.
    """,
                       ingQuantities:[1, 1, 1], ingTypes:[.oz, .oz, .oz], ingNames:["gin", "campari", "sweet vermouth"], garnish: ["orange twist"], instructions: ["pour all ingredients into glass", "place large ice cube", "stir to dilute & garnish"], countryOfOrigin: "Italy", inventedAt: "Cafe Cassoni", inventedBy: "Count Camillo Negroni", glassType: [.rocks], iceType: .big, shakeOrStirTime: ShakeOrStirTime(minTime: 20, maxTime: 40), boozeLevel: .high, flavorProfile: [.bitter, .strong], dryShake: false, difficultyLevel: .easy, backgroundColor: CodableColor(red: 255, green: 51, blue: 51))

let oldFashioned = Cocktail(name: "Old Fashioned", methods: [.built, .stirred], videoID: "SeP3V3MtpxI", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "03:03"), imageURL: "https://i0.wp.com/theeducatedbarfly.com/wp-content/uploads/2020/09/oldfashioned-new-scaled.jpg?resize=2048%2C1152&ssl=1", history: """
    The first documented use of the word "cocktail" comes from the May 13th 1806 edition of The Balance And Columbian Repository which printed it's definition like this: " A potent concoction of spirits, bitters, water, and sugar."

    The story of the modern Old Fashioned goes something like this: A guy walk into the Pendennis Club sometime in the mid 1880's and sidles up to the bar. He asks the bartender for a drink in the Old Fashioned way. The Bartender, knowing that this guy doesn't want an improved whiskey cocktail (the drink which emerged in the wake of slings) makes this guy a bittered sling, but where this drink deviates is that he puts it on ice, which by now was available widely, and garnishes with a twist of orange, adding the essential oils of the fruit. The Old fashioned was born!

    There are many ways to make an Old Fashioned and this video is just one of those ways. And of course it's my favorite. I will though from now on be posting various other recipes for an old fashioned . Some from important cocktail bars and others from bartenders and some from you guys. So comment below and let us know your favorite Old Fashioned build!
    """
                            , ingQuantities: [2, 1, 4, 1], ingTypes: [.oz, .cube, .dash, .dash], ingNames: ["whiskey", "sugar", "angostura bitters", "seltzer"], garnish: ["orange twist"], instructions: ["place sugar in glass", "add bitters and soda", "muddle and stir to combine", "add whiskey and ice", "stir until chilled and garnish"], countryOfOrigin: "United States", glassType: [.rocks], iceType: .big, shakeOrStirTime: ShakeOrStirTime(minTime: 30, maxTime: 60), boozeLevel: .medium, flavorProfile: [.strong], dryShake: false, difficultyLevel: .hard, backgroundColor: CodableColor(red: 255, green: 128, blue: 0))

let sazerac = Cocktail(name: "Sazerac", methods: [.stirred], videoID: "RuZzOcjJUYw", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "00:44"),
                       history: """
    The Sazerac cocktail is purported to have been invented in 1850 in New Orleans by a man named Antoine Amedee Peychaud. He was a pharmacist who ran a drugstore from which he would prescribe medicine but would also make toddies and tonics as cure-alls as well as a drink with his famous Peychauds Bitters (adapted from a family recipe) which is still served in Sazeracs and other cocktails to this day. The Original recipe called for Cognac or Brandy which changed to Rye in about 1865 due to a blight on wine grapes.The Phylloxera Aphid was wreaking havoc in France and completely stopped brandy and Cognac production. The cocktail also took a hit when Absinthe was banned in the United States in 1912, but the Sazerac hungry public was more than happy to drink anise flavored liquor in it's place.
    in 2002 the ban was lifted and we can have Absinthe again, and of course we have brandy and cognac available, but the rye version has really established itself. In this video we teach with Rye, but feel fee to either replace with Brandy or split the main spirit with Brandy however you like.
    Hope you guys enjoy and don't forget to subscribe for more videos released every week.
    """
                       , ingQuantities: [2, 1, 4, 1], ingTypes: [.oz, .cube, .dash, .dash], ingNames: ["rye whiskey", "sugar", "peychauds bitters", "absinthe"], garnish: ["lemon twist"], instructions: ["wash chilled glass with absinthe", "add sugar, bitters and whiskey and muddle", "add ice and stir until chilled", "strain into prepared glass and garnish"], countryOfOrigin: "United States", glassType: [.rocks], iceType: .neat, shakeOrStirTime: ShakeOrStirTime(minTime: 15, maxTime: 20), boozeLevel: .medium, flavorProfile: [.boozy, .bitter], dryShake: false, difficultyLevel: .hard, backgroundColor: CodableColor(red: 255, green: 153, blue: 51))

let whiskeySour = Cocktail(name: "Whiskey Sour", methods: [.shaken], videoID: "hFKZPzfngcU", tutorialStartTime: minutesStringtoSecondsInt(numberToConvert: "04:18"), history: """
    Before the singular mixed drink (what we now think of as a cocktail) the practice was to drink large format drinks in a punch bowl and share it amongst friends. As time went on this began to change as the pace of life got busier and it people began to look down on sitting around for hours on end to drink a punch bowl and get hammered. People were just too busy for so much day drinking, but that didn't mean they didn't want to drink. They just needed something they could imbibe quickly: enter the one-off punch in the late 1850's. Because people had less time, bartenders began making punch recipes designed to be served to one person in a glass that could be drank quickly. According to David Wondrich the very first of these were the Fix and the Sour. And while these drinks were almost identical in ingredients, each had a different build entirely centered around how quickly you were meant to drink them. Of these two drinks it was the Sour (originally done with Gin) which captured the imagination of the public and found itself expanding into it's own category. So the sour began to get spun out into all sorts of different variations and was in it's day the most requested drink. Although the first sours were done over crushed ice the egg white variation of the drink emerged around 1890's and it was in the decade leading up to the turn of the century that so many popular variations such as the New York Sour, Jersey Sour, Jack Frost Sour and Dizzy Sour emerged. It was as Davind Wonndrich writes: "one of the cardinal points of American Drinking" and it definitely deserves consideration today. Enjoy!
    """
                           , ingQuantities: [2, 0.75, 0.75, 1], ingTypes: [.oz, .oz, .oz, .none], ingNames: ["whiskey", "lemon juice", "simple syrup", "egg white"], garnish: ["angostura bitters"], instructions: ["Add egg white into big tin of shaker", "Pour whiskey, lemon juice and simple syrup into small tin", "Combine and close tins together", "Let sit for 10 seconds then shake for 30", "Add big rock of ice and shake hard", "Double strain into chilled glass and garnish"], countryOfOrigin: "United States", glassType: [.martini, .coupe], iceType: .neat, shakeOrStirTime: ShakeOrStirTime(minTime: 12, maxTime: 15), boozeLevel: .medium, flavorProfile: [.sour, .aromatic, .creamy], dryShake: false, difficultyLevel: .hard, backgroundColor: CodableColor(red: 255, green: 255, blue: 102))

