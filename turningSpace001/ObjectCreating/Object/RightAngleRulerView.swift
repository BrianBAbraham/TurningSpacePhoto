//
//  RightAngleRulerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import SwiftUI






struct RightAngleRulerView: View {
    @EnvironmentObject var vm: RightAngleRulerViewModel
   
    var body: some View {

        
        ZStack(alignment: .topLeading ){
            Text(vm.unitSystem.rawValue)
                .font(.system(size: 15 ))
                .lineLimit(1)
                .padding(.leading, 3)
            
            RulerAllPartView()//horizontal
            
            RulerAllPartView()//vertical
                .rotationEffect(Angle(degrees: -90))
                .offset(CGSize(
                    width: (vm.rulerFrameSize.length - vm.scaledRulerWidth) / 2.0 ,
                    height: (-vm.rulerFrameSize.length + vm.scaledRulerWidth ) / 2.0))
        }
        .modifier(ForObjectDrag(frameSize: vm.rulerFrameSize, active: true))
        }
}



struct RulerAllPartView: View {
    @EnvironmentObject var vm: RightAngleRulerViewModel
    static let color: Color = Color("rulerEdges")
    static let opacity: Double = 0.08
    let lineWidth: Double = 1.0
    var body: some View {
        let rulerPartVM = RulerPartViewModel(
            corners: vm.rulerPartAllCGPoint,
            color: Self.color,
            opacity: Self.opacity,
            lineWidth: lineWidth
        )
        ZStack{
            ZStack {
                rulerPartVM.path()
                    .fill(Self.color)
                    .opacity(Self.opacity)
                
                rulerPartVM.path()
                    .stroke(
                        Color.black,
                        lineWidth: lineWidth * vm.scale
                    )
            }

            
            ForEach(vm.rulerDivisionModels) { model in
                ObjectLine(lineWidth: lineWidth * vm.scale, startOfDivisionMark: model.startOfDivisionMark, endOfDivisionMark: model.endOfDivisionMark)
            }
            
            ForEach(vm.rulerNumberModels) { model in
                Text(model.id)
                    .font(.system(size: 50 * vm.scale))
                    .position(model.numberPosition)
            }
            
//            ForEach(vm.rulerNumberDic.map { key, value in (key, value) }, id: \.0) { key, value in
//                Text(key)
//                    .font(.system(size: 50 * vm.scale))
//                    .position(x: value.x, y: value.y)
//            }
            

        }
        .zIndex(1000)
    }
}



class RulerPartViewModel: ObservableObject, 
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

