//
//  ObjectPickrtViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/03/2023.
//

import Foundation
import Combine
import SwiftUI

class ObjectPickerViewModel: ObservableObject,
    SharedObjectType,
    SharedUserEditedDictionaries{
    
    var objectPickerBinding: Binding<String> {
        Binding<String> (
            get: { self.objectType.rawValue },
            set: { self.onChangeOfPicker($0) }
        )
    }
    @Published var allObjectsName: [String] = ObjectChainLabel.sortedNames

    var objectType: ObjectTypes = ObjectDataService.shared.objectType
    var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionariesService.shared.userEditedSharedDics
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init() {
        let _ = ObjectDataMediator.shared
        
        (self as SharedObjectType).subscribeToService()
        (self as SharedUserEditedDictionaries).subscribeToService()
    }
    
    
    func onChangeOfPicker(_ objectName: String) {
        guard let newObjectType = ObjectTypes(rawValue: objectName) else {
            fatalError("Invalid object type")
        }

        ObjectDataService.shared.setObjectType(newObjectType)
        // Delay the following code to ensure objectType is updated
        DispatchQueue.main.async { [weak self] in
            self?.resetObjectByCreatingFromName()
  
            ObjectEditService.shared.resetPartToEdit()
        }
    }
    
    
    func resetObjectByCreatingFromName() {
        // DIMENSIONCHANGE
        UserEditedDictionariesService.shared.dimensionUserEditedDicReseter()
        
        // ANGLECHANGE
        UserEditedDictionariesService.shared.angleUserEditedDicReseter()
        
        UserEditedDictionariesService.shared.partIdsUserEditedDicReseter()
        
        modifyObjectByCreatingFromName()
    }
    
    
    func modifyObjectByCreatingFromName() {
        let objectImageData = ObjectImageData(
            objectType,
            userEditedSharedDics
        )
        
        ObjectImageService.shared.setObjectImage(
            objectImageData
        )
    }
}

