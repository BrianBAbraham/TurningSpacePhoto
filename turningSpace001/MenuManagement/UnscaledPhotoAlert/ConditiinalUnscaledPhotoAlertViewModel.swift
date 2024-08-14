//
//  ConditiinalUnscaledPhotoAlertViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 21/06/2024.
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
