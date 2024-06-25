//
//  ChairManoeuvreModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import SwiftUI
import Foundation
struct ChairManoeuvre {

    private (set) var chairManoeuvres: Array<Type.ChairMovementsParts>
    private (set) var movements: Array<Array<Movement>>
    private (set) var parts: Array<Array<Part>>
    private (set) var manoeuvreScale: Double
    private (set) var manoeuvreTypeOfNextChairManoeuvreAdd: String
    init( ) {
        chairManoeuvres = []
        movements = []
        parts = []
        manoeuvreScale = 0.1
        manoeuvreTypeOfNextChairManoeuvreAdd = MovementNames.slowQuarterTurn.rawValue
print("INITIATION: CHAIR MANOEUVRE MODEL")
    }
    
    mutating func addChairMarkDictionary(_ dictionary: [String : [Double]], _ index: Int) {
        chairManoeuvres[index].chair.marks = dictionary
    }
    
    

    
    mutating func addChairManoeuvre(_ measurementDictionary: [String: Double], _ partsDictionaries: Type.PartsDictionary) {
        let index = chairManoeuvres.count
        let xLocation = ((Double(index - 1)  * 50) * manoeuvreScale + SizeOf.centre.x)
        let newMovement = Movement(xLocation, manoeuvreScale)
        let newParts = createPartsForChairManoeuvre(partsDictionaries)
        let chair = Chair(measurements: measurementDictionary)
        chairManoeuvres.append( (chair, [newMovement], newParts) )
    }
    
    mutating func addRotationMovementToChairManoeuvre (_ chairIndex: Int){
//print("EXTRA MOVEMENT ADDED")
        let movements = chairManoeuvres[chairIndex].movements
        let finalMovementIndex = movements.count - 1
        let movement = movements[finalMovementIndex]
        var newRotationMovement = Movement(movement.xConstraintLocation,  manoeuvreScale)
        newRotationMovement.name = MovementNames.position.rawValue
        newRotationMovement.chairAngle = .pi / 2
        newRotationMovement.xConstraintLocation = movement.xConstraintLocation
        newRotationMovement.yConstraintLocation = movement.yConstraintLocation
        newRotationMovement.xConstraintToChairOriginLocation = movement.xConstraintToChairOriginLocation
        newRotationMovement.yConstraintToChairOriginLocation = movement.yConstraintToChairOriginLocation
        chairManoeuvres[chairIndex].movements.append(newRotationMovement)
    }
    
    
    mutating func createPartsForChairManoeuvre(_ partsDictionaries: Type.PartsDictionary) -> [Part] {
        var newParts = Array<Part>()
        let nameAt = ArrayOfPartElement.names
        for partName in partsDictionaries.keys {
            newParts.append(Part(
                name: partName,
                xLocal: partsDictionaries[partName]![nameAt[0], default: 0],
                yLocal: partsDictionaries[partName]![nameAt[1], default: 0],
                width: partsDictionaries[partName]![nameAt[2], default: 0],
                length: partsDictionaries[partName]![nameAt[3], default: 0],
                partColor: .red))
        }
             return newParts
    }
    
    
    
    mutating func interpolateRotationMovementForChairManoeuvre (_ chairIndex: Int ) {
        let movements = chairManoeuvres[chairIndex].movements
        var movementAngles: [Double] = []
        let reverseFlipEffect = chairManoeuvres[chairIndex].chair.leftToRightFlip != chairManoeuvres[chairIndex].chair.bottomToTopFlip ? -1.0: 1.0
    
        for index in 0...1 {
            movementAngles.append(movements[index].chairAngle * reverseFlipEffect)
//print(movementAngles)
        }

        let minimumAngle = movementAngles.min() ?? 0.0
        let maximumAngle = (movementAngles).max() ?? .pi * 0.5
        let angleStep = (maximumAngle - minimumAngle).magnitude / 2.0

        for index in 2...(movements.count-1) {
//print("\(index)  \((minimumAngle + angleStep * Double(index - 1 )) * reverseFlipEffect)")
            chairManoeuvres[chairIndex].movements[index].chairAngle = (minimumAngle + angleStep * Double(index - 1) ) * reverseFlipEffect
//print(" \(minimumAngle)  \(maximumAngle) \(angleStep) \(Double(movements.count - 1))")
        }
    }
    
    mutating func flipChairManoeuvreLeftToRight(_ chairIndex: Int) {
        chairManoeuvres[chairIndex].chair.leftToRightFlip.toggle()
        for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
            let oldAngle = chairManoeuvres[chairIndex].movements[movementIndex].chairAngle
//print("Flip")

            let xOld = chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation
            chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation =
            -xOld
            chairManoeuvres[chairIndex].movements[movementIndex].chairAngle = -oldAngle

//print("LeftRightFlip")
        }
    }
    
    mutating func flipChairManoeuvreBottomToTop(_ chairIndex: Int) {
        chairManoeuvres[chairIndex].chair.bottomToTopFlip.toggle()
        for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
            let oldAngle = chairManoeuvres[chairIndex].movements[movementIndex].chairAngle
            let xOld = chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation
                        chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation =
                        -xOld
            chairManoeuvres[chairIndex].movements[movementIndex].chairAngle = .pi - oldAngle

//print("model change to xConstratingToOrigin\(-xOld)")
        }
    }
    
    mutating func modifyChairAngle (_ angle: Double, _ chair: ChairManoeuvre.Chair, _ movement: ChairManoeuvre.Movement) {
//print("ModifyChairAngle")
        for chairIndex in 0..<chairManoeuvres.count {
            if chairManoeuvres[chairIndex].chair.id == chair.id {
                for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
                    if chairManoeuvres[chairIndex].movements[movementIndex].id == movement.id {
                        chairManoeuvres[chairIndex].movements[movementIndex].chairAngle = angle
                    }
                }
            }
        }
    }
    

    
    mutating func modifyConstraintSide (_ chairIndex: Int, _ movementIndex: Int) {
        chairManoeuvres[chairIndex].movements[movementIndex].constrainedRightSide.toggle()
    }
    
    mutating func modifyLateralConstraintToChairOriginDistance(_ chairIndex: Int, _ x: Double) {
        for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
            chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation = x
//            chairManoeuvres[chairIndex].movements[movementIndex].yConstraintToChairOriginLocation = y
         }
    }
    
    mutating func modifyLateralConstraintToChairOriginDistanceDueToScaleChange(_ chairIndex: Int, _ newScale: Double) {
        for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
            let currentDimension = chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation
            let newDimension = currentDimension * newScale / manoeuvreScale
            chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation = newDimension
//            chairManoeuvres[chairIndex].movements[movementIndex].yConstraintToChairOriginLocation = y
         }
    }
    
    //    LOGIC REQUIRED WHAT IF NOT "POSITION", "TURN"
    
    mutating func modifyConstraintToChairOriginDistanceByChairDrag(_ chairIndex: Int, _ x: Double) {
        for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
            chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation += x
//print("constraintToOrigin \(chairManoeuvres[chairIndex].movements[movementIndex].xConstraintToChairOriginLocation)"  )
//            chairManoeuvres[chairIndex].movements[movementIndex].yConstraintToChairOriginLocation = y
         }
    }
    
    mutating func modifyConstraintLocationByBackgroundPictureDrag(_ chairIndex: Int, _ x: Double, _ y: Double) {
//print(x)
        for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {

            chairManoeuvres[chairIndex].movements[movementIndex].xConstraintLocation += x
            chairManoeuvres[chairIndex].movements[movementIndex].yConstraintLocation += y
         }
    }
    
    mutating func modifyConstraintLocationByChairDrag(_ chairIndex: Int, _ x: Double, _ y: Double) {
        for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
//print(x)
            chairManoeuvres[chairIndex].movements[movementIndex].xConstraintLocation = x
            chairManoeuvres[chairIndex].movements[movementIndex].yConstraintLocation = y
         }
    }
    
    mutating func modifyManoeuvreForNextChairAdd(_ newManoeuvre: String) {
//print(newManoeuvre)
        manoeuvreTypeOfNextChairManoeuvreAdd = newManoeuvre
    }
    
    mutating func modifyManoeuvreScale (_ scale: Double) {
//        for chairIndex in 0..<chairManoeuvres.count {
//            let dictionary = chairManoeuvres[chairIndex].chair.measurements
//print(scale / manoeuvreScale)
//print(dictionary)
//            for (key, value) in dictionary {
//                chairManoeuvres[chairIndex].chair.measurements[key] = value * scale / manoeuvreScale
//print(dictionary[key]!)
//            }
//print(chairManoeuvres[chairIndex].chair.measurements)
            
//        }
//print("SCALE SET FROM \(manoeuvreScale) TO \(scale)")
       // print("\(String(describing: chairManoeuvres.count>0 ? chairManoeuvres[0].chair.measurements[ChairMeasurements.chairLength.rawValue]: 0.0))")
        manoeuvreScale = scale
    }
    
    
    mutating func modifyMeasurements (_ chairIndex: Int, _ measurements: [String: Double]) {
        chairManoeuvres[chairIndex].chair.measurements = measurements
    }
    
    mutating func modifyMovementSelection(_ chairIndex: Int, _ movementIndex: Int ) {
        chairManoeuvres[chairIndex].movements[movementIndex].isSelected.toggle()
    }
    
    mutating func modifyStartAndEndAnglesHaveCrossed(_ state: Bool, _ chairIndex: Int) {
        chairManoeuvres[chairIndex].chair.startAndEndAnglesCrossed = state
//        chairManoeuvres[chairIndex].chair.startAndEndAnglesCrossed.toggle()
    }
    
//    mutating func modifyChairSelectionSetOtherChairsToFalse(_ chosenChairIndex: Int) {
//        for chairIndex in 0..<chairManoeuvres.count {
//            if chairIndex != chosenChairIndex {
//                chairManoeuvres[chairIndex].chair.isSelected = false
//            }
//        }
//    }
    
//    mutating func modifyEndAngleSubsequentlySmaller(_ state: Bool, _ chairIndex: Int) {
//        chairManoeuvres[chairIndex].chair.endAngleSubsequentlySmaller = state
//    }
//    mutating func modifyStartAngleInitiallySmaller(_ state: Bool, _ chairIndex: Int) {
//print("modifyStartAngleInitiallySmaller \(String(state))")
//        chairManoeuvres[chairIndex].chair.startAngleInitiallySmaller = state
//    }
    
    mutating func removeChairManoeuvre(_ indexOfSelectedChair: Int) {
        chairManoeuvres.remove(at: indexOfSelectedChair)
    }
    
    mutating func removeAllChairManoeuvre() {
        chairManoeuvres = []
    }
    
    mutating func removeInbetweenerdRotationMovement(_ chairIndex: Int) {
        if chairManoeuvres[chairIndex].movements.count == 3 {
            chairManoeuvres[chairIndex].movements.remove(at: 2)
        }
    }
    
    
    mutating func replacePartsInExistingChairManoeuvre(_ partsDictionaries: Type.PartsDictionary, _ chairIndex: Int ) {
        let newParts = createPartsForChairManoeuvre(partsDictionaries)
        chairManoeuvres[chairIndex].parts = newParts

    }
    
    mutating func replaceMarkDictionaryInExistingChairManoeuvre(_ markDictionary: [String: [Double]], _ chairIndex: Int ) {
        chairManoeuvres[chairIndex].chair.marks = markDictionary

    }

    
    mutating func setIsSlectedForThisMovementToFalse(_ chairIndex: Int, _ movementIndex: Int ) {
        chairManoeuvres[chairIndex].movements[movementIndex].isSelected = false
    }
    
    mutating func setIsSelectedForChairToFalse(_ chairIndex: Int) {
        chairManoeuvres[chairIndex].chair.isSelected = false
    }
    
    mutating func setIsSelectedForThisMovementToTrue(_ chairIndex: Int, _ movementIndex: Int) {
        chairManoeuvres[chairIndex].movements[movementIndex].isSelected = true
    }
    
    mutating func setIsSelectedForChairOfThisMovementToTrue(_ chairIndex: Int) {
        chairManoeuvres[chairIndex].chair.isSelected = true
    }
    
    mutating func setIsSelectedForOtherChairsAndMovementsToFalse(_ selectedChairIndex: Int) {
        for chairIndex in 0..<chairManoeuvres.count{
            if chairIndex != selectedChairIndex {
                chairManoeuvres[chairIndex].chair.isSelected = false
                for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
                    chairManoeuvres[chairIndex].movements[movementIndex].isSelected = false
                }
            }
        }
    }
    
    mutating func setShowToolsForThisMovementToFalse(_ chairIndex: Int, _ movementIndex: Int) {
        chairManoeuvres[chairIndex].movements[movementIndex].showTools = false
    }
    
    mutating func setShowToolsForThisMovementToTrueAndOthersToFalse(_ chairIndex: Int, _ movementIndex: Int) {
        for index in 0..<chairManoeuvres[chairIndex].movements.count {
            if index != movementIndex {
                chairManoeuvres[chairIndex].movements[index].showTools = false
            } else {
                chairManoeuvres[chairIndex].movements[movementIndex].showTools = true
            }
        }
    }
    
//    mutating func setShowToolsForThisMovementToFalse(_ chairIndex: Int, _ movementIndex: Int) {
//        chairManoeuvres[chairIndex].movements[movementIndex].showTools = false
//    }

    mutating func toggleFixedConstraintLocation(_ chairIndex: Int, _ movementIndex: Int) {
//print("FixedConstraintToggled")
        chairManoeuvres[chairIndex].movements[movementIndex].fixedConstraintLocation.toggle()
    }
    
    mutating func toggleTurningNotDragging(_ chairIndex: Int) {
        chairManoeuvres[chairIndex].chair.turningNotDragging.toggle()
    }
    mutating func setTurningNotDragging(_ chairIndex: Int, _ turning: Bool) {
        chairManoeuvres[chairIndex].chair.turningNotDragging = turning
    }
    
    struct Chair: Identifiable, Hashable, Equatable {

        var bottomToTopFlip = false
        var editMode = false
//        var endAngleSubsequentlySmaller = false
        var id = UUID()
        var isSelected = false
        var leftToRightFlip = false
//        var clockwiseAngleChange = true
        var manoeuvre = ""
        var marks: [String: [Double]] = [ : ]
        var measurements: [String: Double]
        var movementInterpolation = true
        var name = "SimpleWheelchair"
//        var startAngleInitiallySmaller = false
        var startAndEndAnglesCrossed = false
        var turningNotDragging = false
    }
    
    struct Movement: Hashable {
        var name = MovementNames.slowQuarterTurn.rawValue
        var xConstraintLocation: Double
        var yConstraintLocation: Double
//        var manoeuvreScale: Double
        var chairAngle = 0.0
        var isSelected = false
        var xConstraintToChairOriginLocation: Double
        var yConstraintToChairOriginLocation = 0.0
        var constrainedRightSide: Bool
        var fixedConstraintLocation = false
        var fixedMovement = false
        var showTools = false
        var id = UUID()
        init (_ xConstraintLocation: Double, _ manoeuvreScale: Double) {
            self.xConstraintLocation = xConstraintLocation
//            self.manoeuvreScale = manoeuvreScale
            self.yConstraintLocation = (SizeOf.centre.y) * 0.5
            self.xConstraintToChairOriginLocation = 60.0 * manoeuvreScale
            self.constrainedRightSide = self.xConstraintLocation >= 0.0 ? true: false
        }
    }
    
    struct Part: Identifiable {
        var name: String
        var xLocal: Double = 0.0
        var yLocal: Double = 0.0
        var width: Double = 0.0
        var length: Double = 0.0
        var isSelected = false
        var selectedHandle = [false, false, false, false]
        var partColor: Color
        var id = UUID()
    }

}
