//
//  LineView.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import SwiftUI




struct ObjectLine: View {
    
   let tertiaryMarkElement: CornerDictionary
   var dictionaryElementIn: DictionaryElementIn {
        DictionaryElementIn(
            tertiaryMarkElement,
            Array(tertiaryMarkElement.keys)[0]
        )
    }
    
    var partCorners: [CGPoint] {
        dictionaryElementIn.cgPointsOut2()
    }
   
    var body: some View {
        
        Path { path in
            path.move(to: CGPoint(x: partCorners[0].x, y: partCorners[0].y))
            path.addLine(to: CGPoint(x: partCorners[1].x, y: partCorners[1].y))
        }
        .stroke(Color("rulerMarks"), lineWidth: 1)
    }
}
