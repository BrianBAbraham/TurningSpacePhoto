//
//  ScaleValueProviderView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 03/10/2022.
//

import SwiftUI


struct ScalingToolView: View {
    @EnvironmentObject var scalingToolVM: ScalingToolViewModel
    var dragLeftScalingTool: some Gesture {
        DragGesture()
            .onChanged { value in
                scalingToolVM.setLeftScalingToolPosition(value.location)
            }
    }
    
    var dragRightScalingTool: some Gesture {
        DragGesture()
            .onChanged { value in
                scalingToolVM.setRightScalingToolPosition(value.location)
            }
    }
    
    var body: some View {
        if !scalingToolVM.isDisabled {
            
            DragScalerBoxView("left", scalingToolVM.leftScalingToolPosition, dragLeftScalingTool as! _ChangedGesture<DragGesture>)
            DragScalerBoxView("right", scalingToolVM.rightScalingToolPosition, dragRightScalingTool as! _ChangedGesture<DragGesture>)
        } else {
            EmptyView()
        }
    }
}



struct DragScalerBoxView: View {

    let side: String
    let locationScalerTriangle: CGPoint
    let dragScalerTriangle: _ChangedGesture<DragGesture>
    
    static let scalerBoxSize = CGFloat(60)
    init (
        _ side: String,
        _ locationScalerTriangle: CGPoint,
        _ dragScalerTriangle: _ChangedGesture<DragGesture>
    ) {
        self.side = side
        self.locationScalerTriangle = locationScalerTriangle
        self.dragScalerTriangle = dragScalerTriangle
    }
    var body: some View {
        ZStack {
            ScalerBoxView().creation(
                side
            )
        }
        .position(
            locationScalerTriangle
        )
        .gesture(
            dragScalerTriangle
        )
//        .onTapGesture {
//            pictureScaleViewModel.setScalerBoxTap()
//            }
    }
}
        


struct DashLine{
//    let dotSize = 10.0
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: DragScalerBoxView.scalerBoxSize/2, y : -5000))
            path.addLine (to : CGPoint(x: DragScalerBoxView.scalerBoxSize/2, y: 5000 ))
        }
        .stroke(.red, style: StrokeStyle(dash: [5]))
    }
}
struct Box {
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .opacity(0.3)
            .frame(width: DragScalerBoxView.scalerBoxSize, height: DragScalerBoxView.scalerBoxSize)
    }
}

struct Triangle {
    let xValue: CGFloat
    init (_ name: String){
        if name == "left" {
            xValue = DragScalerBoxView.scalerBoxSize/3 }
        else {
            xValue = -DragScalerBoxView.scalerBoxSize/3
        }
    }
    var body: some View {
           Path { path in
               path.move(to: CGPoint(x : 0, y : 0))
               path.addLine (to : CGPoint(x: xValue, y: -1 * DragScalerBoxView.scalerBoxSize/2))
               path.addLine (to : CGPoint(x: xValue, y: DragScalerBoxView.scalerBoxSize/2))
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
                        .offset(x: DragScalerBoxView.scalerBoxSize, y: DragScalerBoxView.scalerBoxSize/2)
                    
                    DashLine().body
                        .offset(x: DragScalerBoxView.scalerBoxSize/2)
                }
            }
            if name == "left" {
                ZStack {
                    Box().body
                    Triangle(name).body
                        .offset(y: DragScalerBoxView.scalerBoxSize/2)
                    DashLine().body
                        .offset(x: -DragScalerBoxView.scalerBoxSize/2)
                }
            }
        }
        .frame(width: DragScalerBoxView.scalerBoxSize, height: DragScalerBoxView.scalerBoxSize)
        return myView
    }
}

//

