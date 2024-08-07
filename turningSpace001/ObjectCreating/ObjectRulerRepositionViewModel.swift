//
//  RulerAndObjectRecenterVM.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/04/2024.
//

import Foundation

struct RepositionModel {
   
    var repositionState = false
    
    mutating func resetState(){
       repositionState.toggle()
    }
}

class ObjectRulerRepositionViewModel: ObservableObject {
    @Published var repositionModel: RepositionModel
    
    init() {
        self.repositionModel = RepositionModel()
    }
    
    func getRecenterState() -> Bool {
        repositionModel.repositionState
    }
    
   
    func setRepositionState() {
        RecenterObjectsOnScreenService.shared.setRecenterTrue()
        repositionModel.resetState()
    }
}
