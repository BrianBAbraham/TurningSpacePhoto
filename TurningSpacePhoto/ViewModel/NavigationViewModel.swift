//
//  NavigationViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import SwiftUI

class NavigationViewModel: ObservableObject {
 

    @Published private var navigationModel: NavigationModel = NavigationModel(showToggle: true)
   
    
}


extension NavigationViewModel {
    
    func getMenuNames() -> [String] {
        ArrayOfMenu.names
    }
    
    func getShowToggle () -> Bool{
//        print("get toggle")
        return navigationModel.showToggle
    }
    
    func setShowToggle () -> Void {
        navigationModel.showToggle.toggle()
//        print("\(navigationModel.showToggle) navigation ")
    }
    
    func setShowMenu (_ state: Bool){
        navigationModel.showToggle = state
//        print("\(navigationModel.showToggle) navigation ")
    }
}

