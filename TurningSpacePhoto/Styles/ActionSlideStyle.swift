//
//  ActionSlideStyle.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//
import SwiftUI

struct ActionSlideStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
        .transition(.move(edge: .bottom))
        .onAppear{
            withAnimation(Animation.easeInOut(duration: 1.5)) {}
        }
    }
}


