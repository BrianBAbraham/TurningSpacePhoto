//
//  BilateralPartPresenceViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import Foundation
import Combine
import SwiftUI


class BilateralPartSidePresenceViewModel: ObservableObject,
    SharedPartIdUSerEditedDicFunc,
    SharedGetSidesAffectedFuncOnly,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedPartRemovalFuncOnly,
    SharedObjectType,
    SharedUserEditedDictionaries,
    SharedPartToEditFunc,
    SharedObjectChainLabelUserEditedDic{
    
    

    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes : [Part]] = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic
    

  
    var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published var partIdsUserEditedDic: [Part : OneOrTwo<PartTag>] = UserEditedDictionariesService.shared.partIdsUserEditedDic
            
    @Published var objectType: ObjectTypes = ObjectDataService.shared.objectType

    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics

    @Published var showMenu = false

    //on first use toggle flips back to true without this
    @Published var leftPresent = true
    @Published var rightPresent = true

    internal var cancellables: Set<AnyCancellable> = []
    
     var leftBinding: Binding<Bool> {
        Binding<Bool> (
            get: {self.leftPresent},
            set: {self.leftPresent = $0
                self.changeOneOrTwoStatusOfPart()}
        )
    }
    
    var rightBinding: Binding<Bool> {
        Binding<Bool> (
            get: {self.rightPresent},
            set: {self.rightPresent = $0
                self.changeOneOrTwoStatusOfPart()}
        )
    }

    init() {
        (self as SharedPartIdUSerEditedDicFunc).subscribeToService()
        
        (self as SharedObjectChainLabelUserEditedDic).subscribeToService()
        
        (self as SharedPartToEditFunc).subscribeToService()
        
        (self as SharedObjectType).subscribeToService()
            
        (self as SharedUserEditedDictionaries).subscribeToService()
        
        getBilateralPresenceMenuStatus(partToEdit)
        
    }
    
    func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>]) {
        //required for protocol conformity
            //used in another VM
    }
    
    
    func handleScopeOfEditForSideChange(_ newData: SidesAffected) {
    //required for protocol conformity
        //used in another VM
    }
    
    
    func handlePartToEditChange(_ newData: Part) {
        partToEdit = newData
        getBilateralPresenceMenuStatus(newData)
        //update new part with its prior presence
        leftPresent = getIfSideIsPresentFromUserEditedDic(.left, newData)
        rightPresent = getIfSideIsPresentFromUserEditedDic(.right, newData)
    }

    
    //called if UI toggle changes
    func changeOneOrTwoStatusOfPart() {
       
        switch (leftPresent, rightPresent) {
        case (true, true):
            //chain label must exist as one was previously true
            //asonly one change at at time possible
            //if both present return to default
            setPartIdDicInKeyToNilRestoringDefaultForPart()
            
        //one added from none or one removed from two
        case(true, false), (false, true):
            let newId: OneOrTwo<PartTag> = leftPresent ?
                .one(one: .id0): //if left requires .id0 for x < 0
                .one(one: .id1)  //if right requires .i1 for x >= 0
         
            //one removed from two
            if getSidesAffected(partToEdit) == .both {
                modifyPartIdsUserEditedDic(newId)
            }
            
            //one added from none
            if getSidesAffected(partToEdit) == .none {
                //the chain label will have been removed
                restoreChainLabelToObject(partToEdit)
                modifyPartIdsUserEditedDic(newId)
            }
            
        case(false, false):
            //remove chainLabel so part does not exist
            removeChainLabelFromObject(partToEdit)
        }
        
        //finally create a new object with the new specification
       modifyObjectByCreatingFromName()
        

    }
//    
    
    func getBilateralPresenceMenuStatus(_ part: Part) {
        let neverBilateral =
            OneOrTwoId.partWhichAreAlwaysUnilateral.contains(part)
        let rigidlyBilateral =
            (part.transformPartToPartGroup() == PartGroup.none ? false: true)
    
        showMenu = (!neverBilateral && !rigidlyBilateral)
        
        //nb T rB T: nil
        //nb F rb F: nil
        //nb T rB F: show
        //nb F rB T: no show
    }
    
    

    
}



