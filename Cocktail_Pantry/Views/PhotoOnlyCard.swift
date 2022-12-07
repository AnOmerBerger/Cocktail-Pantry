//
//  PhotoOnlyCard.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/30/22.
//

import SwiftUI

struct PhotoOnlyCard: View {
    var cocktail: Cocktail
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: URL(string: cocktail.imageURL ?? "http://stupid")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: cocktail.backgroundColor.red/255, green: cocktail.backgroundColor.green/255, blue: cocktail.backgroundColor.blue/255), Color.white]), startPoint: UnitPoint.top, endPoint: UnitPoint.bottomLeading).opacity(0.8)
                    } else {
                        ImageLoading()
                    }
                }
                .clipShape(Circle())
                .blur(radius: 2)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(.white).opacity(0.4)
                        Text(cocktail.name)
                            .foregroundColor(.black)
                            .font(.headline)
                            .bold()
                            .kerning(5)
                            .italic()
                            .shadow(radius: 2)
                    }
                }
                
            }
            .frame(width: 250, height: 160)
            .clipped()
        }
    }
}

struct PhotoOnlyCard_Previews: PreviewProvider {
    static var previews: some View {
        PhotoOnlyCard(cocktail: sazerac)
    }
}
