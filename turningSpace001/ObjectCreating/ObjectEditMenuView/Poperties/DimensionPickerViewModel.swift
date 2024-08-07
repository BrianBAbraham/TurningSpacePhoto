//
//  DimensionPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine
import SwiftUI



class DimensionPickerViewModel: ObservableObject,
    SharedPartIdUSerEditedDic,
    SharedObjectChainLabelUserEditedDic,
    SharedDimensionPropertyToEdit,
    SharedNoSidesPresentFuncOnly,
    SharedSidesPresentGivenPossibleUserEditFunc,
    SharedScopeOfEditForSideFunc,
    SharedChoiceOfEditForSide,
    SharedPartToEditFunc,
    SharedObjectType {
    var partIdsUserEditedDic: [Part : OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
    
    var objectChainLabelsUserEditDic: [ObjectTypes : [Part]] = UserEditedDictionariesService.shared.objectChainLabelsUserEditDic
    
    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    

    
    var dimensionPropertyBinding: Binding<PartTag> {
        Binding<PartTag>(
            get: { self.dimensionPropertyToEdit
                },
            set: {
                self.setDimensionPropertyToEdit($0) }
        )
    }
   
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    @Published var editableDimension: [PartTag] = []
    
    //inconistant without Published
    @Published var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit

   @Published var disabled: Bool = true
    
   internal var cancellables: Set<AnyCancellable> = []

    init() {
        (self as SharedDimensionPropertyToEdit).subscribeToService()
        
        (self as SharedPartToEditFunc).subscribeToService()

        (self as SharedScopeOfEditForSideFunc).subscribeToService()
        
        (self as SharedChoiceOfEditForSide).subscribeToService()
        
        (self as SharedObjectType).subscribeToService()
        (self as SharedObjectChainLabelUserEditedDic).subscribeToService()
        
        (self as SharedPartIdUSerEditedDic).subscribeToService()
    }
    
    
    func handlePartToEditChange(_ newData: Part) {
       partToEdit = newData
        setFirstAvailableDimensionPropertyActive()
        editableDimension = getPropertiesForDimensionPicker()
    }
    
    
    //set these to extend or reduce UI
    func getPropertiesForDimensionPicker() -> [PartTag] {

        switch partToEdit{
        
        case .backSupport:
            return [ .width, .height]
            
        case .backSupportHeadSupport:
            return [.length,  .width, .height]
            
        case .fixedWheelAtRearWithPropeller:
            return [.width]
        
        case .footSupport, .assistantFootLever:

            return [.length]
        
        default:
            return [.length, .width]
        }
    }
    
    
    func setDimensionPropertyToEdit(_ propertyToEdit: PartTag) {
        ObjectEditService.shared.setDimensionPropertyToEdit(propertyToEdit)
    }
    
    ///most parts have length and wdith, but for those that do not have length
    ///the default length cannot be used
    ///so set the first available dimension prroperty as the default
    ///otherwise no dimension property is highlighted and steppers have no effect
    func setFirstAvailableDimensionPropertyActive() {
    
        let editableDimension = getPropertiesForDimensionPicker()
        if let firstDimension = editableDimension.first {
            setDimensionPropertyToEdit(
                firstDimension
            )
        }
    }
}






