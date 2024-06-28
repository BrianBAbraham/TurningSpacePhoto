//
//  PartNames.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation
enum Part: String, Parts, Hashable {
    typealias AssociatedType = String
    
    var stringValue: String {
        return self.rawValue
    }
    
    case assistantFootLever = "assistantFootLever"
    
    //case armSupport = "arm"
    case armVerticalJoint = "armVerticalJoint"
    
    case backSupport = "backSupport"
    case backSupportAdditionalPart = "backSupportAdditionalPart"
    case backSupportAssistantHandle = "backSupportRearHandle"
    case backSupportAssistantHandleInOnePiece = "backSupportRearHandleInOnePiece"
    case backSupportAssistantJoystick = "backSupportJoyStick"
    case backSupportTiltJoint = "backSupportRotationJoint"
    case backSupportHeadSupport = "headrest"
    case backSupportHeadSupportJoint = "backSupportHeadSupportHorizontalJoint"
    case backSupportHeadSupportLink = "backSupportHeadSupportLink"
    case backSupportHeadLinkRotationJoint = "backSupportHeadSupportLinkHorizontalJoint"
   
      
//    case baseToCarryBarConnector = "baseToCarryBarConnector"
//
//
//    case overheadSupportMastBase = "overHeadSupporMastBase"
//    case overheadSupportMast = "overHeadSupporMast"
//    case overheadSupportAssistantHandle = "overHeadSupporHandle"
//    case overheadSupportAssistantHandleInOnePiece = "overHeadSupporHandleInOnePiece"
//    case overheadSupportLink = "overHeadSupportLink"
//    case overheadSupport = "overHeadSupport"
//    case overheadSupportHook = "overHeadHookSupport"
//    case overheadSupportJoint = "overHeadSupportVerticalJoint"
//
//    case carriedObjectAtRear = "objectCarriedAtRear"

   
    case casterVerticalJointAtRear = "casterVerticalBaseJointAtRear"
    case casterVerticalJointAtMid = "casterVerticalBaseJointAtMid"
    case casterVerticalJointAtFront = "casterVerticalBaseJointAtFront"
    
    case fixedWheelHorizontalJointAtRear = "fixedWheelHorizontalBaseJointAtRear"
    case fixedWheelHorizontalJointAtMid = "fixedWheelHorizontalBaseJointAtMid"
    case fixedWheelHorizontalJointAtFront = "fixedWheelHorizontalBaseJointAtFront"
    
    case casterForkAtRear = "casterForkAtRear"
    case casterForkAtMid = "casterForkAtMid"
    case casterForkAtFront = "casterForkAtFront"
    
    case casterWheelAtRear = "casterWheelAtRear"
    case casterWheelAtMid = "casterWheelAtMid"
    case casterWheelAtFront = "casterWheelAtFront"

    //case fixedWheel = "fixedWheel"
    //case fixedWheelPropeller = "fixedWheelPropeller"
    
  
    case fixedWheelAtRear = "fixedWheelAtRear"
    case fixedWheelAtMid = "fixedWheelAtMid"
    case fixedWheelAtFront = "fixedWheelAtFront"
    case fixedWheelAtRearWithPropeller = "propeller"
    case fixedWheelAtMidWithPropeller = "fixedWheelAtMidithPropeller"
    case fixedWheelAtFrontWithPropeller = "fixedWheelAtFrontithPropeller"
    
    case footSupport = "footSupport"
    case footOnly = "footOnly"
    case footSupportInOnePiece = "footSupportInOnePiece"
    case footSupportJoint = "footSupportHorizontalJoint"
    case footSupportHangerLink = "footSupportHangerLink"
    case footSupportHangerJoint = "footSupportHangerSitOnVerticalJoint"
  
    case joint = "Joint"
    
    case joyStickForOccupant = "occupantControlledJoystick"

    case objectOrigin = "object"

    case notFound = "notAnyPart"
    
    
    case mainSupport = "sitOn"
    //case sleepOnSupport = "sleepOn"
    
    
    case standOnSupport = "standOn"
    
    case armSupport = "armSupport"
    
    case stabiliser = "wheelStabiliser"
    
    case sideSupport = "sideSupport"
    case sideSupportRotationJoint = "sideSupportRotatationJoint"
    case sideSupportJoystick = "sideSupportJoystick"

//    case stabilizerAtRear = "stabilityAtRear"
//    case stabilizerAtMid = "stabilityAtMid"
//    case stabilizerAtFront = "stabilityAtFront"
    
    case sitOnTiltJoint = "tilt-in-space"
    
    case steeredVerticalJointAtFront = "steeredVerticalBaseJointAtFront"
    case steeredVerticalJointAtRear = "steeredVerticalBaseJointAtRear"
    case steeredWheelAtFront = "steeredWheelAtFront"
    case steeredWheelAtRear = "steeredWheelAtRear"
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    
    
    func transformPartToPartGroup() -> PartGroup {
        switch self {
        case
            .backSupportHeadSupportJoint,
            .backSupportHeadSupportLink:
                return .backJointAndLink
        case
            .casterForkAtFront,
            .casterForkAtMid,
            .casterForkAtRear:
                return .casterFork
        case
            .casterVerticalJointAtFront,
            .casterVerticalJointAtMid,
            .casterVerticalJointAtRear:
                return .casterJoint
        case
            .casterWheelAtFront,
            .casterWheelAtMid,
            .casterWheelAtRear:
                return .caster
        case
            
            .fixedWheelAtFront,
            .fixedWheelAtMid,
            .fixedWheelAtRear:
                return .fixedWheel
        case .fixedWheelHorizontalJointAtFront,.fixedWheelHorizontalJointAtMid,.fixedWheelHorizontalJointAtRear:
                return .fixedWheelJoint
            
        case
            .footSupportHangerJoint,
            .footSupportHangerLink,
            .footSupportJoint:
                return .footJointAndLink
//        case .fixedWheelAtFrontWithPropeller,
//            .fixedWheelAtMidWithPropeller,
//            .fixedWheelAtRearWithPropeller:
//            return .propeller
            
        case     .stabiliser:
            return .stabiliser
        case
            .steeredVerticalJointAtFront,
            .steeredVerticalJointAtRear:
                return .steeredJoint
        case
            .steeredWheelAtFront,
            .steeredWheelAtRear:
                return .steeredWheel
            
        case
            .sitOnTiltJoint,
            .backSupportTiltJoint:
                return .tilt
        default:
            return .none
        }
    }
}


/// Object creation requires greater part specification than
/// edit so to minimise name multiple Part of the same group
/// this enum provides the basis for a transform
enum PartGroup: String, Parts {
    case backJointAndLink
    case caster
    case casterFork
    case casterJoint
    case fixedWheel
    case fixedWheelJoint
    case footJointAndLink
    case propeller
    case steeredJoint
    case steeredWheel
    case stabiliser
    case tilt
    
    case none
    
    var stringValue: String {
          return String(describing: self)
      }
}




enum PartTag: String, Parts {
    
    case angle = "angle"
    case arcPoint = "arcPoint"
    case canvas = "canvas"
    case corner = "corner"
    case id0 = "_id0"
    case id1 = "_id1"
    case stringLink = "_"
    case width = "width"
    case length = "length"
    case height = "height"
    case dimension = "dimension"
    case origin = "origin"
    case staticPoint = "staticPoint"
    case xOrigin = "x-move"
    case yOrigin = "y-move"
    case zOrigin = "zOrigin"
    
    var stringValue: String {
        return self.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}


///Alllow part removal or inclusion
///replaces chainLabels
struct PartSwapLabel {
    
    let part: Part
    static let dictionary: [Part: Part] = [
        .backSupportHeadSupport: .backSupport,
        .fixedWheelAtRearWithPropeller: .fixedWheelAtRear,
        .fixedWheelAtFrontWithPropeller: .fixedWheelAtFront,
    ]
        
    let swappedPair: [Part]
    let pair: [Part]
    
    init (_ part: Part) {
        self.part = part
        pair = Self.getPair(part)
        swappedPair =  [pair[1], pair[0]]
    }

    
  static func getPair(_ part: Part) -> [Part]{
        guard let key = PartSwapLabel.dictionary[part] else {
            fatalError()
        }
        
        return [part, key]
    }
}
