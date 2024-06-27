//
//  ObjectCreator.swift
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation


//MARK: PART
protocol Parts {
    var stringValue: String { get }
}


///provide proprties for tuple for part-object access to dictionary
struct PartObject: Hashable {
    let part: Part
    let object: ObjectTypes
    
    init (_ part: Part, _ object: ObjectTypes) {
        self.part = part
        self.object = object
    }
}



///provide proprties for tuple for part-groupaccess to dictionary
struct PartObjectGroup: Hashable {
    let part: Part
    let group: ObjectGroup
    
    init (_ part: Part, _ group: ObjectGroup) {
        self.part = part
        self.group = group
    }
}


///provide proprties for tuple for part-id access to dictionary
struct PartId: Hashable {
    let part: Part
    let id: PartTag
    
    init (_ part: Part, _ id: PartTag) {
        self.part = part
        self.id = id
    }
}



struct StructFactory {
    let objectType: ObjectTypes
    var partData: PartData = ZeroValue.partData
    let linkedOrParentData: PartData
    let part: Part
    let parentPart: Part
    let chainLabelsAccountingForEdit: [Part]
    let defaultOrigin: PartEditedElseDefaultOrigin
    let userEditedData: UserEditedData
    var partOrigin: OneOrTwo<PositionAsIosAxes> = .one(one: ZeroValue.iosLocation)
    var partDimension: OneOrTwo<Dimension3d> = .one(one: ZeroValue.dimension3d)

    // Designated initializer for common parts
    init(_ objectType: ObjectTypes,
         _ userEditedDic: UserEditedDictionaries?,
         _ linkedOrParentData: PartData,
         _ part: Part,
         _ chainLabelsAccountingForEdit: [Part]){
        self.objectType = objectType
        self.linkedOrParentData = linkedOrParentData
        self.part = part
        self.parentPart = linkedOrParentData.part
        self.chainLabelsAccountingForEdit = chainLabelsAccountingForEdit
        let sitOnId: PartTag = .id0
        

        userEditedData =
            UserEditedData(
                objectType,
                userEditedDic,
                sitOnId,
                part)
        
        let defaultDimensionData =
                PartDefaultDimension(
                    part,
                    objectType,
                    linkedOrParentData,
                    userEditedData.optionalDimension)
    
        let defaultDimensionOneOrTwo =
                defaultDimensionData.userEditedDimensionOneOrTwo
    
        defaultOrigin =
            PartEditedElseDefaultOrigin(
                part,
                objectType,
                linkedOrParentData,
                defaultDimensionOneOrTwo,
                userEditedData.partIdAccountingForUserEdit,
                userEditedData.optionalOrigin)
        
        setChildDimensionForPartData()
        setChildOriginForPartData()
        setPartData()

        func setChildDimensionForPartData() {
            partDimension = defaultDimensionOneOrTwo
        }
        
        
        func setChildOriginForPartData() {
            partOrigin = defaultOrigin.editedElseDefaultOriginOneOrTwo
        }

        
        func setPartData() {
            partData = createPart()
        }
    }

   
    init(_ objectType: ObjectTypes,
         _ userEditedDic: UserEditedDictionaries?,
         independantPart childPart: Part) {
        let linkedOrParentData = ZeroValue.partData
        let noChainLabelRequired: [Part] = []
        self.init(
            objectType,
            userEditedDic,
            linkedOrParentData,
            childPart,
            noChainLabelRequired
        )
        partData = createSitOn()
    }

    // Convenience initializer for parts in general
    init(
        _ objectType: ObjectTypes,
         _ userEditedDic: UserEditedDictionaries?,
         _ linkedOrParentData: PartData,
         dependantPart childPart: Part,
         _ chainLabel: [Part]
    ) {
        self.init(
            objectType,
            userEditedDic,
            linkedOrParentData,
            childPart,
            chainLabel)
    }
}
extension StructFactory {
    func createSitOn()
        -> PartData {
            let sitOnName: OneOrTwo<String> = .one(one: "object" + ObjectId.objectId.rawValue + "_sitOn_id0_sitOn_id0")
        return
            PartData(
                part: .mainSupport,
                originName:sitOnName,
                dimensionName: sitOnName,
                dimension: partDimension,
                origin: defaultOrigin.editedElseDefaultOriginOneOrTwo,
                minMaxAngle: nil,
                angles: nil,
                id: .one(one: PartTag.id0) )
    }

    
    func createPart()
        -> PartData {
        let partId = userEditedData.partIdAccountingForUserEdit//two sided default edited to one will be detected
        let partsToBeRotated: [Part] =  getPartsToBeRotated()
        var partAnglesMinMax = partId.createOneOrTwoWithOneValue(ZeroValue.angleMinMax)
        var partAngles = partId.createOneOrTwoWithOneValue(ZeroValue.rotationAngles)
        let originName =
            userEditedData.originName.mapOptionalToNonOptionalOneOrTwo("")
     

        if [.sitOnTiltJoint, .backSupportTiltJoint].contains(part) {
            let (jointAngle, minMaxAngle) = getDefaultJointAnglesData()
            partAngles = getAngles(jointAngle)
            partAnglesMinMax = getMinMaxAngles(minMaxAngle)
        }
 

        return
            PartData(
                part: part,
                originName: originName,
                dimensionName: originName,
                dimension: partDimension,
                maxDimension: partDimension,
                origin: partOrigin,
                globalOrigin: .one(one: ZeroValue.iosLocation),//postProcessed
                minMaxAngle: partAnglesMinMax,
                angles: partAngles,
                id: partId,
                partsToBeRotated: partsToBeRotated)
            
            
        func getPartsToBeRotated() -> [Part]{
            let oneOfAllPartInObject = AllPartInObject.getOneOfAllPartInObjectAfterEdit(chainLabelsAccountingForEdit)
            let partsToBeRotated =
                PartInRotationScopeOut(
                    part,
                    oneOfAllPartInObject)
                        .rotationScopeAllowingForEditToChainLabel

            return partsToBeRotated
        }
         
            
        func getDefaultJointAnglesData() -> (RotationAngles, AngleMinMax){
            let  partDefaultAngle = PartDefaultAngle(part, objectType)
            return (partDefaultAngle.angle, partDefaultAngle.minMaxAngle)
        }


            
        func getAngles(
            _ defaultAngles: RotationAngles) -> OneOrTwo<RotationAngles> {
                userEditedData.optionalAngles.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
            
            
        func getMinMaxAngles(
            _ defaultAngles: AngleMinMax) -> OneOrTwo<AngleMinMax>{
                userEditedData.optionalAngleMinMax.mapOptionalToNonOptionalOneOrTwo(defaultAngles)
        }
    }
}











