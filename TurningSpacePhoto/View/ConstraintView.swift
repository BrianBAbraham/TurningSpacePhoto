//
//  ConstraintView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//


import SwiftUI

struct ConstraintView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel
    let chairMovement: Type.ChairMovementParts
    var movement: ChairManoeuvre.Movement{chairMovement.movement}
    var constraintLlocation: CGPoint {Determine.constraintLocationInGlobal(movement)}
    var flipHandleSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool)
    }
    var body: some View {
        if visibleToolViewModel.getShowTool()  {
            ConstraintMark(chairMovement: chairMovement, location: constraintLlocation)
        }
    }
}




struct LineFromConstraintToWheelMarkView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    let chairMovement: Type.ChairMovementParts
    let chair: ChairManoeuvre.Chair
    let movement: ChairManoeuvre.Movement
    init (_ chairMovementArgument: Type.ChairMovementParts){
        chairMovement = chairMovementArgument
        chair = chairMovement.chair
        movement = chairMovement.movement
    }
    
    var constraintLocation: CGPoint {
        CGPoint (x:movement.xConstraintLocation, y: movement.yConstraintLocation)
    }
    var dimensionToChairExternalWidth: Double {
        (chair.measurements[ChairMeasurements.chairWidth.rawValue] ?? DefaultMeasurements.wheelchair(.chairWidth) ) * 0.5 * scale
    }
    var scale: Double {
        vm.model.manoeuvreScale
    }

    
    var fixedWheelCentreMostDistantFromConstraint: CGPoint { 
        Determine.locationOnConstraintLineAtDimensionFromOriginInGlobal(chair, movement, dimensionToChairExternalWidth, scale)
    }
    var  body: some View {
        StrokedLine(constraintLocation, fixedWheelCentreMostDistantFromConstraint, .green, 1.0)
    }
}

struct ConstraintMark: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    let chairMovement: Type.ChairMovementParts
    let location: CGPoint
    var constraintLockState: Bool {
        chairMovement.movement.fixedConstraintLocation
    }
    var scaledToolSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool)
    }
    
    var body: some View {
        ZStack{
            MyCircle(fillColor: .white, strokeColor: .black, scaledToolSize, location)
 
            constraintLockStateView()
                .position(location)
                .font(.system(size: SizeOf.fontProportionOfTool * scaledToolSize))
                .foregroundColor(.black)

        }
//        .opacity(vm.getMovementFixedConstraintLocationStates(chairMovement).contains(true) ? SizeOf.selectedOpacity: SizeOf.unSelectedOpacity)
        .gesture (
            TapGesture()
            .onEnded {
                vm.toggleFixedConstraintLocation(chairMovement)
            }
        )

    }
    
    func constraintLockStateView() -> some View{
        constraintLockState ? Image(systemName: "lock"): Image(systemName: "lock.open")
    }
}
