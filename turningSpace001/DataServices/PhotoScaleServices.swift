//
//  PhotoScaleServices.swift
//  turningSpace001
//
//  Created by Brian Abraham on 07/08/2024.
//

import Foundation
import SwiftUI

class ShowScalingSliderService {
    static let shared = ShowScalingSliderService()
    
    @Published var scalingSliderNotShowing = true
    
    func setScalingSliderShowing(_ value: Bool) {
        scalingSliderNotShowing = value
    }
}



class PhotoLocationChangeService {
    static let shared = PhotoLocationChangeService()
    
    @Published var locationChange = (x: 0.0, y: 0.0)
    
    
    func setLocationChange(_ value: (x: Double, y: Double)) {
        
        locationChange = value
    }
}



class ShowUnscaledPhotoAlertService {
    static let shared = ShowUnscaledPhotoAlertService()
    
    @Published var showAlertDialog = false
    @Published var showAlert = false
    
    func setShowUnscaledPhotoAlertDialogFalse() {
        showAlertDialog = false
    }
    
    func setShowUnscaledPhotoAlertDialogTrue() {
        showAlertDialog = true
    }
    
    func setShowUnscaledPhotoAlertButtonFalse() {
        showAlert = false
    }
    
    func setShowUnscaledPhotoAlertTrue() {
        showAlert = true
    }
}



class ScaleService {
    @Published var scale = 0.1
    @Published var scalingCompleted = false
    var scalingToolAtInitialPosition = false
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
    @Published var chosenPhotoStatus = false
    @Published var photo: Image?
    @Published var finalPhotoZoom = 1.0
    @Published var photoLocation = SizeOf.centre
    
    static let shared = PhotoService()
    
    func setChosenPhotoStatusTrue() {
        chosenPhotoStatus = true
    }
    
    
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
        setChosenPhotoStatusTrue()
        self.photo = image
    }
    
    
    func removePhoto() {
        photoStatus = false
        chosenPhotoStatus = false
        photo = nil
    }
}
