//
//  ViewModifier.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/03/2024.
//

import SwiftUI


struct GreenWithOpacity: ViewModifier {
    var opacity: Double
    
    init(opacity: Double = 1.0) {
        self.opacity = opacity
    }
    
    
    func body(content: Content) -> some View {
     
            content.background(Color(red: 220/255, green: 255/255, blue: 220/255))

    }
}

extension View {
    func backgroundModifier() -> some View {
        self.modifier(GreenWithOpacity())
    }
}



struct OpacityAndScaleModifierForPicker: ViewModifier {
    var opacity: Double
    var scale: CGFloat

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .scaleEffect(scale)
    }
}


