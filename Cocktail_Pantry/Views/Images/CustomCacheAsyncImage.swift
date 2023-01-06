//
//  CustomCacheAsyncImage.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/5/23.
//

import SwiftUI

struct CustomCacheAsyncImage: View {
    var urlString: String?
    var withPlaceholder: Bool
    
    var body: some View {
        if urlString != nil {
            
            CacheAsyncImage(url: URL(string: urlString!)!) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                case .failure:
                    if withPlaceholder { ImagePlaceholder() }
                case .empty:
                    ImageLoading()
                @unknown default:
                    ImagePlaceholder()
                }
            }
        } else {
            if withPlaceholder { ImagePlaceholder() }
        }
    }
}

struct CustomCachAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CustomCacheAsyncImage(urlString: negroni.imageURL, withPlaceholder: false)
    }
}
