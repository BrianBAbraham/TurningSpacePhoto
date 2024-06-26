//
//  ScalingToollViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 03/06/2024.
//

import Foundation
import SwiftUI
import Combine

struct ScalingToolModel {
    static let initialLefStcalingToolPosition = CGPoint(x: 75, y: 100)
    static let initialRightScalingToolPosition = CGPoint(x: SizeOf.screenWidth * 0.8, y: 100)
    
    var leftScalingToolPosition: CGPoint
    var rightScalingToolPosition: CGPoint
    
    init() {
        leftScalingToolPosition = ScalingToolModel.initialLefStcalingToolPosition
        rightScalingToolPosition = ScalingToolModel.initialRightScalingToolPosition
    }
}



///there are two draggable triangle views
///these are placed inside the  extents of the dimension line
///the point seperation of  the tips of the two triangles is deteremined
///there is an input view for the dimension on the imported plan
///scale is separation/dimension on plan
class ScalingToolViewModel: ObservableObject {
    private (set) var scalingToolModel = ScalingToolModel()
    
    let scaleService = ScaleService.shared

    @Published var leftScalingToolPosition:CGPoint
    
    @Published var rightScalingToolPosition:CGPoint
    
    var scalingCompleted: Bool = ScaleService.shared.scalingCompleted
    
    var photoStatus: Bool =
        PhotoService.shared.photoStatus
    
    private var showUnscaledPhotoAlertButton = ShowUnscaledPhotoAlertService.shared.showAlertDialog
    
   @Published var notShowing = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        leftScalingToolPosition = scalingToolModel.leftScalingToolPosition
        rightScalingToolPosition = scalingToolModel.rightScalingToolPosition
           
        scaleService.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
                self?.setButtonIsNotShowingStatus()
            }
            .store(in: &cancellables)
        
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
                self?.setButtonIsNotShowingStatus()
            }
            .store(in: &cancellables)
        
        ShowUnscaledPhotoAlertService.shared.$showAlert
            .sink { [weak self] newData in
                self?.showUnscaledPhotoAlertButton = newData
                self?.setButtonIsNotShowingStatus()
            }
            .store(in: &cancellables)
    }
}


extension ScalingToolViewModel {
    func getAreScalingToolAtInitialHeight() -> Bool {
        let state = rightScalingToolPosition.y == ScaleValueProviderModel.initialRightScalingToolPosition.y
        return state
    }
    

    func keepLeftAndRightScalingToolPositionLevel(_ location: CGPoint, _ sideToCorrect: LeftOrRight) {
        let verticalOrHorizontal: HorizontalOrVertical = .horizontal

        var modifiedLocation: CGPoint = .zero
        switch verticalOrHorizontal {
        case .horizontal:
            switch sideToCorrect {
            case .left:
                modifiedLocation = CGPoint(x: leftScalingToolPosition.x, y: rightScalingToolPosition.y)
                scalingToolModel.leftScalingToolPosition = modifiedLocation
            case .right:
                modifiedLocation = CGPoint(x: rightScalingToolPosition.x, y: leftScalingToolPosition.y)
                scalingToolModel.rightScalingToolPosition = modifiedLocation
            }
        case .vertical:
                if location.x == leftScalingToolPosition.x {
                    modifiedLocation = CGPoint(x: leftScalingToolPosition.x, y: location.y)
            }
        }
    }
    
    
    func setLeftScalingToolPosition(_ location: CGPoint) {
        keepLeftAndRightScalingToolPositionLevel(location, .right)
        scalingToolModel.leftScalingToolPosition = location
        leftScalingToolPosition = location
        scaleService.setLeftScalingToolPosition(location)
    }
    
    
    func setRightScalingToolPosition(_ location: CGPoint) {
        keepLeftAndRightScalingToolPositionLevel(location, .left)
        scalingToolModel.rightScalingToolPosition = location
        rightScalingToolPosition = location
        scaleService.setRightScalingToolPosition(location)
    }
    

    
        func setButtonIsNotShowingStatus() {
            //if no photo or photo but scaling completed
           notShowing = !photoStatus || scalingCompleted || showUnscaledPhotoAlertButton
        }
}



