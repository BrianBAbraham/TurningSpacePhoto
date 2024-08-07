//
//  UserEditedDictionariesService.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import Combine


protocol SharedUserEditedDictionaries: AnyObject {
    var userEditedSharedDics: UserEditedDictionaries {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedUserEditedDictionaries {
    func subscribeToService() {
        UserEditedDictionariesService.shared.$userEditedSharedDics
            .receive(on: DispatchQueue.main)
            .assign(to: \.userEditedSharedDics,on: self)
            .store(in: &cancellables)
    }
}

protocol SharedPartIdUSerEditedDic: AnyObject {
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedPartIdUSerEditedDic {
    func subscribeToService() {
        UserEditedDictionariesService.shared.$partIdsUserEditedDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.partIdsUserEditedDic,on: self)
            .store(in: &cancellables)
    }
}

protocol SharedPartIdUSerEditedDicFunc: AnyObject {
    var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] {get}
    var cancellables: Set<AnyCancellable> { get set }
    func handlePartIdsUserEditedDicChange(_ newData: [Part: OneOrTwo<PartTag>] )
}
extension SharedPartIdUSerEditedDicFunc {
    func subscribeToService(){
        UserEditedDictionariesService.shared.$partIdsUserEditedDic
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.handlePartIdsUserEditedDicChange(newData)
            }
            .store(in: &self.cancellables)
    }
}

protocol SharedObjectChainLabelUserEditedDic: AnyObject{
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] { get set }
    var cancellables: Set<AnyCancellable> { get set }

}
extension SharedObjectChainLabelUserEditedDic {
    func subscribeToService() {
        UserEditedDictionariesService.shared.$objectChainLabelsUserEditDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectChainLabelsUserEditDic,on: self)
            .store(in: &cancellables)
    }
}


protocol SharedObjectChainLabelUserEditedDicFunc: AnyObject{
    var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    
    func handleObjectChainLabelsUserEditedDicChange(_ newData: [ObjectTypes: [Part]])

}
extension SharedObjectChainLabelUserEditedDicFunc {
    func subscribeToService() {
        UserEditedDictionariesService.shared.$objectChainLabelsUserEditDic
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
                self?.handleObjectChainLabelsUserEditedDicChange(newData)
            }
            .store(in: &self.cancellables)
    }
}


class UserEditedDictionariesService: ObservableObject {
    @Published var  userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared

    @Published var partIdsUserEditedDic: [Part: OneOrTwo<PartTag>] = UserEditedDictionaries.shared.partIdsUserEditedDic
    
    @Published var objectChainLabelsUserEditDic: [ObjectTypes: [Part]] = UserEditedDictionaries.shared.objectChainLabelsUserEditDic//[:]

    static let shared = UserEditedDictionariesService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //Service is acting as intermediary to
        // userEditedSharedDics properties so
        //must sink these
        userEditedSharedDics.$partIdsUserEditedDic
            .assign(to: \.partIdsUserEditedDic, on: self)
            .store(in: &cancellables)
        
        userEditedSharedDics.$objectChainLabelsUserEditDic
            .assign(to: \.objectChainLabelsUserEditDic, on: self)
            .store(in: &cancellables)
    }
    
    
    func angleUserEditedDicModifier(_ entry: AnglesDictionary){
       
        userEditedSharedDics.angleUserEditedDic += entry
    }
    
    
    func angleUserEditedDicReseter(){
        userEditedSharedDics.angleUserEditedDic = [:]
    }
    
    
    func dimensionUserEditedDicModifier(_ entry: Part3DimensionDictionary){
        userEditedSharedDics.dimensionUserEditedDic += entry
    }
    
    
    func dimensionUserEditedDicReseter(){
        userEditedSharedDics.dimensionUserEditedDic = [:]
    }
    

    func objectChainLabelsUserEditDicReseter(_ objectType: ObjectTypes) {
        userEditedSharedDics.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
      
    }
    
    
    func objectChainLabelsUserEditDicModifier(_ objectType: ObjectTypes, _ chainLabels: [Part]) {
        userEditedSharedDics.objectChainLabelsUserEditDic += [objectType: chainLabels]
    }
    
    
    func originOffsetUserEdtiedDicModifier(_ entry: PositionDictionary) {
        userEditedSharedDics.parentToPartOriginOffsetUserEditedDic += entry
    }
    
    
    func originUserEdtiedDicModifier(_ entry: PositionDictionary) {
        userEditedSharedDics.parentToPartOriginUserEditedDic += entry
    }
    

    func partIdsUserEditedDicModifier(_ entry: [Part: OneOrTwo<PartTag>]) {
        userEditedSharedDics.partIdsUserEditedDic += entry
    }
    
    
    func partIdsUserEditedDicReseterForBilateralPart(_ part: Part, _ oneOrTwo: OneOrTwo<PartTag>) {
        
        userEditedSharedDics.partIdsUserEditedDic += [part: oneOrTwo]
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    func partIdsUserEditedDicReseter(_ part: Part) {
        userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
        userEditedSharedDics = UserEditedDictionaries.shared
    }
    
    
    func partIdsUserEditedDicReseter() {
        userEditedSharedDics.partIdsUserEditedDic = [:]
    }
    

}
