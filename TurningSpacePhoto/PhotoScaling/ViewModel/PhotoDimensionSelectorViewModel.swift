//
//  PhotoDimensionSelectorViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 11/06/2024.
//

import Foundation
import Combine


class PhotoDimensionSelectorViewModel: ObservableObject {
    
    @Published private (set) var isNotShowing = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        ShowScalingSliderService.shared.$scalingSliderIsShowing
            .sink { [weak self] newData in
                self?.isNotShowing = !newData
               
        }
        .store(in: &cancellables)
    }
    
    
    func setDimensionOnPhoto(_ value: Double) {
        DimensionService.shared.setDimensionOnPlan(value)
    }
}
  
