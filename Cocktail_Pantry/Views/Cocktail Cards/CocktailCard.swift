//
//  CocktailCard.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/24/22.
//

import SwiftUI

struct CocktailCardWithImage: View {
    var cocktail: Cocktail
    var cardColor: Color { Color(red: cocktail.backgroundColor.red/255, green: cocktail.backgroundColor.green/255, blue: cocktail.backgroundColor.blue/255) }
    
    var ingredientsList: ([String], String) {
        var list = [String]()
        var longString = ""
        for ing in cocktail.ingNames {
            list.append(ing)
            longString += "\(ing), "
        }
        longString.removeLast() ; longString.removeLast()
        return (list, longString)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .frame(width: UIScreen.main.bounds.size.width - 15, height: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 150, alignment: .center)
            .foregroundColor(cardColor).opacity(0.8)
            .overlay {
                HStack {
                    ZStack {
                        Color.gray.opacity(0.2)
                        CustomCacheAsyncImage(urlString: cocktail.imageURL, withPlaceholder: true)
                            .scaledToFill()
                    }
                    .frame(maxWidth: (UIScreen.main.bounds.size.width - 20) / 3.5, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 170 : 100)
                    .clipped()
                    
                    Divider()
                    
                    VStack {
                        Text(ingredientsList.1).font(.overpass(.semiBold, size: 14))
                    }
                    .frame(maxWidth: (UIScreen.main.bounds.size.width - 20) / 3.5)
                    
                    Divider()
                    
                    VStack {
                        Spacer()
                        allFlavors
                            .padding(.top, 8)
                        Spacer()
                        Divider()
                        Spacer()
                        Text(cocktail.difficultyLevel.rawValue).bold().font(.overpass(.black, size: 17))
                        Spacer()
                    }
                    .frame(maxWidth: (UIScreen.main.bounds.size.width - 20) / 3.5)
                }
                .foregroundColor(.black)
                .padding()
            }
    }
}


// MARK: - assisting structs

extension CocktailCardWithImage {
    var allFlavors: some View {
        VStack (spacing: 0){
            if cocktail.flavorProfile.count <= 3 {
                VStack(spacing: 2) {
                    ForEach(cocktail.flavorProfile, id: \.self) { flavor in
                        FlavorProfileView(text: flavor.rawValue)
                    }
                }
            } else {
                VStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { index in
                        FlavorProfileView(text: cocktail.flavorProfile[index].rawValue)
                    }
                }
                Text("...").font(.custom(.semiBold, size: 18)).kerning(3).padding(.vertical, -8)
            }
        }
        .frame(alignment: .bottom)
    }
}


struct CocktailCard_Previews: PreviewProvider {
    static var previews: some View {
        CocktailCardWithImage(cocktail: oldFashioned)
    }
}
