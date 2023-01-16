//
//  ChevronBackButton.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/3/23.
//

import SwiftUI

struct ChevronBackButton: View {
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.black)
                .scaleEffect(1.18)
                .contentShape(Rectangle())
        }
    }
}
