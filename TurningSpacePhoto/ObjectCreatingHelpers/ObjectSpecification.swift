//
//  ObjectSpecification.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/03/2024.
//

import Foundation







//Source of truth for partChain
//chainLabel is the last item in array
//MARK: ChainLabel
struct LabelInPartChainOut {
    static let partChainArrays: [[Part]] = [
            [.stabiliser,.mainSupport, .assistantFootLever],
            [.stabiliser,.mainSupport, .backSupport],
            [.stabiliser,.mainSupport, .backSupportTiltJoint],
            [.stabiliser,.mainSupport, .footSupportHangerLink,  .footSupport],
            [.footOnly],
            [.stabiliser,.mainSupport, .backSupport,.backSupportHeadSupportJoint, .backSupportHeadSupportLink, .backSupportHeadSupport],
            [.stabiliser, .mainSupport, .armSupport],
            [.stabiliser, .mainSupport],
            [.stabiliser,.mainSupport, .sideSupport],
            [.stabiliser,.mainSupport, .sitOnTiltJoint],
            [.fixedWheelHorizontalJointAtRear,  .fixedWheelAtRear],
            [.fixedWheelHorizontalJointAtMid, .fixedWheelAtMid],
            [.fixedWheelHorizontalJointAtFront, .fixedWheelAtFront],
            [.fixedWheelHorizontalJointAtRear, .fixedWheelAtRear, .fixedWheelAtRearWithPropeller ],
        
            [.fixedWheelHorizontalJointAtFront,  .fixedWheelAtFrontWithPropeller],
            [.casterVerticalJointAtRear, .casterWheelAtRear, .casterForkAtRear],
            [.casterVerticalJointAtMid, .casterWheelAtMid, .casterForkAtMid],
            [.casterVerticalJointAtFront, .casterWheelAtFront, .casterForkAtFront],
            [.steeredVerticalJointAtFront, .steeredWheelAtFront]
            
        ]

        // Create the dictionary dynamically from the PartChain arrays
        static let partChainDictionary: [Part: PartChain] = {
            var dictionary: [Part: PartChain] = [:]

            for (index, partChain) in partChainArrays.enumerated() {
                guard let key = partChain.last else {
                                fatalError("no last part")
                            }
                dictionary[key] = partChain
            }

            return dictionary
        }()

    var partChains: [PartChain] = []
    var partChain: PartChain = []

    init(_ parts: [Part]) {//many partChain label
        for part in parts {
            if let partChain = Self.partChainDictionary[part] {
                partChains.append(partChain)
            }
        }
    }

    init(_ part: Part) { //one partChain label
        if let partChain = Self.partChainDictionary[part] {
            self.partChain = partChain
        }
    }

    mutating func getPartChain(_ part: Part) -> PartChain {
        return Self.partChainDictionary[part] ?? []
    }
}



/// provides the object names for the picker
/// provides the chainLabels for each object
//MARK: ObjectsChainLabels
struct ObjectChainLabel {
    static let chairSupport: [Part] =
        [.mainSupport,
         .backSupportTiltJoint,
        .backSupportHeadSupport,
        .footSupport,
        .armSupport,
        .sitOnTiltJoint]
    static let chairSupportWithOutFoot: [Part] =
        [.mainSupport,
         .backSupportTiltJoint,
        .backSupportHeadSupport,
        .armSupport,
        .sitOnTiltJoint]
    ///setting the fork and not the casterWheel  as the terminal part
    ///facilitates editing of the fork length and posiitiong
    ///setting the casterWheel as the terminal part makes the edit loigic more complicated
    static let rearAndFrontCasterFork: [Part] =
        [.casterForkAtRear, .casterForkAtFront]
    static let chairSupportWithFixedRearWheel: [Part] =
    chairSupport + [.fixedWheelAtRear]
    
   static let dictionary: ObjectChainLabelDictionary =
        [
        .allCasterBed:
            [.mainSupport, .sideSupport ],
          
        .allCasterChair:
            chairSupport + rearAndFrontCasterFork,
    
        .allCasterTiltInSpaceArmChair:
            chairSupportWithOutFoot + rearAndFrontCasterFork + [.sitOnTiltJoint],
          
        .allCasterTiltInSpaceShowerChair:
            chairSupport + rearAndFrontCasterFork + [.sitOnTiltJoint],
        
        .allCasterStretcher:
            [ .mainSupport, .sideSupport] + rearAndFrontCasterFork,
        
        .fixedWheelRearDriveAssisted:
            chairSupport + [.fixedWheelAtRear] + [.casterForkAtFront] + [.assistantFootLever],
        
        .fixedWheelMidDrive:
            chairSupport + [.fixedWheelAtMid] + rearAndFrontCasterFork,
        
        .fixedWheelFrontDrive:
            chairSupport + [.fixedWheelAtFront] + [.casterForkAtRear],
         
        .fixedWheelRearDrive:
            chairSupportWithFixedRearWheel + [.casterForkAtFront] ,
        
        .fixedWheelManualRearDrive:
            chairSupportWithFixedRearWheel + [.casterForkAtFront] + [.fixedWheelAtRearWithPropeller],
        
   

        .fixedWheelSolo: [.mainSupport] + [.fixedWheelAtMid]  + [.armSupport] ,
    
        .scooterRearDrive4Wheeler: chairSupportWithOutFoot + [.fixedWheelAtRear, .steeredWheelAtFront],

        .showerTray: [.mainSupport],
    
    ]
}


//MARK: OneOrTwoId
struct OneOrTwoId {
    static let partWhichAreAlwaysUnilateral: [Part] = [
        .backSupportTiltJoint,
        .backSupport,
        .backSupportHeadSupportJoint,
        .backSupportHeadSupportLink,
        .backSupportHeadSupport,
        .footSupportInOnePiece,
        .footOnly,
        .mainSupport,
        .sitOnTiltJoint
    ]
    let forPart: OneOrTwo<PartTag>
    init(_ objectType: ObjectTypes,_ part: Part){
        forPart = getIdForPart(part)
        
        
        func getIdForPart(_ part: Part)
        -> OneOrTwo<PartTag>{
            if Self.partWhichAreAlwaysUnilateral.contains(part) {
                return  .one(one: PartTag.id0)
            } else {
                return .two(left: PartTag.id0, right: PartTag.id1)
            }
            

        }
    }
}

struct TiltingAbility {
    let part: Part
    let group: ObjectGroup
    static let dictionary: [PartObjectGroup: Part] = [
        PartObjectGroup(.mainSupport, .chair): .sitOnTiltJoint,
        PartObjectGroup(.backSupport, .chair): .backSupportTiltJoint,
        ]
    var tilter: Part? {
        Self.dictionary[PartObjectGroup(part, group)]
    }
    var parts:[Part] {
        Array(Self.dictionary.values)
    }
    init (_ part: Part = .notFound, _ objectType: ObjectTypes = .fixedWheelRearDrive) {
        self.part = part
            self.group = ObjectTypesToGroups(objectType: objectType).group
    }
}

struct PartInRotationScopeOut {
    let allChainLabels: [Part]

    let dictionary: [Part: [Part]] = [
        .sitOnTiltJoint:
            [.backSupport, .backSupportTiltJoint, .backSupportHeadSupportLink, .backSupportHeadSupport, .mainSupport, .armSupport, .footSupportHangerLink, .footSupport],
        .backSupportTiltJoint:
            [.backSupport, .backSupportHeadSupportLink, .backSupportHeadSupport]
    ]
    
    let part: Part
    
    var defaultRotationScope: [Part] {
        let initial = dictionary[part] ?? []
        
        return initial.filter{allChainLabels.contains($0)}
    }
    
    var rotationScopeAllowingForEditToChainLabel: [Part] {
        defaultRotationScope
    }
    
    init(_ part: Part, _ allChainLabels: [Part]) {
        self.part = part
        self.allChainLabels = allChainLabels
    }
}


struct AllPartInObject {
    
    static func getOneOfAllPartInObjectBeforeEdit(_ objectType: ObjectTypes) -> [Part] {
        guard let allPartChainLabels = ObjectChainLabel.dictionary[objectType] else {
            fatalError("Chain labels not defined for object")
        }
        return getOneOfAllPartInObject(allPartChainLabels)
    }
    
    static func getOneOfAllPartInObjectAfterEdit(_ allPartChainLabels: [Part]) -> [Part] {
        return getOneOfAllPartInObject(allPartChainLabels)
    }
    
    private static func getOneOfAllPartInObject(_ allPartChainLabels: [Part]) -> [Part] {
        var oneOfEachPartInAllChainLabel: [Part] = []
        for label in allPartChainLabels {
            let partChain = LabelInPartChainOut(label).partChain
            for part in partChain {
                if !oneOfEachPartInAllChainLabel.contains(part) {
                    oneOfEachPartInAllChainLabel.append(part)
                }
            }
        }
        return oneOfEachPartInAllChainLabel
    }
}


//struct AllPartInObject {
//    
//    static func getOneOfAllPartInObjectBeforeEdit(_ objectType: ObjectTypes) -> [Part] {
//        guard let allPartChainLabels = ObjectChainLabel.dictionary[objectType] else {
//            fatalError("chain labels not defined for object")
//        }
//        var oneOfEachPartInAllChainLabel: [Part] = []
//            for label in allPartChainLabels {
//               let partChain = LabelInPartChainOut(label).partChain
//                for part in partChain {
//                    if !oneOfEachPartInAllChainLabel.contains(part) {
//                        oneOfEachPartInAllChainLabel.append(part)
//                    }
//                }
//            }
//        return oneOfEachPartInAllChainLabel
//    }
//    
//    static func getOneOfAllPartInObjectAfterEdit(_ allPartChainLabels: [Part]) -> [Part] {
//        var oneOfEachPartInAllChainLabel: [Part] = []
//            for label in allPartChainLabels {
//               let partChain = LabelInPartChainOut(label).partChain
//                for part in partChain {
//                    if !oneOfEachPartInAllChainLabel.contains(part) {
//                        oneOfEachPartInAllChainLabel.append(part)
//                    }
//                }
//            }
//        return oneOfEachPartInAllChainLabel
//    }
//}
