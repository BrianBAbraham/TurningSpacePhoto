//
//  ReturnToRightSideMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Combine


class ReturnToRightSideMenuViewModel: ObservableObject {
    
    
    
    func retunToRightSideMenu() {
  
            RightSideMenuDisplayService.shared.setShowRightSideMenuTrue()
            
            BottomMenuDisplayService.shared.setShowPhotoMenuFalse()
            
            BottomMenuDisplayService.shared.setShowChairMenuFalse()
    }
}
