//
//  ScaleMenuViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 20/05/2024.
//

import Foundation

class ScaleMenuViewModel: ObservableObject {
    
    @Published private var scaleMenuModel: ScaleMenuModel = ScaleMenuModel(active: false)
  
}

extension ScaleMenuViewModel {

    
    func getMenuActiveStatus () -> Bool{
        scaleMenuModel.active
    }
    
   
    
    func setMenuActiveStatus (_ state: Bool){
     //   print("setShowMenuStatus")
        scaleMenuModel.active = state
    }

    
    func toggleShowMenuStatus () -> Void {
        scaleMenuModel.active.toggle()
    }

}
