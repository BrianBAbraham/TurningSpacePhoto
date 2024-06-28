//
//  Calculate.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/05/2023.
//

import Foundation

struct CircularMotionChange {
    var xChange: Double = 0.0
    var yChange: Double = 0.0
    var zChange: Double = 0.0
    
    init (
        _ r: Double,
        _ angle0: Measurement<UnitAngle>,
        _ angle1: Measurement<UnitAngle>,
        _ rotationAxis: RotationAxis ) {
           
            switch rotationAxis {
            case .yAxis:
                yChange = getChange(r, angle0, angle1, .yChange, rotationAxis)
                zChange = getChange(r, angle0, angle1, .zChange, rotationAxis)
            case .zAxis:
                xChange = getChange(r, angle0, angle1, .xChange, rotationAxis)
                yChange = getChange(r, angle0, angle1, .yChange, rotationAxis)
            }
            
            
            func getChange(
                _ r: Double,
                _ angle0: Measurement<UnitAngle>,
                _ angle1: Measurement<UnitAngle>,
                _ direction: Direction,
                _ rotationAxis: RotationAxis)
                -> Double {

                let angle0 = angle0.converted(to: .radians).value
                let angle1 = angle1.converted(to: .radians).value
                    var trigValue = 0.0
                    switch rotationAxis {
                    case .yAxis:
                        trigValue = dependsOnRotationAxisY(direction)
                    case .zAxis:
                        trigValue = dependsOnRotationAxisZ(direction)
                    }
                   

            return r * trigValue
                    
                    func dependsOnRotationAxisY(_ change: Direction) -> Double{
                        switch direction {
                        case .zChange:
                            return
                                ( sin(angle0 + angle1) - sin(angle0) )
                        case .yChange:
                            return
                                ( cos(angle0 + angle1) - cos(angle0) )
                            
                        default: fatalError()
                        }
                    }
                    
                    func dependsOnRotationAxisZ(_ change: Direction) -> Double{
                        switch direction {
                        case .xChange:
                            return
                                ( cos(angle0 + angle1) - cos(angle0) )
                                
                        case .yChange:
                            return
                                ( sin(angle0 + angle1) - sin(angle0) )
                            
                        default: fatalError()
                        }
                      
                    }
            }
        }
    enum Direction {
        case xChange
        case yChange
        case zChange
    }
    
}



struct PositionOfPointAfterRotationAboutPoint {
    let staticPoint: PositionAsIosAxes //primary origin to 
    let movingPoint: PositionAsIosAxes
    var fromStaticToPointAboutToMove: PositionAsIosAxes{
        CreateIosPosition.subtractSecondFromFirstTouple(
            movingPoint,
            staticPoint)
    }
    let angleChange: Measurement<UnitAngle>
    let rotationAxis: RotationAxis
    var currentAngle: Measurement<UnitAngle> {
        AngleFromPosition(position: fromStaticToPointAboutToMove, rotationAxis: rotationAxis).angle
    }
    var radius: Double {
        RadiusFromPosition(position: fromStaticToPointAboutToMove, rotationAxis: rotationAxis).radius
    }
    var motionChange: CircularMotionChange {
        CircularMotionChange(radius, currentAngle, angleChange, rotationAxis)
    }
    var xChange: Double {
        motionChange.xChange
    }
    var yChange: Double {
        motionChange.yChange
    }
    var zChange: Double {
        motionChange.zChange
    }
    
    var fromStaticToPointWhichHasMoved: PositionAsIosAxes {
        switch rotationAxis {
        case .yAxis:
            return
                (x: fromStaticToPointAboutToMove.x,
                 y: fromStaticToPointAboutToMove.y + yChange,
                 z: fromStaticToPointAboutToMove.z + zChange)
        case .zAxis:
            return
                (x: fromStaticToPointAboutToMove.x + xChange,
                 y: fromStaticToPointAboutToMove.y + yChange,
                 z: fromStaticToPointAboutToMove.z)
        }
          }
    
    var fromObjectOriginToPointWhichHasMoved: PositionAsIosAxes {
        CreateIosPosition.addTwoTouples(
            staticPoint,
            fromStaticToPointWhichHasMoved)
    }
}



enum RotationAxis {
    case yAxis
    case zAxis
}



struct AngleFromPosition {
    let position: PositionAsIosAxes
    let rotationAxis: RotationAxis
    var angle: Measurement<UnitAngle> {
        switch rotationAxis {
        case .yAxis:
            Measurement(value: atan2(position.z, position.y), unit: UnitAngle.radians)
        case .zAxis:
            Measurement(value: atan2(position.y, position.x), unit: UnitAngle.radians)
        }
        
    }
}

struct RadiusFromPosition {
    let position: PositionAsIosAxes
    let rotationAxis: RotationAxis
    var radius: Double {
        switch rotationAxis {
        case .yAxis:
            sqrt(position.z * position.z + position.y * position.y)
        case .zAxis:
            sqrt(position.x * position.x + position.y * position.y)
        }
        
    }
}
