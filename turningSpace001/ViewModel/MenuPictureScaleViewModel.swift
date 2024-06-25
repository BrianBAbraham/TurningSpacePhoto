//
//  MenuScalePictureViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI

import Foundation

class MenuPictureScaleViewModel: ObservableObject {
    
    @Published private var menuPictureScaleModel: MenuPhotoScaleModel = MenuPhotoScaleModel(showMenu: false)
  
}



extension MenuPictureScaleViewModel {

    func getDimensionOnPlan() -> CGFloat {
        return CGFloat( menuPictureScaleModel.dimensionOnPlan)
    }
    
    func getShowMenuStatus () -> Bool{
        menuPictureScaleModel.showMenu
    }
    
    func getScalingCompletedStatus () -> Bool{
        menuPictureScaleModel.scalingCompleted
    }
    
    func setDimensionOnPlan(_ dimension: Double)  {
//print("DIMENSION ON PLAN \(dimension)")
        menuPictureScaleModel.dimensionOnPlan = dimension
    }
    
    func setScalingCompletedStatus (_ state: Bool) {
        menuPictureScaleModel.scalingCompleted = state
    }
    
    func setShowMenuStatus (_ state: Bool){
        menuPictureScaleModel.showMenu = state
    }
    
    func toggleShowMenuStatus () -> Void {
        menuPictureScaleModel.showMenu.toggle()
    }

}



