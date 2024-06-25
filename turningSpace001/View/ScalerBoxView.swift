//
//  ScalerBoxView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 03/10/2022.
//

import SwiftUI

struct DragScalerBox: View {
    //@EnvironmentObject var pictureScaleViewModel: PictureScaleViewModel
    let side: String
    let locationScalerTriangle: CGPoint
    let dragScalerTriangle: _ChangedGesture<DragGesture>
    init (_ side:String, _ locationScalerTriangle: CGPoint, _ dragScalerTriangle: _ChangedGesture<DragGesture> ) {
        self.side = side
        self.locationScalerTriangle = locationScalerTriangle
        self.dragScalerTriangle = dragScalerTriangle
         }
    var body: some View {
        ZStack {
            ScalerBoxView().creation(side)
//            Image(systemName: pictureScaleViewModel.getScalerBoxTap() ? "hand.tap.fill": "hand.tap")
//            .font(Font.system(.largeTitle))
        }
        .position(locationScalerTriangle)
        .gesture(dragScalerTriangle)
//        .onTapGesture {
//            pictureScaleViewModel.setScalerBoxTap()
//            }
    }
}
        


struct DashLine{
//    let dotSize = 10.0
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: PictureScaleView.scalerBoxSize/2, y : -5000))
            path.addLine (to : CGPoint(x: PictureScaleView.scalerBoxSize/2, y: 5000 ))
        }
        .stroke(.red, style: StrokeStyle(dash: [5]))
    }
}
struct Box {
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .opacity(0.3)
            .frame(width: PictureScaleView.scalerBoxSize, height: PictureScaleView.scalerBoxSize)
    }
}

struct Triangle {
    let xValue: CGFloat
    init (_ name: String){
        if name == "left" {
            xValue = PictureScaleView.scalerBoxSize/3 }
        else {
            xValue = -PictureScaleView.scalerBoxSize/3
        }
    }
    var body: some View {
           Path { path in
               path.move(to: CGPoint(x : 0, y : 0))
               path.addLine (to : CGPoint(x: xValue, y: -1 * PictureScaleView.scalerBoxSize/2))
               path.addLine (to : CGPoint(x: xValue, y: PictureScaleView.scalerBoxSize/2))
               path.addLine (to : CGPoint(x: 0, y : 0))
           }
           .foregroundColor(.blue)
       }
}

struct ScalerBoxView {
    func creation(_ name: String) -> some View {
      let myView =
        VStack{
            if name == "right" {
                ZStack{
                    Box().body
                    Triangle(name).body
                        .offset(x: PictureScaleView.scalerBoxSize, y: PictureScaleView.scalerBoxSize/2)
                    
                    DashLine().body
                        .offset(x: PictureScaleView.scalerBoxSize/2)
                }
            }
            if name == "left" {
                ZStack {
                    Box().body
                    Triangle(name).body
                        .offset(y: PictureScaleView.scalerBoxSize/2)
                    DashLine().body
                        .offset(x: -PictureScaleView.scalerBoxSize/2)
                }
            }
        }
        .frame(width: PictureScaleView.scalerBoxSize, height: PictureScaleView.scalerBoxSize)
        return myView
    }
}

//

