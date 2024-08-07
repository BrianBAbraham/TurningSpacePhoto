//
//  PartDisplayName.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation

enum MenuDisplayPart: String {
    case armrest = "armrest"
    case backrest = "backrest"
    case base = "base"
    case casterForkAtFront = "front fork"
    case casterForkAtMid = "mid fork"
    case casterForkAtRear = "rear fork"
    case footRest = "footrest"
    case footLever = "foot tipper"
    case headrest = "headrest"
    case propeller = "propeller"
    case sides = "sides"
    case seat = "seat"
    case stabiliser = "remove"
    case tilt = "tilt"
    case top = "top"


    case wheelAtMid = "mid wheel"
    case wheelAtRear = "rear wheel"
    case wheelAtFront = "front wheel"
    
}


struct PartToDisplayInMenu {
var names: [String] = []
var name: String = ""
   static let dictionary: [Part: MenuDisplayPart] = [
        .assistantFootLever: .footLever,
        .armSupport: .armrest,
        .backSupport: .backrest,
        .backSupportHeadSupport: .headrest,
        .backSupportTiltJoint: .tilt,
        .casterForkAtFront: .casterForkAtFront,
        .casterForkAtMid: .casterForkAtMid,
        .casterForkAtRear: .casterForkAtRear,
        .casterWheelAtFront: .wheelAtFront,
        .casterWheelAtMid: .wheelAtMid,
        .casterWheelAtRear: .wheelAtRear,

        .fixedWheelAtFront: .wheelAtFront,
        .fixedWheelAtMid: .wheelAtMid,
        .fixedWheelAtRear: .wheelAtRear,
        .footSupport: .footRest,
        .fixedWheelAtFrontWithPropeller: .propeller,
        .fixedWheelAtMidWithPropeller: .propeller,
        .fixedWheelAtRearWithPropeller: .propeller,
        .mainSupport: .seat,
        .sitOnTiltJoint: .tilt,
        .stabiliser: .stabiliser,
        .steeredWheelAtFront: .wheelAtFront
        ]
   static let partObjectToMenuNameDictionary: [PartObject: MenuDisplayPart] = [
    PartObject(.sideSupport, .allCasterBed): .sides,
    PartObject(.sideSupport, .allCasterStretcher): .sides,
    PartObject(.mainSupport, .allCasterBed): .top,
    PartObject(.mainSupport, .allCasterStretcher): .top,
    PartObject(.mainSupport, .showerTray): .base,
//    PartObject(.stabiliser, .fixedWheelRearDrive): .stabiliser,
    ]
    
    init(_ parts: [Part], _ objectType: ObjectTypes) {
        var menuCase: MenuDisplayPart?
        
        for part in parts {
            menuCase =
                Self.partObjectToMenuNameDictionary[PartObject(part, objectType)] ?? Self.dictionary[part]
            
            guard let unwrapped = menuCase else {
                fatalError("no menu name for \(part)")
            }
            names += [unwrapped.rawValue]
        }
        
        name = names.count == 1 ? names[0]: ""
        
    }
}
