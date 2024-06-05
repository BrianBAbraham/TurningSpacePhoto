//
//  PlanDimensionSelectorView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 30/05/2024.
//

import SwiftUI





struct ScalingDimensionSelectorView: View {
   
    
    var body: some View {
        VStack {
            
            HStack{
                ConfirmScaleButtonView()

                CurrentDimensionView()
            }

            PlanDimensionSelectorView()
                .padding(EdgeInsets(top: -20, leading: 0, bottom: 50, trailing: 0))

            Spacer()
            
        }
    }
}
//test

struct CurrentDimensionView: View {
   
    @EnvironmentObject var currentDimensionVM: CurrentDimensionViewModel
   let test = 1
    
    var dimensionOnPlan: Int {
        Int(currentDimensionVM.dimensionOnPlan)
    }
    var body: some View {
        Text("\(dimensionOnPlan) mm (between triangle tips)")
            .modifier(MenuButtonTextFont())
            .opacity(currentDimensionVM.notShowing ? 0.1 : 1)
    }
}


import Combine

class CurrentDimensionViewModel: ObservableObject {
    
    @Published private (set) var dimensionOnPlan = DimensionService.shared.dimensionOnPlan
   
    private let mediator = ShowScalingDimensionSelectorMediator.shared
    
 
    let dimensionService = DimensionService.shared
   
    
    @Published private (set) var notShowing = true
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ShowViewService.shared.$scalingDimensionSelectorView
            .sink { [weak self] newData in
                self?.notShowing = newData
        }
        .store(in: &cancellables)
        
    
        dimensionService.$dimensionOnPlan
            .sink { [weak self] newData in
                self?.dimensionOnPlan = newData
            }
            .store(in: &cancellables)

    }
   
}
