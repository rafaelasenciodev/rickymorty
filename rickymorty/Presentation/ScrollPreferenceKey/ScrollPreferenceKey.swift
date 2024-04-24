//
//  ScrollPreferenceKey.swift
//  rickymorty
//
//  Created by Rafael Asencio Blancat on 22/4/24.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
