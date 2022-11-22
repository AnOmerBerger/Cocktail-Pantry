//
//  ImagePlaceholder.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/19/22.
//

import SwiftUI

struct ImageLoading: View {
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
    }
}


struct ImagePlaceholder: View {
    var body: some View {
        VStack {
            Text("Cocktail Pantry").font(.system(size: 8, weight: .bold, design: .default))
            Text("in association with").font(.system(size: 5, weight: .thin, design: .default))
            Image("The Educated Barfly Logo")
                .resizable()
                .scaledToFit()
        }
        .padding()
        .foregroundColor(.black)
    }
}

struct ImagePlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        ImagePlaceholder()
    }
}
