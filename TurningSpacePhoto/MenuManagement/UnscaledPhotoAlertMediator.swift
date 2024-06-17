//
//  UnScaledPhotAlertMediator.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 14/06/2024.
//

import Foundation
import Combine

class UnscaledPhotoAlertMediator {
    static let shared = UnscaledPhotoAlertMediator()
    
    private var photoStatus = PhotoService.shared.photoStatus
    
    private var scalingCompleted = ScaleService.shared.scalingCompleted
    
    private var showRightSideMenu = RightSideMenuDisplayService.shared.showRightSideMenu
    
    private var showPhotoMenu = BottomMenuDisplayService.shared.showPhotoMenu
    
    private var showUnscaledPhotoAlertButton = ShowUnscaledPhotoAlertService.shared.showAlert
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

       PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
                self?.setAlertRequired()
            }
            .store(
                    in: &cancellables
                )
        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
                self?.setAlertRequired()
            }
            .store(
                    in: &cancellables
                )
        
        RightSideMenuDisplayService.shared.$showRightSideMenu
             .sink { [weak self] newData in
                 self?.showRightSideMenu = newData
                 if newData == true {
                     self?.setAlertRequired()
                 }
             }
             .store(
                     in: &cancellables
                 )
         
        BottomMenuDisplayService.shared.$showPhotoMenu
             .sink { [weak self] newData in
                 self?.showPhotoMenu = newData
                 if newData == false{
                     self?.setAlertRequired()
                 }
             }
             .store(
                     in: &cancellables
                 )
        
        ShowUnscaledPhotoAlertService.shared.$showAlert
            .sink { [weak self] newData in
                self?.showUnscaledPhotoAlertButton = newData
                if newData == false{
                    self?.setAlertRequired()
                }
            }
            .store(
                in: &cancellables
            )
   
                    
    }
    
    func setAlertRequired(){
        //if there is already an alert button do not show alert dialog
        if !showUnscaledPhotoAlertButton {
            let unscaledPhoto = !scalingCompleted && photoStatus
            let leavingScaling = !showPhotoMenu || showRightSideMenu
            if  unscaledPhoto && leavingScaling {
                ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertDialogTrue()
                ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertTrue()
            }
        }

    }
    
}






