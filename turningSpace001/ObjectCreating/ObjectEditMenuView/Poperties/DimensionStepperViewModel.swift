//
//  DimensionStepperViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 05/07/2024.
//

import Foundation
import Combine
import SwiftUI


class DimensionStepperViewModel: ObservableObject,
    SharedPartIdUSerEditedDic,
    SharedObjectChainLabelUserEditedDic,
    SharedInitialSliderValueFuncOnly,
    SharedDimensionPropertyToEdit,
    SharedSetValueForBilateralPartFuncOnly,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedObjectType,
    SharedUserEditedDictionaries,
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
                    self.dimensionPropertyToEdit
                )
            },
            set: { newValue in
                self.setValueForBilateralPartInUserEditedDic(
                    self.partToEdit,
                    self.dimensionPropertyToEdit,
                    newValue
                )
                self.modifyObjectByCreatingFromName() }
        )
    }
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit

    var objectType = ObjectDataService.shared.objectType
    
    var partDataDic: [Part : PartData] = ObjectDataService.shared.partDataDic
    
    var choiceOfEditForSide: SidesAffected = ObjectEditService.shared.choiceOfEditForSide
    
   @Published var disabled: Bool = true
    
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    var dimensionPropertyToEdit = ObjectEditService.shared.dimensionPropertyToEdit
    
    internal var cancellables: Set<AnyCancellable> = []
  
    
    init() {

    (self as SharedObjectType).subscribeToService()
        
    (self as SharedUserEditedDictionaries).subscribeToService()
        
    (self as SharedPartToEditFunc).subscribeToService()
     
    (self as SharedDimensionPropertyToEdit).subscribeToService()

    (self as SharedScopeOfEditForSideFunc).subscribeToService()
    
    (self as SharedChoiceOfEditForSide).subscribeToService()
        
    (self as SharedPartDataDic).subScribeToService()
    (self as SharedObjectChainLabelUserEditedDic).subscribeToService()
    (self as SharedPartIdUSerEditedDic).subscribeToService()

}

    
    func handlePartToEditChange(_ newData: Part) {
        partToEdit = newData

    }
}
