//
//  ChosenPhotoViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import Combine
import SwiftUI

class ChosenPhotoViewModel: ObservableObject {
    @Published var chosenPhoto: Image? = PhotoService.shared.photo

    @Published var chosenPhotoStatus: Bool = PhotoService.shared.chosenPhotoStatus

    @Published var finalPhotoZoom = PhotoService.shared.finalPhotoZoom

    @Published var photoLocation = PhotoService.shared.photoLocation
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        PhotoService.shared.$photo
            .sink { [weak self] newData in
                self?.chosenPhoto = newData
            }
            .store(
                in: &cancellables
            )
        
        PhotoService.shared.$chosenPhotoStatus
            .sink { [weak self] newData in
                self?.chosenPhotoStatus = newData
            }
            .store(
                in: &cancellables
            )
        
        PhotoService.shared.$finalPhotoZoom
            .sink { [weak self] newData in
                self?.finalPhotoZoom = newData
            }
            .store(
                in: &cancellables
            )
        
        PhotoService.shared.$photoLocation
            .sink { [weak self] newData in
                self?.photoLocation = newData
            }
            .store(
                in: &cancellables
            )
    }
}





