//
//  CocktailCard.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 5/24/22.
//

import SwiftUI


// MARK: - cocktailCard for VStack


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
        RoundedRectangle(cornerRadius: 22)
            .frame(width: UIScreen.main.bounds.size.width - 15, height: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 150, alignment: .center)
            .foregroundColor(cardColor).opacity(0.8)
            .overlay {
                HStack {
                    ZStack {
                        Color.gray.opacity(0.2)
                        CustomAsyncImage(urlString: cocktail.imageURL, withPlaceholder: true)
                            .scaledToFill()
                    }
                    .frame(maxWidth: (UIScreen.main.bounds.size.width - 20) / 3.5, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 170 : 100)
                    .clipped()
                    
                    Divider()
                    
                    VStack {
                        Text(ingredientsList.1)
                    }
                    .frame(maxWidth: (UIScreen.main.bounds.size.width - 20) / 3.5)
                    
                    Divider()
                    
                    VStack {
                        ForEach(cocktail.flavorProfile, id: \.self) { flavor in
                            FlavorProfileView(text: flavor.rawValue)
                        }
                        Spacer()
                        Divider()
                        Text(cocktail.difficultyLevel.rawValue).bold()
                    }
                    .frame(maxWidth: (UIScreen.main.bounds.size.width - 20) / 3.5)
                }
                .foregroundColor(.black)
                .padding()
            }
    }
}






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
//                                ForEach(ingredientsList, id: \.self) { ingredientName in
//                                    Text(ingredientName)
//                                        .layoutPriority(1)
//                                        .lineLimit(1)
//                                }
                            }
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


// MARK: - cocktailCard for grid

struct CocktailCard: View {
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

// MARK: - assisting structs

struct FlavorProfileView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 0).fill().foregroundColor(.white.opacity(0.4))
                RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 1.2)
                RoundedRectangle(cornerRadius: 0).stroke(Color.black, lineWidth: 0.4)
            }
            .frame(width: 70, height: 25, alignment: .center)
            Text(text)
                .font(.caption)
                .italic()
                .padding(.horizontal, 3)
        }
    }
}

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

struct CocktailCard_Previews: PreviewProvider {
    static var previews: some View {
        CocktailCardWithImage(cocktail: oldFashioned)
    }
}
