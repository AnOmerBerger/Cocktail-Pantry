//
//  Font add-ons.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 12/8/22.
//

import SwiftUI

enum TekoFont: String {
    case light = "Teko-Light"
    case regular = "Teko-Regular"
    case medium = "Teko-Medium"
    case semiBold = "Teko-SemiBold"
    case bold = "Teko-Bold"
}

extension Font {
    static func teko(_ font: TekoFont, size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(font.rawValue, size: size)
    }
    static func overpass(_ font: OverpassFont, size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(font.rawValue, size: size)
    }
}
enum OverpassFont: String {
    case regular = "Overpass-Regular"
    case italic = "Overpass-Italic"
    case thin = "OverpassRoman-Thin"
    case italicThin = "OverpassItalic-Thin"
    case extraLight = "OverpassRoman-ExtraLight"
    case light = "OverpassRoman-Light"
    case semiBold = "OverpassRoman-SemiBold"
    case italicSemiBold = "OverpassItalic-SemiBold"
    case bold = "OverpassRoman-Bold"
    case extraBold = "OverpassRoman-ExtraBold"
    case black = "OverpassRoman-Black"
}

func printFonts() {
    for familyName in UIFont.familyNames {
        print("-------")
        print("Font family name -> [\(familyName)]")
        print("Font names ==> [\(UIFont.fontNames(forFamilyName: familyName))]")
    }
}
