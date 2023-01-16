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
        ZStack {
            VStack {
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
                .blur(radius: 1.5)
                .overlay {
                    RoundedRectangle(cornerRadius: 30, style: .continuous )
                        .foregroundColor(.white).opacity(0.4)
                }
                
            }
            .frame(width: 220, height: 135)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous ))
            
            VStack {
                Spacer()
                Text(cocktail.name)
                    .foregroundColor(.black)
                    .font(.custom(.semiBold, size: 23))
                    .kerning(4.5)
                    .italic()
                    .shadow(radius: 1, x: 3, y: 2.4)
                    .padding(.bottom, 6)
            }
        }
    }
}

struct PhotoOnlyCard_Previews: PreviewProvider {
    static var previews: some View {
        PhotoOnlyCard(cocktail: negroni)
    }
}
