//
//  MovementEditMenuContainerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/08/2024.
//

import Foundation
import Combine


class MovementEditMenuContainerViewModel: ObservableObject, SharedMovementType {
    
    var movementType = MovementEditService.shared.movementType {
            didSet {
                isNotTurning = movementType != .turn
            }
    }
  
    @Published var isNotTurning = false
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init() {
    
        
        (self as SharedMovementType).subscribeToService()
    }
    
}
