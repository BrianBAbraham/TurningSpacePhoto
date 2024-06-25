//
//  TurnHandleView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import SwiftUI


struct TurnHandleConditionalView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel
    var forEachMovementOfOneChairArrayChairMovementPart: [Type.ChairMovementParts]
    let firstIndex = 0
    var chairMovementParts: Type.ChairMovementParts {
        forEachMovementOfOneChairArrayChairMovementPart[firstIndex]
    }
    var chair: ChairManoeuvre.Chair {
        chairMovementParts.chair
    }
    var atLeastOneMovementIsSelected: Bool {
        vm.getIsAnyChairMovementSelectedForThisChair(chairMovementParts)
    }
    var movement: ChairManoeuvre.Movement {
        getFirstSelectedMovementOrReturnFirstMovement(forEachMovementOfOneChairArrayChairMovementPart)
    }
    var  turningNotDragging: Bool {
        chair.turningNotDragging
    }
    var turnStickLength: Double{
        0.0
    }
    var scaledTurnHandleSize: Double {
            vm.applyChairManoeuvreScale(SizeOf.tool)
    }
//        TurnHandleView.turnHandleSize
//        ( (chair.measurements[ChairMeasurements.chairWidth.rawValue] ?? 600 ) * 0.0 + TurnHandleView.turnHandleSize) * 1.0
       //300.0//vm.applyChairManoeuvreScale(200)
 
    var turnHandleDimensionFromOrigin: Double {
        vm.applyChairManoeuvreScale( defineTurnHandleDimensionFromOrigin(chair, vm, scaledTurnHandleSize))
    }
    var scale: Double {
        vm.model.manoeuvreScale
    }
    
    
//    var handleEndLocationInGlobal: CGPoint{
//        Determine.locationOnConstraintLineAtDimensionFromOriginInGlobal(chair, movement, turnHandleDimensionFromOrigin, scale)
//    }
    var handleEndLocationInGlobal: CGPoint{
        Determine.locationOnAftForeLineAtDimensionFromOriginInGlobal(chair, movement, turnHandleDimensionFromOrigin, scale)
    }
    
    
    
    var mostDistantSideFromConstraint: LeftOrRight {
        movement.xConstraintToChairOriginLocation >= 0.0 ? .left: .right}
    var body: some View {
        if atLeastOneMovementIsSelected && visibleToolViewModel.getShowTool() {
                TurnHandleView(
                    forEachMovementOfOneChairArrayChairMovementPart: forEachMovementOfOneChairArrayChairMovementPart,
                    chair: chair,
                    movement: movement,
                    mostDistantSideFromConstraint: mostDistantSideFromConstraint,
                    turnStickLength: turnStickLength,
                    handleEndLocationInGlobal: handleEndLocationInGlobal )
                .opacity(turningNotDragging ? SizeOf.selectedOpacity: SizeOf.unSelectedOpacity)

                .onTapGesture {
                    vm.toggleTurningNotDragging(chairMovementParts)
                }
            }
    }

    func defineTurnHandleDimensionFromOrigin (_ chair: ChairManoeuvre.Chair,_ vm: ChairManoeuvreProjectVM, _ turnHandleSize: Double) -> Double {
      
        let dimensionToChairExternalWidth = ( (chair.measurements[ChairMeasurements.chairLength.rawValue]  ?? DefaultMeasurements.wheelchair(.chairLength) ) )
//        let dimensionForFlip = 100.0
        let dimension = (dimensionToChairExternalWidth * 1.25 + turnHandleSize)
        return dimension
    }

    func getFirstSelectedMovementOrReturnFirstMovement(_ items: [Type.ChairMovementParts]) ->ChairManoeuvre.Movement {
        var movementToBeUsed = items[0].movement
        for chairMovementParts in items.reversed() {
            if chairMovementParts.movement.isSelected == true {
                movementToBeUsed = chairMovementParts.movement
            }
        }
        return movementToBeUsed
    }

}


struct TurnHandleView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @GestureState private var startLocation: CGPoint? = nil
    @State private var xChange = 0.0
    @State private var yChange = 0.0
    var forEachMovementOfOneChairArrayChairMovementPart: [Type.ChairMovementParts]
    let firstIndex = 0
    var chairMovementParts: Type.ChairMovementParts {
        forEachMovementOfOneChairArrayChairMovementPart[firstIndex]
    }
    let chair: ChairManoeuvre.Chair
    let movement: ChairManoeuvre.Movement
    let mostDistantSideFromConstraint: LeftOrRight
    var scaledTurnHandleSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool)
    }
    let turnStickLength: Double
    let handleEndLocationInGlobal: CGPoint

    var chairOriginInGlobal: CGPoint {
        Determine.chairOriginInGlobal(movement)
//        vm.getChairOriginInGlobal(chairMovement)
    }
    var constraintLocationInGlobal: CGPoint {
        Determine.constraintLocationInGlobal(movement)
    }

    var handleEndCirclePathRadius: Double {
        Determine.distanceBetweenTwoLocations(chairOriginInGlobal,handleEndLocationInGlobal)
    }
    var distanceFromConstraintToHandleEnd: Double {
        Determine.distanceBetweenTwoLocations(constraintLocationInGlobal, handleEndLocationInGlobal)
    }
    var handleEndLocationAfterRotationInGlobal: CGPoint {
        Determine.locationAfterTurnAroundPointWithGlobals(movement.chairAngle,constraintLocationInGlobal , handleEndLocationInGlobal )
    }
    var correctorForRightOrLeftSideConstraint: Double {
        mostDistantSideFromConstraint == .left ? 1: 1
    }
    var location: CGPoint {
        Determine.chairOriginInGlobal(chairMovementParts.movement)
    }
//    var flipEffect: Double {
//        (chair.bottomToTopFlip ? 0: .pi) + (chair.leftToRightFlip ? 0: -1.0 * .pi)
//    }
    var turnHandleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                if chair.turningNotDragging {
                    var location = handleEndLocationInGlobal
                    var newLocation = startLocation ?? location
                    newLocation.x = value.translation.width
                    newLocation.y = value.translation.height
                    let newLocationOnCircle =
                    Determine.locationOnCircleClosestToPointInLocal(handleEndCirclePathRadius, constraintLocationInGlobal, value.location)
                    let constraintToHandleEndLocation = Manipulate.secondMinusFirstCGPoints(constraintLocationInGlobal, handleEndLocationInGlobal)
                    let angleConstraintToHandleEndLocation = atan2(constraintToHandleEndLocation.y,constraintToHandleEndLocation.x)
//print("\(Int(angleConstraintToHandleEndLocation * 180 / .pi)) x: \(Int(constraintToHandleEndLocation.x))  y:\(Int(constraintToHandleEndLocation.y))")
//print("\(Int( atan2(newLocationOnCircle.y * correctorForRightOrLeftSideConstraint, newLocationOnCircle.x * correctorForRightOrLeftSideConstraint)  * 180 / .pi)) \n")
                    let angleChange =
                    atan2(newLocationOnCircle.y * correctorForRightOrLeftSideConstraint, newLocationOnCircle.x * correctorForRightOrLeftSideConstraint) -
                    (Angle(radians:movement.chairAngle).normalized().radians ) -
                    angleConstraintToHandleEndLocation
//
//                    let angleChange = atan2(newLocationOnCircle.y, newLocationOnCircle.x) - atan(constraintToHandleEndLocation.y / constraintToHandleEndLocation.x) - Angle(radians:movement.chairAngle).normalized().radians //+ flipEffect
//
//                    let angleChange = atan2(newLocation.y, newLocation.x) - atan(constraintToHandleEndLocation.y / constraintToHandleEndLocation.x) * 0 - Angle(radians:movement.chairAngle).normalized().radians
                    
                    vm.modifyTurnChairAngle(angleChange, chair.id)
                    location = newLocation
                } //else {
//                    var newLocation = startLocation ?? location
//                    let xTranslation = value.translation.width
//                    let yTranslation = value.translation.height
//                    newLocation.y += yTranslation
//                    newLocation.x += xTranslation
//                    xChange = xTranslation - xChange
//                    yChange = yTranslation - yChange
//                    vm.modifyMovementLocationByChairDrag(forEachMovementOfOneChairArrayChairMovementPart, newLocation, CGPoint(x: xChange, y: yChange))
//                    xChange = xTranslation
//                    yChange = yTranslation
//                }
           }
//            .updating($startLocation) { (value, startLocation, transaction) in
//                if chair.turningNotDragging {
//                } else {
//                    startLocation = startLocation ?? Determine.chairOriginInGlobal(chairMovementParts.movement)
//                }
//            }
        
            .onEnded(){ value in
                if chair.turningNotDragging {
                    vm.setTurningNotDragging(chairMovementParts, false)
                }
//                    else {
//                    self.xChange = 0.0
//                    self.yChange = 0.0
//                    vm.setTurningNotDragging(chairMovementParts, false)
//                }
            }
    }
    var iconOnTurnHandle: String {
        "arrow.triangle.2.circlepath"
//        chair.turningNotDragging ? "arrow.triangle.2.circlepath": "arrow.up.and.down.and.arrow.left.and.right"
    }
    var body: some View {
//        if movement.isSelected  {
            ZStack{
                MyCircle(fillColor: Color("Orange"), strokeColor: .black, scaledTurnHandleSize, handleEndLocationAfterRotationInGlobal)
                Image(systemName: iconOnTurnHandle)
                    .foregroundColor(.black)
                    .font(.system(size: SizeOf.fontProportionOfTool * scaledTurnHandleSize))
                    .position(x: handleEndLocationAfterRotationInGlobal.x, y: handleEndLocationAfterRotationInGlobal.y)
        }
            .gesture(turnHandleDrag)
    }
}

//struct LineFromMarkToTurnHandleConditionalView: View {
//    let markLocationInGlobal: CGPoint
//    let handleEndLocationInGlobal: CGPoint
//    let movement: ChairManoeuvre.Movement
//    var movementIsSelected: Bool
//    init(_ markLocationInGlobal: CGPoint, _ handleEndLocationInGlobal: CGPoint, _ movement: ChairManoeuvre.Movement ) {
//        self.markLocationInGlobal = markLocationInGlobal
//        self.handleEndLocationInGlobal = handleEndLocationInGlobal
//        self.movement = movement
//        self.movementIsSelected = movement.isSelected
//    }
//    
//    var body: some View {
//        if self.movement.showTools && self.movementIsSelected {
//            LocalLine.path([self.markLocationInGlobal, self.handleEndLocationInGlobal])
//                .opacity(0.5)
//        }
//    }
//}

