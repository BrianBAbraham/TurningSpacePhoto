//
//  ConditionalRightSideMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Foundation
import Combine


class RightSideMenuViewModel: ObservableObject {
 
    @Published private (set) var showRightSideMenu = RightSideMenuDisplayService.shared.showRightSideMenu
    
    private var cancellables: Set<AnyCancellable> = []
    
   
    init() {
        RightSideMenuDisplayService.shared.$showRightSideMenu
            .sink { [weak self] newData in
                self?.showRightSideMenu = newData
            }
            .store(
                    in: &cancellables
                )

    }

}
