//
//  OriginPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 06/07/2024.
//

import Foundation
import Combine
import SwiftUI

class OriginPickerViewModel: ObservableObject,
 SharedPartIdUSerEditedDic,
 SharedObjectChainLabelUserEditedDic,
    SharedOriginPropertyToEdit,
    SharedEditableOrignExistFuncOnly,
    SharedNoSidesPresentFuncOnly,
    SharedSidesPresentGivenPossibleUserEditFunc,
    SharedScopeOfEditForSideFunc,
    SharedChoiceOfEditForSide,
    SharedObjectType,
                             SharedPartToEditFunc {
    var partIdsUserEditedDic: [Part : OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
    var objectChainLabelsUserEditDic: [ObjectTypes : [Part]] = UserEditedDictionariesService.shared.objectChainLabelsUserEditDic
    
    
    var originPropertyBinding: Binding<PartTag> {
        Binding<PartTag>(
            get: { self.originPropertyToEdit },
            set: { self.setOriginPropertyToEdit($0) }
        )
    }
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    
    @Published var editableOriginExist = false
    
    @Published var editableOrigin: [PartTag] = []
    
    @Published var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    
    var objectType = ObjectDataService.shared.objectType
    
   @Published var disabled: Bool = true
    
   internal var cancellables: Set<AnyCancellable> = []
    
 
    init() {
        (self as SharedObjectType).subscribeToService()
        
        (self as SharedPartToEditFunc).subscribeToService()
    
        (self as SharedOriginPropertyToEdit).subscribeToService()
        
        (self as SharedScopeOfEditForSideFunc).subscribeToService()
        
        (self as SharedChoiceOfEditForSide).subscribeToService()
        (self as SharedObjectChainLabelUserEditedDic).subscribeToService()
        (self as SharedPartIdUSerEditedDic).subscribeToService()

    }
    

    func handlePartToEditChange(_ newData: Part) {
        //ensure that the previous option not applied to new part
        setDefaultPropertyToEditOnPartChange()
        getIfAnyEditableOrigin()
    }
    
    
    func setOriginPropertyToEdit(_ value: PartTag){
        ObjectEditService.shared.setOriginPropertyToEdit(value)
    }
    
    
    func setDefaultPropertyToEditOnPartChange() {
        switch partToEdit {
        case .assistantFootLever, .fixedWheelAtRearWithPropeller:
            setOriginPropertyToEdit(.xOrigin)
            
        default:
            break
        }
    }
    
}



