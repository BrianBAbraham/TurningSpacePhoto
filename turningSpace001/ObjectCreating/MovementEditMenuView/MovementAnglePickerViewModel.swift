//
//  MovementAnglePickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/08/2024.
//

import Foundation
import Combine
import SwiftUI

class MovementAnglePickerViewModel: ObservableObject,                           SharedObjectAngleType {
    
    @Published var objectAngleName: String {
        didSet {
            setObjectAngleType()
        }
    }
    var binding: Binding<String> {
        Binding<String> (
            get: {self.objectAngleName},
            set: { newValue in
                self.objectAngleName = newValue
            }
        )
    }
    var objectAngleType: WhichAngle = MovementEditService.shared.objectAngleType
    
    let menuItems: [String] = WhichAngle.allCases.map {
        $0.rawValue
    }


    //showing movment or movments
    
    internal var cancellables: Set<AnyCancellable> = []
    
    
    init(){
        objectAngleName = objectAngleType.rawValue

        (self as SharedObjectAngleType).subscribeToService()

    }
}


extension MovementAnglePickerViewModel {

    func setObjectAngleType(){
        objectAngleType = WhichAngle(rawValue: objectAngleName) ?? .end
        MovementEditService.shared.setObjectAngleType(objectAngleType)
    }

}
