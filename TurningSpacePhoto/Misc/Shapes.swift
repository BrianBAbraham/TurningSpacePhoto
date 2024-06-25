//
//  Shapes.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import Foundation
import SwiftUI

struct LocalFilledRectangle {
   static func path(_ xPathStarts: CGFloat, _ yPathStarts: CGFloat, _ width: CGFloat, _ length: CGFloat, _ myColor: Color, _ myOpacity: Double) -> some View {
       Path { path in
           path.move(to: CGPoint(x:    xPathStarts, y: yPathStarts ))
           path.addLine(to: CGPoint(x: xPathStarts + width, y: yPathStarts ))
           path.addLine(to: CGPoint(x: xPathStarts + width, y: yPathStarts + length ))
           path.addLine(to: CGPoint(x: xPathStarts , y: yPathStarts + length  ))
           path.closeSubpath()

       }
//       .stroke(.black)
      .fill(myColor)
      .opacity(myOpacity)
   }
}

struct LocalOutlineRectangle {
//    @Environment(\.colorScheme) var colorScheme
//    var darkMode: Color {
//        colorScheme == .dark ? Color.white: Color.black
//    }
    
   static func path(_ xPathStarts: CGFloat, _ yPathStarts: CGFloat, _ width: CGFloat, _ length: CGFloat, _ myColor: Color, _ myOpacity: Double) -> some View {
       Path { path in
           path.move(to: CGPoint(x:    xPathStarts, y: yPathStarts ))
           path.addLine(to: CGPoint(x: xPathStarts + width, y: yPathStarts ))
           path.addLine(to: CGPoint(x: xPathStarts + width, y: yPathStarts + length ))
           path.addLine(to: CGPoint(x: xPathStarts , y: yPathStarts + length  ))
           path.closeSubpath()
       }
       .stroke(.black)
       .opacity(myOpacity)
   }
    
//    func blackOrWhite() ->Color {
//        var colorAllowingForDarkMode: Color {
//            colorScheme == .dark ? Color.white: Color.black
//        }
//        return colorAllowingForDarkMode
//    }
}

struct LocalLine {
    static func path(_ points: [CGPoint]) -> some View {
         Path { path in
             path.move(to: points[0])
             path.addLine(to: points[1] )
         }
        .stroke(.black, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))}
}

struct MyCircle: View {
    let strokeColor: Color
    let fillColor: Color?
    let dimension: Double
    let position: CGPoint
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    init(fillColor: Color?, strokeColor: Color,  _ dimension: Double, _ position: CGPoint) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.dimension = dimension
        self.position = position
    }
    var body: some View {
        ZStack{
            if let fillColorUnwrapped = fillColor {
                ZStack{
                    Circle()
                        .fill(fillColorUnwrapped)
                        .modifier(CircleModifier( dimension: dimension, position: position))
                    Circle()
                        .fill(.black)
//                        .modifier(CircleModifier( dimension: dimension * (horizontalSizeClass == .compact ? 2:2), position: position))
                        .modifier(CircleModifier( dimension: 30, position: position))
                        .opacity(0.0001)
                }
            }
            Circle()
                .stroke(self.strokeColor)
                .modifier(CircleModifier( dimension: dimension, position: position))
        }
    }
}

struct MyBackgroundlessCircle: View {
    let dimension: Double
    let position: CGPoint
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    init( _ dimension: Double, _ position: CGPoint) {
        self.dimension = dimension
        self.position = position
    }
    var body: some View {
                    Circle()
                        .fill(.black)
                        .modifier(CircleModifier( dimension: 45, position: position))
//                        .modifier(CircleModifier( dimension: dimension * (horizontalSizeClass == .compact ? 1.5:1), position: position))
                        .opacity(0.00001)
    }
}

struct CircleModifier: ViewModifier {
    let dimension: Double
    let position: CGPoint
    
    func body(content: Content) -> some View {
        content
            .frame(width: self.dimension, height: self.dimension)
            .position(self.position)
    }
}

struct ArcPath: Shape {
    let arcCentre: CGPoint
    let radius: Double
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
//        path.move(to: arcCentre)
        path.addArc(center: arcCentre, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}



//struct Arc {
//    let basePath = CGMutablePath()
//    let startAngle: Angle
//    let endAngle: Angle
//    let clockwise: Bool = true
//    let x: Double
//    let y: Double
////    let radius: CGFloat
//
//    let radii: [CGFloat] = [10, 20, 30, 40]
//    for radius in radii {
//            // Move to the start point of the arc
//        basePath.move(to: CGPoint(x: center.x + radius * cos(startAngle),
//                                  y: center.y + radius * sin(startAngle)))
//        // Add the arc, starting at that same point
//        basePath.addArc(center: center, radius: radius,
//                        startAngle: startAngle, endAngle: endAngle,
//                        clockwise: true)
//    }
    
//  func path(in rect: CGRect) -> Path {
//    var path = Path()
//      let radius = max(rect.size.width, rect.size.height) / 2
//    path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
//                radius: radius,
//                startAngle: startAngle,
//                endAngle: endAngle,
//                clockwise: clockwise)
//    return path
//  }
//}


struct Line : Shape {
    let firstPoint: CGPoint
    let secondPoint: CGPoint
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        return path
    }
}

struct StrokedLine: View {
    let firstPoint: CGPoint
    let secondPoint: CGPoint
    let color: Color
    let lineWidth: Double
    init(_ firstPoint: CGPoint, _ secondPoint: CGPoint, _ color: Color, _ lineWidth: Double){
        self.firstPoint = firstPoint
        self.secondPoint = secondPoint

        self.color = color
        self.lineWidth = lineWidth
    }
    var body: some View {
        Line(firstPoint: firstPoint, secondPoint: secondPoint)
            .stroke(lineWidth: lineWidth)
            .fill(self.color)
    }
}
