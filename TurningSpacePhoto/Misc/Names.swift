//
//  Names.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import Foundation
enum ToupleIndexFor: Int, CaseIterable {
    case chair = 0
    case movements = 1
    case parts = 2
}

enum StartOrEnd: CaseIterable {
    case start, end
}

enum LeftOrRight {
    case left, right
}

enum MovementNames: String, CaseIterable, Identifiable {
    case slowQuarterTurn = "slow 1/4 turn"
    case mediumQuarterTurn = "medium 1/4 turn"
    case tightestQuarterTurn = "tightest 1/4 turn"
    case position = "one chair"
//    case straight = "straight"
    var id: Self { self }
//    case turn = "turn"
}

//enum ManoeureNames: [String] {
//
//    case oval = ["Oval", "position", "straight", "turn", "straight ", "turn", "straight", "turn", "straight"]
//    case slalom = "Slalom"
//    case simpleStraight = "Simple Straight"
//    case simpleTurn = "Simmple Turn"
//    case teeTurn = "T-Turn"
//}

enum PartElementNames: String, CaseIterable {
    case xLocal = "xLocal"
    case yLocal = "yLocal"
    case width = "Width"
    case length = "Length"
}

enum ChairMeasurements: String {
    case chairLength = "chairLength"
    case chairWidth = "chairWidth"
    case footPlateWidth = "footPlateWidth"
    case seatDepth = "seetDepth"
    case wheelLength = "wheelLength"
}

enum ChairPartsAndLocationNames: String, CaseIterable {
    case left = "Left"
    case betweenLeftRight = "Centre"
    case right = "Right"
    case front = "Front"
    case betweenFrontRear = "Middle"
    case rear = "Rear"
    case arm = "ArmRestPart"
    case casterFork = "CasterForkPart"
    case casterWheel = "CasterWheelPart"
    case fixedWheel = "FixedWheelPart"
    case footPlate =  "FootPlatePart"
    case footPlateHanger = "FootPlateHangerPart"
    case headRest = "HeadRestPart"
    case joyStick = "JoyStickPart"
    case propeller = "PropellerPart"
    case seat = "SeatPart"
    case steeringWheel = "SteeringWheelPart"
    case wheel = "WheelPart"
    case mark = "Mark"
}

enum FrontBothSidesNames: String, CaseIterable {
    case frontLeft = "FrontLeft"
    case frontRight = "FrontRight"
}

enum RearBothSidesNames: String, CaseIterable {
    case rearLeft = "RearLeft"
    case rearRight = "RearRight"
}

enum FlipAxes {
    case bottomToTop
    case leftToRight
}
//struct LocationNames {
//    let names = ChairPartsAndLocationNames(String)
//    let required = [names.left, names.betweenLeftRight, names.right, names.front, names.betweenFrontRear, names.rear]
//
//    static let are = ChairPartsAndLocationNames.allCases[0...5].map{$0}
//}

enum MovementIs: String {
    case anyWhere = "AnyWhere"
    case fixedConstraint = "FixedConstraint"
    case lineConstraint = "LineConstraint"
}

enum DriveIsBy : String {
    case joystick = "Joystick"
    case fingerDrag = "FingerDrag"
    case wheels  = "Wheels"
}

struct ArrayOfPartElement {
static let names: [String] = PartElementNames.allCases.map {$0.rawValue}
    
}


enum FillOrStroke {
    case fill
    case fillAndStroke
    case stroke
}

enum Flips {
    case noFlips
    case bottomToTopFlip
    case bothFlips
    case leftToRightFlip

}

enum Menu: String, CaseIterable {
    case chair = "arrow.triangle.2.circlepath"//"figure.roll"
    case photo = "photo"
    case options = "options"
}

struct ArrayOfMenu {
static let names: [String] = Menu.allCases.map {$0.rawValue}
}
    

enum HorizontalOrVertical {
    case horizontal
    case vertical
}
