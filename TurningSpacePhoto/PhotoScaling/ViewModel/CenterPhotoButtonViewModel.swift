//
//  ResetPositionButtonViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 03/06/2024.
//

import Foundation
import Combine

class CenterPhotoButtonViewModel: ObservableObject {
    @Published var notShowing: Bool = true
    let photoService = PhotoService.shared
    var photoLocation = PhotoService.shared.photoLocation
    var photoStatus = PhotoService.shared.photoStatus
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        photoService.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
                self?.getIsNotShowing()
            }
            .store(in: &cancellables)
        
        
        photoService.$photoLocation
            .sink { [weak self] newData in
                self?.photoLocation = newData
                self?.getIsNotShowing()
            }
            .store(in: &cancellables)
    }
    
    
    func getIsNotShowing() {
        // no imnage
        // image and image has not moved
        let photoExistsButNotMoved =
        (photoStatus && photoLocation != SizeOf.centre)
        
        notShowing = !photoExistsButNotMoved
    }
    
    
    func resetPositions() {
        photoService.setPhotoLocation(SizeOf.centre)
    }
}
