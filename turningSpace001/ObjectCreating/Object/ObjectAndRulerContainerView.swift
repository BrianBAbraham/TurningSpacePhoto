//
//  ObjectAndRulerContainerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//
import SwiftUI


import SwiftUI

struct ObjectAndRulerContainerView: View {
    
    let displayStyle: ObjectDisplayStyle
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let widthOffset = screenWidth * 0.25
            let heightOffset = screenHeight * 0.5

            VStack {
                ZStack {
                    AllPartWithArcContainerView(
                        displayStyle: displayStyle)
                   
                    RightAngleRulerView()
                    
                }
                    .offset(x: widthOffset, y: heightOffset)
            }
            .frame(width: screenWidth, height: screenHeight, alignment: .leading)
        }
    }
}

