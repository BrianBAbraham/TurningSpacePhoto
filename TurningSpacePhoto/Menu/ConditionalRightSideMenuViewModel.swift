//
//  ConditionalRightSideMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Foundation
import Combine


class ConditionalRightSideMenuViewModel: ObservableObject {
 
    @Published private (set) var showRightSideMenu = MainMenusDisplayService.shared.showRightSideMenu
    

    
    private var cancellables: Set<AnyCancellable> = []
    
   
    init() {
        MainMenusDisplayService.shared.$showRightSideMenu
            .sink { [weak self] newData in
                self?.showRightSideMenu = newData
            }
            .store(
                    in: &cancellables
                )

    }

}
