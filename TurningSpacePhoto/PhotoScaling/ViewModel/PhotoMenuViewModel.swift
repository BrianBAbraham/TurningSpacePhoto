//
//  ScaleMenuViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 20/05/2024.
//

import Foundation

class PhotoMenuViewModel: ObservableObject {
    
    private var photoMenuModel: PhotoMenuModel = PhotoMenuModel()
   
    @Published private (set) var showMenu: Bool
    
    init(){
        showMenu = photoMenuModel.active
    }
  
    
    func getMenuActiveStatus () -> Bool{
        showMenu
    }
    
   
    func setMenuActiveStatus (_ state: Bool){
        showMenu = state
        photoMenuModel.active = state
    }


}
