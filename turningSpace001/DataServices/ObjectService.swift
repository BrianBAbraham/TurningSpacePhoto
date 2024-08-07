//
//  ObjectService.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/07/2024.
//

import Foundation
import Combine


protocol SharedPartDataDic: AnyObject {
    var partDataDic: [Part: PartData] {get set}
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedPartDataDic {
    func subScribeToService() {
        ObjectDataService.shared.$partDataDic
            .receive(on: DispatchQueue.main)
            .assign(to: \.partDataDic,on: self)
            .store(in: &cancellables)
    }
}



protocol  SharedObjectType: AnyObject {
    var objectType: ObjectTypes {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedObjectType {
    func subscribeToService() {
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectType,on: self)
            .store(in: &cancellables)
    }
}


class ObjectDataService {
    @Published var angleMinMaxDic: AngleMinMaxDictionary = [:]
    @Published var objectDimension: Dimension = ZeroValue.dimension
    @Published var objectChainLabelsDefaultDic: ObjectChainLabelsDictionary = [:]
    @Published var postTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    @Published var preTiltObjectToPartFourCornerPerKeyDic:
        CornerDictionary = [:]
    @Published var postTiltObjectToPartOneCornerPerKeyDic:
        PositionDictionary = [:]
    @Published var partDataDic: [Part: PartData] = [:]
    @Published var objectType = ObjectTypes.fixedWheelRearDrive
    
    static let shared = ObjectDataService()
    
    func setMinMaxDic(_ value: AngleMinMaxDictionary) {
        angleMinMaxDic = value
    }
    
    
    func setObjectDimension(_ value: Dimension) {
        objectDimension = value
    }
        
    
    func setObjectChainLabelsDefaultDic(_ value: ObjectChainLabelsDictionary) {

        objectChainLabelsDefaultDic = value
    }
    
    
    func setObjectType(_ value: ObjectTypes) {
        objectType = value
    }
    
    
    func setPartDataDic(_ value: [Part: PartData] = [:]) {
        partDataDic = value
    }
    
    
    func setPostTiltObjectToPartFourCornerPerKeyDic( _ value: CornerDictionary) {
        postTiltObjectToPartFourCornerPerKeyDic = value
    }
    
    
    func setPreTiltObjectToPartFourCornerPerKeyDic(_ value: CornerDictionary) {
        preTiltObjectToPartFourCornerPerKeyDic = value
    }
    
    
    func setPostTiltObjectToPartOneCornerPerKeyDic(_ value: PositionDictionary) {
        postTiltObjectToPartOneCornerPerKeyDic = value
    }
}



class ObjectImageService {
    @Published var objectImageData: ObjectImageData = ObjectImageData(
        .fixedWheelRearDrive,
        nil
    )
    static let shared = ObjectImageService()
    
   
    func setObjectImage(_ objectImageData: ObjectImageData) {

        self.objectImageData = objectImageData
    }
}

