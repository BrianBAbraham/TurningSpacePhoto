//
//  NavigationViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import Combine


class DismissRightSideMenuViewModel: ObservableObject {
 
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

    func setShowRightSideMenuFalse (){
        RightSideMenuDisplayService.shared.setShowRightSideMenuFalse()
    }
}

