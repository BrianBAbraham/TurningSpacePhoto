//
//  PhotoScaleSettingViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 24/05/2024.
//

import Foundation
import SwiftUI

struct PhotoScaleSettingModel {
    static let initialLeftcalingTriangleLocation = CGPoint(x: 75, y: 100)
    static let initialRightScalingTriangleLocation = CGPoint(x: SizeOf.screenWidth * 0.8, y: 100)
    
    
    var leftScalingTriangleLocation = initialLeftcalingTriangleLocation
    var rightScalingTriangleLocation = initialRightScalingTriangleLocation
    
}


class PhotoScaleSettingViewModel: ObservableObject {
    @Published private (set) var photoScaleSettingModel: PhotoScaleSettingModel = PhotoScaleSettingModel()
    
    
}
extension PhotoScaleSettingViewModel {
    func getLeftScalingTriangleLocation() -> CGPoint {
        photoScaleSettingModel.leftScalingTriangleLocation
    }
    
    func getRightScalingTriangleLocation() -> CGPoint {
        photoScaleSettingModel.rightScalingTriangleLocation
    }
    
    
    
    func getAreScalingTrianglesAtInitialHeight() -> Bool {
        let state = getRightScalingTriangleLocation().y == PhotoScaleSettingModel.initialRightScalingTriangleLocation.y

        return state
    }
    

    func keepLeftAndRightScalingTriangleLocationLevel(_ location: CGPoint, _ sideToCorrect: LeftOrRight) {
        let verticalOrHorizontal: HorizontalOrVertical = .horizontal
        let leftScalingTriangleLocation = getLeftScalingTriangleLocation()
        let rightScalingTriangleLocation = getRightScalingTriangleLocation()
        var modifiedLocation: CGPoint = .zero
        switch verticalOrHorizontal {
        case .horizontal:
            switch sideToCorrect {
            case .left:
                modifiedLocation = CGPoint(x: leftScalingTriangleLocation.x, y: rightScalingTriangleLocation.y)
                photoScaleSettingModel.leftScalingTriangleLocation = modifiedLocation
            case .right:
                modifiedLocation = CGPoint(x: rightScalingTriangleLocation.x, y: leftScalingTriangleLocation.y)
                photoScaleSettingModel.rightScalingTriangleLocation = modifiedLocation
            }
        case .vertical:
                if location.x == leftScalingTriangleLocation.x {
                    modifiedLocation = CGPoint(x: leftScalingTriangleLocation.x, y: location.y)
            }
        }
    }

    
    func getScalingTriangleSeparation(_ scalerBoxSize: CGFloat, _ caller: String = "unkown") -> Double{
        var separation = photoScaleSettingModel.leftScalingTriangleLocation.x - photoScaleSettingModel.rightScalingTriangleLocation.x
        if separation == CGFloat(0) {
        } else {
            if separation < CGFloat(0) {
                separation = -separation + scalerBoxSize
            } else {
                separation = separation - scalerBoxSize
            }
        }

      //  print("PictureScaleViewModel.getScalingTriangleSeparation requested from \(caller) \(separation)")
        return Double(separation)
    }
    
    
    func setLeftScalingTriangleLocation(_ location: CGPoint) {
        keepLeftAndRightScalingTriangleLocationLevel(location, .right)
        photoScaleSettingModel.leftScalingTriangleLocation = location
    }
    
    
    func setRightScalingTriangleLocation(_ location: CGPoint) {
        keepLeftAndRightScalingTriangleLocationLevel(location, .left)

        photoScaleSettingModel.rightScalingTriangleLocation = location
    }
    
    
    func setScalingTrianglesToInitialPosition() {
        photoScaleSettingModel.leftScalingTriangleLocation = PhotoScaleSettingModel.initialLeftcalingTriangleLocation
        photoScaleSettingModel.rightScalingTriangleLocation = PhotoScaleSettingModel.initialRightScalingTriangleLocation
    }
}

