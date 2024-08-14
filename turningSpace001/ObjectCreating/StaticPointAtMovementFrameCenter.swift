//
//  StaticPointAtMovementFrameCenter.swift
//  turningSpace001
//
//  Created by Brian Abraham on 14/08/2024.
//

import Foundation


struct ObjectZeroStaticPointAtMovementFrameCenter {
    let movementImageData: MovementImageData
    let scale0: Double
    var ensureInitialObjectAllOnScreen: EnsureNoNegativePositions
    var movementDictionaryForScreen: CornerDictionary = [:]
    var dataToCentreObjectZeroOrigin: AddOrPad = (
         addX: 0.0,
         addY: 0.0,
         padX: 0.0,
         padY: 0.0
     )
  //  var staticPoint: PositionAsIosAxes = ZeroValue.iosLocation
    var objectZeroOrigin = ZeroValue.iosLocation
    var uniqueCanvasNames: [String] = [
        PartTag.canvas.rawValue + PartTag.origin.rawValue,
        PartTag.canvas.rawValue + PartTag.corner.rawValue
    ]
    var onScreenMovementFrameSize: Dimension = ZeroValue.dimension
    
    init(
        _ movementImageData: MovementImageData,
        _ scale: Double
    ) {
       
            self.movementImageData = movementImageData
            self.scale0 = scale
        
       ensureInitialObjectAllOnScreen = EnsureNoNegativePositions(
        fourCornerDic: [:],
        objectDimension: ZeroValue.dimension,
        scale: scale0
       )// required to avoid self not intialised
        ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        
        movementDictionaryForScreen = getMovementDictionaryForScreen()

        objectZeroOrigin = getStaticPointPosition(
            movementDictionaryForScreen
        )
       
        let staticPointOriginInitial = getStaticPointPosition(
            movementDictionaryForScreen
        )
        
        let dataWithStaticPointAtMovementFrameCentre
         = setDataSoStaticPointAtMovementFrameCenter(
            staticPointOriginInitial
        )
        
        movementDictionaryForScreen =
            transformSoStaticPointInMovementFrameCenter(
                dataWithStaticPointAtMovementFrameCentre
            )

        let staticPointOriginAfterDataTransformation = getStaticPointPosition(
            movementDictionaryForScreen
        )


        movementDictionaryForScreen = addCanvasOriginToDictionary()
        
        movementDictionaryForScreen = addCanvasCornerToDictionary(
            staticPointOriginAfterDataTransformation
        )
        
//        staticPoint = translateStaticPointForCentreObjectZeroOrigin(
//            dataToCentreObjectZeroOrigin
//        )
        
        onScreenMovementFrameSize = getObjectOnScreenFrameSize(
            movementDictionaryForScreen
        )
    }
    

    func getMakeWholeObjectOnScreen()
        -> EnsureNoNegativePositions {
            let objectDimension: Dimension =
                getObjectDimension()
            let fourCornerDic: CornerDictionary =
                getPostTiltObjectToPartFourCornerPerKeyDic()
            return
                EnsureNoNegativePositions(
                    fourCornerDic: fourCornerDic,
                    objectDimension: objectDimension,
                    scale: scale0
                )
    }
    
    func getObjectDimension ( )
        -> Dimension {
            movementImageData.objectImageData.objectDimension
    }
    
    
    func getPostTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
        movementImageData.objectImageData.postTilt.objectToPartFourCornerPerKeyDic
    }

    
    func getPreTiltObjectToPartFourCornerPerKeyDic() -> CornerDictionary {
        movementImageData.objectImageData.preTilt.objectToPartFourCornerPerKeyDic
    }

    
   mutating func  getMovementDictionaryForScreen ()
        -> CornerDictionary {
        ensureInitialObjectAllOnScreen = getMakeWholeObjectOnScreen()
        let dic =
            ensureInitialObjectAllOnScreen.getModifiedDictionary()
          
        return dic
    }
    
    
    func getOffsetToKeepObjectOriginStaticInLengthOnScreen() -> Double{
            ensureInitialObjectAllOnScreen
                .getOffsetToKeepObjectOriginStaticInLengthOnScreen()
    }
    
    func getObjectOnScreenFrameSize (_ dic: CornerDictionary)
    -> Dimension {
        FourCornerDictionryTo(dic).valueSize
    }

    
    ///the data is orgainised so that no matter what edits occur the objectZero origin
    ///remains at the data center and hence the View center and hence
    ///as edits occur objectZero origin is static on the screen view
    ///This avoids the need to have View code which determines the objectZero screen origin position
    ///an manipulate the View to keep that point static
    mutating func transformMovementDictionaryForScreenToCentreObjectZeroOrigin(){
        let addTouple = (x: dataToCentreObjectZeroOrigin.addX, y: dataToCentreObjectZeroOrigin.addY,z: 0.0)
        
        for (key, _) in movementDictionaryForScreen {
            if let value = movementDictionaryForScreen[key] {
                movementDictionaryForScreen[key] = CreateIosPosition.addToupleToArrayOfTouples(addTouple, value)
            }
        }
    }
    
    func getOffsetForObjectOrigin() -> PositionAsIosAxes {
        let oneCornerDic = ConvertFourCornerPerKeyToOne(fourCornerPerElement: movementDictionaryForScreen).oneCornerPerKey
        let minThenMax =
            CreateIosPosition
               .minMaxPosition(
                   oneCornerDic
                   )
        //the minimum values of the translated object is the offset for all part positions including origin
        return
            CreateIosPosition.negative(minThenMax[0])
        
        
    }
    
//    func getUniquePartNamesFromObjectDictionary() -> [String] {
//        let dic = getPostTiltObjectToPartFourCornerPerKeyDic()
//      
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
    
    
    func getDictionaryMaxForScreenDictionary() -> PositionAsIosAxes{
        let dic = ConvertFourCornerPerKeyToOne(
            fourCornerPerElement: movementDictionaryForScreen
        ).oneCornerPerKey
        
        let minMax = CreateIosPosition.minMaxPosition(
            dic
        )
        let onlyMax = 1
        let max = minMax[onlyMax]
        
        return max
    }
    

    
    func setDataSoStaticPointAtMovementFrameCenter(
        _ objectZeroOrigin: PositionAsIosAxes
    ) -> AddOrPad {// move object to add space or pad with space

        let max = getDictionaryMaxForScreenDictionary() //minMax[1]
        var padX = 0.0
        var padY = 0.0
        var addX = 0.0
        var addY = 0.0
        //print("struct \(max)\n")
        (
            addX,
            padX
        ) = getCorrections(
            max.x,
            objectZeroOrigin.x
        )
        (
            addY,
            padY
        ) = getCorrections(
            max.y,
            objectZeroOrigin.y
        )
      
        return (addX: addX, addY: addY, padX: padX, padY: padY )
        
        func getCorrections(
            _ max: Double,
            _ origin: Double
        ) -> (
            Double,
            Double
        ) {
            //print("struct \(origin)\n")
            var pad = max
            var translate = 0.0
            switch (
                max,
                origin
            ) {
            case let (
                max,
                origin
            ) where max > 2 * origin:
                translate = max - 2 * origin
            case let (
                max,
                origin
            ) where max < 2 * origin:
                pad = 2 * origin
            case let (
                max,
                origin
            ) where max == origin:
                break
                //do nothing
            default:
                break
            }
            
           // print("struct \(translate) \(pad) \n")
            return (
                translate,
                pad
            )
        }
        
    }

    
    func getStaticPointPosition(_ dic: CornerDictionary)  -> PositionAsIosAxes{
        let useAnyOfFour = 0
        var origin: PositionAsIosAxes = ZeroValue.iosLocation
        if let data = movementDictionaryForScreen["staticPoint_id0_"] {
            origin = data[0]
        } else {
            //if no turn, use object origin
            let name = CreateNameFromIdAndPart(.id0, PartTag.origin).name
            let filteredDictionary =
            dic.filter { $0.key.contains(name) }
            
            guard let origin = filteredDictionary[name]?[useAnyOfFour] else {
                print(dic)
                fatalError()
            }
        }
      
        return origin
    }

    
    func getTranslationToCentreObjectZeroOrigin() -> PositionAsIosAxes {
        (dataToCentreObjectZeroOrigin.addX, y: dataToCentreObjectZeroOrigin.addY, z: 0.0)
    }
    
//  
//    mutating func translateStaticPointForCentreObjectZeroOrigin(_ translation: AddOrPad) -> PositionAsIosAxes {
//        let translation = (dataToCentreObjectZeroOrigin.addX, y: dataToCentreObjectZeroOrigin.addY, z: 0.0)//getTranslationToCentreObjectZeroOrigin()
//       staticPoint = CreateIosPosition.addTwoTouples(translation, staticPoint)
//        
//        return staticPoint
//    }
    
    
    func transformSoStaticPointInMovementFrameCenter(_ translation: AddOrPad) -> CornerDictionary {
        var dic: CornerDictionary = [:]
        let translation = (translation.addX, y: translation.addY, z: 0.0)//getTranslationToCentreObjectZeroOrigin()
                for (key, value) in movementDictionaryForScreen {
                    let currentValue = value
                    let newValue =
                        CreateIosPosition.addToupleToArrayOfTouples(translation, currentValue)
                    dic[key] = newValue
                }
        return dic
    }
    
    
    mutating func addCanvasCornerToDictionary(_ objectZeroOrigin: PositionAsIosAxes) -> CornerDictionary{
        
        let canvasCornerName = uniqueCanvasNames[1]
        let origin = getCanvasOrigin()
        let data = setDataSoStaticPointAtMovementFrameCenter(objectZeroOrigin)
        let corner = (x: data.padX, y: data.padY, z: 0.0)
        let corners = CreateIosPosition.addToupleToArrayOfTouples(corner, origin)
//print("struct \(origin) \(data) ")
//        print("struct \(corners) \(canvasCornerName)")
        movementDictionaryForScreen[canvasCornerName] = corners
        
        return movementDictionaryForScreen
    }
    
    func getCanvasOrigin() -> [PositionAsIosAxes] {
        let size = 0.5
        return
            [(x: 0.0, y: 0.0, z: 0.0), (x: size, y: 0.0, z: 0.0), (x: size, y: size, z: 0.0), (x: 0.0, y: size, z: 0.0)]
    }
    
    
    mutating func addCanvasOriginToDictionary() -> CornerDictionary{
        let canvasOriginName = uniqueCanvasNames[0]

       movementDictionaryForScreen[canvasOriginName] = getCanvasOrigin()
        
        return movementDictionaryForScreen

    }
}


