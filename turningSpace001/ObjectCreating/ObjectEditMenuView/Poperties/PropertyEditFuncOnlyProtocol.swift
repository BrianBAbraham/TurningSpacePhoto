//
//  PropertyEditFuncOnlyProtocol.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/07/2024.
//
//
import Foundation
import Combine






protocol SharedModifyObjectByCreatingFromNameFuncOnly: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    
    var userEditedSharedDics: UserEditedDictionaries {get set}
    
    var objectType: ObjectTypes {get set}
    
}
extension SharedModifyObjectByCreatingFromNameFuncOnly{
    

    func modifyObjectByCreatingFromName(){
        let objectImageData = ObjectImageData(
            objectType,
            userEditedSharedDics
        )
        
        ObjectImageService.shared.setObjectImage(
            objectImageData
        )
    }
}



protocol SharedEditableOrignExistFuncOnly: AnyObject {
    var editableOriginExist: Bool {get set}
    var editableOrigin: [PartTag] {get set}
    var partToEdit: Part {get}
    var objectType: ObjectTypes {get}
    
}
extension SharedEditableOrignExistFuncOnly {
    func getPropertiesForOriginPicker(_ part: Part) -> [PartTag] {
        if  let displayPart = PartToDisplayInMenu.dictionary[part] {
            switch displayPart {
            case .seat:
                if objectType == .showerTray {
                    return []
                } else {
                    return [.xOrigin, .yOrigin]
                }
                
            case .propeller, .footLever, .headrest:
                return [.xOrigin]
                
            case .casterForkAtFront, .casterForkAtMid, .casterForkAtRear:
                return [.yOrigin]
                
            case .backrest:
               return []
                
            default:
                return [.xOrigin, .yOrigin]
                }
        } else {
            return [.xOrigin, .yOrigin]
        }
    }
    
    
    func getIfAnyEditableOrigin(){
       editableOrigin = getPropertiesForOriginPicker(partToEdit)
        editableOriginExist =
            editableOrigin == [] ? false: true
    }
}



protocol SharedPartRemovalFuncOnly: AnyObject{
    var partToEdit: Part {get}
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] {get set}
    var objectType: ObjectTypes {get}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedPartRemovalFuncOnly {
    func modifyPartIdsUserEditedDic(_ newId: OneOrTwo<PartTag> ) {
        
        let partChain = LabelInPartChainOut(partToEdit).partChain
        
        let linkedPartDic: [Part: Part] = [
            .footSupport: .footSupportHangerLink,
        ]
         
        let partOrLinkedPart = linkedPartDic[partToEdit] ?? partToEdit
        
        guard let firstIndex = partChain.firstIndex(of: partOrLinkedPart) else {
            fatalError("\(partChain)")
        }
        //provide id for the parts of the chain being edited
        //as not all the chain may be removed
        //if there were two then if on the right the id must be id0 as only one
        for index in firstIndex..<partChain.count {
            UserEditedDictionariesService.shared.partIdsUserEditedDicModifier([partChain[index]: newId])
        }
    }
    
    
    func removeChainLabelFromObject(
        _ chainLabel: Part) {
        guard let currentObjectChainLabels =
                objectChainLabelsUserEditDic[objectType] ??
                    ObjectChainLabel.dictionary[objectType] else {
                          fatalError()
                        }
        let newChainLabels =
            currentObjectChainLabels.filter { $0 != chainLabel}
            
            UserEditedDictionariesService.shared.objectChainLabelsUserEditDicModifier(objectType, newChainLabels)
    }


    func restoreChainLabelToObject(
        _ chainLabel: Part
    ) {
        guard let currentObjectChainLabels = objectChainLabelsUserEditDic[objectType] ??
                ObjectChainLabel.dictionary[objectType] else {
            fatalError(
                "no chain labels for object \(objectType)"
            )
        }
        let newChainLabels = currentObjectChainLabels + [chainLabel]
       
        UserEditedDictionariesService.shared.objectChainLabelsUserEditDicModifier(objectType, newChainLabels)
    }


    func setPartIdDicInKeyToNilRestoringDefaultForPart () {
        let partChain = LabelInPartChainOut(partToEdit).partChain
        for part in partChain {
            let oneOrTwo = OneOrTwoId(objectType, part).forPart
            UserEditedDictionariesService.shared.partIdsUserEditedDicReseterForBilateralPart(part, oneOrTwo)
        }
    }
}



protocol SharedInitialSliderValueFuncOnly: AnyObject {
    var partDataDic: [Part: PartData]  {get}
    
    var userEditedSharedDics: UserEditedDictionaries {get}
    
    var choiceOfEditForSide: SidesAffected {get}
}
extension SharedInitialSliderValueFuncOnly {
    func getInitialSliderValue(
        _ partToEdit: Part,
        _ propertyToEdit: PartTag,
        _ sidesAffected: SidesAffected? = nil
    ) -> Double {
        //sometimes the UI selection is adjusted by another part eg footlength for footplate
        //print("Getting initial slider value for part: \(partToEdit), tag: \(propertyToEdit)")
        
        
        let part = PartsRequiringLinkedPartUse(partToEdit).partForDimensionEdit
        
        var value: Double? = nil
        if let partData = partDataDic[part] {//parts edited out do not exist
            let idForLeftOrRight = choiceOfEditForSide == .right ? PartTag.id1: PartTag.id0
        
            var id: PartTag
            if let sideAsId = sidesAffected?.getOneId() {
                id = sideAsId
            } else {
                id =  partData.id.one ?? idForLeftOrRight//two sources for id
            }
           
            switch propertyToEdit {
            case .height:
                let dimension = partData.dimension.returnValue(id)
                
                value = dimension.height
            case .width:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.width
            case.length:
                let dimension = partData.dimension.returnValue(id)
                value = dimension.length
            case .xOrigin, .yOrigin:
                let name = CreateNameFromIdAndPart(id, part).name
                let offsetToOrigin = userEditedSharedDics.originOffsetUserEditedDic[name] ?? ZeroValue.iosLocation

                value = propertyToEdit == .xOrigin ?
                offsetToOrigin.x: offsetToOrigin.y
                
            case .angle:
                value =
                    partData.angles.returnValue(id).x.converted(to: .degrees).value
            
            default:
                break
            }
        }
            let whenPartHasBeenRemovedAndValueNotUsed = 0.0
          
            return value ?? whenPartHasBeenRemovedAndValueNotUsed
    }
}






protocol SharedSetValueForBilateralPartFuncOnly: AnyObject {
    var choiceOfEditForSide: SidesAffected {get}
    
    var partDataDic: [Part: PartData]  {get}
    
    var userEditedSharedDics: UserEditedDictionaries {get}
}
extension SharedSetValueForBilateralPartFuncOnly {
    
    func getEditedOrDefaultOriginOffset(
        _ name: String
    )
        -> PositionAsIosAxes {

        return
            userEditedSharedDics.parentToPartOriginOffsetUserEditedDic[name] ?? ZeroValue.iosLocation
    }
    
    
    func dimensionWithModifiedProperty(
        _ value: Double,
        _ dimension: Dimension3d,
        _ property: PartTag
    ) -> Dimension3d {
        switch property {
        case .height:
            return
                (
                    width: dimension.width,
                    length: dimension.length,
                    height: value
                )
        case .length:
            return
                (
                    width: dimension.width,
                    length: value,
                    height:dimension.height
                )
        case.width:
            return
                (
                    width: value,
                    length: dimension.length,
                    height:dimension.height
                )
        default: return dimension
        }
    }
    
    
    func getEditedOrDefaultDimension(
        _ name: String,
        _ part: Part,
        _ id: PartTag)
        -> Dimension3d {

            guard let partData = partDataDic[part] else {
                fatalError()
            }
        return
            partData.dimension.returnValue(id)
    }
    
    
    ///the value may be for origin or dimension
    ///origin may be x or y
    ///dimension may be width or length
    func setValueForBilateralPartInUserEditedDic(
        _ partToEdit: Part,
        _ propertyToEdit: PartTag,
        _ value: Double,
        _ sidesAffected: SidesAffected? = nil) {
    
            //sometimes the UI part is not the part that is edtied
        let part = PartsRequiringLinkedPartUse(partToEdit).partForDimensionEdit
        var partOrLinkedPart: Part = .notFound
        let allDimensionProperties: [PartTag] = [.width, .length, .height]
        if value == 0.0 && allDimensionProperties.contains(propertyToEdit) {
           //do not let dimensions cross zer0
        } else {
            
            transformToStabiliserForDriveWheelModForOriginY ()

            var sidesToEdit: SidesAffected
            
            if let unwrapped = sidesAffected {
               sidesToEdit = unwrapped
            } else {
                sidesToEdit = choiceOfEditForSide
            }
            switch sidesToEdit {
            case .both:
                process(.id0)
                process(.id1)
            case.left:
                process(.id0)
            case.right:
                process(.id1)
            default:
                break
            }
        }

     
        func process(
            _ id: PartTag
        ) {
            let name = CreateNameFromIdAndPart(
                id,
                partOrLinkedPart
            ).name
            switch propertyToEdit {
            case .length, .width, .height:
                let currentDimension =
                getEditedOrDefaultDimension(
                    name,
                    partOrLinkedPart,
                    id
                )
                let newDimension =
                dimensionWithModifiedProperty(
                    value,
                    currentDimension,
                    propertyToEdit
                )
                UserEditedDictionariesService.shared.dimensionUserEditedDicModifier(
                    [name: newDimension]
                )
            case .xOrigin, .yOrigin:
                let currentOrigin = getEditedOrDefaultOriginOffset(
                    name
                )
                let newOriginOffset = propertyToEdit == .xOrigin ? xOriginModified(
                    currentOrigin,
                    id
                ) : yOriginModified(
                    currentOrigin,
                    id
                )
                UserEditedDictionariesService.shared.originOffsetUserEdtiedDicModifier(
                    [name: newOriginOffset]
                )
            default: break
            }
        }
            
        func transformToStabiliserForDriveWheelModForOriginY () {
            ///the static point is on the  common turn axis of the fixed wheels
            ///increasing the stability of the main support by increasing the distance
            ///between the main support and the drive wheels for a rear drive  wheelchair
            ///therefore is an increase in stability rather than solely a motion of the drive wheels
            ///however, it is cleaner to include y origin control of the drive wheelchair position
            ///in the rear wheel menu rather than create a new stability menu
            ///the code to do that is also conistant with the mid and front drive
            let dic: [Part: Part] = [
                .fixedWheelAtRear: .stabiliser,
                .fixedWheelAtFront: .stabiliser,
                .fixedWheelAtMid: .stabiliser,
            ]
            if let unwrapped = dic[part],  propertyToEdit == .yOrigin {
                partOrLinkedPart = unwrapped
        
            } else {
                partOrLinkedPart = part
            }
        }
            
            
        func xOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            var mod: Double//eg armRest xMove '-' brings closer, but headRest moves left
            
            if getNoModRequiredX(part) {
                mod = 1.0
            } else {
                mod = makeLeftAndRightMoveCloserWithNegAndApartWithPos()
            }
            let newOrigin =
                (x: origin.x + value * mod,
                 y: origin.y,
                 z: 0.0)
            return newOrigin
            
            func makeLeftAndRightMoveCloserWithNegAndApartWithPos() -> Double {
                var reverseDirection = 1.0
                if choiceOfEditForSide == .both {
                    reverseDirection = id == .id1 ? 1.00: -1.00
                }
                return reverseDirection
            }
        }
            
            
        func getNoModRequiredX(_ part: Part) -> Bool{
            let exclusionsForAlwaysUniPart: [Part] = [
                .mainSupport,
                .backSupport,
                .backSupportHeadSupport
            ]
            return
                exclusionsForAlwaysUniPart.contains(part) ? true: false
        }
        
        
        func yOriginModified(_ origin: PositionAsIosAxes, _ id: PartTag) -> PositionAsIosAxes {
            return
                (x: origin.x,
                y: origin.y + value,
                z: 0.0)
        }
    }
}




protocol SharedGetSidesAffectedFuncOnly: AnyObject {
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] {get}
    var objectType: ObjectTypes {get}
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] {get}
    var cancellables: Set<AnyCancellable> { get set }
   
    func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>] )
}
extension SharedGetSidesAffectedFuncOnly {

    
    func getIfSideIsPresentFromUserEditedDic(_ side: SidesAffected, _ partToEdit: Part) -> Bool{
        
        var present: Bool
        // it the object has an entry in objectChainLabelsUserEditDic
        // chain labels have been modified
        if let chainLabels = objectChainLabelsUserEditDic[objectType] {
            //if the partToEdit is not present no part present either side
            if !chainLabels.contains(partToEdit) {
                present = false
            } else {
               //if there is a chain label has that side been removed
              present = whichSidePresent()
            }
        } else {
            //if no chain label modifications still need to check for presence on side
            present = whichSidePresent()
        }
        
        func whichSidePresent() -> Bool {
            let oneOrTwoId: OneOrTwo = partIdsUserEditedDic[partToEdit] ?? OneOrTwoId(
                objectType,
                partToEdit
            ).forPart
            
            let sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        
            return
                sidesPresent.contains(side)
        }
        return present
    }

    
    func getSidesAffected(_ partToEdit: Part) ->SidesAffected {
        let left = getIfSideIsPresentFromUserEditedDic(.left, partToEdit)
        let right = getIfSideIsPresentFromUserEditedDic(.right, partToEdit)
        
        switch (left, right) {
        case (true, true):
            return .both
        case (true, false):
            return .left
        case (false, true):
            return .right
        case (false, false):
            return .none
        }
    }
}










