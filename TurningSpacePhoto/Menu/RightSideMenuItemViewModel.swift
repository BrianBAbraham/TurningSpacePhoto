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
        SubMenuDisplayService.shared.toggleShowChairMenu()
    }
    
    func setShowPhotoMenuTrue (){
        SubMenuDisplayService.shared.setShowPhotoMenuTrue()
    }
}
