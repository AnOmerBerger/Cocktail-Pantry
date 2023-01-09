//
//  CustomToggle.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/7/23.
//

import SwiftUI

struct CustomToggle: View {
    var textOn: String
    var textOff: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(isOn ? Color.purple : Color.gray.opacity(0.7))
                    .frame(width: 27, height: 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.white)
                            .frame(width: 15, height: 14)
                            .padding(.horizontal, 0.6),
                        alignment: isOn ? .trailing : .leading
                    )
                Text(isOn ? textOn : textOff).font(.caption).fontWeight(.semibold).foregroundColor(isOn ? .purple : .gray)
            }
            .onTapGesture { isOn.toggle() }
            Spacer()
        }
    }
}

struct CustomToggle_Previews: PreviewProvider {
    static var previews: some View {
        CustomToggle(textOn: "pantry mode", textOff: "simple search", isOn: .constant(true))
    }
}
