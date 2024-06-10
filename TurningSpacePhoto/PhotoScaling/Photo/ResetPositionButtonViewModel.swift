//
//  ResetPositionButtonViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 03/06/2024.
//

import Foundation
import Combine

class ResetPositionButtonViewModel: ObservableObject {
    @Published var isActive: Bool = PhotoService.shared.photoStatus
    let photoService = PhotoService.shared
    var photoLocation = PhotoService.shared.photoLocation
    let scalingService = ScaleService.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        photoService.$photoStatus
            .sink { [weak self] newData in
                self?.isActive = newData
                
            }
            .store(in: &cancellables)
        
        
        photoService.$photoLocation
            .sink { [weak self] newData in
                self?.photoLocation = newData
            }
            .store(in: &cancellables)
    }
    
    
    func getIsActive() -> Bool {
        // imnage exists
        // image or scaling toools have moved
        isActive && photoLocation != SizeOf.centre
    }
    
    func resetPositions() {
        photoService.setPhotoLocation(SizeOf.centre)
        scalingService.setScalingToolToInitialPosition()
    }
}
