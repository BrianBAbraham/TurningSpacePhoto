//
//  MovementImageData.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/04/2024.
//

import Foundation

///create duplicates of ObjectImageData
///renaming object with index as required
struct MovementImageData {
    var objectImageData: ObjectImageData
    let staticPoint: PositionAsIosAxes
    let startAngle: Double
    let endAngle: Double
    let angleChange: Double
    
    init(
        _ objectImageData: ObjectImageData,
        movementType: Movement,
        staticPoint: PositionAsIosAxes,
        startAngle: Double,
        endAngle: Double,
        forward: Double ){
            
        self.objectImageData = objectImageData
        self.staticPoint = staticPoint
        self.startAngle = startAngle
        self.endAngle = endAngle
        angleChange = endAngle - startAngle
            
        switch movementType {
        case .none:
            return
        case .linear:
            translateObject(1,
                            (x: 0.0, y: 1000.0, z: 0.0))
        case .turn:
            for index in 0...1 {
                let newObjectId = index
                let rotationAngle = Measurement(
                    value: [startAngle, angleChange][index],
                    unit: UnitAngle.degrees
                )
                
                updateDicForStaticPoint(index, staticPoint)
              
                rotateObject(
                    newObjectId,
                    rotationAngle,
                    staticPoint
                )
                
                updateOneCornerPerKeyDictionary()
            }
       default:
            return
        }
            
        setSize()
           
    }
    
    
    mutating func updateDicForStaticPoint(_ objectIndex: Int, _ staticPoint: PositionAsIosAxes){
        let name = PartTag.staticPoint.rawValue + "_id" + String(objectIndex) + PartTag.stringLink.rawValue
        
        let p = staticPoint
        
        objectImageData.postTilt.objectToPartFourCornerPerKeyDic[name] = [p,p,p,p]
    }
    

    mutating  func translateObject(_ objectIndex: Int, _ movement: PositionAsIosAxes) {
        for (
            key,
            value
        ) in objectImageData.postTilt.objectToPartFourCornerPerKeyDic {
            objectImageData.postTilt.objectToPartFourCornerPerKeyDic +=
            [ReplaceCharBeforeSecondUnderscore.get(
                in: key,
                with: String(objectIndex)
            ):
                CreateIosPosition.addToupleToArrayOfTouples(
                    (
                        movement
                    ),
                    value
                )]
        }
    }
    
    
    mutating func rotateObject(
        _ objectIndex: Int,
        _ angle: Measurement<UnitAngle>,
        _ staticPoint: PositionAsIosAxes
    ) {
        for (
            key,
            value
        ) in objectImageData.postTilt.objectToPartFourCornerPerKeyDic {
            
            var newValues = rotatePart(
                value,
                angle,
                staticPoint
            )
            
            newValues = CreateIosPosition.addToupleToArrayOfTouples(
                (
                    x: 0.0,
                    y: 0.0,
                    z: 1000.0
                ),
                newValues
            )
            
            objectImageData.postTilt.objectToPartFourCornerPerKeyDic +=
            [ReplaceCharBeforeSecondUnderscore.get(
                in: key,
                with: String(
                    objectIndex
                ) //change name of object
            ):
                newValues
            ]
        }
        
        func rotatePart(
            _ positions: [PositionAsIosAxes],
            _ angle: Measurement<UnitAngle>,
            _ staticPoint: PositionAsIosAxes
        ) -> [PositionAsIosAxes]{
            var rotatedPositions: [PositionAsIosAxes] = []
            for position in positions {
                let rotatedPosition =
                PositionOfPointAfterRotationAboutPoint(
                    staticPoint: (
                        staticPoint
                    ),
                    movingPoint: position,
                    angleChange: angle,
                    rotationAxis: .zAxis
                ).fromObjectOriginToPointWhichHasMoved
                
                rotatedPositions.append(
                    rotatedPosition
                )
            }
            return rotatedPositions
        }
    }
    
    
    mutating func setSize() {
        objectImageData.objectDimension =
        FourCornerDictionryTo(objectImageData.postTilt.objectToPartFourCornerPerKeyDic).valueSize
    }
    
    
    mutating func updateOneCornerPerKeyDictionary() {
        objectImageData.postTilt.objectToOneCornerPerKeyDic =
        ConvertFourCornerPerKeyToOne(
            fourCornerPerElement: objectImageData.postTilt.objectToPartFourCornerPerKeyDic
        ).oneCornerPerKey
    }

    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        
        let names =
        Array(objectImageData.postTilt.objectToOneCornerPerKeyDic.keys)
        
    return names
    }
}



enum Movement: String, CaseIterable {
    case none = "static"
    case linear = "forward"
    case turn = "turn"
    case slalom = "slalom"
    //case t = "T-turn"
    //case incremental = "off wall"
}


//struct IdentifiableDictionary: Identifiable {
//    let id: UUID // Provides a unique identifier for each instance
//    var dictionary: CornerDictionary // Example dictionary, can be of any type
//
//    init(dictionary: CornerDictionary) {
//        self.id = UUID() // Generate a new UUID for each new instance
//        self.dictionary = dictionary
//    }
//}
