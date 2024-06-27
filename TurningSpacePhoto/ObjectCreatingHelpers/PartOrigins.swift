//
//  PartOrigins.swift
//  CreateObject
//
//  Created by Brian Abraham on 07/02/2024.
//

import Foundation

struct PartEditedElseDefaultOrigin {
    let linkedOrParentDimension: OneOrTwo<Dimension3d>
    var linkedOrParentDimensionUsingOneValue: Dimension3d
    let part: Part
    let objectType: ObjectTypes
    let parentData: PartData
    var userEditedPartDimensionOneOrTwo: OneOrTwo<Dimension3d>
    var editedElseDefaultOriginOneOrTwo: OneOrTwo<PositionAsIosAxes> = .one(one: ZeroValue.iosLocation)
    var userEditedOptionalOriginOffset: OneOrTwoOptional<PositionAsIosAxes>

    init (_ part: Part,
          _ object: ObjectTypes,
          _ linkedOrParentData: PartData,
          _ userEditedDimensionOneOrTwo: OneOrTwo<Dimension3d>,
          _ partIdAllowingForUserEdit: OneOrTwo<PartTag>,
          _ userEditedOriginOffsetOneOrTwoOptional: OneOrTwoOptional<PositionAsIosAxes>
          ) {
        self.part = part
        
        self.objectType = object
        self.parentData = linkedOrParentData
        self.userEditedPartDimensionOneOrTwo = userEditedDimensionOneOrTwo
        self.userEditedOptionalOriginOffset =
            userEditedOriginOffsetOneOrTwoOptional//provide edited origin

        linkedOrParentDimension = linkedOrParentData.dimension
        linkedOrParentDimensionUsingOneValue = linkedOrParentDimension.mapOneOrTwoToOneOrLeftValue()
        
        editedElseDefaultOriginOneOrTwo = getOneOrTwoOriginWithOptionalOffset()
        
        //child origin is with respect to parent dimension
        func getOneOrTwoOriginWithOptionalOffset() -> OneOrTwo<PositionAsIosAxes>{
            let parentDimensionAsTouple = linkedOrParentDimension.mapToTouple()
            ///if you remove a propeller both parent remain
            ///so if you seek the parent depenant dimesnion for the remaining propeller
            ///you get an error as there are two
            
            switch userEditedPartDimensionOneOrTwo {
            case .one (let onePart):
                var oneParentValueIfOneChild: Dimension3d
                
                if let unwrapped = parentDimensionAsTouple.one {
                    //parent has one (unilateral) dimension
                    oneParentValueIfOneChild = unwrapped
                } else {
                    //parent has two (bilateral) dimension
                    if  partIdAllowingForUserEdit.mapToTouple().one != nil {
                        //but child has one dimension
                            oneParentValueIfOneChild = assignParentDimensionAccordingToId()
                    } else {
                        fatalError("child is one and parent is neither one or two")
                    }
                }
                guard var returnOneOrigin = getDefaultFromDimensions(onePart, oneParentValueIfOneChild) else {
                    fatalError("no default dimension for this part \(part)")
                }
                if doesOneHaveId0RequiringRightToLeftTransform() != nil {
                    returnOneOrigin = CreateIosPosition.getLeftFromRight(returnOneOrigin)
                }
                let editedElseDefaultOrigin: OneOrTwo<PositionAsIosAxes> =
                    getUserEditedElseDefaultPartOrigin(returnOneOrigin)
                
            return editedElseDefaultOrigin
                
                
                func assignParentDimensionAccordingToId() -> Dimension3d {
                    guard let childId = partIdAllowingForUserEdit.mapToTouple().one else {
                        fatalError("no child id")
                    }
                    let parentDimension: OneOrTwo<Dimension3d> =
                    linkedOrParentDimension.mapTwoToOneUsingOneId(childId)
                    
                    return parentDimension.returnValue(childId)
                }
                
            case .two(let leftPart, let rightPart):
                
                var returnLeftOrigin = getDefaultFromDimensions(leftPart, parentDimensionAsTouple.left) ?? ZeroValue.iosLocation

                returnLeftOrigin = CreateIosPosition.getLeftFromRight(returnLeftOrigin)
                
                let returnRightOrigin = getDefaultFromDimensions(rightPart, parentDimensionAsTouple.right) ?? ZeroValue.iosLocation
                
                let editedElseDefaultOrigin: OneOrTwo<PositionAsIosAxes> =
                    getUserEditedElseDefaultPartOrigin(returnLeftOrigin, returnRightOrigin)
                
                return editedElseDefaultOrigin
            }
        }
        
        func getUserEditedElseDefaultPartOrigin(
            _ value1: PositionAsIosAxes,
            _ value2: PositionAsIosAxes? = nil ) -> OneOrTwo<PositionAsIosAxes>{
            //edited values else default values
                let origins =
            userEditedOriginOffsetOneOrTwoOptional.mapValuesToOptionalOneOrTwoAddition(value1, value2)
//                if part == .fixedWheelAtRearWithPropeller {
//                   
//                    print(userEditedOriginOffsetOneOrTwoOptional)
//                    print (origins )
//                }
                return origins
        }
        
        
        func doesOneHaveId0RequiringRightToLeftTransform() -> PartTag? {
            var idForOne: PartTag? = nil
            switch partIdAllowingForUserEdit{
            case .one(let one):
                if one == .id0 {
                    idForOne = .id0
                }
            default:
              break
            }
            return idForOne
        }
        
        
        func getDefaultFromDimensions(_ selfDimension: Dimension3d, _ parentDimension: Dimension3d)  -> PositionAsIosAxes? {
            let origin =
            getFineTuneOriginDefault(selfDimension, parentDimension) ??
            getGeneralOriginDefault(selfDimension, parentDimension)
            return origin
        }
                     
        
        func getFineTuneOriginDefault(_ selfDimension: Dimension3d, _ parentDimension: Dimension3d) -> PositionAsIosAxes? {
            let chairHeight = 500.0
            return
                [
                PartObject(.fixedWheelAtRear, .fixedWheelManualRearDrive): (x: 75.0, y: 0.0, z: 0.0),
                PartObject(.mainSupport, .fixedWheelSolo): (x: 0.0, y: 0.0, z: chairHeight),
                PartObject(.mainSupport, .fixedWheelMidDrive): (x: 0.0, y: 0.0, z: chairHeight ),
                PartObject(.mainSupport, .fixedWheelFrontDrive): (x: 0.0, y: -selfDimension.length/2, z: chairHeight),
                PartObject(.mainSupport, .allCasterBed): (x: 0.0, y: selfDimension.length/2, z: 900.0),
                PartObject(.mainSupport, .allCasterStretcher): (x: 0.0, y: selfDimension.length/2, z: 900.0),
                ][PartObject(part, object)]
        }
    
    
        func  getGeneralOriginDefault(_ selfDimension: Dimension3d, _ linkedOrParentDimension: Dimension3d) -> PositionAsIosAxes? {
           let wheelBaseJointOrigin = getWheelBaseJointOrigin()

            return
                [
                .armSupport: (x: linkedOrParentDimension.width/2 + selfDimension.width/2, y: 0.0, z: selfDimension.height/2),
                .assistantFootLever: (x: linkedOrParentDimension.width/2.5, y: -(selfDimension.length + linkedOrParentDimension.length)/2, z: wheelBaseJointOrigin.z),
                .backSupport: (x: 0.0, y: -(linkedOrParentDimension.length + selfDimension.length)/2, z: selfDimension.height/2.0 ),
                .backSupportHeadSupport: (x: 0.0, y: 0.0, z: linkedOrParentDimension.height/2),
                .backSupportHeadSupportJoint: (x: 0.0, y: 0.0, z: linkedOrParentDimension.height/2.0),
                .backSupportHeadSupportLink:   (x: 0.0, y: 0.0, z: selfDimension.height/2),
                .backSupportTiltJoint: (x: 0.0, y: -linkedOrParentDimension.length/2, z: 0.0) ,
                
                .casterForkAtFront: (x: 0.0, y: -selfDimension.length * 2.0/3.0, z:  200.0),
                .casterForkAtRear: (x: 0.0, y: -selfDimension.length * 2.0/3.0, z:  200.0),
                .casterWheelAtFront: (x: 0.0, y: -selfDimension.height/2.0, z: 0.0),
                .casterWheelAtRear: (x: 0.0, y: -selfDimension.height/2.0, z: 0.0),
                .casterVerticalJointAtFront: wheelBaseJointOrigin,
                .casterVerticalJointAtRear: wheelBaseJointOrigin,
                .fixedWheelAtFront: ZeroValue.iosLocation,
                .fixedWheelAtMid: ZeroValue.iosLocation,
                .fixedWheelAtRear: ZeroValue.iosLocation,
                .fixedWheelHorizontalJointAtFront: wheelBaseJointOrigin,
                .fixedWheelHorizontalJointAtMid: wheelBaseJointOrigin,
                .fixedWheelHorizontalJointAtRear: wheelBaseJointOrigin,
                .fixedWheelAtRearWithPropeller: (x: PartDefaultDimension(.fixedWheelAtRear,objectType, linkedOrParentData).partDimension.width * 2 ,
                                                 //wheelBaseJointOrigin.x,
                                                 y: 0.0, z: 0.0),
                .footOnly: ZeroValue.iosLocation,
                
                .footSupport: (x: -PartDefaultDimension(.footSupport,objectType, linkedOrParentData).partDimension.width/2.0,
                               y: linkedOrParentDimension.length/2.0, z: 100.0),
                
                .footSupportJoint: (x: 0.0, y: linkedOrParentDimension.length/2.0, z: 0.0),
                .footSupportHangerJoint: (x: linkedOrParentDimension.width/2.0, y: linkedOrParentDimension.length/2.0, z: 0.0),
                
                .footSupportHangerLink: (x: linkedOrParentDimension.width/2.0 , y: (linkedOrParentDimension.length + selfDimension.length)/2.0, z: selfDimension.height/2.0),
            
                .footSupportInOnePiece: ZeroValue.iosLocation,
            
                .sideSupport: (x: linkedOrParentDimension.width/2 + selfDimension.width/2, y: 0.0, z: selfDimension.height/2),
                
                .sideSupportRotationJoint: (x: linkedOrParentDimension.width/2, y: -linkedOrParentDimension.length/2, z: selfDimension.height),
                .mainSupport:  (x: 0.0, y: selfDimension.length/2, z: 500.0 ),
                .sitOnTiltJoint: (x: 0.0, y: linkedOrParentDimension.length/12, z: -100.0),
                .stabiliser: (x: 0.0, y: selfDimension.length/2, z: -100.0),
                
                .steeredVerticalJointAtFront: wheelBaseJointOrigin,
                .steeredWheelAtFront: ZeroValue.iosLocation
                ] [part]
        }
    }
    

    
    func getWheelBaseJointOrigin() -> PositionAsIosAxes {
        var origin = ZeroValue.iosLocation
        let xOffset = linkedOrParentDimensionUsingOneValue.width
        let yOffset = linkedOrParentDimensionUsingOneValue.length
        let wheelJointHeight = 0.0
        let rearCasterVerticalJointOriginForMidDrive = (
                x: xOffset/2,
                y: -yOffset/2,
                z: wheelJointHeight)

        let xPosition = xOffset/2
        let xPositionAtFront = xOffset/2
        let rearOriginDic: [ObjectTypes: PositionAsIosAxes] =
            [
            .fixedWheelFrontDrive: (
                x: xPosition,
                y: -yOffset,
                z: wheelJointHeight),
            .fixedWheelMidDrive: rearCasterVerticalJointOriginForMidDrive]
        let midOriginDic: [ObjectTypes: PositionAsIosAxes] =
            [
            .fixedWheelSolo: (
                x: xPosition,
                y: 0.0,
                z: wheelJointHeight),
            .fixedWheelMidDrive: (
                x: xPosition,
                y: 0.0,
                z: wheelJointHeight) ]
        let frontOriginDic: [ObjectTypes: PositionAsIosAxes] =
            [
            .fixedWheelFrontDrive: (
                x: xPosition,
                y: 0.0,
                z: wheelJointHeight),
            .fixedWheelMidDrive: (
                x: xPosition,
                y: yOffset/2,
                z: wheelJointHeight),
            .scooterRearDrive4Wheeler: (
                x: xPositionAtFront,
                y: 800.0,
                z: wheelJointHeight)
            ]
           switch part {
                case//REAR
                    .fixedWheelAtRearWithPropeller,
                    .fixedWheelHorizontalJointAtFront,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtRear:
                        origin = (
                                    x: xPosition,
                                    y: 0.0,
                                    z: wheelJointHeight)
               
                case  .casterVerticalJointAtRear:
                   origin = rearOriginDic[objectType] ?? (
                                   x: xPosition,
                                   y: 0.0,
                                   z: wheelJointHeight)
                case//MID
                    .casterVerticalJointAtMid:
                        origin =  midOriginDic[objectType] ?? (
                                x: xPosition,
                                y: 0.0,
                                z: wheelJointHeight)
                case//FRONT
                    .casterVerticalJointAtFront,
                    .steeredVerticalJointAtFront:
                        origin = frontOriginDic[objectType] ?? (
                                        x: xPositionAtFront,
                                        y: yOffset,
                                        z: wheelJointHeight)
                default:
                    break
            }
        return origin
    }
    func getWheelBaseJointOriginX() -> PositionAsIosAxes {
        let casterHeight =
            PartDefaultDimension.casterForkDimension.height + PartDefaultDimension.casterWheelDimension.height
        let fixedWheelHeight = PartDefaultDimension.fixedWheelDimension.height / 2.0
        var origin = ZeroValue.iosLocation
        let linkedOrParentWidth = linkedOrParentDimensionUsingOneValue.width
        let linkedOrParentLength = linkedOrParentDimensionUsingOneValue.length

        let xPosition = linkedOrParentWidth/2

           switch part {
                case//REAR
                    .fixedWheelAtRearWithPropeller,
                    .fixedWheelHorizontalJointAtFront,
                    .fixedWheelHorizontalJointAtMid,
                    .fixedWheelHorizontalJointAtRear:
                        origin = (
                                    x: xPosition,
                                    y: 0.0,
                                    z: fixedWheelHeight)
               
           case .casterVerticalJointAtFront,
                   .casterVerticalJointAtMid,
                   .casterVerticalJointAtRear,
                   .steeredVerticalJointAtFront:
               origin =
               getOrigin()
                default:
                    break
            }
        return origin
        
        
        func getOrigin() ->  PositionAsIosAxes {
            let casterVerticalJointAtFrontForRearDriveOrFourCaster =
                (x: linkedOrParentWidth, y: linkedOrParentLength ,z: casterHeight)
           
            let casterVerticalJointAtFrontForFrontDrive =
                (x: linkedOrParentWidth, y: 0.0 ,z: casterHeight)
            
            let casterVerticalJointAtFrontForMidDrive =
                (x: linkedOrParentWidth, y: linkedOrParentLength / 2.0 ,z: casterHeight)
            
            let casterVerticalJointAtRearForMidDrive =
                (x: linkedOrParentWidth, y: -linkedOrParentLength / 2.0 ,z: casterHeight)
            
            let steeredVerticalJointAtFront =
                ( x: linkedOrParentWidth, y: linkedOrParentLength * 1.5, z: fixedWheelHeight)
            
            let dic =
           [
                PartObject(.casterVerticalJointAtFront, .fixedWheelFrontDrive): casterVerticalJointAtFrontForFrontDrive,
                PartObject(.casterVerticalJointAtFront, .fixedWheelMidDrive): casterVerticalJointAtFrontForMidDrive,
                PartObject(.casterVerticalJointAtRear, .fixedWheelMidDrive): casterVerticalJointAtRearForMidDrive,
                PartObject(.steeredVerticalJointAtFront, .scooterRearDrive4Wheeler): steeredVerticalJointAtFront,
            ]
            
            return dic[PartObject(part, objectType)] ?? casterVerticalJointAtFrontForRearDriveOrFourCaster
            
        }
        
        
    }
    func getMainSupportOrigin() -> PositionAsIosAxes {
        var origin = ZeroValue.iosLocation
        let x = 0.0//linkedOrParentDimensionUsingOneValue.width
        let yOffset = linkedOrParentDimensionUsingOneValue.length
        let height = 0.0
        let reverse = -1.0
        let rearCasterVerticalJointOriginForMidDrive = (
                x: x,
                y: -yOffset/2 * reverse,
                z: height)
        let midDriveOrigin = (
            x: x,
            y: yOffset/2 * reverse,
            z: height)
       
        let rearOriginDic: [ObjectTypes: PositionAsIosAxes] =
            [
            .fixedWheelManualRearDrive: (
                x: x,
                y: 0.0,
                z: height),
            .fixedWheelFrontDrive: (
                x: x,
                y: -yOffset ,
                        z: height),
            .fixedWheelMidDrive: rearCasterVerticalJointOriginForMidDrive]
        let midOriginDic: [ObjectTypes: PositionAsIosAxes] =
            [
            .fixedWheelSolo: (
                x: x,
                y: 0.0,
                z: height),
            .fixedWheelMidDrive: (
                x: x,
                y: 0.0,
                z: height) ]
        let frontOriginDic: [ObjectTypes: PositionAsIosAxes] =
            [
            .fixedWheelFrontDrive: (
                x: x,
                y: 0.0,
                z: height),
            .fixedWheelMidDrive: (
                x: x,
                y: yOffset/2 * reverse,
                z: height),
            .fixedWheelSolo: midDriveOrigin,
            .scooterRearDrive4Wheeler: (
                x: x,
                y: 800.0,
                z: height)
            ]
           switch part {
                case
                    .fixedWheelAtRearWithPropeller,
                    .fixedWheelHorizontalJointAtRear,
                    .casterVerticalJointAtRear:
                        origin = rearOriginDic[objectType] ?? (
                                        x: x,
                                        y: 0.0,
                                        z: height)
                case
                    .fixedWheelHorizontalJointAtMid,
                    .casterVerticalJointAtMid:
                        origin =  midOriginDic[objectType] ?? (
                                x: x,
                                y: yOffset/2 * reverse,
                                z: height)
                case
                    .fixedWheelHorizontalJointAtFront,
                    .casterVerticalJointAtFront,
                    .steeredVerticalJointAtFront:
                        origin = frontOriginDic[objectType] ?? (
                                        x: x,
                                        y: yOffset * reverse,
                                        z: height)
                default:
                    break
            }
        return origin
    }
}







struct DefaultMinMaxOriginDictionary {
    let originDic: PositionDictionary = [:]
    
    let fineOriginMinMaxDic: [PartObject: (min: PositionAsIosAxes, max: PositionAsIosAxes)] = [
        PartObject(.mainSupport, .showerTray):
            (min: (x: 600.0, y: 600.0, z: 10.0),
             max: (x: 2000.0, y: 3000.0, z: 10.0))
        ]
    let generalOriginMinMaxDic: [Part: (min: PositionAsIosAxes, max: PositionAsIosAxes)] = [
          .footSupportHangerLink:
            (min: (x: -500.0, y: 0.0, z: 0.0),
             max: (x: 500.0, y: 0.0, z: 0.0))
        ]
    
    static var shared = DefaultMinMaxOriginDictionary()
    
    
    func getDefault(_ part: Part, _ objectType: ObjectTypes)  -> (min: PositionAsIosAxes, max: PositionAsIosAxes) {
        let minMaxDimension =
        getFineTuneMinMaxOrigin(part, objectType) ??
        getGeneralMinMaxOrigin(part)
        return minMaxDimension
    }
    
    
    func getFineTuneMinMaxOrigin(_ part: Part, _ objectType: ObjectTypes) -> (min: PositionAsIosAxes, max: PositionAsIosAxes)? {
       fineOriginMinMaxDic[PartObject(part, objectType)]
    }
    
    
    func getGeneralMinMaxOrigin(_ part: Part) -> (min: PositionAsIosAxes, max: PositionAsIosAxes) {
       
        guard let minMax = generalOriginMinMaxDic[part] else {
            fatalError("no minMax exists for \(part)")
        }
        
        return minMax
    }
}
