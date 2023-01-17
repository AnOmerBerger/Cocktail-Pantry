//
//  FlavorProfileView.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/9/23.
//

import SwiftUI

struct FlavorProfileView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: 0).fill().foregroundColor(.white.opacity(0.4))
                RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 1.2)
                RoundedRectangle(cornerRadius: 0).stroke(Color.black, lineWidth: 0.4)
            }
            .frame(width: 75, height: 25, alignment: .center)
            Text(text)
                .font(.overpass(.light, size: 11))
                .italic()
                .padding(.horizontal, 3)
                .foregroundColor(.black)
        }
    }
}
