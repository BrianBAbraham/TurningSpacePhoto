//
//  Services.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 29/05/2024.
//

import Foundation
import SwiftUI
import Combine


class ShowViewService {
    static let shared = ShowViewService()
    
    @Published var scalingDimensionSelectorView = false
    
    func setScalingDimensionSelectorView(_ value: Bool) {
        scalingDimensionSelectorView = value
    }
}




class ScaleService {
    @Published var scale = 1.0
    @Published var scalingCompleted = false
    @Published var scalingToolAtInitialPosition = false
    @Published var leftScalingToolPosition = CGPoint(x: 75, y: 100)
    @Published var rightScalingToolPosition = CGPoint(x: SizeOf.screenWidth * 0.8, y: 100)
    
    
   
    
    static let shared = ScaleService()
        
    func setScale(_ scale: Double) {
        self.scale = scale
       
    }
    
    
    func setScalingCompleted() {
        scalingCompleted = true
       
    }
    
    
    func setScalingCompletedFalse() {
        scalingCompleted = false
       
    }
    
    
    func setScalingToolToInitialPosition () {
        scalingToolAtInitialPosition = true
    }
    
    
    func unsetScalingToolAtInitialPosition () {
        scalingToolAtInitialPosition = false
    }
    
    
    func setLeftScalingToolPosition(_ value: CGPoint) {
        leftScalingToolPosition = value
        
    }
    
    
    func setRightScalingToolPosition(_ value: CGPoint) {
        rightScalingToolPosition = value
        
    }
}



class DimensionService {
    @Published var dimensionOnPlan = 2000.0
    
    static let shared = DimensionService()
    
    func setDimensionOnPlan(_ value: Double ) {
       
        dimensionOnPlan = value
    }
}



class PhotoService {
    @Published var photoStatus = false
    @Published var photo: Image?
    @Published var finalPhotoZoom = 1.0
    @Published var photoLocation = SizeOf.centre
    
    static let shared = PhotoService()
    
    
    func setFinalPhotoZoom(_ value: Double) {
    
        self.finalPhotoZoom = value
    }
    
    
    func setPhotoLocation(_ value: CGPoint) {
        photoLocation = value
    }
    

    func setPhotoStatus(_ status: Bool) {
        photoStatus = status
    }
    
    
    func setPhoto(_ image: Image) {
        setPhotoStatus(true)
        self.photo = image
    }
    
    
    func resetPhoto() {
        photoStatus = false
        photo = nil
    }
}
