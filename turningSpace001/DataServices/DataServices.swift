//
//  Services.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 29/05/2024.
//

import Foundation
import SwiftUI
import Combine



class MeasurementSystemService {
    @Published var unitSystem: UnitSystem = .cm
    static let shared = MeasurementSystemService()
    

    func setMeasurementSystem(_ unitSystem: UnitSystem) {
        self.unitSystem = unitSystem
    }
}


//class DictionaryService {
//    @Published var userEditedSharedDics: UserEditedDictionaries = UserEditedDictionaries.shared
//    @Published var partDataSharedDic: [Part: PartData] = [:]
//    @Published var currentObjectType: ObjectTypes = .fixedWheelRearDrive
//    @Published var screenDictionary: CornerDictionary = [:]
//
//    static let shared = DictionaryService()
//    
//    func angleUserEditedDicModifier(_ entry: AnglesDictionary){
//        userEditedSharedDics.angleUserEditedDic += entry
//    }
//    
//    func angleUserEditedDicReseter(){
//        userEditedSharedDics.angleUserEditedDic = [:]
//    }
//    
//    func dimensionUserEditedDicModifier(_ entry: Part3DimensionDictionary){
//        userEditedSharedDics.dimensionUserEditedDic += entry
//    }
//    
//    func dimensionUserEditedDicReseter(){
//        userEditedSharedDics.dimensionUserEditedDic = [:]
//    }
//    
//    func objectChainLabelsUserEditDicReseter(_ objectType: ObjectTypes) {
//        userEditedSharedDics.objectChainLabelsUserEditDic.removeValue(forKey: objectType)
//    }
//    
//    
//    func originOffsetUserEdtiedDicModifier(_ entry: PositionDictionary) {
//        userEditedSharedDics.parentToPartOriginOffsetUserEditedDic += entry
//    }
//    
//    
//    func originUserEdtiedDicModifier(_ entry: PositionDictionary) {
//        userEditedSharedDics.parentToPartOriginUserEditedDic += entry
//    }
//    
//    
//    func partDataSharedDicModifier(_ initialised: [Part: PartData] ) {
//        partDataSharedDic = initialised
//    }
//    
//    
//    func partIdsUserEditedDicModifier(_ entry: [Part: OneOrTwo<PartTag>]) {
//        userEditedSharedDics.partIdsUserEditedDic += entry
//    }
//    
//    
//    func partIdsUserEditedDicReseter(_ part: Part) {
//        userEditedSharedDics.partIdsUserEditedDic.removeValue(forKey: part)
//    }
//    
//    
//    func partIdsUserEditedDicReseter() {
//        userEditedSharedDics.partIdsUserEditedDic = [:]
//    }
//    
//
//    func setScreenDictionary(_ dictionary: CornerDictionary) {
//        screenDictionary = dictionary
//    }
//}
//
//
//
//

class RecenterObjectsOnScreenService {
    @Published var recenter = false
    
    static let initialRulerPosition = CGPoint(x:100, y: 350)
    static let shared = RecenterObjectsOnScreenService()
    
    func setRecenterTrue() {
        print(recenter)
        recenter.toggle()
    }
}
