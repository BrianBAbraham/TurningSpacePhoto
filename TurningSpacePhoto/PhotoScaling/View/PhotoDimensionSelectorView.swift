//
//  PhotoDimensionSelectorView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 04/06/2024.
//

import SwiftUI

struct PhotoDimensionSelectorView: View {
    @EnvironmentObject  var photoDimensionSelectorVM: PhotoDimensionSelectorViewModel
    
    @State private var millimeterDimensionOnPlan = DimensionService.shared.dimensionOnPlan
  
   
   

    private let step: Double = 10
    private let range = 1000.0...6000.0

    var body: some View {
          
            HStack {
                scaleButton(action: { millimeterDimensionOnPlan -= step }, title: "-5")
                    .disabled(photoDimensionSelectorVM.notShowing)
                sliderView
                    .disabled(photoDimensionSelectorVM.notShowing)
                scaleButton(action: { millimeterDimensionOnPlan += step }, title: "+5")
                    .disabled(photoDimensionSelectorVM.notShowing)
            }
            .padding()
       
    }

    private var sliderView: some View {
        Slider(value: $millimeterDimensionOnPlan, in: range, step: step)
            .onChange(of: millimeterDimensionOnPlan) { value in
                photoDimensionSelectorVM.setDimensionOnPhoto(millimeterDimensionOnPlan)
            }
            .accentColor(photoDimensionSelectorVM.notShowing ? .gray : .orange)
            .opacity(photoDimensionSelectorVM.notShowing ? 0.1 : 1)


    }

    private func scaleButton(action: @escaping () -> Void, title: String) -> some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(PictureScaleBlueButton())
        .modifier(MenuButtonWithTextFont())
        .opacity(photoDimensionSelectorVM.notShowing ? 0.1 : 1)
    }
}





