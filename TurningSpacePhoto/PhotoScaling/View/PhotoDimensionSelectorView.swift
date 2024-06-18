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
                addButton(action: { millimeterDimensionOnPlan -= step }, title: "-5")
                    .disabled(!photoDimensionSelectorVM.isNotShowing)
                sliderView
                    .disabled(!photoDimensionSelectorVM.isNotShowing)
                addButton(action: { millimeterDimensionOnPlan += step }, title: "+5")
                    .disabled(!photoDimensionSelectorVM.isNotShowing)
            }
            .padding()
       
    }

    private var sliderView: some View {
        Slider(value: $millimeterDimensionOnPlan, in: range, step: step)
            .onChange(of: millimeterDimensionOnPlan) { value in
                photoDimensionSelectorVM.setDimensionOnPhoto(millimeterDimensionOnPlan)
            }
            .accentColor(photoDimensionSelectorVM.isNotShowing ? .gray : .orange)
            .opacity(photoDimensionSelectorVM.isNotShowing ? 1 : 0.1)


    }

    private func addButton(action: @escaping () -> Void, title: String) -> some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(PictureScaleBlueButton())
        .modifier(MenuButtonWithTextFont())
        .opacity(photoDimensionSelectorVM.isNotShowing ? 1 : 0.1)
    }
}





