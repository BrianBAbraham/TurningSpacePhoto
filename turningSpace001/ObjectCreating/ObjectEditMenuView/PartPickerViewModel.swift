//
//  PartPickerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 01/07/2024.
//

import Foundation
import Combine
import SwiftUI

class PartPickerViewModel: ObservableObject,
   SharedPartToEdit{
    var partBinding: Binding<String> {
        Binding<String>(
            get: { self.getObjectSensitiveNameForPart()  },
            set: {// print("reset part")
                return self.setPartToEdit($0) }
        )
    }
    
    @Published var oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit: [String] = []
    @Published var partToEdit = ObjectEditService.shared.partToEdit

    var objectType = ObjectDataService.shared.objectType

    var oneOfAllEditablePartForObjectBeforeEdit: [String] = []

    internal var cancellables: Set<AnyCancellable> = []

    static let partsNotToAppearOnEditMenu: [PartGroup] = [
    .tilt,
    .backJointAndLink,
    .casterJoint,
    .fixedWheelJoint,
    .footJointAndLink,
    .stabiliser,
    .steeredJoint,
    ]
    
    init() {
        
        ObjectDataService.shared.$objectType
            .sink { [weak self] newData in
                self?.objectType = newData
                self?.oneOfAllEditablePartForObjectBeforeEdit = self?.getOneOfAllEditablePartForObjectBeforeEdit() ?? []
                
                self?.oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit = self?.getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit() ?? []
             
            }
            .store(in: &self.cancellables)
        
        (self as SharedPartToEdit ).subscribeToService()
    }
    
    
    func getObjectSensitiveNameForPart() -> String {
        PartToDisplayInMenu([partToEdit], objectType).name
    }
   
    
    func getOneOfAllPartForObjectBeforeEdit() -> [Part] {
            AllPartInObject.getOneOfAllPartInObjectBeforeEdit(objectType)
      }
    
    
    func getOneOfAllEditablePartForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
        oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains( $0.transformPartToPartGroup())}
        return parts.map{$0.rawValue}
    }
    
    
    func getOneOfAllEditablePartWithMenuNamesForObjectBeforeEdit() -> [String] {
        let oneOfAllPartForObjectBeforeEdit = getOneOfAllPartForObjectBeforeEdit()
        let parts =
            oneOfAllPartForObjectBeforeEdit.filter {!Self.partsNotToAppearOnEditMenu.contains($0.transformPartToPartGroup())}

        return PartToDisplayInMenu(parts, objectType).names
    }
    
    
    func setPartToEdit(_ menuPartName: String) {
        let index = oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit.firstIndex(where: { $0 == menuPartName }) ?? 0
        
        let partName =
            oneOfAllEditablePartForObjectBeforeEdit[index]
        
        guard let part = Part(rawValue: partName) else {
            fatalError("no part for that part name")
        }
        
        ObjectEditService.shared.setPartToEdit(part)
        
        resetForNewPartEdit()
        //print("DETECT")
        func resetForNewPartEdit(){
            //if part has one side the property is disregarded
            ObjectEditService.shared.setSideToEdit(
                .both)
            ObjectEditService.shared.setScopeOfEditForSide(
                .both)
            
        }
    }
}


