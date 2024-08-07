//
//  MovementAngleStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/08/2024.
//

import Foundation
import SwiftUI
import Combine






class MovementAngleStepperViewModel: ObservableObject, SharedMovementType,
    SharedStaticPoint,
    SharedObjectAngles,
    SharedObjectAngleType,
    SharedMovementImageData,
    SharedSetMovementImageDataFuncOnly,
    SharedObjectImageDataFunc {
    
    var binding: Binding<Double> {
        Binding<Double> (
            get: {0.0},
            set: { newValue in
                self.setObjectAngle(newValue)
            }
        )
    }
    //these properties required to create dictionary of positions for motion
    //these sink through the protocols
    var staticPoint: PositionAsIosAxes = MovementEditService.shared.staticPoint
    var movementType: Movement = MovementEditService.shared.movementType
    var startAngle: Double = MovementEditService.shared.startAngle
    var endAngle: Double = MovementEditService.shared.endAngle
    var forward: Double = MovementEditService.shared.forward//in direction facing
    //start, end or both angles may be modified
    var objectAngleType: WhichAngle = MovementEditService.shared.objectAngleType

    //intialise object data
    //static single object
    var objectImageData: ObjectImageData =
        ObjectImageService.shared.objectImageData
    
    //EXTRACTIONS FROM DATA LAYER
    //intialise movement data
    //movement are single object data plus transformed object data
    //showing movment or movments
    //@Published private
    var movementImageData =
        MovementImageService.shared.movementImageData
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init(){
        (self as SharedObjectAngles).subscribeToService()
        (self as SharedObjectAngleType).subscribeToService()
        (self as SharedMovementType).subscribeToService()
        (self as SharedStaticPoint).subscribeToService()
        (self as SharedMovementImageData).subscribeToService()
        (self as SharedSetMovementImageDataFuncOnly).setMovementImageData()
        (self as SharedObjectImageDataFunc).subscribeToService()
    }
}


extension MovementAngleStepperViewModel {
        
    func setObjectAngle(_ angleIncrement: Double) {
        switch objectAngleType {
        case .start:
            setStartAngle(angleIncrement)
        case .end:
            setEndAngle(angleIncrement)
        case .startAndEnd:
            setStartAngle(angleIncrement)
            setEndAngle(angleIncrement)
        }
    }
    

    func setStartAngle(_ angleIncrement: Double) {
        startAngle += angleIncrement
        MovementEditService.shared.setStartAngle(startAngle)
        setMovementImageData()
    }
    

    func setEndAngle(_ angleIncrement: Double) {
        endAngle += angleIncrement
        MovementEditService.shared.setEndAngle(endAngle)
        setMovementImageData()
    }
}
