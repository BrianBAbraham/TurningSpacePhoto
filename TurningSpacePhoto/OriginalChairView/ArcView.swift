//
//  ArcView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 30/09/2022.
//

import SwiftUI

struct TurningArcs: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @State private var startAndEndAngleCrossed = false
//    @State private var endAngleSubsequentlySmaller = false
    let chairMovements: [Type.ChairMovementParts]
    init (_ chairMovementsArgument: [Type.ChairMovementParts]){
        chairMovements = chairMovementsArgument
    }
    var scale: Double {
        vm.model.manoeuvreScale
    }
    let firstChairMovementIndex = 0
    let firstMovementIndex = 0
    var firstMovement: ChairManoeuvre.Movement {
        chairMovements[firstMovementIndex].movement
    }
    var lastMovementIndex = 1
    var lastMovement: ChairManoeuvre.Movement {
        chairMovements[lastMovementIndex].movement
    }
    var centre: CGPoint { CGPoint(x: firstMovement.xConstraintLocation, y: firstMovement.yConstraintLocation) }
    var radius: Double {
        chairMovements[firstMovementIndex].movement.xConstraintToChairOriginLocation
    }
    var startAngleAccountingForFlip: Angle { chairAngleForArcAccountingForFlip(firstMovement.chairAngle)  }
    var endAngleAccountingForFlip: Angle {  chairAngleForArcAccountingForFlip(lastMovement.chairAngle) }
    var turnDirection: Bool {
        getTurnDirection()

        //ModifyCode in model
//        vm.model.chairManoeuvres[0].chair.clockwiseAngleChange
    }
    
    func getTurnDirection() -> Bool {
        let state = firstMovement.chairAngle < lastMovement.chairAngle ? false: true
        return state
    }
    
    var markNames: [String] { [
        //ModifyCode
        Determine.partNameFromRandomOrderPartAndLocations([[.right,.footPlate]],.front)[0],
        Determine.partNameFromRandomOrderPartAndLocations([[.left,.footPlate]],.front)[0],
        Determine.partNameFromRandomOrderPartAndLocations([[.rear,.left,.fixedWheel]],.rear)[0],
        Determine.partNameFromRandomOrderPartAndLocations([[.rear,.right,.fixedWheel]],.betweenFrontRear)[0],
        Determine.partNameFromRandomOrderPartAndLocations([[.rear,.left,.fixedWheel]],.betweenFrontRear)[0],
        Determine.partNameFromRandomOrderPartAndLocations([[.rear,.right,.fixedWheel]],.rear)[0]
        ]
    }
    var markDictionary: [String: [Double]] {
        chairMovements[firstMovementIndex].chair.marks
    }
    var locationOfMarkNameInLocal: [[Double]] {
        Determine.markLocationsInLocalFromDictionaryForMarkNames(markDictionary, markNames)
    }
    var markRadii: [Double] {
        getMarkRadii(markNames)
    }
    var markRadiiIndexed: [(Int,Double)] {
        Array(zip(markRadii.indices, markRadii))
    }
    var scaledConstraintToChairOriginBeforeTurn: CGPoint {
        CGPoint(x: firstMovement.xConstraintToChairOriginLocation * scale, y: firstMovement.yConstraintToChairOriginLocation * scale)
    }
    var markAngles: [Angle] {
        getMarkAngleToConstraint()
    }
    var bottomToTopFlip: Bool {
        chairMovements[firstMovementIndex].chair.bottomToTopFlip
    }
    var leftToRightFlip: Bool {
        chairMovements[firstMovementIndex].chair.leftToRightFlip
    }
    var noFlips: Bool {
        !bottomToTopFlip && !leftToRightFlip ? true: false
    }
    var bothFlips: Bool {
        bottomToTopFlip && leftToRightFlip ? true: false
    }
    var numberOfRevolutions: CGFloat {
        2.0 * CGFloat( Int( (firstMovement.chairAngle - lastMovement.chairAngle).magnitude / Constant.twoPi ) + 1)
    }
    func chairAngleForArcAccountingForFlip(_ initialAngle: Double) -> Angle {
        var angle = Angle(radians: 0)
        if noFlips {
//print("NO FLIPS")
            angle = Angle(radians: initialAngle)
        }
        if bothFlips {
//print("BOTH FLIPS")
            angle = Angle(radians: .pi + initialAngle)
        }
        if bottomToTopFlip && !bothFlips {
//print("ONLY BOTTOM TO TOP")
            angle = -Angle(radians: .pi - initialAngle  )
        }
        if leftToRightFlip && !bothFlips {
//print("ONLY LEFT TO RIGHT")
            angle = Angle(radians: initialAngle + .pi)
        }
        return angle
    }


    func getMarkAngleToConstraint() -> [Angle] {
        var  markAngles: [Angle] = []
        var angle = Angle(radians: 0.0)
        var xDimension: CGFloat
        var yDimension: CGFloat
        let transformToCorrectSignum = ((bottomToTopFlip || leftToRightFlip)) ? -1.0 : 1.0
        for location in locationOfMarkNameInLocal {
//            if firstMovement.fixedConstraintLocation  {
                yDimension = (CGFloat(location[1] * scale) * transformToCorrectSignum + scaledConstraintToChairOriginBeforeTurn.y)
                xDimension = (CGFloat(location[0] * scale) + scaledConstraintToChairOriginBeforeTurn.x * transformToCorrectSignum)
                angle =
                Angle(radians:
                atan2(
                    yDimension ,
                    xDimension))
//            } else {
//                yDimension = (CGFloat(location[1] * scale) * transformToCorrectSignum + scaledConstraintToChairOriginBeforeTurn.y)
//                xDimension = (CGFloat(location[0] * scale) + scaledConstraintToChairOriginBeforeTurn.x * transformToCorrectSignum)
//                    angle =
//                    Angle(radians:
//                     atan2(
//                        yDimension ,
//                        xDimension) )
//            }

            markAngles.append(angle)

        }
//print("markAngles \(markAngles)")
        return markAngles
    }
    
    func getMarkRadii(_ markNames: [String]) -> [Double]{
        var markRadii: [Double] = []
        var radius = 0.0
        var  location = [[0.0,0.0]]
        let markNamesAccountingForSideSwap = Determine.markNamesAccountingForBothFlips(chairMovements[firstMovementIndex].chair, markNames)
        
        for markNameAccountingForSideSwap in markNamesAccountingForSideSwap {
            location = Determine.markLocationsInLocalFromDictionaryForMarkNames(markDictionary, [markNameAccountingForSideSwap])
            radius = Determine.radiusFromConstraintToMarkAccountingForScale(scaledConstraintToChairOriginBeforeTurn, location[0][0] * scale, location[0][1] * scale) /// scale
            markRadii.append(radius)
        }
        
//        var markNameAccountingForSideSwap = ""
//        for markName in markNames {
//            if bottomToTopFlip || leftToRightFlip && !bothFlips {
//                if markName.contains("Left") {
//                    markNameAccountingForSideSwap = markName.replacingOccurrences(of: "Left", with: "Right")
//                }
//                if markName.contains("Right") {
//                    markNameAccountingForSideSwap = markName.replacingOccurrences(of: "Right", with: "Left")
//                }
//            } else {
//                markNameAccountingForSideSwap = markName
//            }
//            //ModifyCode
//            location = Determine.markLocationsInLocalFromDictionaryForMarkNames(markDictionary, [markNameAccountingForSideSwap])
//            radius = Determine.radiusFromConstraintToMarkAccountingForScale(scaledConstraintToChairOriginBeforeTurn, location[0][0] * scale, location[0][1] * scale) /// scale
//            markRadii.append(radius)
//        }
    return markRadii
    }
    
    var  body: some View {
        ForEach(markRadiiIndexed, id: \.1) { index, element in
            ArcPath(arcCentre: centre, radius: markRadii[index], startAngle: startAngleAccountingForFlip + markAngles[index], endAngle: endAngleAccountingForFlip + markAngles[index], clockwise: turnDirection)
                .stroke(Color.red, lineWidth: numberOfRevolutions * scale * 2.5)
               
        }
    }
}


//struct ArcView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArcView()
//    }
//}
