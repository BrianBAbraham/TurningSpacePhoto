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


class MenuForMovementEditViewModel: ObservableObject {
    @Published var showMenu = BottomMenuDisplayService.shared.showMovementEditMenu
    
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init () {
        BottomMenuDisplayService.shared.$showMovementEditMenu
            .receive(on: DispatchQueue.main)
            .assign(to: \.showMenu,on: self)
            .store(in: &cancellables)
    }
}
