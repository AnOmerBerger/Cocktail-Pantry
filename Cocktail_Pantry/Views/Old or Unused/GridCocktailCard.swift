//
//  GridCocktailCard.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/9/23.
//

import SwiftUI

struct GridCocktailCard: View {
    var cocktail: Cocktail // the cocktail to load in
    var ingredientsList: [String] {
        var list = [String]()
        for ing in cocktail.ingNames {
            list.append(ing)
        }
        return list
    }
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 190, height: 250, alignment: .center)
                    .foregroundColor(.black.opacity(0.8))
                VStack {
                    Text(cocktail.name).bold()
                    Spacer()
                    ScrollView {
                        VStack {
                            AllFlavorsView(profile: cocktail.flavorProfile)
                            Text("******")
                            ForEach(ingredientsList, id: \.self) { ingredientName in
                                Text(ingredientName)
                            }
                            .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxHeight: 150)
                    Spacer()
                    HStack {
                        ForEach(cocktail.methods, id: \.self) { method in
                            methodDisplay(method: method)
                        }
                        Spacer()
                        Text(cocktail.difficultyLevel.rawValue).bold()
                        Spacer()
                        NavigationLink(
                            destination: CocktailPage(cocktail: cocktail),
                            label: {
                                Image(systemName: "arrowtriangle.right.fill")
                                    .offset(x: 6, y: 5)
                                    .rotationEffect(Angle.degrees(30))
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            })
                    }
                }
                .foregroundColor(.white)
                .padding()
            }
    }
}
