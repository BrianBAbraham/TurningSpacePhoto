//
//  UnilateralPartPresence.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/07/2024.
//

import Foundation
import Combine
import SwiftUI


class UnilateralPartPresenceViewModel: ObservableObject,
    SharedModifyObjectByCreatingFromNameFuncOnly,
    SharedPartRemovalFuncOnly,
    SharedPartToEditFunc,
    SharedObjectType,
    SharedUserEditedDictionaries,
    SharedObjectChainLabelUserEditedDic{
    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes : [Part]] = UserEditedDictionariesService.shared.userEditedSharedDics.objectChainLabelsUserEditDic

    var partBinding: Binding<Bool> {
       Binding<Bool> (
           get: {self.partPresent},
           set: {self.partPresent = $0
               self.changeStatusOfPart()}
       )
   }
    
    @Published var partToEdit = ObjectEditService.shared.partToEdit
    
    @Published  var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    @Published var showMenu = false

    var partPresent = true
    
    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    
    var cancellables: Set<AnyCancellable> = []
    
        init() {
        (self as SharedObjectChainLabelUserEditedDic).subscribeToService()
        
        (self as SharedPartToEditFunc).subscribeToService()
        
        (self as SharedObjectType).subscribeToService()
            
        (self as SharedUserEditedDictionaries).subscribeToService()
    }
    
    
    func handlePartToEditChange(_ newData: Part) {
          partToEdit = newData
          showMenu = setShowMenuStatus()
      }
    
    
    func setShowMenuStatus() -> Bool{
        switch partToEdit {
        case .backSupportHeadSupport:
            return true
        default :
            return false
        }
    }
    
    //called if UI toggle changes
    func changeStatusOfPart() {
        
        switch partPresent {
        case true:
            //chain label must not exist as one was previously true
            //as only one change at at time possible
            restoreChainLabelToObject(partToEdit)
            setPartIdDicInKeyToNilRestoringDefaultForPart()
        case false:
            //remove chainLabel so part does not exist
            removeChainLabelFromObject(partToEdit)
        }
    
        //finally create a new object with the new specification
        modifyObjectByCreatingFromName()
    }
}

