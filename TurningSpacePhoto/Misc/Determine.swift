//
//  Determine.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import Foundation
import SwiftUI
struct Determine {

    static  func chairOriginInGlobal(_ movement: ChairManoeuvre.Movement) -> CGPoint{
        let xLocation = movement.xConstraintLocation + movement.xConstraintToChairOriginLocation
        let yLocation = movement.yConstraintLocation + movement.yConstraintToChairOriginLocation
        return
            CGPoint(x: xLocation, y: yLocation )
    }
    
    static  func chairOriginAccountingForScaleInGlobal(_ movement: ChairManoeuvre.Movement, _ scale: Double) -> CGPoint{
        let xLocation = movement.xConstraintLocation + movement.xConstraintToChairOriginLocation * scale
        let yLocation = movement.yConstraintLocation + movement.yConstraintToChairOriginLocation * scale
        return
            CGPoint(x: xLocation, y: yLocation )
    }
    
    static func constraintLocationInGlobal(_ movement: ChairManoeuvre.Movement) -> CGPoint {
        let xLocation = movement.xConstraintLocation
        let yLocation = movement.yConstraintLocation
        return CGPoint(x: xLocation, y: yLocation)
    }
    
    static func distanceBetweenTwoLocations(_ firstLocation: CGPoint, _ secondLocation: CGPoint) -> Double {
        let vectorFromFirstToSecond = Manipulate.secondMinusFirstCGPoints(firstLocation, secondLocation)
        let distance = Manipulate.magnitudeOfVector(vectorFromFirstToSecond)
        return distance
    }
    

    
    
 static func frontRearNames() -> [String]{
     let chairPartsAndLocationsNames = ChairPartsAndLocationNames.allCases
     var frontToRearNames: [String] = []
     for item in chairPartsAndLocationsNames {
         switch item {
         case .front: frontToRearNames.append(ChairPartsAndLocationNames.front.rawValue)
         case .betweenFrontRear: frontToRearNames.append(ChairPartsAndLocationNames.betweenFrontRear.rawValue)
         case .rear: frontToRearNames.append(ChairPartsAndLocationNames.rear.rawValue)
         default: break
         }
     }
     return frontToRearNames
 }
    
    static func locationAfterTurnAroundPointWithGlobals(_ angle: Double, _ theTurnPoint: CGPoint, _ theOldLocation: CGPoint) -> CGPoint {
        let cosFunction = cos(angle)
        let sinFunction = sin(angle)
        let vectorToTurnPoint = Manipulate.secondMinusFirstCGPoints(theOldLocation, theTurnPoint)
        let xToTurnPoint = -vectorToTurnPoint.x
        let yToTurnPoint = -vectorToTurnPoint.y
        let xNewLocation = xToTurnPoint * cosFunction - yToTurnPoint * sinFunction + theTurnPoint.x
        let yNewLocation = xToTurnPoint * sinFunction + yToTurnPoint * cosFunction + theTurnPoint.y
        return CGPoint(x: xNewLocation, y: yNewLocation)
    }
    
//    static func locationOfTurnHandleStickEndInGlobal ( _ movement: ChairManoeuvre.Movement, _ markLocationInGlobal: CGPoint, _ xFlipped: Bool) -> CGPoint {
//        var turnStickLength = 600.0
//        if movement.name == MovementNames.turn.rawValue {
//            turnStickLength += 600.0
//        }
//        var xLocationOfTurnHanldeStickEndInGlobal = markLocationInGlobal.x + turnStickLength
//        xLocationOfTurnHanldeStickEndInGlobal = xFlipped ? -xLocationOfTurnHanldeStickEndInGlobal: xLocationOfTurnHanldeStickEndInGlobal
//
//        let turnHandleStickEndLocationInGlobal =  CGPoint(x: xLocationOfTurnHanldeStickEndInGlobal,  y: markLocationInGlobal.y)
//print(xLocationOfTurnHanldeStickEndInGlobal)
//print(markLocationInGlobal.x)
//print("")
//        return turnHandleStickEndLocationInGlobal
//    }
    
    static func locationOfLeftTurnHandleStickEndInGlobal (_ turnStickLength: Double, _ markLocationInGlobal: CGPoint ) -> CGPoint{
        return CGPoint(x: markLocationInGlobal.x + turnStickLength,  y: markLocationInGlobal.y)
    }
    
    static func locationOfRightTurnHandleStickEndInGlobal (_ turnStickLength: Double, _ markLocationInGlobal: CGPoint) -> CGPoint{
        return CGPoint(x: markLocationInGlobal.x - turnStickLength,  y: markLocationInGlobal.y)
        
    }
    
    static func locationOnConstraintLineAtDimensionFromOriginInGlobal(_ chair: ChairManoeuvre.Chair, _ movement: ChairManoeuvre.Movement, _ dimension: Double, _ scale: Double) -> CGPoint{
//print("locationOnConstraintLineAtDimensionFromOriginInGlobal:\(dimension)")
        var locationForDimension: CGPoint = .zero
        var mostDistantSideFromConstraint: LeftOrRight {
            movement.xConstraintToChairOriginLocation >= 0.0 ? .left: .right}
        switch mostDistantSideFromConstraint {
            case .left:
            locationForDimension = CGPoint(x: dimension, y: 0 )
            case .right:
            locationForDimension = CGPoint(x: -dimension, y: 0 )
        }
        locationForDimension = Manipulate.addCGPoints(locationForDimension, chairOriginAccountingForScaleInGlobal(movement, scale))
//print("locationOnConstraintLineAtDimensionFromOriginInGlobal:\(locationForDimension)")
        return locationForDimension
    }
    
    static func locationOnAftForeLineAtDimensionFromOriginInGlobal(
        _ chair: ChairManoeuvre.Chair,
        _ movement: ChairManoeuvre.Movement,
        _ dimension: Double,
        _ scale: Double
    ) -> CGPoint{
        var locationForDimension: CGPoint = CGPoint(
            x: 0,
            y: dimension
        )
        locationForDimension = Manipulate.addCGPoints(
            locationForDimension,
            chairOriginAccountingForScaleInGlobal(
                movement,
                scale
            )
        )
        return locationForDimension
    }
    
    
//    static func locationOnAftForeLineAtDimensionFromOriginInGlobal(_ chair: ChairManoeuvre.Chair, _ movement: ChairManoeuvre.Movement, _ dimension: Double, _ scale: Double) -> CGPoint{
////print("locationOnConstraintLineAtDimensionFromOriginInGlobal:\(dimension)")
//        var locationForDimension: CGPoint = .zero
//        var mostDistantSideFromConstraint: LeftOrRight {
//            movement.xConstraintToChairOriginLocation >= 0.0 ? .left: .right}
//        switch mostDistantSideFromConstraint {
//            case .left:
//            locationForDimension = CGPoint(x: 0 , y: dimension)
//            case .right:
//            locationForDimension = CGPoint(x: 0 , y: dimension)
//        }
//        locationForDimension = Manipulate.addCGPoints(locationForDimension, chairOriginAccountingForScaleInGlobal(movement, scale))
////print("locationOnConstraintLineAtDimensionFromOriginInGlobal:\(locationForDimension)")
//        return locationForDimension
//    }
    
    static func locationOnCircleClosestToPointInLocal(_ radius: Double, _ circleCentre: CGPoint, _ otherLocation: CGPoint) -> CGPoint {
        let circleCentreToOtherLocationInLocal = Manipulate.secondMinusFirstCGPoints( circleCentre,  otherLocation)
        let angle = Double(atan2(circleCentreToOtherLocationInLocal.y, circleCentreToOtherLocationInLocal.x))
        let locationOnCircleClosestToPointInLocal = CGPoint(x: radius * cos(angle), y: radius * sin(angle))
        return locationOnCircleClosestToPointInLocal
    }
    
    static func markNamesAccountingForBothFlips(_ chair: ChairManoeuvre.Chair, _ markNames: [String]) -> [String] {
        var bottomToTopFlip: Bool {
            chair.bottomToTopFlip
        }
        var leftToRightFlip: Bool {
            chair.leftToRightFlip
        }
        var noFlips: Bool {
            !bottomToTopFlip && !leftToRightFlip ? true: false
        }
        var bothFlips: Bool {
            bottomToTopFlip && leftToRightFlip ? true: false
        }
        var markNamesAccountingForSideSwap: [String] = []
        var markNameAccountingForSideSwap = ""
        for markName in markNames {
            if bottomToTopFlip || leftToRightFlip && !bothFlips {
                if markName.contains("Left") {
                    markNameAccountingForSideSwap = markName.replacingOccurrences(of: "Left", with: "Right")
                }
                if markName.contains("Right") {
                    markNameAccountingForSideSwap = markName.replacingOccurrences(of: "Right", with: "Left")
                }
            } else {
                markNameAccountingForSideSwap = markName
            }
            markNamesAccountingForSideSwap.append(markNameAccountingForSideSwap)
        }
        return markNamesAccountingForSideSwap
    }
    
    
    static func markLocationsInLocalFromDictionaryForMarkNames(
        _ markDictionary: [String:[Double]],
        _ markNames: [String]) ->[[Double]]{
            var xLocationOfPartInLocal: Double = 0.0
            var yLocationOfPartInLocal: Double = 0.0
            var markLocationsInLocal: [[Double]] = []
            for name in markNames {
                xLocationOfPartInLocal = markDictionary[name]?[0] ?? 0.0
                yLocationOfPartInLocal = markDictionary[name]?[1] ?? 0.0
                markLocationsInLocal.append([xLocationOfPartInLocal, yLocationOfPartInLocal])
            }
            return markLocationsInLocal
    }
    

    static func radiusFromConstraintToMarkAccountingForScale(
        _ constraintToChairOrigin: CGPoint,
        _  xPartLocationInLocal: Double,
        _  yPartLocationInLocal: Double
        ) -> CGFloat {
            let x = xPartLocationInLocal + constraintToChairOrigin.x
            let y = yPartLocationInLocal + constraintToChairOrigin.y
        return  sqrt(pow(x, 2) + pow(y ,2))
    }
    
    static func sideMostDistantFromConstraint(_ leftMarkLocationInGlobal: CGPoint, _ rightMarkLocationInGlobal: CGPoint,  _ constraintLocationInGlobal:CGPoint) -> LeftOrRight {
        let rightDistance = Determine.distanceBetweenTwoLocations(rightMarkLocationInGlobal, constraintLocationInGlobal)
        let leftDistance = Determine.distanceBetweenTwoLocations(leftMarkLocationInGlobal, constraintLocationInGlobal)
        
        if rightDistance >= leftDistance {
            return .right
        } else {
            return .left
        }
    }
    
    static func partNameFromRandomOrderPartAndLocations(_ partAndLocations: [[ChairPartsAndLocationNames]], _ markLocation: ChairPartsAndLocationNames? = nil) -> [String] {
        var partNames:[String] = []
        var frontRearName:String = ""
        var leftRightName:String = ""
        var partName:String = ""
//        var nonLocationItem: ChairPartsAndLocationNames = .seat
        var nonLocationItem: String = ""
        var markLocationName:String = ""
        

        
        
        
        for partAndLocation in partAndLocations {
            for item in partAndLocation {
                switch item {
                    case .front: frontRearName = ChairPartsAndLocationNames.front.rawValue
                    case .betweenFrontRear: frontRearName = ChairPartsAndLocationNames.betweenFrontRear.rawValue
                    case .rear: frontRearName = ChairPartsAndLocationNames.rear.rawValue
                    case .left: leftRightName = ChairPartsAndLocationNames.left.rawValue
                    case .betweenLeftRight: leftRightName = ChairPartsAndLocationNames.betweenLeftRight.rawValue
                    case .right: leftRightName = ChairPartsAndLocationNames.right.rawValue
                default: nonLocationItem = item.rawValue
            }
//            for item in ChairPartsAndLocationNames.allCases {
//                if nonLocationItem == item {
//                    partName = item.rawValue
//                }
//            }
        }
        partName = frontRearName + leftRightName + nonLocationItem
            partNames.append(partName)
        }
        

        
        if let markUnwrapped = markLocation {
            switch markUnwrapped {
                case .front: markLocationName = ChairPartsAndLocationNames.front.rawValue
                case .betweenFrontRear: markLocationName = ChairPartsAndLocationNames.betweenFrontRear.rawValue
                case .rear: markLocationName = ChairPartsAndLocationNames.rear.rawValue
                case .left: markLocationName = ChairPartsAndLocationNames.left.rawValue
                case .betweenLeftRight: markLocationName = ChairPartsAndLocationNames.betweenLeftRight.rawValue
                case .right: markLocationName = ChairPartsAndLocationNames.right.rawValue
                default: markLocationName = ""
            }
        }
        if markLocationName != "" {
            partNames = [partName + markLocationName + "Mark"]
        }
        
        
//print(partNames)
        return partNames
    }
    
    
//    static func directionOfArcs(_ startAngleAccountingForFlip: Double, _ endAngleAccountingForFlip: Double) -> Bool{
//        startAngleInitiallySmaller = startAngleAccountingForFlip < endAngleAccountingForFlip ? true: false
//        if startAngleAccountingForFlip > endAngleAccountingForFlip {
//            endAngleSubsequentlySmaller = true
//        }
//        return startAngleInitiallySmaller && !endAngleSubsequentlySmaller ? true: false
//    }
    
    static func turnStickLength(_ movement: ChairManoeuvre.Movement, _ length: Double) -> Double {
        var turnStickLength = length
        if movement.name == MovementNames.slowQuarterTurn.rawValue {
            turnStickLength += length
        }
        return turnStickLength
    }
    
}

struct Manipulate {
    
    static func addCGPoints (_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> CGPoint {
        CGPoint(x:firstPoint.x + secondPoint.x, y: firstPoint.y + secondPoint.y )
    }
    
    static func cgpointFromTwoDoubleInArray(_ twoDoublesInArray: [Double]) -> CGPoint {
        CGPoint(x: twoDoublesInArray[0] ,y: twoDoublesInArray[1])
    }
    
    static func magnitudeOfVector(_ vector: CGPoint) -> Double {
        sqrt(pow(vector.x,2) + pow(vector.y,2))
    }
    
    static func secondMinusFirstCGPoints (_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> CGPoint {
       CGPoint(x:secondPoint.x - firstPoint.x, y: secondPoint.y - firstPoint.y )
   }
    

    
}

struct Constant {
  static let twoPi = 2.0 * .pi
}
