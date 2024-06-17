//
//  ConditionalUnscaledPhotoAlertViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 17/06/2024.
//

import Foundation
import Combine


class ConditionalUnscaledPhotoAlertViewModel: ObservableObject {
    
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
    
}


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
    
    func setScale() {
        BottomMenuDisplayService.shared.setShowPhotoMenuTrue()
        
        ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertButtonFalse()
    }
        
    
    func setDoNotScale() {
        ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertTrue()
    }

    
    func setShowUnscaledPhotoAlertDialogTrue() {
        print("DERTECT")
        ShowUnscaledPhotoAlertService.shared.setShowUnscaledPhotoAlertDialogTrue()
    }

}
