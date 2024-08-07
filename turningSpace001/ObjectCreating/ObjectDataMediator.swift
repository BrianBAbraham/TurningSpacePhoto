//
//  ObjectDataMediator.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/06/2024.
//

import Foundation
import Combine


///extract the properties from ObjectImageData and
///publish in ObjectDataService
class ObjectDataMediator: ObservableObject {
    
    private var objectImageData: ObjectImageData = ObjectImageService.shared.objectImageData
    
    private var cancellables: Set<AnyCancellable> = []
    
    let objectDataService = ObjectDataService.shared
    
    static let shared = ObjectDataMediator()
    
    init(){
 
       ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                self?.updateObjectDataService()
            }
            .store(in: &cancellables)
        
    }
    
    func updateObjectDataService() {
  
        objectDataService.setMinMaxDic(objectImageData.angleMinMaxDic)
        
        objectDataService.setObjectDimension(objectImageData.objectDimension)
        
        objectDataService.setObjectChainLabelsDefaultDic(objectImageData.objectChainLabelsDefaultDic)
        
        objectDataService.setPostTiltObjectToPartFourCornerPerKeyDic(objectImageData.postTilt.objectToPartFourCornerPerKeyDic)
        
        objectDataService.setPreTiltObjectToPartFourCornerPerKeyDic(objectImageData.preTilt.objectToPartFourCornerPerKeyDic )
        
        objectDataService.setPostTiltObjectToPartOneCornerPerKeyDic(objectImageData.postTilt.objectToOneCornerPerKeyDic)
        
        objectDataService.setPartDataDic(objectImageData.partDataDic)
    }
}
