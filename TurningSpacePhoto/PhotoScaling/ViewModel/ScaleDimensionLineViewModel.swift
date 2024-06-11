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
    @Published var dimensionOnPhoto: Double = DimensionService.shared.dimensionOnPlan
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        DimensionService.shared.$dimensionOnPlan
            .sink { [weak self] newData in
                self?.dimensionOnPhoto = newData
            }
            .store(in: &cancellables)

        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
            }
            .store(in: &cancellables)
        
        ScaleService.shared.$scale
            .sink { [weak self] newData in
                self?.scale = newData
            }
            .store(in: &cancellables)
    }
}


