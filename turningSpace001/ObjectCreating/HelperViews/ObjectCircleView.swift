//
//  CircleView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 07/08/2024.
//

import Foundation
import SwiftUI


struct ObjectCircleModifier: ViewModifier {
    let dimension: Double
    let position: CGPoint
    
    func body(content: Content) -> some View {
        content
            .frame(width: self.dimension, height: self.dimension)
            .position(self.position)
    }
}




struct MyObjectCircle: View {
    let fillColor: Color?
    let strokeColor: Color
    let dimension: Double
    let position: CGPoint
    var body: some View {
        ZStack {
            if let fillColorUnwrapped = fillColor {
                Circle()
                    .fill(fillColorUnwrapped)
                    .frame(width: dimension, height: dimension)
                    .position(position)

                Circle()
                    .fill(.black)
                    .frame(width: 10, height: 10)
                    .position(position)
                    .opacity(0.0001)
            }
            Circle()
                .stroke(strokeColor)
                .frame(width: dimension, height: dimension)
                .position(position)
        }
    }
}
