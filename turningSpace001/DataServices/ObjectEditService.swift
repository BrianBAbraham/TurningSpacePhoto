//
//  ObjectEditService.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/07/2024.
//

import Foundation
import Combine




protocol SharedChoiceOfEditForSide: AnyObject {
    var choiceOfEditForSide: SidesAffected {get set}
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedChoiceOfEditForSide {
    func subscribeToService() {
        ObjectEditService.shared.$choiceOfEditForSide
            .receive(on: DispatchQueue.main)
            .assign(to: \.choiceOfEditForSide,on: self)
            .store(in: &cancellables)
    }
}


protocol SharedDimensionPropertyToEdit: AnyObject {
    var dimensionPropertyToEdit: PartTag { get set }
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedDimensionPropertyToEdit {
   func subscribeToService() {
       ObjectEditService.shared.$dimensionPropertyToEdit
           .receive(on: DispatchQueue.main)
           .assign(to: \.dimensionPropertyToEdit,on: self)
           .store(in: &cancellables)
   }
}


protocol SharedOriginPropertyToEdit: AnyObject {
    var originPropertyToEdit: PartTag { get set }
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedOriginPropertyToEdit {
   func subscribeToService() {
       ObjectEditService.shared.$originPropertyToEdit
           .receive(on: DispatchQueue.main)
           .assign(to: \.originPropertyToEdit,on: self)
           .store(in: &cancellables)
   }
}


protocol SharedPartToEditFunc: AnyObject{
    var partToEdit: Part { get set }
    var cancellables: Set<AnyCancellable> { get set }
    func handlePartToEditChange(_ newData: Part)

}
extension SharedPartToEditFunc {
    func subscribeToService() {
        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.partToEdit = newData
                self?.handlePartToEditChange(newData)
            }
            .store(in: &self.cancellables)
    }
}


protocol  SharedPartToEdit: AnyObject {
    var partToEdit: Part {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedPartToEdit {
    func subscribeToService() {
        ObjectEditService.shared.$partToEdit
            .receive(on: DispatchQueue.main)
            .assign(to: \.partToEdit,on: self)
            .store(in: &cancellables)
    }
}

class ObjectEditService {
    static let defaultPart = Part.mainSupport
    @Published var scopeOfEditForSide: SidesAffected = .both
    @Published var choiceOfEditForSide: SidesAffected = .both
    @Published var dimensionPropertyToEdit: PartTag = .length
    @Published var originPropertyToEdit: PartTag = .xOrigin
    @Published var partToEdit = ObjectEditService.defaultPart
    
    
    static let shared = ObjectEditService()
    
    
    func resetPartToEdit() {
      //  print("RESET PART")
        self.partToEdit = ObjectEditService.defaultPart
    }
    
    
    func setScopeOfEditForSide(_ sideChoice: SidesAffected) {
        scopeOfEditForSide = sideChoice
    }
    
    
    func setSideToEdit(_ sideChoice: SidesAffected) {
        choiceOfEditForSide = sideChoice
    }
    
    
    func setDimensionPropertyToEdit(_ propertyToEdit: PartTag) {
        dimensionPropertyToEdit = propertyToEdit
    }
    
    
    func setOriginPropertyToEdit(_ propertyToEdit: PartTag) {
        originPropertyToEdit = propertyToEdit
    }
    
    
    func setPartToEdit(_ partToEdit: Part) {
       // print("SET PART")
        self.partToEdit = partToEdit
    }
}
