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
    static let initialLefStcalingToolPosition = ScaleService.shared.leftScalingToolPosition
    static let initialRightScalingToolPosition = ScaleService.shared.rightScalingToolPosition
    
    
    var leftScalingToolPosition = initialLefStcalingToolPosition
    var rightScalingToolPosition = initialRightScalingToolPosition
    var separation = 0.0
    var scale = ScaleService.shared.scale
    var dimensionOnPlan = DimensionService.shared.dimensionOnPlan
    
    
    mutating func setScalingToolSeparation( ) {
        separation = leftScalingToolPosition.x - rightScalingToolPosition.x
        if separation == CGFloat(0) {
        } else {
            if separation < CGFloat(0) {
                separation = -separation + Self.scalerBoxSize
            } else {
                separation = separation - Self.scalerBoxSize
            }
        }

        separation = Double(separation)
    }
    
    mutating func setScale()  {
        setScalingToolSeparation()
        scale =
            separation/dimensionOnPlan
    }
}



///there are two draggable triangle views
///these are placed inside the  extents of the dimension line
///the point seperation of  the tips of the two triangles is deteremined
///there is an input view for the dimension on the imported plan
///scale is separation/dimension on plan
class ScaleValueProviderMediator: ObservableObject {
    private (set) var scaleValueProviderModel: ScaleValueProviderModel = ScaleValueProviderModel()

    let scaleServices = ScaleService.shared
   
    var dimensionOnPlan = DimensionService.shared.dimensionOnPlan
    
    @Published var scale = ScaleService.shared.scale

    private var cancellables: Set<AnyCancellable> = []

    init() {
        DimensionService.shared.$dimensionOnPlan
            .sink { [weak self] newData in
                self?.dimensionOnPlan = newData
                self?.setDimensionOnPlan(newData)
            }
            .store(in: &cancellables)

        scaleServices.$leftScalingToolPosition
            .sink { [weak self] newData in
                    self?.setLeftScalingToolPosition(newData )
            }
            .store(in: &cancellables)

        scaleServices.$rightScalingToolPosition
            .sink { [weak self] newData in
                    self?.setRightScalingToolPosition(newData )
            }
            .store(in: &cancellables)

        scaleServices.$scalingCompleted
            .sink { [weak self] newData in
                if newData {
                    self?.setScale()
                }
        }
        .store(in: &cancellables)
    }
}


extension ScaleValueProviderMediator {
    func setLeftScalingToolPosition(_ location: CGPoint) {
        scaleValueProviderModel.leftScalingToolPosition = location
    }
    
    
    func setRightScalingToolPosition(_ location: CGPoint) {
        scaleValueProviderModel.rightScalingToolPosition = location
    }
    
    
    func setScale() {
        scaleValueProviderModel.setScale()

        scale =
        scaleValueProviderModel.scale
        
        scaleServices.setScale(scale)
    }
    
    
    func getScale() -> Double {
        scaleValueProviderModel.scale
    }
    

    func setDimensionOnPlan(_ value: Double) {
        scaleValueProviderModel.dimensionOnPlan = value
    }
}


