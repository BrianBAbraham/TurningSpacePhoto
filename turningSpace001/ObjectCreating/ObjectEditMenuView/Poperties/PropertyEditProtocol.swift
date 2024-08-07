//
//  PropertyEditProtocol.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/07/2024.
//

import Foundation
import Combine









protocol SharedScopeOfEditForSideFunc: AnyObject {
    //when scope of edit for edit side is .none
    // set disabled true
    var disabled: Bool {get set}
    func getPartNotPresent() -> Bool
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedScopeOfEditForSideFunc {
    func subscribeToService() {
        ObjectEditService.shared.$scopeOfEditForSide
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.disabled = self?.getPartNotPresent() ?? true
              
            }
            .store(in: &self.cancellables)
    }
}


protocol SharedNoSidesPresentFuncOnly: AnyObject {
    var partToEdit: Part {get}
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected]
}
extension SharedNoSidesPresentFuncOnly {
    func getPartNotPresent() -> Bool {
        let partOrAssociatedPart = PartsRequiringLinkedPartUse(partToEdit).partForEditableOrigin
        let first = getSidesPresentGivenPossibleUserEdit(partOrAssociatedPart)[0]

        return first == .none
    }
}


protocol SharedSidesPresentGivenPossibleUserEditFunc: AnyObject {
    var objectType: ObjectTypes {get}
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] {get}
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] {get}
}
extension SharedSidesPresentGivenPossibleUserEditFunc {
    func getSidesPresentGivenPossibleUserEdit(_ partOrAssociatedPart: Part) -> [SidesAffected] {
        guard let chainLabels =
                objectChainLabelsUserEditDic[objectType]
                ?? ObjectDataService.shared.objectChainLabelsDefaultDic[objectType] else {
            fatalError()
        }

        var sidesPresent: [SidesAffected] = []
        if chainLabels.contains(partOrAssociatedPart) {
            let oneOrTwoId: OneOrTwo<PartTag> =
            partIdsUserEditedDic[partOrAssociatedPart] ?? OneOrTwoId(objectType, partOrAssociatedPart).forPart
            sidesPresent = oneOrTwoId.mapOneOrTwoToSide()
        } else {
            sidesPresent = [.none]
        }

//print("\(partOrAssociatedPart) \(sidesPresent) \n")
        return sidesPresent
    }
}
