//
//  SlideFromBottomMenuViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import Foundation
import Combine


class DismissBottomMenuViewModel: ObservableObject {
    
    
    func setShowChairMenuFalse (){
        BottomMenuDisplayService.shared.setShowChairMenuFalse()
    }
    
    
    func setShowPhotoMenuFalse (){
        BottomMenuDisplayService.shared.setShowPhotoMenuFalse()
    }
    

}


