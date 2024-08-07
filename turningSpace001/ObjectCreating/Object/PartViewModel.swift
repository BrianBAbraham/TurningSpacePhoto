//
//  PartViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import SwiftUI
//import Combine

enum ObjectDisplayStyle {
    case movement
    case edit
}

protocol PartRectangle {
    var corners: [CGPoint] {get}
    var color: Color {get}
    var opacity: Double {get}
    var lineWidth: Double {get}
    var cornerRadius: Double {get}
}
extension PartRectangle {
    func path() -> Path {
        var path = Path()
        
        guard corners.count >= 3 else { return path }
        
        let distances = corners.indices.map { index -> CGFloat in
            let nextIndex = (index + 1) % corners.count
            return distance(corners[index], corners[nextIndex])
        }
        
        var adjustedPoints: [CGPoint] = []
        
        for i in corners.indices {
            let prevIndex = (i - 1 + corners.count) % corners.count
            let nextIndex = (i + 1) % corners.count
            
            let prevSegmentLength = min(cornerRadius, distances[prevIndex] / 2.0)
            let nextSegmentLength = min(cornerRadius, distances[i] / 2.0)
            
            let prevPoint = pointAlongLine(from: corners[prevIndex], to: corners[i], distance: prevSegmentLength)
            let nextPoint = pointAlongLine(from: corners[nextIndex], to: corners[i], distance: nextSegmentLength)
            
            adjustedPoints.append(prevPoint)
            adjustedPoints.append(corners[i])
            adjustedPoints.append(nextPoint)
        }
        
        for (i, point) in adjustedPoints.enumerated() where i % 3 == 0 {
            let nextI = (i + 2) % adjustedPoints.count
            let midI = (i + 1) % adjustedPoints.count
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            
            path.addArc(tangent1End: adjustedPoints[midI], tangent2End: adjustedPoints[nextI], radius: cornerRadius)
        }
        
        path.closeSubpath()
        
        return path
    }
    
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
    }
    
    private func pointAlongLine(from: CGPoint, to: CGPoint, distance: CGFloat) -> CGPoint {
        let fullDistance = self.distance(from, to)
        let ratio = distance / fullDistance
        
        let newX = from.x + ratio * (to.x - from.x)
        let newY = from.y + ratio * (to.y - from.y)
        
        return CGPoint(x: newX, y: newY)
    }
}

class PartViewModel: ObservableObject, 
        PartRectangle {
    @Published var color: Color
    @Published var opacity: Double
    @Published var lineWidth: Double
    var corners: [CGPoint]
    var cornerRadius: Double
    var displayStyle: ObjectDisplayStyle
    
    init(
        corners: [CGPoint],
        color: Color,
        opacity: Double,
        lineWidth: Double,
        cornerRadius: CGFloat,
        displayStyle: ObjectDisplayStyle
    ) {
        self.corners = corners
        self.color = displayStyle == .edit ? color: .white
        self.opacity = opacity
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.displayStyle = displayStyle
    }
}
