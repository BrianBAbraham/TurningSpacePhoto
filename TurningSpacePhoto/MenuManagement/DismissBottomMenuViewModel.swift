//
//  SlideFromBottomMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Combine


class DismissBottomMenuViewModel: ObservableObject {
    private var photoStatus = PhotoService.shared.photoStatus
    private var cancellables: Set<AnyCancellable> = []
    
    init () {
        
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
                
            }
            .store(in: &cancellables)
    }
    
    
    func setShowChairMenuFalse (){
        BottomMenuDisplayService.shared.setShowChairMenuFalse()
    }
    
    
    func setShowPhotoMenuFalse (){
        
        if photoStatus {
            //if a photo exists protect against unscaled use
            let _ = UnscaledPhotoAlertMediator.shared
        }
        
        BottomMenuDisplayService.shared.setShowPhotoMenuFalse()
    }
    

}


