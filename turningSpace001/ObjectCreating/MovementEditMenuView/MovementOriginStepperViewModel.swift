//
//  MovementOriginStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/08/2024.
//

import Foundation
import SwiftUI
import Combine


class MovementOriginStepperViewModel: ObservableObject, SharedMovementType,
    SharedStaticPoint,
    SharedObjectAngles,
    SharedMovementImageData,
    SharedSetMovementImageDataFuncOnly,
    SharedObjectImageDataFunc {
    
    var binding: Binding<Double> {
        Binding<Double> (
            get: {0.0},
            set: { newValue in
                self.modifyStaticPointUpdateInX(newValue)
            }
        )
    }
    
    @Published var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation

    var movementType: Movement = MovementEditService.shared.movementType
    var staticPointUpdate: PositionAsIosAxes = ZeroValue.iosLocation {
        didSet {
            //movementImageData =
            setMovementImageData()
            MovementEditService.shared.setStaticPoint(staticPointUpdate)
        }
    }
    var startAngle: Double = MovementEditService.shared.startAngle
    var endAngle: Double = MovementEditService.shared.endAngle
    var forward: Double = MovementEditService.shared.forward//in direction facing
  
    
    //intialise object data
    //static single object
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData

    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    
    var movementImageData =
        MovementImageService.shared.movementImageData
    
    internal var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        (self as SharedObjectAngles).subscribeToService()
        (self as SharedMovementType).subscribeToService()
        (self as SharedStaticPoint).subscribeToService()
        (self as SharedMovementImageData).subscribeToService()
        (self as SharedObjectImageDataFunc).subscribeToService()
        
    }
}


extension MovementOriginStepperViewModel {
  
    func modifyStaticPoint(
        _ increment: Double
    ) {
        staticPoint = CreateIosPosition.addTwoTouples(
            (
                x: increment,
                y: 0.0,
                z: 0.0
            ),
            staticPoint
        )
    }
    
    
    func modifyStaticPointUpdateInX(
        _ increment: Double
    ) {
        staticPointUpdate = CreateIosPosition.addTwoTouples(
            staticPointUpdate,
            (
                x: increment,
                y: 0.0,
                z: 0.0
            )
        )
        
        modifyStaticPoint(
            increment
        )
        MovementEditService.shared.setStaticPoint(staticPoint)
        setMovementImageData()
    }
}
