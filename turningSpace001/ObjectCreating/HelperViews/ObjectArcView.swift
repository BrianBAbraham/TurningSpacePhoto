//
//  ObjectArcView.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import SwiftUI


struct ArcView: View {
    let origin: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    init(
        _ anglesRadius: ArcData,
        _ staticPoint: [PositionAsIosAxes]
    ){
        
        self.origin = CGPoint(x: staticPoint[0].x, y: staticPoint[0].y)
        radius = anglesRadius.radius
        startAngle = Angle(radians: Double(anglesRadius.start))
        endAngle = Angle(radians: Double(anglesRadius.end))
        clockwise = anglesRadius.clockwise
    }
        
    var body: some View {
        ZStack{
            Path { path in
                path.addArc(center: origin,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: !clockwise
                )
            }
            .stroke(Color.black, lineWidth: 1)
        }
    }
}


struct ArcPointView: View {
    let position: [PositionAsIosAxes]?
    var screenPosition: CGPoint {
        if let unwrapped = position {
            return CGPoint(x: unwrapped[0].x, y: unwrapped[0].y)
        } else {
            return CGPoint.zero
        }
    }
    
    init(position: [PositionAsIosAxes]?) {
        self.position = position
    }
    var body: some View {
        MyObjectCircle(fillColor: .red, strokeColor: .black, dimension
                 :20, position: screenPosition)
    }
}
