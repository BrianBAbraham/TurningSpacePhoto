//
//  SlideFromBottomMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Combine


class DismissBottomMenuViewModel: ObservableObject {
    var chosenPhotoStatus: Bool = PhotoService.shared.photoStatus
    var scalingCompleted: Bool = ScaleService.shared.scalingCompleted
    @Published var preventPhotoMenuDismiss = BottomMenuDisplayService.shared.preventPhotoMenuDimsiss
  
    
  
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.chosenPhotoStatus = newData
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
       
        BottomMenuDisplayService.shared.$preventPhotoMenuDimsiss
            .sink { [weak self] newData in
                self?.preventPhotoMenuDismiss = newData
                if newData == true {
                    //self?.setShowPhotoMenuTrue()
                }
              
            }
            .store(
                    in: &cancellables
                )
    }
    
    
    func setShowChairMenuFalse (){
        BottomMenuDisplayService.shared.setShowChairMenuFalse()
    }
    
    
    func setShowPhotoMenuFalse (){
        print("!preventPhotoMenuDismiss \(preventPhotoMenuDismiss)")
        if preventPhotoMenuDismiss{

            
        } else {
            BottomMenuDisplayService.shared.setShowPhotoMenuFalse()
        }
        }
    
    
    func setShowPhotoMenuTrue (){
            BottomMenuDisplayService.shared.setShowPhotoMenuTrue()
        }
    
}


