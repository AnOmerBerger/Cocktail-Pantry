//
//  BackSwipe_Extension.swift
//  Cocktail_Pantry
//
//  Created by Omer Berger on 1/2/23.
//

import SwiftUI

// re-enables backswipe when back-button is hidden. Taken from StackOverflow
// https://stackoverflow.com/questions/59921239/hide-navigation-bar-without-losing-swipe-back-gesture-in-swiftui

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
