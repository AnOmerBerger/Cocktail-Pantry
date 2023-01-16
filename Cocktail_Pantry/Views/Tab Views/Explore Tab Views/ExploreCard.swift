//
//  ExploreCard.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/3/23.
//

import SwiftUI

struct ExploreCard: View {
    var text: String
    var imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0).foregroundColor(.white).frame(width: 130, height: 100)
            VStack {
                Image(imageName)
                    .resizable().scaledToFill().frame(width: 130, height: 100).clipped()
                Text(text).font(.custom(.light, size: 22)).foregroundColor(.black).padding(.bottom, 5).frame(height: 30)
            }
            .frame(width: 130, height: 130)
            RoundedRectangle(cornerRadius: 0).stroke(lineWidth: 1.5).foregroundColor(.gray).frame(width: 130, height: 130)
        }
    }
}
