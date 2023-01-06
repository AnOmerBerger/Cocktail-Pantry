//
//  CustomAsyncImage.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 12/4/22.
//

import SwiftUI

struct CustomAsyncImage: View {
    var urlString: String?
    var withPlaceholder: Bool
    
    var body: some View {
        if urlString != nil {
            //
            AsyncImage(url: URL(string: urlString!)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                } else if phase.error != nil {
                    if withPlaceholder {
                        ImagePlaceholder()
                    }
                } else {
                    ImageLoading()
                }
            }
        } else { // if urlString == nil
            if withPlaceholder {
                ImagePlaceholder()
            }
        }
    }
}
