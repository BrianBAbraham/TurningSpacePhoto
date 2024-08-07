//
//  ForObjectDrag.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/05/2023.
//

import SwiftUI

struct ForObjectDrag: ViewModifier {
    let frameSize: Dimension
    @State private var location = CGPoint (x: 0, y: 0)
    @GestureState private var startLocation: CGPoint? = nil
    let active: Bool

    
    
    var objectDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location // 3
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location // 2
            }
    }
    
    func body(content: Content) -> some View {
        if active == true {
            content
                .frame(width: frameSize.width, height: frameSize.length)
                .position(location)
                .gesture(objectDrag)
                
        } else {
            content
        }

    }
}

