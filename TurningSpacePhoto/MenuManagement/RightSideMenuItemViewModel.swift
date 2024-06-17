//
//  RightSideMenuItemViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 13/06/2024.
//

import Foundation
import Combine

class RightSideMenuItemViewModel: ObservableObject {
    
    
    
    func setShowRightSideMenuFalse (){
        RightSideMenuDisplayService.shared.setShowRightSideMenuFalse()
    }
    
    func toggleShowChairMenuStatus(){
        BottomMenuDisplayService.shared.toggleShowChairMenu()
    }
    
    func setShowPhotoMenuTrue (){
        BottomMenuDisplayService.shared.setShowPhotoMenuTrue()
    }
}
