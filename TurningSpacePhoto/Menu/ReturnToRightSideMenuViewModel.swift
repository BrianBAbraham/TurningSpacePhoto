//
//  ReturnToRightSideMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Combine


class ReturnToRightSideMenuViewModel: ObservableObject {
 
    //@Published private (set) var showRightSideMenu = MainMenusDisplayService.shared.showRightSideMenu
    
//    private var showPhotoMenu = SubMenuDisplayService.shared.showPhotoMenu
    
    private var photoStatus = PhotoService.shared.photoStatus
    
    private var scalingCompleted = ScaleService.shared.scalingCompleted
    
    private var cancellables: Set<AnyCancellable> = []
    
   
    init() {
//        MainMenusDisplayService.shared.$showRightSideMenu
//            .sink { [weak self] newData in
//                self?.showRightSideMenu = newData
//            }
//            .store(
//                    in: &cancellables
//                )
        
//        SubMenuDisplayService.shared.$showPhotoMenu
//            .sink { [weak self] newData in
//                self?.showPhotoMenu = newData
//            }
//            .store(
//                    in: &cancellables
//                )
        
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
}


extension ReturnToRightSideMenuViewModel {
    
//    func setShowRightSideMenuFalse() {
//        MainMenusDisplayService.shared.setShowRightSideMenuFalse()
//    }
//    

    func setShowMenu (_ value: Bool){
            MainMenusDisplayService.shared.setShowRightSideMenu(value)
    }
    
    
    func retunToRightSideMenu() {
        if !scalingCompleted && photoStatus {
            
        }
        else {
            setShowMenu(true)
            
            SubMenuDisplayService.shared.setShowPhotoMenuFalse()
            
            SubMenuDisplayService.shared.setShowChairMenuFalse()
        }
    }
}
