//
//  MovementService.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import Combine

protocol  SharedStaticPoint: AnyObject {
    var staticPoint: PositionAsIosAxes {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedStaticPoint {
    func subscribeToService() {
        MovementEditService.shared.$staticPoint
            .receive(on: DispatchQueue.main)
            .assign(to: \.staticPoint,on: self)
            .store(in: &cancellables)
    }
}


protocol  SharedObjectAngles: AnyObject {
    var endAngle: Double {get set}
    var startAngle: Double {get set}
  
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedObjectAngles {
    func subscribeToService() {
        MovementEditService.shared.$endAngle
            .receive(on: DispatchQueue.main)
            .assign(to: \.endAngle,on: self)
            .store(in: &cancellables)
 
        MovementEditService.shared.$startAngle
            .receive(on: DispatchQueue.main)
            .assign(to: \.startAngle,on: self)
            .store(in: &cancellables)
    }
}


protocol SharedObjectAngleType: AnyObject {
         var objectAngleType: WhichAngle {get set}
         var cancellables: Set<AnyCancellable> { get set }
    }
extension SharedObjectAngleType {
    func subscribeToService() {
        MovementEditService.shared.$objectAngleType
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectAngleType,on: self)
            .store(in: &cancellables)
    }
}

protocol SharedObjectImageDataFunc: AnyObject {
    var objectImageData: ObjectImageData { get set}
    func setMovementImageData()
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedObjectImageDataFunc {
    func subscribeToService() {
        ObjectImageService.shared.$objectImageData
            .sink { [weak self] newData in
                self?.objectImageData = newData
                //update movement if objectData changes
                self?.setMovementImageData()
            }
            .store(
                in: &cancellables
            )
    }
}


protocol SharedSetMovementImageDataFuncOnly {
    var objectImageData: ObjectImageData { get }
    var movementType: Movement { get }
    var staticPoint: PositionAsIosAxes { get }
    var startAngle: Double { get }
    var endAngle: Double { get }
    var forward: Double { get }

    func setMovementImageData()
}

extension SharedSetMovementImageDataFuncOnly {
    func setMovementImageData() {
        MovementImageService.shared.setMovementImageData(
            objectImageData,
            movementType,
            staticPoint,
            startAngle,
            endAngle,
            forward
        )
    }
}

protocol SharedMovementImageData: AnyObject {
    var movementImageData: MovementImageData {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedMovementImageData {
    func subscribeToService() {
        MovementImageService.shared.$movementImageData
            .receive(on: DispatchQueue.main)
            .assign(to: \.movementImageData,on: self)
            .store(in: &cancellables)
    }
}


class MovementImageService {
    @Published var movementImageData: MovementImageData = MovementImageData (
        ObjectImageService.shared.objectImageData,//object data
        movementType: .turn, //transform data
        staticPoint: ZeroValue.iosLocation, //transform data
        startAngle: 0.0, //transform data
        endAngle: 0.0, //transform data
        forward: 0.0 //transform data
    )
    
    static let shared = MovementImageService()

    func setMovementImageData(
        _ objectImageData: ObjectImageData,
        _ movementType: Movement,
        _ staticPoint: PositionAsIosAxes,
        _ startAngle: Double,
        _ endAngle: Double,
        _ forward: Double ) {
          //  print("set MovementImageService")
            movementImageData =
            MovementImageData (
                objectImageData,//object data
                movementType: movementType, //transform data
                staticPoint: staticPoint, //transform data
                startAngle: startAngle, //transform data
                endAngle: endAngle, //transform data
                forward: forward //transform data
                )
    }
}



protocol  SharedMovementType: AnyObject {
    var movementType: Movement {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedMovementType {
    func subscribeToService() {
        MovementEditService.shared.$movementType
            .receive(on: DispatchQueue.main)
            .assign(to: \.movementType,on: self)
            .store(in: &cancellables)
    }
}

class MovementEditService {
    @Published var movementType: Movement = .none
    @Published var staticPoint = ZeroValue.iosLocation
    @Published var endAngle = 30.0
    @Published var startAngle = 0.0
    @Published var objectAngleType: WhichAngle = .end
    @Published var forward = 0.0
    static let shared = MovementEditService()
    
    func setMovmentTypeToNone(){
        movementType = .none
    }
    
    func setMovmentTypeToTurn(){
        movementType = .turn
    }
    
    func setMovementTypeToForward(){
//        movementType = .linear
    }
    
    func setMovementType(_ value: Movement) {
        movementType = value
    }
    
    func setStaticPoint(_ value: PositionAsIosAxes) {
        staticPoint = value
    }
    
    func setEndAngle(_ value: Double) {
        
        endAngle = value
    }
    
    
    func setStartAngle(_ value: Double) {
        startAngle = value
    }
    
    func setObjectAngleType(_ value: WhichAngle) {
        objectAngleType = value
    }
}



class MovementDataService {
    @Published var uniquePartNames: [String] = []
    @Published var preTiltObjectToPartFourCornerDictionary: CornerDictionary = [:]
    @Published var dictionaryForScreen: CornerDictionary = [:]
    @Published var maximumnDimensionOfMotion = 0.0
    @Published var objectFrameSize: Dimension = ZeroValue.dimension
    
    static let shared = MovementDataService()
    
    func setDictionaryForScreen(_ value: CornerDictionary) {
        dictionaryForScreen = value
    }
    
    
    func setMaximumDimensionOfMotion(_ value: Double) {
        maximumnDimensionOfMotion = value
    }
        
    
    func setObjectFrameSize(_ value: Dimension) {
        objectFrameSize = value
    }
    
    
    func setPreTiltObjectToPartFourCornerDictionary( _ value: CornerDictionary) {
        preTiltObjectToPartFourCornerDictionary = value
    }
    
    
    func setUniquePartNames(_ value: [String]) {
        uniquePartNames = value
    }
    
    
    
}


class MovementDictionaryForScreenService {
    @Published var movementDictionaryForScreen: CornerDictionary = [:]
    static let shared = MovementDictionaryForScreenService()
    
    
    func setMovementDictionaryForScreen(_ dic: CornerDictionary) {
        movementDictionaryForScreen = dic
    }
}


protocol SharedMovementDictionaryForScreen: AnyObject {
    var movementDictionaryForScreen: CornerDictionary {get set}
    var cancellables: Set<AnyCancellable> { get set }
}
extension SharedMovementDictionaryForScreen {
    func subscribeToService() {
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .receive(on: DispatchQueue.main)
            .assign(to: \.movementDictionaryForScreen, on: self)
            .store(in: &cancellables)
    }
}





protocol SharedObjectZeroStaticPointAtMovementFrameCenter: AnyObject {
    var objectZeroStaticPointAtMovementFrameCenter: ObjectZeroStaticPointAtMovementFrameCenter {get set}
    var cancellables: Set<AnyCancellable> {get set}
}
extension SharedObjectZeroStaticPointAtMovementFrameCenter {
    func subscribeToService() {
        ObjectZeroStaticPointAtMovementFrameCenterService.shared.$objectZeroStaticPointAtMovementFrameCenter
            .receive(on: DispatchQueue.main)
            .assign(to: \.objectZeroStaticPointAtMovementFrameCenter, on: self)
            .store(in: &cancellables)
    }
}
class ObjectZeroStaticPointAtMovementFrameCenterService {
    @Published var objectZeroStaticPointAtMovementFrameCenter: ObjectZeroStaticPointAtMovementFrameCenter = ObjectZeroStaticPointAtMovementFrameCenter(
            MovementImageService.shared.movementImageData,           ScaleService.shared.scale)//?
    
    static let shared = ObjectZeroStaticPointAtMovementFrameCenterService()
    
    
    func setObjectZeroStaticPointAtMovementFrameCenter(_ newData: ObjectZeroStaticPointAtMovementFrameCenter) {
    
        self.objectZeroStaticPointAtMovementFrameCenter = newData
    }
}
