//
//  PartDimensions.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation

struct PartDefaultDimension {
    static let casterForkDimension = (width: 50.0, length: 100.0, height: 50.0)
    static let casterWheelDimension = (width: 20.0, length: 75.0, height: 75.0)
    static let fixedWheelDimension = (width: 20.0, length: 600.0, height: 600.0)
    static let poweredWheelDimension = (width: 50.0, length: 200.0, height: 200.0)
    static let steeredWheelDimension = (width: 50.0, length: 200.0, height: 200.0)
    static let joint = (width: 10.0, length: 10.0, height: 10.0)
    static let wheelStabiliser = (width: 100.0, length: 50.0, height: 10.0)

    var linkedOrParentDimension = ZeroValue.dimension3d
    var userEditedDimensionOneOrTwoOptional: OneOrTwoOptional<Dimension3d>?
    var userEditedDimensionOneOrTwo: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)
    var partDimension = ZeroValue.dimension3d
    var partDimensionOneOrTwo: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)
    let part: Part
    let objectType: ObjectTypes
    var parentPart: Part
    
    
    init (_ part: Part,
          _ objectType: ObjectTypes,
          _ linkedOrParentData: PartData = ZeroValue.partData,
          _ userEditedDimensionOneOrTwoOptional: OneOrTwoOptional<Dimension3d>? = nil) {
        self.part = part
        self.objectType = objectType
        self.parentPart = linkedOrParentData.part
        self.userEditedDimensionOneOrTwoOptional = userEditedDimensionOneOrTwoOptional

        linkedOrParentDimension = linkedOrParentData.dimension.mapOneOrTwoToOneOrLeftValue()
        
        guard let unwrapped = getDefault(part) else {
            fatalError("no dimension exists for part \(part)")
        }
        
        partDimension = unwrapped
       
        if let unwrapped = userEditedDimensionOneOrTwoOptional {
            userEditedDimensionOneOrTwo = getDimensionFromOptional()
            
            func getDimensionFromOptional() -> OneOrTwo<Dimension3d>{
                switch unwrapped {
                case .one (let one):
                    let returnOne = one == nil ? partDimension: one!
                    return .one(one: returnOne)
                case .two(let left, let right):
                    let returnLeft = left == nil ? partDimension: left!
                    let returnRight = right == nil ? partDimension: right!
                    return .two(left: returnLeft, right: returnRight)
                }
            }
        }

        func getDefault(_ childOrParent: Part)  -> Dimension3d? {
            getFineTuneDimensionDefault(childOrParent) ??
            getGeneralDimensionDefault(childOrParent)
        }
                     
        
        func getFineTuneDimensionDefault(_ childOrParent: Part) -> Dimension3d? {
            [
                PartObject(.backSupport, .allCasterTiltInSpaceArmChair): (width: linkedOrParentDimension.width, length: 100.0, height: 500.0),
                PartObject(.casterForkAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
                PartObject(.casterWheelAtFront, .fixedWheelMidDrive): (width: 20.0, length: 50.0, height: 50.0),
                PartObject(.fixedWheelAtRear, .fixedWheelManualRearDrive): (width: 20.0, length: 600.0, height: 600.0),
                PartObject(.footOnly, .showerTray): (width: 900.0, length: 1200.0, height: 10.0),
                PartObject(.armSupport, .allCasterTiltInSpaceArmChair): (width: 100.0, length: linkedOrParentDimension.length, height: 150.0),
                PartObject(.mainSupport, .allCasterBed): (width: 900.0, length: 2200.0, height: 150.0),
                PartObject(.mainSupport, .allCasterStretcher): (width: 600.0, length: 1400.0, height: 10.0),
                PartObject(.mainSupport, .showerTray): (width: 900.0, length: 1200.0, height: 10.0),
            ][PartObject(childOrParent, objectType)]
        }
    
    
        func  getGeneralDimensionDefault(_ childOrParent: Part) -> Dimension3d? {
            let z = ZeroValue.dimension3d
            let j = Self.joint
            return
                [
                .assistantFootLever: (width: 20.0, length: 150.0, height: 20.0),
                .armSupport: (width: 50.0, length: linkedOrParentDimension.length, height: 150.0),
                .backSupport: (width: linkedOrParentDimension.width, length: 10.0 , height: 500.0),
                .backSupportHeadSupport: (width: 150.0, length: 50.0, height: 100.0) ,
                .backSupportHeadSupportJoint: Self.joint,
                .backSupportHeadSupportLink: (width: 20.0, length: 20.0, height: 150.0),
                .backSupportTiltJoint: j,
                .casterForkAtFront: Self.casterForkDimension,
                .casterForkAtRear: Self.casterForkDimension,
                .casterWheelAtFront: Self.casterWheelDimension,
                .casterWheelAtMid: Self.casterWheelDimension,
                .casterWheelAtRear: Self.casterWheelDimension,
                .casterVerticalJointAtFront:j,
                .casterVerticalJointAtMid:j,
                .casterVerticalJointAtRear: j,
                .fixedWheelAtFront: Self.poweredWheelDimension,
                .fixedWheelAtMid: Self.poweredWheelDimension,
                .fixedWheelAtRear: Self.poweredWheelDimension,
                .fixedWheelHorizontalJointAtFront: j,
                .fixedWheelHorizontalJointAtMid: j,
                .fixedWheelHorizontalJointAtRear:j,
                .fixedWheelAtRearWithPropeller: (width: 10.0, length: linkedOrParentDimension.length * 0.9, height: linkedOrParentDimension.height * 0.9),
                .footSupport: (width: 150.0, length: 100.0, height: 20.0),
                .footSupportJoint: j,
                .footSupportInOnePiece: (width: 50.0, length: 200.0, height: 200.0),
                .footSupportHangerJoint: j,
                .footSupportHangerLink: (width:20.0, length: 300.0, height: 20.0),
               
                .objectOrigin: z,
                
                .mainSupport: (width: 400.0, length: 400.0, height: 10.0),
                .sideSupport: (width: 50.0, length: linkedOrParentDimension.length, height: 150.0),
                .sitOnTiltJoint: j,
                .stabiliser: Self.wheelStabiliser,
                .steeredWheelAtFront: Self.steeredWheelDimension,
                .steeredVerticalJointAtFront: j,
                ] [childOrParent]
        }
    }
}


struct DefaultMinMaxDimensionDictionary {
  static  let casterFork =
        (min: (width: 10.0, length: 10.0, height: 10.0),
         max: (width: 100.0, length: 200.0, height: 500.0))
    static let casterWheel =
    (min: (width: 10.0, length: 20.0, height: 20.0),
     max: (width: 100.0, length: 300.0, height: 300.0))
    static let fixedWheel =
    (min: (width: 10.0, length: 100.0, height: 100.0),
     max: (width: 100.0, length: 800.0, height: 800.0))
    static let propeller =
    (min: (width: 10.0, length: 10.0, height: 300.0),
     max: (width: 100.0, length: 800.0, height: 800.0))
    
    let dimensionDic: Part3DimensionDictionary = [:]
    
    let fineDimensionMinMaxDic: [PartObject: (min: Dimension3d, max: Dimension3d)] = [
        PartObject(.mainSupport, .showerTray):
            (min: (width: 600.0, length: 600.0, height: 10.0),
             max: (width: 2000.0, length: 3000.0, height: 10.0))
        ]
    let generalDimensionMinMaxDic: [Part: (min: Dimension3d, max: Dimension3d)] = [
        .assistantFootLever:
          (min: (width: 10.0, length: 10.0, height: 10.0),
           max: (width: 100.0, length: 500.0, height: 40.0)),
        .armSupport:
          (min: (width: 10.0, length: 10.0, height: 10.0),
           max: (width: 200.0, length: 1000.0, height: 40.0)),
        .backSupport:
          (min: (width: 10.0, length: 10.0, height: 10.0),
           max: (width: 1000.0, length: 100.0, height: 1400.0)),
       .backSupportHeadSupport:
         (min: (width: 10.0, length: 10.0, height: 10.0),
          max: (width: 1000.0, length: 400.0, height: 40.0)),
        .casterForkAtFront: casterFork,
        .casterForkAtRear: casterFork,
        .casterWheelAtRear: casterWheel,
        .casterWheelAtFront: casterWheel,
        .fixedWheelAtFront: fixedWheel,
        .fixedWheelAtMid: fixedWheel,
        .fixedWheelAtRear: fixedWheel,
        .fixedWheelAtRearWithPropeller: propeller,
        .footSupport:
            (min: (width: 10.0, length: 50.0, height: 10.0),
             max: (width: 50.0, length: 1000.0, height: 40.0)),
        .footSupportHangerLink:
            (min: (width: 10.0, length: 50.0, height: 10.0),
             max: (width: 50.0, length: 1000.0, height: 40.0)),
        .mainSupport:
          (min: (width: 200.0, length: 200.0, height: 10.0),
           max: (width: 1000.0, length: 2000.0, height: 40.0)),
          .sideSupport:
            (min: (width: 10.0, length: 10.0, height: 10.0),
             max: (width: 200.0, length: 1000.0, height: 40.0)),
        .steeredWheelAtFront: fixedWheel,
        ]
    
    static var shared = DefaultMinMaxDimensionDictionary()
    
    
    func getDefault(_ part: Part, _ objectType: ObjectTypes)  -> (min: Dimension3d, max: Dimension3d) {
        let minMaxDimension =
        getFineTuneMinMaxDimension(part, objectType) ??
        getGeneralMinMaxDimension(part)
        return minMaxDimension
    }
    
    
    func getFineTuneMinMaxDimension(_ part: Part, _ objectType: ObjectTypes) -> (min: Dimension3d, max: Dimension3d)? {
       fineDimensionMinMaxDic[PartObject(part, objectType)]
    }
    
    
    func getGeneralMinMaxDimension(_ part: Part) -> (min: Dimension3d, max: Dimension3d) {
      
        guard let minMax = generalDimensionMinMaxDic[part] else {
            fatalError("no minMax exists for \(part)")
        }
        
        return minMax
    }
}
