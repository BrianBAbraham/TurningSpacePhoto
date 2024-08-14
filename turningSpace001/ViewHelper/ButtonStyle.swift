//
//  ButtonStyle.swift
//  turningSpace001
//
//  Created by Brian Abraham on 31/10/2022.
//

import SwiftUI

struct TopNavigationBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("Orange"))

            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct PictureScaleBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(4)
            .background(Color("Orange"))
            .foregroundColor(.blue)
            .clipShape(Capsule())
            .shadow(radius: 2)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
