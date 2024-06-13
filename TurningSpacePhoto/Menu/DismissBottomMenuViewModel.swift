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
    @Published var preventDismiss = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.chosenPhotoStatus = newData
                self?.getPreventDismiss()
            }
            .store(
                    in: &cancellables
                )
        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
                self?.getPreventDismiss()
            }
            .store(
                    in: &cancellables
                )
        }
    
    func getPreventDismiss(){
        preventDismiss = 
            !scalingCompleted && chosenPhotoStatus
    }
    
    
    func setShowChairMenuFalse (){
        SubMenuDisplayService.shared.setShowChairMenuFalse()
    }
    
    
    func setShowPhotoMenuFalse (){
        SubMenuDisplayService.shared.setShowPhotoMenuFalse()
    }
    
    
    func setShowRightSideMenuFalse() {
        MainMenusDisplayService.shared.setShowRightSideMenuFalse()
    }
    
}


