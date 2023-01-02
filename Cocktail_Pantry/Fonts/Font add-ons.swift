//
//  Font add-ons.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 12/8/22.
//

import SwiftUI

enum CustomFont: String {
    case light = "Teko-Light"
    case regular = "Teko-Regular"
    case medium = "Teko-Medium"
    case semiBold = "Teko-SemiBold"
    case bold = "Teko-Bold"
}

extension Font {
    static func custom(_ font: CustomFont, size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(font.rawValue, size: size)
    }
}

func printFonts() {
    for familyName in UIFont.familyNames {
        print("-------")
        print("Font family name -> [\(familyName)]")
        print("Font names ==> [\(UIFont.fontNames(forFamilyName: familyName))]")
    }
}
