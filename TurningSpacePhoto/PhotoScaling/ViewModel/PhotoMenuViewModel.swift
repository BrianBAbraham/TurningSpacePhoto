//
//  ScaleMenuViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 20/05/2024.
//

import Foundation
import Combine

class PhotoMenuViewModel: ObservableObject {
    
    @Published private (set) var showMenu: Bool = BottomMenuDisplayService.shared.showPhotoMenu
   
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        BottomMenuDisplayService.shared.$showPhotoMenu
            .sink { [weak self] newData in
                self?.showMenu = newData
            }
            .store(
                    in: &cancellables
                )
    }
  
    

    func setShowMenu (_ state: Bool){
        BottomMenuDisplayService.shared.setShowPhotoMenu(state)
    }
}
