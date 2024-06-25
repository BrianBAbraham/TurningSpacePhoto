//
//  NavigationViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import Combine


class DismissRightSideMenuViewModel: ObservableObject {
 
    func setShowRightSideMenuFalse (){
        RightSideMenuDisplayService.shared.setShowRightSideMenuFalse()
    }
}

