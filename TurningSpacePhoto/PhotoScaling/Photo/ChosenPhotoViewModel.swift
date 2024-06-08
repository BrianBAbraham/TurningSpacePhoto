//
//  ChosenPhotoViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import Combine
import SwiftUI


//class ChosenPhotoViewModel: ObservableObject {
//
//   @Published
//    private (set) var chosenPhotoModel =
//     ChosenPhotoModel(currentPhotoZoom: 1.0)
//    
//    var chosenPhoto: Image? = PhotoService.shared.photo
//    
//    var finalPhotoZoom = PhotoService.shared.finalPhotoZoom
//    
//    var scalingCompleted = ScaleService.shared.scaleServicesData.scalingCompleted
//    
//    private var cancellables: Set<AnyCancellable> = []
//    
//    
//    init() {
//       
//        PhotoService.shared.$photo
//            .sink { [weak self] newData in
//                self?.chosenPhoto = newData
//                //self?.model.modifyManoeuvreScale(newData)
//            }
//            .store(
//                in: &cancellables
//            )
//        
//        PhotoService.shared.$finalPhotoZoom
//            .sink { [weak self] newData in
//                self?.finalPhotoZoom = newData
//                self?.setFinalChosenPhotoZoom(newData)
//            }
//            .store(
//                in: &cancellables
//            )
//        
//        ScaleService.shared.$scaleServicesData
//            .sink { [weak self] newData in
//                self?.scalingCompleted = newData.scalingCompleted
//                //self?.setFinalChosenPhotoZoom(newData)
//            }
//            .store(
//                in: &cancellables
//            )
//    }
//    
//}


extension ChosenPhotoViewModel {
    func getScalingCompleted() -> Bool {
        scalingCompleted
    }
    
    
    func getFinalChosentPhotoZoom() -> Double {
        return
            chosenPhotoModel.finalPhotoZoom
    }

    
    func setFinalChosenPhotoZoom(_ zoom: Double) {
        chosenPhotoModel.finalPhotoZoom = zoom
    }
    
   
    func getChosenPhoto() -> Image? {
        chosenPhotoModel.chosenPhoto
    }
    
    
    func setChosenPhoto(){
        chosenPhotoModel.chosenPhoto = chosenPhoto
        if chosenPhoto != nil {
            chosenPhotoModel.chosenPhotoStatus = true
        }
    }
    
    
    func getChosenPhotoLocation() -> CGPoint {
        chosenPhotoModel.chosenPhotoLocation
        
    }

    
    func getChosenPhotoStatus() -> Bool {
        chosenPhotoModel.chosenPhotoStatus
    }
        

    func setChosenPhotoLocation(_ location: CGPoint) {
        chosenPhotoModel.chosenPhotoLocation = location
        PhotoService.shared.setPhotoLocation(location)
    }
}
//
class ChosenPhotoViewModel: ObservableObject {

   @Published
    private (set) var chosenPhotoModel =
     ChosenPhotoModel(currentPhotoZoom: 1.0)
    
    var chosenPhoto: Image? = PhotoService.shared.photo
    
    var finalPhotoZoom = PhotoService.shared.finalPhotoZoom
    
    var scalingCompleted = ScaleService.shared.scalingCompleted
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
       
        PhotoService.shared.$photo
            .sink { [weak self] newData in
                self?.chosenPhoto = newData
                
            }
            .store(
                in: &cancellables
            )
        
        PhotoService.shared.$finalPhotoZoom
            .sink { [weak self] newData in
                self?.finalPhotoZoom = newData
                self?.setFinalChosenPhotoZoom(newData)
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
    }
    
}
