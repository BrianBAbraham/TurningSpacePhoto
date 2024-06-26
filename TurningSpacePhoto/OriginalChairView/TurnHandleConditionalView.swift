//
//  TurnHandleView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import SwiftUI


struct TurnHandleConditionalView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
  
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
    var turnHandleDimensionFromOrigin: Double {
        vm.applyChairManoeuvreScale( defineTurnHandleDimensionFromOrigin(chair, vm, scaledTurnHandleSize))
    }
    var scale: Double {
        vm.model.manoeuvreScale
    }
    var handleEndLocationInGlobal: CGPoint{
        Determine.locationOnAftForeLineAtDimensionFromOriginInGlobal(chair, movement, turnHandleDimensionFromOrigin, scale )
    }
    var mostDistantSideFromConstraint: LeftOrRight {
        movement.xConstraintToChairOriginLocation >= 0.0 ? .left: .right}
    var body: some View {
    
        if atLeastOneMovementIsSelected {
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
        let dimension = (dimensionToChairExternalWidth * 0.5 + turnHandleSize)
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

                    let angleChange =
                    atan2(newLocationOnCircle.y * correctorForRightOrLeftSideConstraint, newLocationOnCircle.x * correctorForRightOrLeftSideConstraint) -
                    (Angle(radians:movement.chairAngle).normalized().radians ) -
                    angleConstraintToHandleEndLocation
                    
                    vm.modifyTurnChairAngle(angleChange, chair.id)
                    location = newLocation
                }
           }

        
            .onEnded(){ value in
                if chair.turningNotDragging {
                    vm.setTurningNotDragging(chairMovementParts, false)
                }

            }
    }
    var iconOnTurnHandle: String {
        "arrow.triangle.2.circlepath"

    }
    var body: some View {
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



