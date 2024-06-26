//
//  VisbileToolViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 17/10/2022.
//

import Foundation
import SwiftUI

class VisibleToolViewModel: ObservableObject {
 

    @Published private var visibleToolModel: VisibleToolModel = VisibleToolModel()
   
    
}


extension VisibleToolViewModel {
    
    
    func getShowTool () -> Bool {
        visibleToolModel.showTool
    }
    
    func getZoomForTool () ->Double {
        visibleToolModel.zoom
    }
    
//    func setShowTool (_ status: Bool) {
//        visibleToolModel.showTool = status
//    }
    

    
    func setZoomForTool (_ zoom: Double, _ manoeuvreScale: Double) {
        if zoom * manoeuvreScale > 0.1 {
            visibleToolModel.showTool = true
        } else {
            visibleToolModel.showTool = false
        }
        visibleToolModel.zoom = zoom
    }
}
