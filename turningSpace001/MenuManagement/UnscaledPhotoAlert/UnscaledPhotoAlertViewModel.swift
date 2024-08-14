//
//  ConditionalUnscaledPhotoAlertViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 17/06/2024.
//

import Foundation
import Combine


class UnscaledPhotoAlertViewModel: ObservableObject {
    @Published var showAlertDialog = ShowUnscaledPhotoAlertService.shared.showAlertDialog
        
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ShowUnscaledPhotoAlertService.shared.$showAlertDialog
             .sink { [weak self] newData in
                 self?.showAlertDialog = newData
                 
             }
             .store(
                     in: &cancellables
                 )

    }
    
    func setProceedWithScalingPhoto() {
        BottomMenuDisplayService.shared.setShowPhotoMenuTrue()
        
        ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertButtonFalse()
    }
        
    
    func setProceedWithUnscaledPhoto() {
        ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertTrue()
    }

    
    func setShowUnscaledPhotoAlertDialogTrue() {
        ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertDialogTrue()
    }

}
