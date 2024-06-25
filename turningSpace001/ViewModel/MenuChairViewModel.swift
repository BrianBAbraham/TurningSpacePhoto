
//  MenuChairViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 07/09/2022.


import Foundation
import SwiftUI


class MenuChairViewModel: ObservableObject {
    @Published private var menuChairModel: MenuChairModel = MenuChairModel(showMenu: false)
}



extension MenuChairViewModel {
    func getShowMenuStatus() -> Bool{
        menuChairModel.showMenu
    }
    
    func getCurrentMovementType() -> MovementNames{
        menuChairModel.currentMovementType
    }
    
    func setShowMenuStatus(_ state: Bool){
        menuChairModel.showMenu = state
    }
    
    func setCurrentMovementType(_ movementType: MovementNames){
print(movementType.rawValue)
        menuChairModel.currentMovementType = movementType
    }
    
    func toggleShowMenuStatus(){
        menuChairModel.showMenu.toggle()
    }
}
