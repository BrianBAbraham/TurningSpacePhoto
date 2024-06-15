//
//  ConfirmScaleButtonViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 11/06/2024.
//

import Foundation
import Combine

class ConfirmScaleButtonViewModel: ObservableObject {
   
    @Published private (set) var notShowing = true
    
    private var cancellables: Set<AnyCancellable> = []
   
    init() {
        // Ensure ShowScalingDimensionSelectorMediator.shared is initialized
       let _ = ShowScalingDimensionSelectorMediator.shared
        
        ShowScalingDimensionSelectorService.shared.$scalingDimensionSelectorView
            .sink { [weak self] newData in
                self?.notShowing = newData
        }
        .store(in: &cancellables)
    }
    

    func setScalingCompleted(){
        ScaleService.shared.setScalingCompleted()
        UnscaledPhotoAlertService.shared.setUnscaledPhotoAlertFalse()
    }
}
