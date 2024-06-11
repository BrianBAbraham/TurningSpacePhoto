//
//  ChosenPhotoViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import Combine
import SwiftUI


class SlideFromBottomViewModel: ObservableObject {
    @Published var chosenPhotoStatus: Bool = PhotoService.shared.photoStatus
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.chosenPhotoStatus = newData
            }
            .store(
                    in: &cancellables
                )
                }
}





class ChosenPhotoViewModel: ObservableObject {
    @Published var chosenPhoto: Image? = PhotoService.shared.photo

    @Published var photoStatus: Bool = PhotoService.shared.photoStatus

    @Published var finalPhotoZoom = PhotoService.shared.finalPhotoZoom

    @Published var chosenPhotoLocation = PhotoService.shared.photoLocation
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        PhotoService.shared.$photo
            .sink { [weak self] newData in
                self?.chosenPhoto = newData
            }
            .store(
                in: &cancellables
            )
        
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
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
                self?.chosenPhotoLocation = newData
            }
            .store(
                in: &cancellables
            )
    }
}


extension ChosenPhotoViewModel {

    func setChosenPhotoLocation(_ location: CGPoint) {
      
        PhotoService.shared.setPhotoLocation(location)
    }
}

