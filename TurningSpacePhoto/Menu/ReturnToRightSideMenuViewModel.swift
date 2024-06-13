//
//  ReturnToRightSideMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Combine


class ReturnToRightSideMenuViewModel: ObservableObject {
    
    private var photoStatus = PhotoService.shared.photoStatus
    
    private var scalingCompleted = ScaleService.shared.scalingCompleted
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

       PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
            }
            .store(
                    in: &cancellables
                )
        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
            }
            .store(
                    in: &cancellables
                )
    }
    
    
    func retunToRightSideMenu() {
        if !scalingCompleted && photoStatus {
            
        }
        else {
            MainMenusDisplayService.shared.setShowRightSideMenuTrue()
            
            SubMenuDisplayService.shared.setShowPhotoMenuFalse()
            
            SubMenuDisplayService.shared.setShowChairMenuFalse()
        }
    }
}
