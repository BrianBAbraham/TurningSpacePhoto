//
//  ScaleMenuViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 20/05/2024.
//

import Foundation
import Combine

class PhotoMenuViewModel: ObservableObject {
    
    @Published private (set) var showMenu: Bool = SubMenuDisplayService.shared.showPhotoMenu
   
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        SubMenuDisplayService.shared.$showPhotoMenu
            .sink { [weak self] newData in
                self?.showMenu = newData
            }
            .store(
                    in: &cancellables
                )
    }
  
    

    func setShowMenu (_ state: Bool){
        SubMenuDisplayService.shared.setShowPhotoMenu(state)
    }
}
