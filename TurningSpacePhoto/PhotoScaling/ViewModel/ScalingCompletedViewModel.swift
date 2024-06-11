//
//  ScalingCompletedViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//


    
import Foundation
import Combine

class ScalingCompletedViewModel: ObservableObject {
   
    @Published var scalingCompleted: Bool = ScaleService.shared.scalingCompleted
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
            }
            .store(in: &cancellables)
    }
    
    
}
