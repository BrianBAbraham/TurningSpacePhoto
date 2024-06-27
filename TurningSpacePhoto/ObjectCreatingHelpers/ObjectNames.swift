//
//  ObjectNames.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/02/2024.
//

import Foundation




enum ObjectTypes: String, CaseIterable, Hashable {
    
    case allCasterBed = "bed"
    case allCasterChair = "shower chair"
    case allCasterHoist = "mobile hoist"
    case allCasterTiltInSpaceArmChair = "armchair"
    case allCasterTiltInSpaceShowerChair = "shower-tilts"
    
    case allCasterStandAid = "Stand aid: caster base"
    case allCasterStretcher = "stretcher"
    
//    case bathIntegralHoist = "IntegralBathHoist"
//    case bathFloorFixedHoistOneRotationPoint = "SingleRotationPointBathHoist"
//    case bathFloorFixedHoistTwoRotationPoint = "DoubleRotationPointBathHoist"
    
    case fixedWheelRearDriveAssisted = "manual-assist"
    case fixedWheelFrontDrive = "power-front"
    case fixedWheelMidDrive  = "power-mid"
    case fixedWheelRearDrive = "power-rear"
    case fixedWheelManualRearDrive = "manual-rear"
    case fixedWheelSolo = "power-balance"
    case fixedWheelTransfer = "Fixed wheel transfer device"
    
//    case hingedDoorSingle = "Door"
//    case hingedDoorDouble = "Bi-FoldDoor"
//    case hingedDoortripple = "Tri-FoldDoor"
//
    case scooterFrontDrive4Wheeler = "scooter-4 front"
    case scooterFrontDrive3Wheeler =  "Scooter-3 (front)"
    case scooterRearDrive4Wheeler  = "scooter4-rear"
    case scooterRearDrive3Wheeler = "Scooter-3 (rear)"
    
    case seatThatTilts = "Tilting chair"
    
    case showerTray = "shower tray"
    
    case stairLiftStraight = "Straight stair-lift"
    case stairLiftInternalRadius = "Internal radius stair-lift"
    case stairLiftExternalRaidus = "External radius stair-lift"
    
    case verticalLift = "Vertical Lift"
}

enum ObjectGroup {
    case base
    case chair
    case hoist
    case lieOn
    case object
   
    case seat
}

struct ObjectTypesToGroups {
  static  let dictionary: [ObjectTypes: ObjectGroup] = [
        .allCasterBed: .lieOn,
        .allCasterChair: .chair,
        .allCasterHoist: .hoist,
        .allCasterStretcher: .lieOn,
        .allCasterTiltInSpaceArmChair: .chair,
        .allCasterTiltInSpaceShowerChair: .chair,
        .fixedWheelRearDrive: .chair,
        .fixedWheelRearDriveAssisted: .chair,
        .fixedWheelMidDrive: .chair,
        .fixedWheelFrontDrive: .chair,
        .fixedWheelManualRearDrive: .chair,
        .fixedWheelSolo: .chair,
        .fixedWheelTransfer: .seat,
        .scooterRearDrive3Wheeler: .chair,
        .scooterRearDrive4Wheeler: .chair,
        .scooterFrontDrive3Wheeler: .chair,
        .scooterFrontDrive4Wheeler: .chair,
        .showerTray: .base,
    ]
    let objectType: ObjectTypes
    var group: ObjectGroup {
        guard let group = Self.dictionary[objectType] else {
            fatalError("\(objectType)")
        }
        return group
    }
}














/// some edits have have multiple effects
//enum ObjectLinkedEdits {
//    case legLength //lengthens footSupportHangerLink dimension and footSupport origin
//    case sitOn // affects object frame origin
//    
//}
