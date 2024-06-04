//
//  ScaleDimensionLineView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 01/06/2024.
//

import SwiftUI

struct ScaleDimensionLineView: View {

    @EnvironmentObject  var scaleDimensionLineVM: ScaleDimensionLineViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var scale: Double {
        scaleDimensionLineVM.scale
    }
    var dimensionOnPlan: Double {
        scaleDimensionLineVM.dimensionOnPlan
    }
    
    let zoom: Double
    init(_ zoom: Double) {
        self.zoom = zoom
    }
    var body: some View {
        if scaleDimensionLineVM.scalingCompleted {
            ZStack{
                Text(" dimension-line: \(Int(dimensionOnPlan))")
                    .foregroundColor(.red)
                    .font(horizontalSizeClass == .compact ? .footnote: .title)
                    .padding(.bottom, 20)
                Rectangle()
                    .frame(width: dimensionOnPlan * scale * zoom, height: 1)
                    .foregroundColor(.red)
                    .padding(.leading, 20)
              }
              .zIndex(10.0)
        } else {
            EmptyView()
        }

    }
}
