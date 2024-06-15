//
//  NoScalingAlertMediator.swift
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
    }
    
    func setAlertRequired(){
      //  print("\nDETECT")
        let unscaledPhoto = !scalingCompleted && photoStatus
        let leavingScaling = !showPhotoMenu || showRightSideMenu
//        print("\(unscaledPhoto && leavingScaling)\n")
        if  unscaledPhoto && leavingScaling {
            UnscaledPhotoAlertService.shared.setUnscaledPhotoAlertTrue()
            ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertTrue()
        }
    }
    
}



class ShowUnscaledPhotoAlertViewModel: ObservableObject {
    @Published var showAlert = ShowUnscaledPhotoAlertService.shared.showAlert
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ShowUnscaledPhotoAlertService.shared.$showAlert
             .sink { [weak self] newData in
                 self?.showAlert = newData
                 
             }
             .store(
                     in: &cancellables
                 )
        
    }
    
    
    func setPreventPhotoMenuDimissFalse(){
        BottomMenuDisplayService.shared.setPreventPhotoMenuDismissFalse()
    }
    
    func setPreventPhotoMenuDimissTrue(){
        BottomMenuDisplayService.shared.setPreventPhotoMenuDismissTrue()
    }
    

}
