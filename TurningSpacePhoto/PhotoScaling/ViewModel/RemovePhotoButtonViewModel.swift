//
//  RemovePhotoViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 01/06/2024.
//


import Foundation
import Combine

class RemovePhotoButtonViewModel: ObservableObject {
    let photoService = PhotoService.shared
   
    @Published var isNotShowing = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        photoService.$photoStatus
            .sink { [weak self] newData in
                self?.isNotShowing = !newData
            }
            .store(in: &cancellables)
    }
    
    func removePhoto() {
        photoService.removePhoto()
        
        ScaleService.shared.setScalingCompletedFalse()
        
        ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertButtonFalse()
        
    }
}
