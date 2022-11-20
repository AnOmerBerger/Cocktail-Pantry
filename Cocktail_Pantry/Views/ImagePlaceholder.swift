//
//  ImagePlaceholder.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/19/22.
//

import SwiftUI

struct ImagePlaceholder: View {
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
    }
}

struct ImagePlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        ImagePlaceholder()
    }
}
