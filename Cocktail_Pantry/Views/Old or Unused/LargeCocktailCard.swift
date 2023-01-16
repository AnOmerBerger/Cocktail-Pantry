//
//  LargeCocktailCard.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/9/23.
//

import SwiftUI

struct LargeCocktailCard: View {
    var cocktail: Cocktail // the cocktail to load in
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
    
    @Binding var videoIDforVideoPlayer: String
    @Binding var showVideoPlayerOverlay: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: UIScreen.main.bounds.size.width - 20, height: 200, alignment: .center)
                .foregroundColor(cardColor).opacity(0.8)
                .overlay {
                    VStack {
                        Text(cocktail.name).bold()
                        Spacer()
                        VStack {
                            HStack {
                                AllFlavorsView(profile: cocktail.flavorProfile)
                            }
                            Text("******")
                            HStack {
                                Text(ingredientsList.1)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                Spacer()
                                ZStack {
                                    HStack {
                                        ForEach(cocktail.methods, id: \.self) { method in
                                            methodDisplay(method: method)
                                        }
                                        Spacer()
                                        VStack {
                                            Image(systemName: "play.circle")
                                                .imageScale(.large)
                                                .foregroundColor(.blue)
                                            Text("video")
                                                .font(.caption)
                                        }
                                        .onTapGesture {
                                            videoIDforVideoPlayer = cocktail.videoID
                                            showVideoPlayerOverlay = true
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        Text(cocktail.difficultyLevel.rawValue).bold()
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    }
                }
        }
    }
}

//MARK: - assisting structs

struct AllFlavorsView: View {
    var profile: [FlavorProfile]
    
    var body: some View {
        if profile.count <= 2 {
            HStack {
                ForEach(profile, id: \.self) { flavor in
                    FlavorProfileView(text: flavor.rawValue)
                }
            } .padding(.horizontal)
        } else if profile.count == 3 {
            VStack {
                HStack {
                    ForEach(profile[0..<2], id: \.self) { flavor in
                        FlavorProfileView(text: flavor.rawValue)
                    }
                }
                HStack {
                    ForEach(profile[2..<3], id: \.self) { flavor in
                        FlavorProfileView(text: flavor.rawValue)
                    }
                }
            } .padding(.horizontal)
        } else if profile.count == 4 {
            VStack {
                HStack {
                    ForEach(profile[0..<2], id: \.self) { flavor in
                        FlavorProfileView(text: flavor.rawValue)
                    }
                }
                HStack {
                    ForEach(profile[2..<4], id: \.self) { flavor in
                        FlavorProfileView(text: flavor.rawValue)
                    }
                }
            } .padding(.horizontal)
        }
    }
}

struct methodDisplay: View {
    let method: Method
    var methodImageName: String
    
    init(method: Method) {
        self.method = method
        switch method {
        case .stirred:
            methodImageName = "pencil.and.outline"
        case .shaken:
            methodImageName = "scribble.variable"
        case .built:
            methodImageName = "building"
        }
    }
    
    var body: some View {
        ZStack {
            Image(systemName: methodImageName).foregroundColor(.gray.opacity(0.8))
                .shadow(color: .white, radius: 15, x: 0, y: 0)
        }
        .frame(maxHeight: 50)
    }
}
