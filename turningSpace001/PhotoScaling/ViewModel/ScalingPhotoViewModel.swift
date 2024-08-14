//
//  ScalingPhotoViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 31/05/2024.
//
import Foundation
import Combine
import SwiftUI


//provides a photo which is scaled independently of
//wheelchair until scaling completed is activated
class ScalingPhotoViewModel: ObservableObject {

    
    @Published var showScalingPhoto = false
    
    @Published var scalingPhotoLocation = PhotoService.shared.photoLocation
        
    let photoService = PhotoService.shared
    
    @Published var scalingPhoto: Image? = PhotoService.shared.photo
    
    var scalingCompleted = ScaleService.shared.scalingCompleted
    
   private (set) var showPhotoMenu =
        BottomMenuDisplayService.shared.showPhotoMenu
    

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
        
        BottomMenuDisplayService.shared.$showPhotoMenu
            .sink { [weak self] newData in
                self?.showPhotoMenu = newData
                self?.setShowScalingPhotoFalseIfPhotoMenuDimsissed()
            }
            .store(
                in: &cancellables
            )
    }
}


extension ScalingPhotoViewModel {
    
    func setFinalChosenPhotoZoom(_ zoom: Double) {
        //make available for other ViewModel
       photoService.setFinalPhotoZoom(zoom)
    }
    
    
    func setShowScalingPhoto() {

        if scalingCompleted == false &&
            scalingPhoto != nil {
            showScalingPhoto = true
        } else {
            showScalingPhoto = false
        }
    }

    
    func setShowScalingPhotoFalseIfPhotoMenuDimsissed(){
        if !showPhotoMenu && scalingPhoto != nil && !scalingCompleted {
            showScalingPhoto = false
        }
    }

    
    func setScalingPhotoLocation(_ location: CGPoint) {
        photoService.setPhotoLocation(location)
    }
    
}
