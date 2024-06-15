//
//  ReturnToRightSideMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Combine


class ReturnToRightSideMenuViewModel: ObservableObject {
    
    private var unscaledPhotoAlert = UnscaledPhotoAlertService.shared.unscaledPhotoAlert
    
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
    
    
    func retunToRightSideMenu() {
//            ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertToTrue()
  
            RightSideMenuDisplayService.shared.setShowRightSideMenuTrue()
            
            BottomMenuDisplayService.shared.setShowPhotoMenuFalse()
            
            BottomMenuDisplayService.shared.setShowChairMenuFalse()
    }
}
