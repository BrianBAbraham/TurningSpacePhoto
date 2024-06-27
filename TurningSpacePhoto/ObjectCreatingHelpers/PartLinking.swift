//
//  PartLinking.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation

struct PartsRequiringLinkedPartUse {
    static let forDimensionEditDic: [Part: Part] =
    [// dimension edit for one part effected by different part
        .footSupport: .footSupportHangerLink,
     ]
    
    static let forOriginEditDic: [Part: Part] =
        [//origin edit for these parts required edits by a different part
        .casterWheelAtFront: .casterVerticalJointAtFront,//chain order reversed
        .casterWheelAtMid: .casterForkAtMid,//ditto
        .casterWheelAtRear: .casterVerticalJointAtRear,//ditto
        .footSupport: .footSupportHangerLink,
        ]
    
    static let forEditableOriginDic: [Part: Part] =
    [// show depends on user edits, edits act on chain label
    // chain label need to take account of linked part changes
        .casterWheelAtFront: .casterForkAtFront,//chain order reversed
        .casterWheelAtMid: .casterForkAtMid,//ditto
        .casterWheelAtRear: .casterForkAtRear,//ditto
        
        
        //the menu display is back support but the chainLink lable is as below
        .backSupport: .backSupportTiltJoint
    ]
    
    static let forEditableDimensionDic: [Part: Part] =
    [
        .footSupport: .footSupportHangerLink,
    ]

    
    static let forPartLinkDic: [Part: Part] = [
        .fixedWheelAtRearWithPropeller: .fixedWheelAtRear
    ]
    
   let partForDimensionEdit: Part
    
    let partForOriginEdit: Part
    
    let partForLink: Part?
    
    let partForEditableOrigin: Part
    
    let partForEditableDimension: Part
    
    init(_ part: Part) {
        partForDimensionEdit =
            Self.forDimensionEditDic[part] ?? part
        partForOriginEdit =
            Self.forOriginEditDic[part] ?? part
        partForLink =
            Self.forPartLinkDic[part]
        
        partForEditableOrigin =
            Self.forEditableOriginDic[part] ?? part
        
        partForEditableDimension =
            Self.forEditableDimensionDic[part] ?? part
        
//        print("\nORIGIN in \(part) out \(partForOriginEdit)")
//        print("DIMENSION in \(part) out \(partForDimensionEdit)")
//        print("EDITABLE ORIGIN in \(part) out \(partForEditableOrigin)")
//        print("EDITABLE DIMENSION in \(part) out \(partForEditableOrigin)\n")
    }
}



//determine if a part is linked to another part for origin or dimension
//struct LinkedParts {
//    let dictionary: [Part: Part] = [
//        .fixedWheelHorizontalJointAtRear: .mainSupport,
//        .fixedWheelHorizontalJointAtMid: .mainSupport,
//        .fixedWheelHorizontalJointAtFront: .mainSupport,
//        .casterVerticalJointAtRear: .mainSupport,
//        .casterVerticalJointAtMid: .mainSupport,
//        .casterVerticalJointAtFront: .mainSupport,
//        .steeredVerticalJointAtFront: .mainSupport
//        ]
//}
