//
//  ChairManoeuvreViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import Foundation
import SwiftUI
import simd
import Combine
 

class ChairManoeuvreProjectVM: ObservableObject {
    @Published private (set) var model: ChairManoeuvre  = ChairManoeuvre()
    var chairManoeuvres: Array<Type.ChairMovementsParts> {model.chairManoeuvres}
    var movements: Array<Array<ChairManoeuvre.Movement>> {model.movements}
    var parts: Array<Array<ChairManoeuvre.Part>> {model.parts}
    var scale: Double =
    ScaleService.shared.scale 

    private var cancellables: Set<AnyCancellable> = []
    init() {

        
        ScaleService.shared.$scale
            .sink { [weak self] newData in
                self?.scale = newData
                self?.model.modifyManoeuvreScale(newData)
            }
            .store(
                in: &cancellables
            )
        
    }
    

//    func errorReport(_ chairMovements: [Type.ChairMovementParts] ) {
//        var movementCount = 99
//        var chairIndex = 99
//        for index in 0..<chairManoeuvres.count {
//            if chairMovements[0].chair.id == chairManoeuvres[index].chair.id {
//                chairIndex = index
//                movementCount = chairManoeuvres[index].movements.count
//            }
//        }
       
//print ("chair:\(chairIndex)   movement\(movementCount) ")
//    }
    
    func setShowMenu (_ value: Bool){
            RightSideMenuDisplayService.shared.setShowRightSideMenu(value)
    }
    
    func addChairManoeuvre() {
        let simpleWheelchairMeasurementDictionary =
            [ChairMeasurements.chairLength.rawValue: 1340.0,
             ChairMeasurements.chairWidth.rawValue: DefaultMeasurements.wheelchair(.chairWidth),
             ChairMeasurements.footPlateWidth.rawValue: 150.0,
             ChairMeasurements.seatDepth.rawValue: 450.0,
             ChairMeasurements.wheelLength.rawValue: 600]
        let wheelchair = Create(chairMeasurementDictionary: simpleWheelchairMeasurementDictionary).simpleWheelchair()
        
        model.addChairManoeuvre(simpleWheelchairMeasurementDictionary, wheelchair)
        
        let chairIndex = model.chairManoeuvres.count - 1
        let markDictionary = createDictionaryForMarkLocationInRootLocal(chairIndex)
        model.addChairMarkDictionary(markDictionary, chairIndex)
        
        var lateralConstraintToChairOrginDistance = 0.0
        if model.manoeuvreTypeOfNextChairManoeuvreAdd == MovementNames.slowQuarterTurn.rawValue {
            let name = ChairMeasurements.chairWidth.rawValue
            lateralConstraintToChairOrginDistance = (simpleWheelchairMeasurementDictionary[name]  ?? 800 )
            model.modifyLateralConstraintToChairOriginDistance(chairIndex, lateralConstraintToChairOrginDistance )
            addRotationMovement(chairIndex)
        }
            
        if model.manoeuvreTypeOfNextChairManoeuvreAdd == MovementNames.mediumQuarterTurn.rawValue {
            let name = ChairMeasurements.chairWidth.rawValue
            lateralConstraintToChairOrginDistance = (simpleWheelchairMeasurementDictionary[name]  ?? 600 ) * 0.5
            model.modifyLateralConstraintToChairOriginDistance(chairIndex, lateralConstraintToChairOrginDistance )
            addRotationMovement(chairIndex)
        }
            
        if model.manoeuvreTypeOfNextChairManoeuvreAdd == MovementNames.tightestQuarterTurn.rawValue {
            lateralConstraintToChairOrginDistance = 0

            model.modifyLateralConstraintToChairOriginDistance(chairIndex, lateralConstraintToChairOrginDistance )
            addRotationMovement(chairIndex)
        }

    
    }
    
    func addRotationMovement(_ chairIndex: Int) {
            model.addRotationMovementToChairManoeuvre(chairIndex)
    }
    
    func addRotationMovementWithInterpolation() {
        if getIsAnyChairSelected() {
            let chairIndex =  getSelectedChairIndexAfterEnsuringSelectedExists()
            if chairManoeuvres[chairIndex].movements.count < 3 {
                model.addRotationMovementToChairManoeuvre(chairIndex)
                
                if chairManoeuvres[chairIndex].movements.count == 3 && chairManoeuvres[chairIndex].chair.movementInterpolation {
                    model.interpolateRotationMovementForChairManoeuvre(chairIndex)
                }
            }

        }
    }
    

    
    func applyChairManoeuvreScale(_ dimension: Double) -> Double{
        model.manoeuvreScale * dimension
    }
    
    func editChairInExistingChairManoeuvre() {
        
    }
    
    func flipManoeuvreBottomToTop(_ chairMovement: Type.ChairMovementParts) {
        let chairIndex = getChairIndex(chairMovement)

        model.flipChairManoeuvreBottomToTop(chairIndex)
    }

    func flipManoeuvreLeftToRight(_ chairMovement: Type.ChairMovementParts) {
        let chairIndex = getChairIndex(chairMovement)
print("left to right")
        model.flipChairManoeuvreLeftToRight(chairIndex)
    }
    
    
//    func getMeasurement(_ chair: ChairManoeuvre.Chair, _ measurementCase: ChairMeasurements) {
//        var measurement = 0.0
//        switch measurementCase {
//        case .chairLength:
//            measurement = getMeasurementValue(ChairMeasurements.chairLength.rawValue)
//        case .chairWidth:
//            <#code#>
//        case .footPlateWidth:
//            <#code#>
//        case .seatDepth:
//            <#code#>
//        case .wheelLength:
//            <#code#>
//        }
//
//        func getMeasurementValue(_ name: String ) -> Double {
//
//        }
//        let caseName = ChairMeasurements(rawValue: measurementName)
//        var measurement = 0.0
//        if let caseNameUnwrapped = caseName {
//            measurement = chair.measurements[measurementName]
//        } else {
//            let measurement = DefaultMeasurements.wheelchair(caseName)
//        }
//        return measurement
//    }
    
    func getAngleChangeInTanTwoRange(_ angleChange: Double, _ chairAngle: Double) -> Double {
        let angleSign = angleChange < 0 ? -1.0: 1.0
        let angleChangeInPiRange = angleChange.magnitude > .pi ?  Constant.twoPi - angleSign * angleChange: angleChange
        let angleInTanTwoRange = angleChangeInPiRange
        return angleInTanTwoRange
    }


    func getChairOriginInGlobal(_ chairMovement: Type.ChairMovementParts) -> CGPoint {
        let chairIndex = getChairIndex(chairMovement)
        let movementIndex = getMovementIndex(chairIndex, chairMovement)
        let movement =  model.chairManoeuvres[chairIndex].movements[movementIndex]
        let xlocation = movement.xConstraintLocation + movement.xConstraintToChairOriginLocation
        let ylocation = movement.yConstraintLocation + movement.yConstraintToChairOriginLocation
        return CGPoint(x: xlocation, y: ylocation)
    }

    
//    func reportSelectionStatus() {
//        for chairIndex in 0..<chairManoeuvres.count {
//            for movementIndex in 0..<chairManoeuvres[chairIndex].movements.count {
//                print("chair:\(chairIndex)  selection:\(chairManoeuvres[chairIndex].chair.isSelected)  movement:\(movementIndex) selection:\(chairManoeuvres[chairIndex].movements[movementIndex].isSelected)")
//            }
//        }
//    }
    
    func getChairIndex(_ chairMovement: Type.ChairMovementParts) ->Int {
        var chairIndexOnlyCalledIfItExists = 0
//        while chairMovement.chair.id != chairManoeuvres[chairIndex].chair.id {
//            print(chairIndex)
//            chairIndex += 1
//        }
        
        for index in 0..<model.chairManoeuvres.count {
            if chairMovement.chair.id == chairManoeuvres[index].chair.id {
                chairIndexOnlyCalledIfItExists = index
        }

        }
      
//    print("CHAIR INDEX \(chairIndexOnlyCalledIfItExists)")
        return chairIndexOnlyCalledIfItExists
    }

    
   func getChairIndexFromId(_ chairId: UUID) -> Int {
        var chairIndexFromChairId = 0
        for index in 0..<model.chairManoeuvres.count {
            if model.chairManoeuvres[index].chair.id == chairId {
                chairIndexFromChairId = index
            }
        }
        return chairIndexFromChairId
    }
    
    func getChairsSelectionState() -> [Bool]{
        var isSelectedArray: [Bool] = []
        for index in 0..<chairManoeuvres.count {
            isSelectedArray.append(chairManoeuvres[index].chair.isSelected)
        }
        return isSelectedArray
    }
//    func getIndexForChairWithAllMovements(_ chairWithAllMovements: Type.ChairMovementsParts) -> Int {
//        var chairIndex: Int?
//        for index in 0..<model.chairManoeuvres.count {
//            if chairWithAllMovements.chair.id == model.chairManoeuvres[index].chair.id {
//                chairIndex = index
//            }
//        }
//
//
//        return chairIndex!
//    }
    

    
    func getForEachMovementOfOneChairArrayChairMovementPart() ->  [(chairIndex: Int, chairMovementsParts: [Type.ChairMovementParts])]  {
        var items: [(chairIndex: Int, chairMovementsParts: [Type.ChairMovementParts])] = []
        for chairIndex in 0..<model.chairManoeuvres.count {
            var item: [Type.ChairMovementParts] = []
            for movement in chairManoeuvres[chairIndex].movements {
                item.append(
                    (chair: chairManoeuvres[chairIndex].chair, movement: movement,  parts: chairManoeuvres[chairIndex].parts)
                )
            }
            items.append((chairIndex: chairIndex, chairMovementsParts: item))
        }
        return items
    }
    



    func getIsAnyChairSelected() -> Bool {
        let aChairIsSelected = getChairsSelectionState().contains(true)
        if aChairIsSelected == false {
//print("You must select a chair")
        }
        return aChairIsSelected
    }
    func getSelectedChairIndexAfterEnsuringThatOneChairIsSelected() -> Int{
        let selectionState = getChairsSelectionState()
        let firstTrue = selectionState.firstIndex{ $0 == true}
        return firstTrue!
    }
    
    func getIsAnyChairSelectedString() -> String {
        let aChairIsSelected = getChairsSelectionState().contains(true)
        if aChairIsSelected == false {
//print("You must select a chair")
        }
        return "yes"
    }
    
    func getIsAnyChairMovementSelectedForThisChair( _ chairMovementParts: Type.ChairMovementParts) -> Bool {
        var numberOfMovementSelectedIndex = 0
        var anyMovementSelected = false
        let chairIndex = getChairIndex(chairMovementParts)
        if model.chairManoeuvres.count > 0 {
    //print("chairIndex:\(chairIndex)  count:\(model.chairManoeuvres.count)")
            for movement in model.chairManoeuvres[chairIndex].movements {
                if movement.isSelected {
                    numberOfMovementSelectedIndex += 1
                }
            }
            anyMovementSelected = numberOfMovementSelectedIndex > 0 ? true: false
        }
        
//print("A CHAIR MOVEMENT IS SELECTED \(numberOfMovementSelectedIndex)")
        return anyMovementSelected
    }
    
    func getMarkLocationInRootLocal( _ chair: ChairManoeuvre.Chair, _ markName: String ) -> CGPoint {
        var locationCG = CGPoint(x: 0.0, y: 0.0)
        let markDictionary = chair.marks
//print("\(markDictionary.count)")
//print(markDictionary[markName])
//for key in markDictionary.keys {
//    print("\(key) \(markName)")
//}

        if let location = markDictionary[markName] {
//print(location)
            locationCG = CGPoint(x: location[0], y: location[1])
        }
        return locationCG
    }
    
    func getMovementFixedConstraintLocationStates(_ chairMovement: Type.ChairMovementParts) -> [Bool] {
        let chairIndex = getChairIndex(chairMovement)
        var movementFixedConstraintLocationStates: [Bool] = [false]
        if chairManoeuvres.count > 0 {
            for movement in chairManoeuvres[chairIndex].movements {
                movementFixedConstraintLocationStates.append(movement.fixedConstraintLocation)
            }
        }
        return movementFixedConstraintLocationStates
    }
    
    

    
    func getMovementIndex(_ chairIndex: Int, _ chairMovement: Type.ChairMovementParts) -> Int {
        var movementIndexOnlyCalledIfItExists = 0
        for index in 0..<chairManoeuvres[chairIndex].movements.count {
            if chairMovement.movement.id == chairManoeuvres[chairIndex].movements[index].id {
                movementIndexOnlyCalledIfItExists = index
            }
        }
//print(movementIndexOnlyCalledIfItExists)
        return movementIndexOnlyCalledIfItExists
    }
    
    func getMovementIndexWithOutChairIndex( _ chairMovement: Type.ChairMovementParts) -> Int? {
        if chairManoeuvres.count > 0 {
        let chairIndex = getChairIndex(chairMovement)
        return getMovementIndex(chairIndex, chairMovement)
        } else {
            return nil
        }
        
    }
    
    
    func getMovementsSelectionStatesForThisChair(_ chairIndex: Int) -> [Bool]{
        var movementsSelectionStates:[Bool] = []
        for movement in chairManoeuvres[chairIndex].movements {
            movementsSelectionStates.append(movement.isSelected)
        }
        return movementsSelectionStates
    }
    
    func getSelectedChairIndexAfterEnsuringSelectedExists() -> Int {
        let chairsIsSelected = getChairsSelectionState()
        let chairIndex = chairsIsSelected.firstIndex(of: true)
//print("chair index \(chairIndex!)")
        return chairIndex!
    }
    //MODIFY
    func getSelectedMeasurement(_ measurementItem: ChairMeasurements) -> Double{
        var measurement: Double = 0.0
        let defaultMeasurement = DefaultMeasurements.wheelchair(measurementItem)
        if getIsAnyChairSelected() {
           let chairIndex = getSelectedChairIndexAfterEnsuringSelectedExists()
            if let unwrappedMeasurement = model.chairManoeuvres[chairIndex].chair.measurements[measurementItem.rawValue] {
                measurement = unwrappedMeasurement
            } else {
                measurement = defaultMeasurement
            }
        } else {
        measurement = defaultMeasurement
        }
        return measurement
    }

    
    func modifyAllMovementLocationsByBackgroundPictureDrag( _ dragLocationChange: CGPoint) {
        
        for chairIndex in 0..<chairManoeuvres.count {
        let x = Double(dragLocationChange.x)
        let y = Double(dragLocationChange.y)

        model.modifyConstraintLocationByBackgroundPictureDrag(chairIndex, x, y)
        }
    }

    
//    func modifyAllMovementLocationsByBackgroundPictureDrag(_ chairMovement: [Type.ChairMovementParts], _ dragLocationChange: CGPoint) {
//
//        for chairIndex in 0..<chairManoeuvres.count {
//        let x = Double(dragLocationChange.x)
//        let y = Double(dragLocationChange.y)
//
//        model.modifyConstraintLocationByBackgroundPictureDrag(chairIndex, x, y)
//        }
//    }
    

//    func modifyAllMovementLocationsByBackgroundPictureDrag(_ chairMovement: [Type.ChairMovementParts], _ dragLocationChange: CGPoint) {
//        let chairIndex = getChairIndex(chairMovement[0])
//
//        let x = Double(dragLocationChange.x)
//        let y = Double(dragLocationChange.y)
//
//        model.modifyConstraintLocationByBackgroundPictureDrag(chairIndex, x, y)
//    }
    
    
    func modifyTurnChairAngle (_ angleChange: Double, _ chairId: UUID) {
        for chairManoeuvre in chairManoeuvres {
            if chairManoeuvre.chair.id == chairId {
//                let flipEffect = (chairManoeuvre.chair.bottomToTopFlip ? 0: .pi * 1.0) + (chairManoeuvre.chair.leftToRightFlip ? 0: .pi * -1.0)
                for movement in chairManoeuvre.movements {
                    if movement.isSelected{
                        let existingAngle = movement.chairAngle
//print("\n angleChange:\(Int(angleChange * 180 / .pi))")
                        let angleChangeInTanTwoRange = getAngleChangeInTanTwoRange(angleChange , movement.chairAngle)
                        let newAngle = angleChangeInTanTwoRange + existingAngle
//print("newAngle:\(Int(newAngle * 180 / .pi))\n")
                        model.modifyChairAngle (newAngle, chairManoeuvre.chair, movement)
                    }
                }
            }
        }
    }
    
    func modifyLateralConstraintToChairOriginDistanceDueToScaleChange(_ newScale: Double) {
        for chairIndex in 0..<chairManoeuvres.count{
            model.modifyLateralConstraintToChairOriginDistanceDueToScaleChange(chairIndex, newScale)
        }
    }
    
    func modifyManoeuvreForNextChairAdd(_ newManoeuvre: String) {
        model.modifyManoeuvreForNextChairAdd(newManoeuvre)
    }
    
    func modifyMovementLocationByChairDrag(_ chairMovement: [Type.ChairMovementParts], _ dragLocationAtChairAngleZero: CGPoint, _ dragLocationChange: CGPoint) {

        let chairIndex = getChairIndex(chairMovement[0])
        let movement = chairManoeuvres[chairIndex].movements[0]
        var x = Double(dragLocationAtChairAngleZero.x)
        var y = Double(dragLocationAtChairAngleZero.y)
        let xConstraintToChairOriginLocation = movement.xConstraintToChairOriginLocation
        let yConstraintToChairOriginLocation = movement.yConstraintToChairOriginLocation
        if !movement.fixedConstraintLocation {
            x -= xConstraintToChairOriginLocation
            y -= yConstraintToChairOriginLocation
            model.modifyConstraintLocationByChairDrag(chairIndex, x, y)
        } else {
            let movementMagnifier = 10.0
            let chairAngle = movement.chairAngle
            let sinFunction = sin(chairAngle)
            let cosFunction = cos(chairAngle)
            let sDistanceDifference = (dragLocationChange.x * cosFunction + dragLocationChange.y * sinFunction) * movementMagnifier
            model.modifyConstraintToChairOriginDistanceByChairDrag(chairIndex, sDistanceDifference)
        }
    }
    
    func modifyManoeuvreScale(_ scale: Double, _ caller: String = "unknown") {
    //print("MANIEUVRE SCALE MODIFIED by \(caller) to \(scale)")
        model.modifyManoeuvreScale(self.scale)
        //model.modifyManoeuvreScale(scale)
    }
    
//    func modifyZoomScale (_ newManoeuvreScale: Double) {
//print("SizeOf.zoomScale \(SizeOf.zoomScale)")
//        let proportionalChangeToManoeuvreScale = model.manoeuvreScale/newManoeuvreScale
//        let correctionEnsuringFixedFingerTapArea = model.manoeuvreScale/newManoeuvreScale
//        SizeOf.zoomScale = SizeOf.zoomScale * correctionEnsuringFixedFingerTapArea
//print("SizeOf.zoomScale \(SizeOf.zoomScale)")
//    }

    
//    func modifyEndAngleSubsequentlySmaller(_ state: Bool, _ chairMovement: Type.ChairMovementParts) {
//        let chairIndex = getChairIndex(chairMovement)
//        model.modifyEndAngleSubsequentlySmaller(state, chairIndex)
//    }
//    func modifyStartEndAnglesCrossed(_ state: Bool, _ chairMovement: Type.ChairMovementParts) {
//        let chairIndex = getChairIndex(chairMovement)
//print("CHAIR INDEX \(chairIndex)")
//        model.modifyStartAngleInitiallySmaller(state, chairIndex)
//    }
    


    

    func removeChairManoeuvre() {
        let chairsIsSlelected = getChairsSelectionState()
        if let selectedChairIndex =  chairsIsSlelected.firstIndex(where: { $0 == true}) {
            model.removeChairManoeuvre(selectedChairIndex)
        } else {

        }
    }
    
    func removeAllChairManoeuvreById() {
            model.removeAllChairManoeuvre()
    }
       
//    func removeMovement(){
//        if getIsAnyChairSelected() {
//            let chairIndex =  getSelectedChairIndexAfterEnsuringSelectedExists()
//                model.removeInterpolatedRotationMovement(chairIndex)
//        }
//
//        removeInterpolatedRotationMovement(_ chairIndex: Int)
//
//    }
    
    func removeIntbetweenerRotationMovement() {
        if getIsAnyChairSelected() {
            let chairIndex =  getSelectedChairIndexAfterEnsuringSelectedExists()
                model.removeInbetweenerdRotationMovement(chairIndex)
        }
    }

    
    
    
    func replacePartsInExistingChairManoeuvre(_ new: Double, _ measureItem: ChairMeasurements){
        if getIsAnyChairSelected() {
            let scale = 1.0
            let chairIndex = getSelectedChairIndexAfterEnsuringSelectedExists()
            let chairMeasurements = chairManoeuvres[chairIndex].chair.measurements
            let oldChairWidth = chairMeasurements[ChairMeasurements.chairWidth.rawValue] ?? 100.0
            let oldChairLength = chairMeasurements[ChairMeasurements.chairLength.rawValue] ?? 100.0
//print ("input \(new)")
            let newSimpleWheelchairParameters =
            [ChairMeasurements.chairLength.rawValue: .chairLength == measureItem ? new: oldChairLength,
             ChairMeasurements.chairWidth.rawValue: .chairWidth == measureItem ? new: oldChairWidth,
                 ChairMeasurements.footPlateWidth.rawValue: 150.0,
                 ChairMeasurements.seatDepth.rawValue: 500.0,
                 ChairMeasurements.wheelLength.rawValue: 600]
            let newSimpleWheelchair = Create(chairMeasurementDictionary: newSimpleWheelchairParameters).simpleWheelchair()
            
            model.replacePartsInExistingChairManoeuvre(newSimpleWheelchair, chairIndex)

            let newMarkDictionary = createDictionaryForMarkLocationInRootLocal(chairIndex)
            model.replaceMarkDictionaryInExistingChairManoeuvre(newMarkDictionary, chairIndex)
            
            model.modifyMeasurements(chairIndex, newSimpleWheelchairParameters)
        } else {

        }
    }
    
    func getSelectedChairMeasurement(_ measurementName: ChairMeasurements) -> Double{
        var measurement = DefaultMeasurements.wheelchair(measurementName)
        if getIsAnyChairSelected() {
            let chairIndex = getSelectedChairIndexAfterEnsuringSelectedExists()
            if let unwrappedMeasurement = model.chairManoeuvres[chairIndex].chair.measurements[measurementName.rawValue] {
                measurement = unwrappedMeasurement
            }
        } else {
//print("SELECT CHAIR")
        }
        return measurement
    }

    func toggleFixedConstraintLocation(_ chairMovement: Type.ChairMovementParts) {
        let chairIndex = getChairIndex(chairMovement)
        let movementIndex = getMovementIndex(chairIndex, chairMovement)
        model.toggleFixedConstraintLocation(chairIndex, movementIndex)
    }
    
    func toggleSelectionOfOneMovementOfManoeuvre(_ chairMovement: Type.ChairMovementParts) {
//print("SELECTION MODIFIED")
        let chairIndex = getChairIndex(chairMovement)
        let movementIndex = getMovementIndex(chairIndex, chairMovement)
        var chairWasSelected = false
        if chairMovement.movement.isSelected {
//print("was selected")
                chairWasSelected = true
            model.setIsSlectedForThisMovementToFalse(chairIndex, movementIndex)
            model.setShowToolsForThisMovementToFalse(chairIndex, movementIndex)
            let movementSelectionStatesForThisChair = getMovementsSelectionStatesForThisChair(chairIndex)
            if movementSelectionStatesForThisChair.contains(true) {

            } else {
                model.setIsSelectedForChairToFalse(chairIndex)
            }
        } else {
            model.setIsSelectedForThisMovementToTrue(chairIndex, movementIndex)
            model.setShowToolsForThisMovementToTrueAndOthersToFalse(chairIndex, movementIndex)
            model.setIsSelectedForChairOfThisMovementToTrue(chairIndex)
            model.setIsSelectedForOtherChairsAndMovementsToFalse(chairIndex)
        }
        if chairWasSelected && !chairManoeuvres[chairIndex].chair.isSelected && chairManoeuvres[chairIndex].chair.turningNotDragging {
            toggleTurningNotDragging(chairMovement)
//print(chairManoeuvres[chairIndex].chair.turningNotDragging)
        }
    }
    
//    func toggleSelectionOfAllMovementToOneStateForManoeuvre(_ chairMovement:Type.ChairMovementParts) {
//        let chairIndex = getChairIndex(chairMovement)
//        model.toggleSelectionOfAllMovementToOneStateForManoeuvre(chairIndex)
//    }
    
    func setTurningNotDragging(_ chairMovement: Type.ChairMovementParts, _ turning: Bool) {
        let chairIndex = getChairIndex(chairMovement)
//print("Turning not dragging set to \(turning)")
        model.setTurningNotDragging(chairIndex, turning)
    }
    
    func toggleTurningNotDragging(_ chairMovement: Type.ChairMovementParts) {
        let chairIndex = getChairIndex(chairMovement)

        model.toggleTurningNotDragging(chairIndex)
//print("Turning not dragging set to \(model.chairManoeuvres[chairIndex].chair.turningNotDragging)")
    }
//    func modifyFixedConstraintLocation(_ chairMovement: Type.ChairMovementParts) {
//        let chairIndex = getChairIndex(chairMovement)
//        let movementIndex = getMovementIndex(chairIndex, chairMovement)
//
//    }
    
    
//    func toggleFlipState(_ chairMovement: Type.ChairMovementParts, _ horizontalOrVertical: FlipAxes) {
//        let chairIndex = getChairIndex(chairMovement)
//        switch horizontalOrVertical {
//        case .leftToRight:
//            model.toggleHorizontalFlipState(chairIndex)
//        case .bottomToTop:
//            model.toggleVerticalFlipState(chairIndex)
//        }
//    }
    

    
    
    
    func createDictionaryForMarkLocationInRootLocal( _ chairManoeuvreIndex: Int) -> [String : [Double]] {
        var markDictionary: [String : [Double]] = [ : ]
        for part in chairManoeuvres[chairManoeuvreIndex].parts {
            let xLocationVariations = part.name.contains(ChairPartsAndLocationNames.right.rawValue) ? part.xLocal: part.width + part.xLocal
            
            func createDictionary(_ frontToRearNames: [String], _ xLocationVariations: Double, _ yLocationVariations: [Double] ) -> [String : [Double]] {
                for index in 0..<frontToRearNames.count {
                    markDictionary[part.name + frontToRearNames[index] + "Mark"]
                        = [xLocationVariations,  yLocationVariations[index] ]
//print("\(part.name + frontToRearNames[index] + "Mark") ")
                }
                return markDictionary
            }
            
            if part.name.contains(ChairPartsAndLocationNames.wheel.rawValue) {
                let yLocationVariations = [part.yLocal + part.length, part.yLocal + part.length/2, part.yLocal]
                let frontToRearNames = Determine.frontRearNames()
                markDictionary = createDictionary(frontToRearNames, xLocationVariations, yLocationVariations)
            }
            if part.name.contains(ChairPartsAndLocationNames.footPlate.rawValue) {
                let yLocationVariations = [part.yLocal + part.length]
                let frontToRearNames = [ChairPartsAndLocationNames.front.rawValue]
                markDictionary = createDictionary(frontToRearNames, xLocationVariations, yLocationVariations)
            }
            if part.name.contains(ChairPartsAndLocationNames.footPlateHanger.rawValue) {
                let yLocationVariations = [part.yLocal + part.length]
                let frontToRearNames = [ChairPartsAndLocationNames.front.rawValue]
                markDictionary = createDictionary(frontToRearNames, xLocationVariations, yLocationVariations)
            }
        }
        return markDictionary
    }
    
    func createCGPointDictionary(_ names: [String], _ values: [CGPoint]) -> [String: CGPoint] {
        Dictionary(uniqueKeysWithValues: zip(names, values))
    }
    

        
}
