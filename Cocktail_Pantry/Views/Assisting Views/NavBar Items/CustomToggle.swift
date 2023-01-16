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
    @State var extraBoolForContainedAnimation: Bool = true // created to make toggle animation without animating other views that are reliant on the @Binding it's connected to
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(extraBoolForContainedAnimation ? Color("LaunchScreenColor") : Color.gray.opacity(0.7))
                    .frame(width: 27, height: 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.white)
                            .frame(width: 15, height: 14)
                            .padding(.horizontal, 0.6),
                        alignment: extraBoolForContainedAnimation ? .trailing : .leading
                    )
                Text(isOn ? textOn : textOff).font(.custom(.regular, size: 16)).kerning(0.7).foregroundColor(isOn ? Color("LaunchScreenColor") : .gray)
            }
            .onTapGesture {
                isOn.toggle()
                withAnimation(Animation.easeOut(duration: 0.2)) {
                    extraBoolForContainedAnimation.toggle()
                }
            }
            Spacer()
        }
        .onAppear { extraBoolForContainedAnimation = isOn }
    }
}

struct CustomToggle_Previews: PreviewProvider {
    static var previews: some View {
        CustomToggle(textOn: "pantry mode", textOff: "simple search", isOn: .constant(true))
    }
}
