//
//  ObjectAndRulerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 12/04/2024.
//

import Foundation
import Combine



class ObjectAndRulerViewModel: ObservableObject {
    @Published var defaultScale = 0.0
    @Published var measurementScale = 0.0

    var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    var objectZeroStaticPointAtMovementFrameCenter: ObjectZeroStaticPointAtMovementFrameCenter = ObjectZeroStaticPointAtMovementFrameCenterService.shared.objectZeroStaticPointAtMovementFrameCenter
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        ObjectZeroStaticPointAtMovementFrameCenterService.shared.$objectZeroStaticPointAtMovementFrameCenter
            .receive(on: DispatchQueue.main)
            .sink { [weak self] new in
                self?.objectZeroStaticPointAtMovementFrameCenter = new
                self?.onScreenMovementFrameSize = new.onScreenMovementFrameSize
                self?.updateScales()
            }
            .store(in: &cancellables)
    }
    
    
    func updateScales(){
        let maximumnDimensionOfMotion  = getMaximumDimensionOfMotion()
        defaultScale = Screen.smallestDimension/maximumnDimensionOfMotion
        measurementScale = Screen.smallestDimension/maximumnDimensionOfMotion
        
        func getMaximumDimensionOfMotion() -> Double {
            onScreenMovementFrameSize.length > onScreenMovementFrameSize.width ?         onScreenMovementFrameSize.length :         onScreenMovementFrameSize.width
        }
    }
}
//gets the picked movement
//provides the raw data from movmentImageData
//commits to the service
//class ObjectAndRulerViewModel2: ObservableObject {
//    @Published var maximumnDimensionOfMotion = 0.0
//    @Published var movementDictionaryForScreen: CornerDictionary =
//        MovementDictionaryForScreenService.shared.movementDictionaryForScreen
//    @Published var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
//    @Published var recenter = RecenterObjectsOnScreenService.shared.recenter
//    var movementImageData: MovementImageData =
//        MovementImageService.shared.movementImageData
//    var uniquePartNames: [String] = []
//
//    private var cancellables: Set<AnyCancellable> = []
//    
//    init(){
//        RecenterObjectsOnScreenService.shared.$recenter
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.recenter,on: self)
//            .store(in: &cancellables)
//        
//        MovementImageService.shared.$movementImageData
//            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
//            .sink { [weak self] newData in
//                guard let self = self else { return }
//                self.movementImageData = newData
//                // Call methods to update related data
//                self.updateData()
//                self.maximumnDimensionOfMotion = getMaximumDimensionOfMotion()
//            }
//            .store(in: &cancellables)
//        
//        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
//            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
//            .sink { [weak self] newData in
//                guard let self = self else { return }
//                self.movementDictionaryForScreen = newData
//                // Call methods to update related data
//                self.updateData()
//                self.maximumnDimensionOfMotion = getMaximumDimensionOfMotion()
//            }
//            .store(in: &cancellables)
//
//        updateData()
//        
//    }
//    
//    
//    private func updateData() {
//        uniquePartNames = getUniquePartNamesFromObjectDictionary()
//        
//        preTiltObjectToPartFourCornerPerKeyDic = getPreTiltObjectToPartFourCornerPerKeyDic()
//    }
//    
//    
//    func getPreTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
//        movementImageData.objectImageData.preTilt.objectToPartFourCornerPerKeyDic
//    }
//    
//    
//    func getUniquePartNamesFromObjectDictionary() -> [String] {
//        let dic = movementImageData.objectImageData.postTilt.objectToPartFourCornerPerKeyDic
//        let names =
//        Array(
//            dic.keys
//        ).filter {
//            !(
//                $0.contains(
//                    PartTag.arcPoint.rawValue //UI manages differently from parts
//                )  || $0.contains(
//                    PartTag.origin.rawValue// ditto
//                )  || $0.contains(
//                    PartTag.staticPoint.rawValue// ditto
//                ) //|| $0.contains(
//                    //Part.stabiliser.rawValue// fixed wheel edits this
//               // )
//            ) }
//      
//        return names
//    }
//    
//    
//    func getMaximumDimensionOfMotion() -> Double {
//        if movementDictionaryForScreen .isEmpty {
//            return 0.0
//            
//        } else {
//            let dic =  ConvertFourCornerPerKeyToOne(
//                fourCornerPerElement: movementDictionaryForScreen).oneCornerPerKey
//            
//            let minMax = CreateIosPosition.minMaxPosition(dic)
//            
//            let motionDimension =
//            CreateIosPosition.convertMinMaxToDimension(minMax)
//            
//            return motionDimension.width > motionDimension.length ? motionDimension.width: motionDimension.length
//        }
//    }
//}
//    

