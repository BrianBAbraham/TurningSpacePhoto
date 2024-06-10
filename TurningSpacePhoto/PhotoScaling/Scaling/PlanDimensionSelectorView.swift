//
//  PlanDimensionSelectorView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 04/06/2024.
//

import SwiftUI

struct PlanDimensionSelectorView: View {
    @State private var millimeterDimensionOnPlan = DimensionService.shared.dimensionOnPlan
  
    @EnvironmentObject  var planDimensionSelectorVM: PlanDimensionSelectorViewModel
   

    private let step: Double = 10
    private let range = 1000.0...6000.0

    var body: some View {
          
            HStack {
                scaleButton(action: { millimeterDimensionOnPlan -= step }, title: "-5")
                    .disabled(planDimensionSelectorVM.notShowing)
                sliderView
                    .disabled(planDimensionSelectorVM.notShowing)
                scaleButton(action: { millimeterDimensionOnPlan += step }, title: "+5")
                    .disabled(planDimensionSelectorVM.notShowing)
            }
            .padding()
       
    }

    private var sliderView: some View {
        Slider(value: $millimeterDimensionOnPlan, in: range, step: step)
            .onChange(of: millimeterDimensionOnPlan) { value in
                planDimensionSelectorVM.setDimensionOnPlan(millimeterDimensionOnPlan)
            }
            .accentColor(planDimensionSelectorVM.notShowing ? .gray : .orange)
            .opacity(planDimensionSelectorVM.notShowing ? 0.1 : 1)


    }

    private func scaleButton(action: @escaping () -> Void, title: String) -> some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(PictureScaleBlueButton())
        .modifier(MenuButtonWithTextFont())
        .opacity(planDimensionSelectorVM.notShowing ? 0.1 : 1)
    }
}


import Combine

class PlanDimensionSelectorViewModel: ObservableObject {
    
    @Published private (set) var notShowing = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        ShowScalingDimensionSelectorService.shared.$scalingDimensionSelectorView
            .sink { [weak self] newData in
                self?.notShowing = newData
               
        }
        .store(in: &cancellables)
    }
    
    
    func setDimensionOnPlan(_ value: Double) {
        DimensionService.shared.setDimensionOnPlan(value)
    }
}
