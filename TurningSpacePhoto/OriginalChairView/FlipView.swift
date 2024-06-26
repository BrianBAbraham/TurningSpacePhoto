//
//  FlipView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import SwiftUI


struct TapToFlipConditionalView: View {

    @EnvironmentObject var vm: ChairManoeuvreProjectVM

    let chairMovement: Type.ChairMovementParts
    var movement: ChairManoeuvre.Movement{
        chairMovement.movement
        }
    
    
    
    
    var chair: ChairManoeuvre.Chair{
        chairMovement.chair
    }
    var scale: Double {
        vm.model.manoeuvreScale
    }
    var scaledChairOriginInGlobal: CGPoint {
        Determine.chairOriginAccountingForScaleInGlobal(movement, scale)
    }
    var constraintLocationInGlobal: CGPoint {
        Determine.constraintLocationInGlobal(movement)
    }
    var scaledHorizontalDimensionFromOrign: Double {
        (chair.measurements[ChairMeasurements.chairWidth.rawValue] ?? DefaultMeasurements.wheelchair(.chairWidth) ) * 0.5 * scale
    }
    var originAfterRotationInGlobal: CGPoint {
        Determine.locationAfterTurnAroundPointWithGlobals(movement.chairAngle,constraintLocationInGlobal, scaledChairOriginInGlobal )
    }

    var flipHandleSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool)
    }
    
    var body: some View {

   
        CircleFlipView(chairMovement: chairMovement, originAfterRotationInGlobal: originAfterRotationInGlobal)

   }
}

struct CircleFlipView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @State var bottomToTopFlip = false
    @State var leftToRightFlip = false
    let chairMovement: Type.ChairMovementParts
//    let firstMovementIndex = 0
    let originAfterRotationInGlobal: CGPoint
    var scale: Double {
        vm.model.manoeuvreScale
    }
    var flipHandleSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool)
    }
    
    var markLocations: [[Double]] {
        getMarkLocations ()
    }
    var bottomToTopFlipSignum: Double {
        bottomToTopFlip ? 1.0: -1.0
    }
    var constraintLocationInGlobal: CGPoint {
        Determine.constraintLocationInGlobal(chairMovement.movement)
    }
    
    func getMarkLocations () -> [[Double]] {
        let markNames = [
            //ModifyCode
            Determine.partNameFromRandomOrderPartAndLocations([[.left,.footPlate]],.front)[0],
            Determine.partNameFromRandomOrderPartAndLocations([[.right,.footPlate]],.front)[0]
            ]
//        let markNamesAccountingForSideSwap = Determine.markNamesAccountingForSideSwap(chairMovement.chair, markNames)
        
        let markLocations =
        Determine.markLocationsInLocalFromDictionaryForMarkNames(chairMovement.chair.marks, markNames)
        
        return markLocations
        
    }
    
    var bottomToTopFlipLocationInGlobal: CGPoint {
        CGPoint(x: constraintLocationInGlobal.x + markLocations[0][0] * scale, y:constraintLocationInGlobal.y - (markLocations[0][1] * scale + flipHandleSize/1.9) * bottomToTopFlipSignum)
    }
    var leftToRightFlipLocationInGlobal: CGPoint {
        CGPoint(x: constraintLocationInGlobal.x + markLocations[1][0] * scale, y:constraintLocationInGlobal.y - (markLocations[1][1] * scale + flipHandleSize/1.9) * bottomToTopFlipSignum)
    }
    var  body: some View {
        ZStack{
            MyCircle(fillColor: Color("Orange"), strokeColor: .black, flipHandleSize, bottomToTopFlipLocationInGlobal)

            Image(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down")
                .foregroundColor(.black)
                .font(.system(size: SizeOf.fontProportionOfTool * flipHandleSize))
                .position(bottomToTopFlipLocationInGlobal)
        }
        .opacity(bottomToTopFlip ? SizeOf.selectedOpacity: SizeOf.unSelectedOpacity)
        .onTapGesture {
            vm.flipManoeuvreBottomToTop(chairMovement)
            bottomToTopFlip.toggle()
        }
        ZStack{
            MyCircle(fillColor: Color("Orange"), strokeColor: .black, flipHandleSize, leftToRightFlipLocationInGlobal)

            Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                .foregroundColor(.black)
                .font(.system(size: SizeOf.fontProportionOfTool * flipHandleSize))
                .position(leftToRightFlipLocationInGlobal)
        }
        .opacity(leftToRightFlip ? SizeOf.selectedOpacity: SizeOf.unSelectedOpacity)
        .onTapGesture {
            vm.flipManoeuvreLeftToRight(chairMovement)
            leftToRightFlip.toggle()
        }
    }
}


