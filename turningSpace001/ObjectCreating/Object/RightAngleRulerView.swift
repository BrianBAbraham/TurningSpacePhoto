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
        let rulerFrameSize = vm.getRulerFrameSize()
        let width = vm.width
    
        
        ZStack(alignment: .topLeading ){
            Text(vm.unitSystem.rawValue)
                .font(.system(size: 60))
                .padding()
            
            RulerAllPartView(vm: vm)
            
            RulerAllPartView(vm: vm)
                .rotationEffect(Angle(degrees: -90))
                .offset(CGSize(
                    width: (rulerFrameSize.length - width) / 2.0 , 
                    height: (-rulerFrameSize.length + width ) / 2.0))
        }
    
        .modifier(ForObjectDrag(frameSize: rulerFrameSize, active: true))
        }
}



struct RulerAllPartView: View {
    var vm: RightAngleRulerViewModel
    var rulerMarksDictionary: CornerDictionary{ vm.getRulerMarks()}
    var rulerNumberDictionary: PositionDictionary{ vm.getNumberDictionary()}
    var rulerCorners: [CGPoint]{
        vm.getCorners()
    }
    
    var body: some View {
        ZStack{
            RulerPartView(
                corners: rulerCorners
            )
            ForEach(rulerMarksDictionary.map { key, value in (key, value) }, id: \.0) { key, value in
                ObjectLine(tertiaryMarkElement: [key: value])
            }
            ForEach(rulerNumberDictionary.map { key, value in (key, value) }, id: \.0) { key, value in
                Text(key)
                    .font(.system(size: 50))
                    .position(x: value.x, y: value.y)
            }
        }
        .zIndex(1000)
    }
}



struct RulerPartView: View {
    let corners: [CGPoint]
    static let color: Color = Color("rulerEdges")
    static let opacity: Double = 0.08
    static let lineWidth: Double = 5.0
    
    @StateObject var vm: RulerPartViewModel
    
    init(
        corners: [CGPoint]
    ) {

        self.corners = corners

        _vm = StateObject(
            wrappedValue: RulerPartViewModel(
                corners: corners,
                color: Self.color,
                opacity: Self.opacity,
                lineWidth: Self.lineWidth
            )
        )
    }
    
    var body: some View {
        ZStack {
            vm.path()
                .fill(Self.color)
                .opacity(Self.opacity)
            
            vm.path()
                .stroke(
                    Color.black,
                    lineWidth: Self.lineWidth
                )
        }
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

