//
//  MovementPickVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import Foundation
import Combine
import SwiftUI







class MovementPickerViewModel: ObservableObject,
    SharedMovementType, 
    SharedObjectAngles,
    SharedStaticPoint,
    SharedMovementImageData,
    SharedSetMovementImageDataFuncOnly, 
    SharedObjectImageDataFunc {
    
    //@Published 
    var movementType: Movement = MovementEditService.shared.movementType
    @Published var movementName: String = Movement.none.rawValue{
        didSet {
            setMovementType()
        }
    }
    var binding: Binding<String> {
        Binding<String> (
            get: {self.movementName},
            set: { newValue in
                self.updateMovementImageData(
                    to: newValue)
                self.movementName = newValue
            }
        )
    }

    var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
    var startAngle: Double =  MovementEditService.shared.startAngle
    var endAngle: Double =  MovementEditService.shared.endAngle
    var forward: Double =  MovementEditService.shared.forward//in direction facing
    let menuItems: [String] = Movement.allCases.map {
        $0.rawValue
    }
    

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
        (self as SharedSetMovementImageDataFuncOnly).setMovementImageData()
        (self as SharedObjectImageDataFunc).subscribeToService()
    }
}


extension MovementPickerViewModel {
    
    func setMovementType() {
        movementType = Movement(rawValue: movementName) ?? .none
        
        MovementEditService.shared.setMovementType(movementType)
    }
    
    
    func updateMovementImageData(
        to newMovement: String
    ) {
        movementName = newMovement
        setMovementImageData()
    }
 
}


