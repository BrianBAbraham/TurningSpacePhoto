//
//  OriginStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI


class OriginStepperViewModel: ObservableObject,
    SharedPartIdUSerEditedDic,
    SharedObjectChainLabelUserEditedDic,
    SharedOriginPropertyToEdit,
    SharedEditableOrignExistFuncOnly, 
    SharedInitialSliderValueFuncOnly,
    SharedSetValueForBilateralPartFuncOnly,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedUserEditedDictionaries,
    SharedObjectType,
    SharedNoSidesPresentFuncOnly,
    SharedSidesPresentGivenPossibleUserEditFunc,
    SharedScopeOfEditForSideFunc,
    SharedChoiceOfEditForSide,
    SharedPartDataDic,
    SharedPartToEditFunc{
    @Published var partIdsUserEditedDic: [Part : OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
    
    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes : [Part]] = UserEditedDictionariesService.shared.objectChainLabelsUserEditDic
    

    var stepperValueBinding: Binding<Double> {
        Binding<Double>(
            get: {
                self.getInitialSliderValue(
                    self.partToEdit,
                    self.originPropertyToEdit
                )
            },
            set: {                     newValue in
                self.setValueForBilateralPartInUserEditedDic(
                    self.partToEdit,
                    self.originPropertyToEdit,
                            newValue
                            )
                self.modifyObjectByCreatingFromName() }
        )
    }
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published var editableOriginExist = false
    
    @Published var editableOrigin: [PartTag] = []
    
    var objectType = ObjectDataService.shared.objectType

    var partDataDic: [Part : PartData] = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
    @Published var disabled: Bool = true
    
    var userEditedSharedDics = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var originPropertyToEdit = ObjectEditService.shared.originPropertyToEdit
    
    internal var cancellables: Set<AnyCancellable> = []

        init() {

        (self as SharedPartToEditFunc).subscribeToService()
        (self as SharedOriginPropertyToEdit).subscribeToService()
        (self as SharedScopeOfEditForSideFunc).subscribeToService()
        (self as SharedChoiceOfEditForSide).subscribeToService()
        (self as SharedPartDataDic).subScribeToService()
        (self as SharedObjectType).subscribeToService()
        (self as SharedUserEditedDictionaries).subscribeToService()
        (self as SharedObjectChainLabelUserEditedDic).subscribeToService()
        (self as SharedPartIdUSerEditedDic).subscribeToService()
    }

    
    func handlePartToEditChange(
    _ newData: Part
    ) {
        //ensure that the previous option not applied to new part
        partToEdit = newData
        getIfAnyEditableOrigin()
    }
}
