//
//  ScalingPhotoViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 31/05/2024.
//
import Foundation
import Combine
import SwiftUI



class ScalingPhotoViewModel: ObservableObject {

    
    @Published var showScalingPhoto = false
    
    @Published var scalingPhotoLocation = PhotoService.shared.photoLocation
        
    let photoService = PhotoService.shared
    
    var scalingPhoto: Image? = PhotoService.shared.photo
    
    var scalingCompleted = ScaleService.shared.scalingCompleted
    

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
       
        photoService.$photo
            .sink { [weak self] newData in
                self?.scalingPhoto = newData
                self?.setShowScalingPhoto()
            }
            .store(
                in: &cancellables
            )
        
        
       photoService.$photoLocation
            .sink { [weak self] newData in
                self?.scalingPhotoLocation = newData
            }
            .store(
                in: &cancellables
            )
        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
                self?.setShowScalingPhoto()
            }
            .store(
                in: &cancellables
            )
    }
}


extension ScalingPhotoViewModel {
    
    func setFinalChosenPhotoZoom(_ zoom: Double, _ callerName: String? = "unknown") {
        //make available for other ViewModel
       photoService.setFinalPhotoZoom(zoom)
    }
    
    
    func setShowScalingPhoto() {
       showScalingPhoto = false
        if scalingCompleted == false &&
            scalingPhoto != nil {
            showScalingPhoto = true
        } else {
            showScalingPhoto = false
        }
    }
    

    
    
    func setScalingPhotoLocation(_ location: CGPoint) {
        photoService.setPhotoLocation(location)
    }
    
}
