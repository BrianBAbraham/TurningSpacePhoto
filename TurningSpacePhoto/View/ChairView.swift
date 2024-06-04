//
//  Chair.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import SwiftUI
import Foundation

struct RectangleView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM

    let chair: ChairManoeuvre.Chair
    let manoeuvre: ChairManoeuvre.Movement
    let part: ChairManoeuvre.Part
    var scale: Double {
        vm.model.manoeuvreScale
    }
    
    var body: some View {
        localRectangle(manoeuvre, part)
    }
    
    func localRectangle(_ manoeuvre: ChairManoeuvre.Movement, _ part: ChairManoeuvre.Part) -> some View {
        ZStack{
            LocalFilledRectangle.path(part.xLocal * scale
                                ,part.yLocal * scale ,part.width * scale ,part.length * scale, partColor(), partOpacity())
            LocalOutlineRectangle.path(part.xLocal * scale
                                ,part.yLocal * scale,part.width * scale ,part.length * scale , partColor(), partOpacity())
        }
    }
    
    func partColor() -> Color {
        manoeuvre.isSelected ? Color("Blue"): Color("Orange")
    }
    
    func partOpacity() -> Double {
        part.isSelected ? 1.0: 1.0
    }
}

//struct MarkView: View {
//    @EnvironmentObject var vm: ChairManoeuvreProjectVM
//    let location: CGPoint
//    var markSize: Double { vm.applyChairManoeuvreScale(50.0) }
//    var body: some View {
//        Circle()
//            .fill(.blue)
//            .frame(width: markSize)
//            .position(location)
//            .opacity(0.3)
//    }
//}

struct MarkView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    let chairMovement: Type.ChairMovementParts
    var chair: ChairManoeuvre.Chair{chairMovement.chair}
    var movement: ChairManoeuvre.Movement{chairMovement.movement}
    var markSize: Double { vm.applyChairManoeuvreScale(50.0) }

    
    func getMarkLocationMostDistantFromConstraintInGlobal() -> CGPoint {
        var constraintLocationInGlobal: CGPoint {
            Determine.constraintLocationInGlobal(movement)
        }
        var chairOriginInGlobal: CGPoint {Determine.chairOriginInGlobal(movement)}
        var leftMarkName: String {
            Determine.partNameFromRandomOrderPartAndLocations([[.rear,.left,.fixedWheel]],.betweenFrontRear)[0]
        }
        var leftMarkLocationInGlobal: CGPoint {
            Manipulate.addCGPoints(vm.getMarkLocationInRootLocal(chair,leftMarkName), chairOriginInGlobal)
        }
        var rightMarkName: String {
            Determine.partNameFromRandomOrderPartAndLocations([[.rear,.right,.fixedWheel]],.betweenFrontRear)[0]
        }
        var rightMarkLocationInGlobal: CGPoint {
            Manipulate.addCGPoints(vm.getMarkLocationInRootLocal(chair,rightMarkName), chairOriginInGlobal)
        }
        var leftOrRight: LeftOrRight{
            movement.xConstraintToChairOriginLocation >= 0.0 ? .left: .right}
        var markLocationMostDistantFromConstraintInGlobal: CGPoint {
            switch leftOrRight {
            case .left:
                return leftMarkLocationInGlobal
            case .right:
                return rightMarkLocationInGlobal
            }
        }
        return markLocationMostDistantFromConstraintInGlobal
    }
    
    var body: some View {
        Circle()
            .fill(.blue)
            .frame(width: markSize)
            .position(getMarkLocationMostDistantFromConstraintInGlobal())
            .opacity(0.3)
    }
}

struct ChairView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    let chairMovement: Type.ChairMovementParts
    var chair: ChairManoeuvre.Chair{chairMovement.chair}
    var movement: ChairManoeuvre.Movement{chairMovement.movement}
    var parts: [ChairManoeuvre.Part] {chairMovement.parts}
//    var constraintLocationInGlobal: CGPoint {
//        Determine.constraintLocationInGlobal(movement)
//    }

    var  body: some View {
        ZStack {
            ForEach(parts) { part in
                RectangleView( chair: chair, manoeuvre: movement, part: part)
                }


//                .position(constraintLocationInGlobal)

            }
    }
}

struct ForRotationView: ViewModifier {
    let movement: ChairManoeuvre.Movement
    func body(content: Content) -> some View {
        content
            .transformEffect(rotateViewAroundConstraint(movement))
    }
    
    func rotateViewAroundConstraint(_ movement: ChairManoeuvre.Movement ) -> CGAffineTransform {
        var transform = CGAffineTransform(translationX: 0,  y: 0 )
        let x = movement.xConstraintLocation
        let y = movement.yConstraintLocation
        let angle = movement.chairAngle
        transform = CGAffineTransform(translationX: -x,  y: -y )
            .concatenating(CGAffineTransform(rotationAngle: CGFloat(angle)))
            .concatenating(CGAffineTransform(translationX: x , y:  y ))
        return transform
    }
}

struct ChairMovementView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @EnvironmentObject var menuChairVM: MenuChairViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel
    let chairMovement: Type.ChairMovementParts
    
    init (chairMovementArgument: Type.ChairMovementParts){
        chairMovement = chairMovementArgument
    }
    var chair: ChairManoeuvre.Chair{chairMovement.chair}
    var movement: ChairManoeuvre.Movement{chairMovement.movement}
    var parts: [ChairManoeuvre.Part] {chairMovement.parts}
    var mostDistantSideFromConstraint: LeftOrRight {
        movement.xConstraintToChairOriginLocation >= 0.0 ? .left: .right}
    var scale: Double {
        let scale =
        vm.model.manoeuvreScale
       // print("scale in view \(scale)")
        return scale
    }
    var scaledToolSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool)
    }
    var chairOriginInGlobal: CGPoint {Determine.chairOriginAccountingForScaleInGlobal(movement, scale)}
    
    var chairDragToolIcon: String {
        vm.getMovementFixedConstraintLocationStates(chairMovement).contains(true) ? "arrow.left.and.right":"arrow.up.and.down.and.arrow.left.and.right"
    }
    var flipHandleSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool) * 3    }
    var noFixedConstraintLocationOrFirstMovement: Bool {
        if vm.getMovementIndexWithOutChairIndex(chairMovement) == nil {
            return false
        } else {
        return
        (vm.getMovementIndexWithOutChairIndex(chairMovement)! == 0) || (!vm.getMovementFixedConstraintLocationStates(chairMovement).contains(true)) ? true: false
        }
    }
    var chairDragToolOffset: Double {
        vm.applyChairManoeuvreScale( vm.getSelectedMeasurement(.seatDepth)) * 1.35
    }
    var chairDragToolView: some View {
        ZStack{
            MyBackgroundlessCircle( flipHandleSize, chairOriginInGlobal)
            Image(systemName: chairDragToolIcon)
                .foregroundColor(.red)
                .font(.system(size: SizeOf.fontProportionOfTool * scaledToolSize * 1.5))
                .opacity(chair.turningNotDragging ? SizeOf.unSelectedOpacity: SizeOf.selectedOpacity)
                .position(chairOriginInGlobal)
        }

        .offset(y:chairDragToolOffset)

    }
    
    var body: some View {
            ZStack {
                ZStack {
//                    LineFromMarkToTurnHandleConditionalView( markLocationMostDistantFromConstraintInGlobal, handleEndLocationInGlobal, movement)
                    
//                    MarkView(chairMovement: chairMovement)
                        LineFromConstraintToWheelMarkView(chairMovement)
                    
                        GeometryReader { geo in
                            ChairView(chairMovement: chairMovement)
                                .position(chairOriginInGlobal)
                                .offset(x: geo.size.width / 2 , y: geo.size.height / 2)

                            if noFixedConstraintLocationOrFirstMovement {chairDragToolView}
                        }
                    }
                .gesture(
                    TapGesture(count: 2).onEnded {
                        print("DOUBLE TAP")
                    }.exclusively(before: TapGesture(count: 1).onEnded {
                    vm.toggleSelectionOfOneMovementOfManoeuvre(chairMovement)
                        if vm.getIsAnyChairSelected() {
//                            menuChairVM.setShowMenuStatus(true)
                            navigationVM.setShowMenu(false)
                        }
                        
                    })
                )
                    .modifier(ForRotationView(movement: movement))
            }
        }
    
    
    
}

//struct ChairDragTool: View {
//    var body: some View {
//        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
//            .font(.system(size: SizeOf.fontProportionOfTool * scaledToolSize))
//            .position(chairOriginInGlobal)
//    }
//}

struct ChairMovementsView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var fingerLocation: CGPoint? = nil
    @State var showingPopover = false
    var forEachMovementOfOneChairArrayChairMovementPart: [Type.ChairMovementParts]
    let firstIndex = 0
    var firstMovement: ChairManoeuvre.Movement {
        forEachMovementOfOneChairArrayChairMovementPart[firstIndex].movement
    }
    var chair: ChairManoeuvre.Chair {forEachMovementOfOneChairArrayChairMovementPart[firstIndex].chair}
    var location: CGPoint {
        Determine.chairOriginInGlobal(firstMovement)
    }
    @State private var xChange = 0.0
    @State private var yChange = 0.0
    var angle: Double {
        firstMovement.chairAngle
    }
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    var chairDrag: some Gesture {
            DragGesture()
                .onChanged{ value in
    //                turningNotDragging ? print("TAP CHAIR TO SELECT"): print(" can drag")
                    var newLocation = startLocation ?? location
                    let xTranslation = value.translation.width
                    let yTranslation = value.translation.height
                    newLocation.y += yTranslation
                    newLocation.x += xTranslation
                    xChange = xTranslation - xChange
                    yChange = yTranslation - yChange
                    vm.modifyMovementLocationByChairDrag(forEachMovementOfOneChairArrayChairMovementPart, newLocation, CGPoint(x: xChange, y: yChange))
                    xChange = xTranslation
                    yChange = yTranslation
                }
                .updating($startLocation) { (value, startLocation, transaction) in
                    startLocation = startLocation ?? Determine.chairOriginInGlobal(firstMovement)
                }
                .onEnded(){ value  in
                    self.xChange = 0.0
                    self.yChange = 0.0
                }
    }
    @State var all: GestureMask = .all
    @State var subviews: GestureMask = .subviews
    var  turningNotDragging: Bool {
        chair.turningNotDragging
    }
//    var scale: Double {vm.model.manoeuvreScale}
//    var chairOriginInGlobal: CGPoint {Determine.chairOriginAccountingForScaleInGlobal(firstMovement, scale)}
    var body: some View {
        let indexOfFirstMovement = 0
        ZStack{
//            GeometryReader { geo in
//                Color(.red)


                ForEach(forEachMovementOfOneChairArrayChairMovementPart, id: \.movement.id ) { item in
                    ChairMovementView(chairMovementArgument: item)
                    
                }
//                .border(.red)
//                .border(width: geo.size.width, height: geo.size.height)
//                .foregroundColor(.red)
//            }


                    .gesture(
                        chairDrag.simultaneously(with: fingerDrag), including: turningNotDragging ? subviews: all
        //                chairDrag.simultaneously(with: fingerDrag)

            )
            
            
            if forEachMovementOfOneChairArrayChairMovementPart.count > 1 {
            TurningArcs(forEachMovementOfOneChairArrayChairMovementPart)
            }

            TapToFlipConditionalView(chairMovement: forEachMovementOfOneChairArrayChairMovementPart[0])
            
            ConstraintView(chairMovement: forEachMovementOfOneChairArrayChairMovementPart[indexOfFirstMovement])
                .opacity(0.9)

//                .position(chairOriginInGlobal)
//                .border(.red)

        }
    }
}

extension Angle {
  /// Returns an Angle in the range `0° ..< 360°`
  func normalized() -> Angle {
    var degrees = self.degrees.truncatingRemainder(dividingBy: 360)
    if degrees < 0 {
      degrees = degrees + 360
    }
    return Angle(degrees: degrees)
  }
}

