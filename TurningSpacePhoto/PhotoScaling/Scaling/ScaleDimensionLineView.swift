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
   
    let zoom: Double
    init(
        _ zoom: Double
    ) {
        self.zoom = zoom
    }
    var body: some View {
        if scaleDimensionLineVM.scalingCompleted {
            let dimensionOnPhoto = scaleDimensionLineVM.dimensionOnPhoto
            ZStack{
                Text(" dimension-line: \(Int(dimensionOnPhoto))"
                )
                .foregroundColor(
                    .red
                )
                .font(
                    horizontalSizeClass == .compact ? .footnote: .title
                )
                .padding(
                    .bottom,
                    20
                )
                Rectangle()
                    .frame(
                        width: dimensionOnPhoto *  scaleDimensionLineVM.scale * zoom,
                        height: 1
                    )
                    .foregroundColor(
                        .red
                    )
                    .padding(
                        .leading,
                        20
                    )
            }
            .zIndex(
                10.0
            )
        } else {
            EmptyView()
        }

    }
}
