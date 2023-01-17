//
//  StoreTab.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 11/29/22.
//

import SwiftUI

struct StoreTab: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { g in
            VStack(spacing: 50) {
                Spacer()
                VStack(spacing: 18){
                    Image("The Educated Barfly Logo")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 40)
                    Text("Visit The Educated Barfly Amazon store!").font(.overpass(.regular, size: 16))
                    Link(destination: URL(string: "https://www.amazon.com/shop/theeducatedbarfly")!) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25, style: .continuous).opacity(0.6)
                            Image(systemName: "cart")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        .frame(width: 200, height: 80)
                    }
                }
                PhotoGallery(width: g.size.width - 10, height: g.size.height / 4 - 20)
                    .padding(.horizontal, 5)
                Spacer()
            }
        }
    }
}

struct StoreTab_Previews: PreviewProvider {
    static var previews: some View {
        StoreTab()
    }
}
