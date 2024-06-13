
//  MenuChairViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 07/09/2022.


import Foundation
import SwiftUI
import Combine


class MenuChairViewModel: ObservableObject {
    @Published private var menuChairModel: MenuChairModel = MenuChairModel(showMenu: false)
    @Published private (set) var showChairMenu = SubMenuDisplayService.shared.showChairMenu
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        SubMenuDisplayService.shared.$showChairMenu
            .sink { [weak self] newData in
                self?.showChairMenu = newData
            }
            .store(
                in: &cancellables
            )
        
    }
    
}






extension MenuChairViewModel {
    func getShowMenuStatus() -> Bool{
        showChairMenu
    }
    
    func getCurrentMovementType() -> MovementNames{
        menuChairModel.currentMovementType
    }
    
    func setShowMenuStatus(_ state: Bool){
        SubMenuDisplayService.shared.setShowChairMenu(state)
    }
    
    func setCurrentMovementType(_ movementType: MovementNames){
        menuChairModel.currentMovementType = movementType
    }
    
//    func toggleShowMenuStatus(){
//        SubMenuDisplayService.shared.toggleShowChairMenu()
//    }
}
