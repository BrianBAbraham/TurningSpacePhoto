//
//  RulerPartViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 13/08/2024.
//

import Foundation
import SwiftUI

class RulerOutlineModel: ObservableObject,
//form the rectangles which make up the ruler
    PartRectangle {
    var corners: [CGPoint]
    var color: Color
    var opacity: Double
    var lineWidth: Double
    let cornerRadius = 0.0

    init(
        corners: [CGPoint],
        color: Color = .white,
        opacity: Double,
        lineWidth: Double
    ) {
        self.corners = corners
        self.color = color
        self.opacity = opacity
        self.lineWidth = lineWidth
    }
}
