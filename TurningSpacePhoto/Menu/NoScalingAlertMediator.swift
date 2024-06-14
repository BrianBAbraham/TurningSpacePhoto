//
//  NoScalingAlertMediator.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 14/06/2024.
//

import Foundation
import Combine

class NoScalingAlertMediator: ObservableObject {
    private var photoStatus = PhotoService.shared.photoStatus
    
    private var scalingCompleted = ScaleService.shared.scalingCompleted
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private (set) var alertRequired = false
    
    init() {

       PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
                self?.setAlertRequired()
            }
            .store(
                    in: &cancellables
                )
        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
                self?.setAlertRequired()
            }
            .store(
                    in: &cancellables
                )
    }
    
    func setAlertRequired(){
        alertRequired =
            !scalingCompleted && photoStatus
    }
    
}
