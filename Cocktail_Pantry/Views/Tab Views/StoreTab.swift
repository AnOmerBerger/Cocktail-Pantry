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
        VStack(spacing: 18) {
            Image("The Educated Barfly Logo")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 40)
            Text("Visit The Educated Barfly Amazon store!")
            Link(destination: URL(string: "https://www.amazon.com/shop/theeducatedbarfly?listId=2CM22Z2HJBY14&ref=exp_theeducatedbarfly_vl_vv_d")!) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25).opacity(0.6)
                    Image(systemName: "cart")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 80)
            }
        }
    }
}

struct StoreTab_Previews: PreviewProvider {
    static var previews: some View {
        StoreTab()
    }
}
