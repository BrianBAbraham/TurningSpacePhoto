//
//  NoScalingAlertMediator.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 14/06/2024.
//

import Foundation
import Combine

class UnscaledPhotoAlertMediator {
    private var photoStatus = PhotoService.shared.photoStatus
    
    private var scalingCompleted = ScaleService.shared.scalingCompleted
    
    private var cancellables: Set<AnyCancellable> = []
    
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
        if !scalingCompleted && photoStatus {
            UnscaledPhotoAlertService.shared.setUnscaledPhotoAlertTrue()
        }
    }
    
}



class UnscaledPhotoAlertViewModel: ObservableObject {
    @Published var unscaledPhotoAlert = UnscaledPhotoAlertService.shared.unscaledPhotoAlert
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        UnscaledPhotoAlertService.shared.$unscaledPhotoAlert
             .sink { [weak self] newData in
                 self?.unscaledPhotoAlert = newData
             }
             .store(
                     in: &cancellables
                 )
        
    }
}
