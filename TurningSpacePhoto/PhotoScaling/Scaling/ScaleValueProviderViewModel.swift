//
// ScaleValueProviderViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 27/05/2024.
//

import Foundation
import SwiftUI
import Combine

struct ScaleValueProviderModel {
    
    static let scalerBoxSize = CGFloat(60)
    static let initialLefStcalingToolPosition = CGPoint(x: 75, y: 100)
    static let initialRightScalingToolPosition = CGPoint(x: SizeOf.screenWidth * 0.8, y: 100)
    
    
    var leftScalingToolPosition = initialLefStcalingToolPosition
    var rightScalingToolPosition = initialRightScalingToolPosition
    var separation = 0.0
    var scale = 1.0
    static let intialDimensionOnPlan = 2000.0
    var dimensionOnPlan = intialDimensionOnPlan
}



///there are two draggable triangle views
///these are placed inside the  extents of the dimension line
///the point seperation of  the tips of the two triangles is deteremined
///there is an input view for the dimension on the imported plan
///scale is separation/dimension on plan
class ScaleValueProviderViewModel: ObservableObject {
    private (set) var scaleValueProviderModel: ScaleValueProviderModel = ScaleValueProviderModel()
    
    let scaleServices = ScaleService.shared
    let dimensionService = DimensionService.shared
    @Published var dimensionOnPlan = DimensionService.shared.dimensionOnPlan
    
   // var scalingCompeted = false

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        DimensionService.shared.$dimensionOnPlan
            .sink { [weak self] newData in
                self?.dimensionOnPlan = newData
            }
            .store(in: &cancellables)
        
        ScaleService.shared.$leftScalingToolPosition
            .sink { [weak self] newData in
                    self?.setLeftScalingToolPosition(newData )
            }
            .store(in: &cancellables)
        
        ScaleService.shared.$rightScalingToolPosition
            .sink { [weak self] newData in
                    self?.setRightScalingToolPosition(newData )
            }
            .store(in: &cancellables)
        
        scaleServices.$scalingCompleted
            .sink { [weak self] newData in
                if newData {
                    
                    self?.setScale("scaling completed")
                }
        }
        .store(in: &cancellables)
    }
    
}


extension ScaleValueProviderViewModel {

    
    func setLeftScalingToolPosition(_ location: CGPoint) {
      
        scaleValueProviderModel.leftScalingToolPosition = location
    }
    
    
    func setRightScalingToolPosition(_ location: CGPoint) {
        scaleValueProviderModel.rightScalingToolPosition = location
    }
    

}


extension ScaleValueProviderViewModel {
    
    func getScalingToolSeparation() -> Double {
        scaleValueProviderModel.separation
    }
    
    
    func setScale(_ caller: String = "unkown") {
     setScalingToolSeparation()
   
     let scale =
         scaleValueProviderModel.separation/dimensionOnPlan
        
        scaleValueProviderModel.scale = scale
        
        scaleServices.setScale(scale)
    }
    
    
    func getScale() -> Double {
        scaleValueProviderModel.scale
    }
    

    func setScalingToolSeparation( ) {
        let scalerBoxSize = ScaleValueProviderModel.scalerBoxSize
        var separation = scaleValueProviderModel.leftScalingToolPosition.x - scaleValueProviderModel.rightScalingToolPosition.x
        if separation == CGFloat(0) {
        } else {
            if separation < CGFloat(0) {
                separation = -separation + scalerBoxSize
            } else {
                separation = separation - scalerBoxSize
            }
        }

        scaleValueProviderModel.separation = Double(separation)
    }
    
    
    func setDimensionOnPlan(_ value: Double) {
        scaleValueProviderModel.dimensionOnPlan = value
        dimensionService.setDimensionOnPlan(value)
    }
}
