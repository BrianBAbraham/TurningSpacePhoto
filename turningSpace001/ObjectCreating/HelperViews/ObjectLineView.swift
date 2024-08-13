//
//  LineView.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import SwiftUI






struct ObjectLineView: View {
    let lineWidth: Double
    let startOfDivisionMark: CGPoint
    let endOfDivisionMark: CGPoint

    var body: some View {
        
        Path { path in
            path.move(to: startOfDivisionMark)
            path.addLine(to: endOfDivisionMark)
        }
        .stroke(Color("rulerMarks"), lineWidth: lineWidth)
    }
}
