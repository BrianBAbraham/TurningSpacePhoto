//
//  UserEditedDictionary.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation



//MARK: UIEditedDictionary
///parts edited by the UI are stored in dictionary
///these dictiionaries are used for parts,
///where extant, instead of default values
///during intitialisation
///partChainId  are wrapped in OneOrTwo
struct UserEditedDictionaries {
    //relating to Part
    var dimensionUserEditedDic: Part3DimensionDictionary
    
    var angleUserEditedDic: AnglesDictionary
    var angleMinMaxDic: AngleMinMaxDictionary
    
    //relating to Object
//    var parentToPartOriginUserEditedDicNew: [PartId: PositionAsIosAxes]
    var originOffsetUserEditedDic: PositionDictionary
    var parentToPartOriginUserEditedDic: PositionDictionary
    var parentToPartOriginOffsetUserEditedDic: PositionDictionary
    var objectToPartOrigintUserEditedDic: PositionDictionary

    
    //relating to ObjectImage
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>]
    var objectChainLabelsUserEditDic: ObjectChainLabelDictionary
   
    static var shared = UserEditedDictionaries()
    
   private init(
        dimension: Part3DimensionDictionary  =
            [:],
        origin: PositionDictionary =
            [:] ,
        parentToPartOriginUserEditedDic: PositionDictionary = [:],
        parentToPartOriginOffsetUserEditedDic: PositionDictionary = [:],
//        parentToPartOriginUserEditedDicNew: [PartId: PositionAsIosAxes] = [:],
        objectToParOrigintUserEditedDic: PositionDictionary = [:],
        originOffsetUserEditedDic: PositionDictionary = [:],
        anglesDic: AnglesDictionary =
            [:],
        angleMinMaxDic: AngleMinMaxDictionary =
            [:],
        partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] =
            [:],
        objectChainLabelsUserEditDic: ObjectChainLabelDictionary =
            [:]) {
        
        self.dimensionUserEditedDic = dimension
   
        self.parentToPartOriginUserEditedDic = parentToPartOriginUserEditedDic
        self.parentToPartOriginOffsetUserEditedDic = parentToPartOriginUserEditedDic
//        self.parentToPartOriginUserEditedDicNew = parentToPartOriginUserEditedDicNew
        self.objectToPartOrigintUserEditedDic = objectToParOrigintUserEditedDic
        self.originOffsetUserEditedDic = originOffsetUserEditedDic
        self.angleUserEditedDic =
            anglesDic
        self.angleMinMaxDic =
            angleMinMaxDic
        self.partIdsUserEditedDic =
            partIdsUserEditedDic
        self.objectChainLabelsUserEditDic = objectChainLabelsUserEditDic
    }
}



///All dictionary are input in userEditedDictionary
///The optional  values associated with a part are available
///dimension
///origin
///The non-optional id are available
///All values are wrapped in OneOrTwoValues
struct UserEditedData {
    let dimensionUserEditedDic: Part3DimensionDictionary
    let parentToPartOriginUserEditedDic: PositionDictionary
    let parentToPartOriginOffsetUserEditedDic: PositionDictionary
    let objectToPartOrigintUserEditedDic: PositionDictionary
    let angleUserEditedDic: AnglesDictionary
    let angleMinMaxDic: AngleMinMaxDictionary
    let partIdDicIn: [Part: OneOrTwo<PartTag>]
    let part: Part
    let sitOnId: PartTag
    
    var originName:  OneOrTwoOptional <String> = .one(one: nil)
    var optionalAngles: OneOrTwoOptional <RotationAngles> = .one(one: nil)
    var optionalAngleMinMax: OneOrTwoOptional <AngleMinMax> = .one(one: nil)
    var optionalDimension: OneOrTwoOptional <Dimension3d> = .one(one: nil)
    var optionalOrigin: OneOrTwoOptional <PositionAsIosAxes> = .one(one: nil)
    var partIdAccountingForUserEdit: OneOrTwo <PartTag>//bilateral parts can be edited to unilateral
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?,
        _ sitOnId: PartTag,
        _ part: Part) {
            self.sitOnId = sitOnId
            self.part = part
            dimensionUserEditedDic =
            userEditedDic?.dimensionUserEditedDic ?? [:]
            parentToPartOriginUserEditedDic =
            userEditedDic?.parentToPartOriginUserEditedDic ?? [:]
            parentToPartOriginOffsetUserEditedDic =
            userEditedDic?.parentToPartOriginOffsetUserEditedDic ?? [:]

            objectToPartOrigintUserEditedDic =
            userEditedDic?.objectToPartOrigintUserEditedDic ?? [:]
            angleUserEditedDic =
            userEditedDic?.angleUserEditedDic ?? [:]
            angleMinMaxDic =
            userEditedDic?.angleMinMaxDic ?? [:]
            partIdDicIn =
            userEditedDic?.partIdsUserEditedDic ?? [:]

            partIdAccountingForUserEdit = //non-optional as must iterate through id
            partIdDicIn[part] ?? //UI edit:.two(left:.id0,right:.id1)<->.one(one:.id0) ||.one(one:.id1)
            OneOrTwoId(objectType, part).forPart // default
                        
            originName = getOriginName(partIdAccountingForUserEdit)
                                       
            optionalOrigin = getOptionalOrigin()

            optionalAngleMinMax =
            getOptionalValue(partIdAccountingForUserEdit, from: angleMinMaxDic) { item in
                return CreateNameFromIdAndPart(sitOnId, part).name
            }
            
            optionalAngles = getOptionalAngles()
            optionalDimension = getOptionalDimension()
        }
    
    
    func getOriginName(_ partId: OneOrTwo<PartTag>)
    -> OneOrTwoOptional<String>{
        
        switch partId {
        case .one(let one):
            let oneName = CreateNameFromIdAndPart(one, part).name
            return
                .one(one: oneName)
        case .two(let left, let right):
            let leftName = CreateNameFromIdAndPart(left, part).name
            let rightName = CreateNameFromIdAndPart(right, part).name
            return
                .two(
                    left: leftName,
                    right: rightName)
        }
    }
    
    
    func getOptionalAngles() -> OneOrTwoOptional<RotationAngles>{
        var angles: OneOrTwoOptional<RotationAngles> = .one(one: nil)
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            angles =
                .one(one: angleUserEditedDic[one ] )
        case .two(let left, let right):
            angles =
                .two(left: angleUserEditedDic[ left ], right: angleUserEditedDic[right ] )
        }
        return angles
    }
    
    func getOptionalDimension() -> OneOrTwoOptional<Dimension3d>{
        var dimension: OneOrTwoOptional<Dimension3d> = .one(one: nil)
//        if part == .footSupportHangerLink {
//            print(originName.mapOptionalToNonOptionalOneOrTwo(""))
//        }
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            dimension =
                .one(one: dimensionUserEditedDic[one ] )
        case .two(let left, let right):
            dimension =
                .two(left: dimensionUserEditedDic[ left ], right: dimensionUserEditedDic[right ] )
        }
        return dimension
    }
    
    func getOptionalOrigin() -> OneOrTwoOptional<PositionAsIosAxes>{
        var origin: OneOrTwoOptional<PositionAsIosAxes> = .one(one: nil)
        switch originName.mapOptionalToNonOptionalOneOrTwo("") {
        case .one(let one):
            origin =
                .one(one: parentToPartOriginOffsetUserEditedDic[one ] )
        case .two(let left, let right):
            origin =
                .two(left: parentToPartOriginOffsetUserEditedDic[ left ],
                     right: parentToPartOriginOffsetUserEditedDic[right ] )
        }
        if part == Part.footSupportHangerLink {
        }
        return origin
    }
        
    
//    func getOrigin() -> OneOrTwoOptional<PositionAsIosAxes>{
//        var origin: OneOrTwoOptional<PositionAsIosAxes>
//        switch partIdAllowingForUserEdit {
//        case .one(let one):
//            origin =
//                .one(one: parentToPartOriginUserEditedDicNew[PartId(part,one)])
//        case .two(let left, let right):
//            origin =
//                .two(left: parentToPartOriginUserEditedDicNew[PartId(part, left)],
//                     right: parentToPartOriginUserEditedDicNew[PartId(part, right)])
//        }
//        return origin
//    }
//
    
    func getOptionalValue<T>(
        _ partIds: OneOrTwo<PartTag>,
        from dictionary: [String: T?],
        using closure: @escaping (PartTag) -> String
    ) -> OneOrTwoOptional<T> {
        if part == .mainSupport {
        }
        
        let commonPart = { (id: PartTag) -> T? in
            dictionary[closure(id)] ?? nil
        }
        switch partIds {
        case .one(let oneId):
            return .one(one: commonPart(oneId))
        case .two(let left, let right):
            return .two(left: commonPart(left), right: commonPart(right))
        }
    }
    

}

