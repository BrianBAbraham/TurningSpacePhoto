//
//  CurrentDimensionViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 20/06/2024.
//

import Foundation
import Combine

class CurrentDimensionViewModel: ObservableObject {
    
    @Published private (set) var dimensionOnPlan = DimensionService.shared.dimensionOnPlan
   
    
    @Published private (set) var notShowing = true
 
    let dimensionService = DimensionService.shared
   

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ShowScalingSliderService.shared.$scalingSliderNotShowing
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
