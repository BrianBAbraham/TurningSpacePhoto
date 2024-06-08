//
//  ScaleDimensionLineViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 01/06/2024.
//

import Foundation
import Combine

class ScaleDimensionLineViewModel: ObservableObject {
    
    @Published var scale: Double = ScaleService.shared.scale
    @Published var scalingCompleted: Bool = ScaleService.shared.scalingCompleted
    @Published var dimensionOnPlan: Double = DimensionService.shared.dimensionOnPlan
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        DimensionService.shared.$dimensionOnPlan
            .sink { [weak self] newData in
                self?.dimensionOnPlan = newData
            }
            .store(in: &cancellables)

        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.updateScalingCompleted(newData)
            }
            .store(in: &cancellables)
        
        ScaleService.shared.$scale
            .sink { [weak self] newData in
                self?.scale = newData
            }
            .store(in: &cancellables)
    }
    
    private func updateScalingCompleted(_ newData: Bool) {
        scalingCompleted = newData
    }
}


