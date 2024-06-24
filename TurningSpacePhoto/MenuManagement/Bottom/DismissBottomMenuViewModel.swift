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
    
    
    func setMenu(_ menuName: String) {
       
        if menuName == "openFile" {
           
        }
        if menuName == "photo" {
        
            setShowPhotoMenuFalse()
            
        }
        if menuName == "arrow.clockwise" {
           
        }
        if menuName == MenuIcon.chairTool {
            setShowChairMenuFalse()
        }
    }
    
    
    func setShowChairMenuFalse (){
        BottomMenuDisplayService.shared.setShowChairMenuFalse()
    }
    
    
    func setShowPhotoMenuFalse (){

        if photoStatus {
          
            //if photo exists alert of unscaled use
            let _ = UnscaledPhotoAlertMediator.shared
            
            //photo is chosen even if unscaled
            PhotoService.shared.setChosenPhotoStatusTrue()
        }
        
        BottomMenuDisplayService.shared.setShowPhotoMenuFalse()
    }
    
    
  

}


