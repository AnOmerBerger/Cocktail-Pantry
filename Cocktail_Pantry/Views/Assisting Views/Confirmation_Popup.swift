//
//  Confirmation_Popup.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/3/23.
//

import SwiftUI

struct Confirmation_Popup: View {
    @EnvironmentObject var viewModel: ViewModel
    var savedCocktailsCount: Int { viewModel.savedCocktails.count }
    @Binding var showPopup: Bool
    
    @State var addRemoveTrend: Int = 0
    var addRemoveText: String {
        switch addRemoveTrend {
        case -1:
            return "removed from"
        case 1:
            return "added to"
        default:
            return ""
        }
    }
    var body: some View {
        Text("\(addRemoveText) favorites").foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.72), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .opacity(showPopup ? 1 : 0)
            .onChange(of: savedCocktailsCount) { [savedCocktailsCount] newCount in
                if newCount > savedCocktailsCount {
                    addRemoveTrend = 1
                } else if newCount < savedCocktailsCount {
                    addRemoveTrend = -1
                }
                withAnimation {
                    showPopup = true
                }
                withAnimation(Animation.default.delay(2)) {
                    showPopup = false
                }
            }
    }
}

struct Confirmation_Popup_Previews: PreviewProvider {
    static var previews: some View {
        Confirmation_Popup(showPopup: Binding.constant(true)).environmentObject(ViewModel())
    }
}
