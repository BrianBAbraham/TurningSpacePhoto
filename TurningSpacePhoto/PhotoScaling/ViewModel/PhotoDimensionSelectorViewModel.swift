//
//  PhotoDimensionSelectorViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 11/06/2024.
//

import Foundation
import Combine


class PhotoDimensionSelectorViewModel: ObservableObject {
    
    @Published private (set) var notShowing = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        ShowScalingDimensionSelectorService.shared.$scalingDimensionSelectorView
            .sink { [weak self] newData in
                self?.notShowing = newData
               
        }
        .store(in: &cancellables)
    }
    
    
    func setDimensionOnPhoto(_ value: Double) {
        DimensionService.shared.setDimensionOnPlan(value)
    }
}
  
