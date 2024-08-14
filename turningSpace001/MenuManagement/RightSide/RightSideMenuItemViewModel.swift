//
//  RightSideMenuItemViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 13/06/2024.
//

import Foundation
import Combine



class RightSideMenuItemViewModel: ObservableObject {

    
    func resetAllMenu() {
        BottomMenuDisplayService.shared.setShowPhotoMenuFalse()
        BottomMenuDisplayService.shared.setObjectEditMenuFalse()
        BottomMenuDisplayService.shared.setMovementEditMenuFalse()
    }
    
    func handleButtonAction(for name: String) {
        RightSideMenuDisplayService.shared.setShowRightSideMenuFalse()
        resetAllMenu()
        switch name {
        case "photo":
            BottomMenuDisplayService.shared.setShowPhotoMenuTrue()
        case "figure.roll":
            BottomMenuDisplayService.shared.setObjectEditMenuTrue()
        case "arrow.clockwise":
            BottomMenuDisplayService.shared.setMovementEditMenuTrue()
            
        case "gear":
            break
            
        default:
            break
        }
    }
}
