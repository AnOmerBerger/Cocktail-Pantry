//
//  TitleAndIcon.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/16/23.
//

import SwiftUI

struct TitleAndIcon: View {
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Text("Cocktail Pantry").font(.overpass(.semiBold, size: 16))
            Image("Pruple_Logo_transparent").resizable().scaledToFit()
            
        }
    }
}
