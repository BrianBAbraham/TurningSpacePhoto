//
//  MovementMenuViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 22/07/2024.
//

import Foundation
import Combine


class EditScreenViewModel: ObservableObject, 
    SharedMovementType {
    
    var movementType =
    MovementEditService.shared.movementType {
        
            didSet {
                isNotTurning = movementType != .turn
            }
        
    }
    @Published var recenter = RecenterObjectsOnScreenService.shared.recenter
    
    @Published var isNotTurning = false
    
  
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init() {
        RecenterObjectsOnScreenService.shared.$recenter
            .receive(on: DispatchQueue.main)
            .assign(to: \.recenter,on: self)
            .store(in: &cancellables)
        
        (self as SharedMovementType).subscribeToService()
    }
    
}


