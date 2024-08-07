//
//  RulerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import Foundation
import Combine


struct RulerModel {
    let ensureInitialRulerIsOnScreen:
        EnsureNoNegativePositions
    let rulerMarks: CornerDictionary
    var rulerNumbers: PositionDictionary
}







class RightAngleRulerViewModel: ObservableObject {
   
    @Published var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    
    @Published private var rulerModel: RulerModel
    
    @Published var objectName: String = ObjectDataService.shared.objectType.rawValue
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
   
    var unitSystem: UnitSystem = MeasurementSystemService.shared.unitSystem
    let lengthBefore = 170.0//measurement lines
    let lengthAfter = 30.0// measurment lines
    let numberSpan: Double
    let width: Double
  
    let rulerDataBackGround: RulerDataBackground
    var rulerMarks: RulerDataMarks
  

    private var cancellables: Set<AnyCancellable> = []
    
    init(
        _ numberSpan: Double = 3000.0,
        _ width: Double = 170.0
    ) {
        self.numberSpan = numberSpan
        self.width = width
        let rulerLength = lengthBefore + numberSpan + lengthAfter
        
        rulerDataBackGround =
            RulerDataBackground (
                rulerLength: rulerLength,
                rulerWidth: width
            )
        
        let unitSystemInitial = MeasurementSystemService.shared.unitSystem
        
        rulerMarks = RulerDataMarks(
            lengthBefore: lengthBefore,
            numberSpan: numberSpan,
            ruleWidth: width,
            unitSystem: unitSystemInitial
        )
        
        rulerModel = 
            RulerModel(
                ensureInitialRulerIsOnScreen: EnsureNoNegativePositions(
                fourCornerDic: rulerDataBackGround.fourCornerDic,
                objectDimension: rulerDataBackGround.dimension
                ),
                rulerMarks: rulerMarks.getMarksDictionary(),
                rulerNumbers: [:]
        )
        
        ObjectDataService.shared.$objectType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newData in
               // self?.objectType = newData
                self?.objectName = newData.rawValue
            }
            .store(in: &self.cancellables)
        
        
        MeasurementSystemService.shared.$unitSystem
            .sink { [weak self] newData in
                self?.unitSystem = newData
            }
            .store(in: &self.cancellables)
        
        
        MovementImageService.shared.$movementImageData
            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
                self.preTiltObjectToPartFourCornerPerKeyDic = newData.objectImageData.preTilt.objectToPartFourCornerPerKeyDic
               
            }
            .store(in: &cancellables)
        
        
        updateDependentProperties()
    }
    
    
  func updateDependentProperties() {
//        print("ruler update")
      self.rulerMarks = RulerDataMarks(
        lengthBefore: lengthBefore,
        numberSpan: numberSpan,
        ruleWidth: width,
        unitSystem: unitSystem
      )

      self.rulerModel = RulerModel(
          ensureInitialRulerIsOnScreen: EnsureNoNegativePositions(
              fourCornerDic: rulerDataBackGround.fourCornerDic,
              //oneCornerDic: rulerDataBackGround.oneCornerDic,
              objectDimension: rulerDataBackGround.dimension
          ),
          rulerMarks: self.rulerMarks.getMarksDictionary(),
          rulerNumbers: [:]
      )
      
      switch unitSystem {
      case .cm, .mm:
          rulerModel.rulerNumbers = createMetricNumberDictionary()
      case .imperial:
          rulerModel.rulerNumbers = createImperialNumberDictionary()
      }
    }
    
    
    func getDictionaryForScreen() -> CornerDictionary {
        rulerModel.ensureInitialRulerIsOnScreen.fourCornerDic
    }
    
    
    func getCorners() -> [CGPoint] {
        let dic = getDictionaryForScreen()
        let dictionaryElementIn = DictionaryElementIn(
            dic,
            ""
        )
        return dictionaryElementIn.cgPointsOut()
    }
    
    
    func getRulerFrameSize() -> Dimension {
        let frameSize = rulerModel.ensureInitialRulerIsOnScreen.objectDimension
        return frameSize
    }
    
    
    func getRulerMarks() -> CornerDictionary{
        rulerModel.rulerMarks
    }
    
    
    func getNumberDictionary() -> PositionDictionary {
        rulerModel.rulerNumbers

    }
    
    
    func createMetricNumberDictionary() -> PositionDictionary{
        let dictionary = getRulerMarks()
        var labelDictionary: PositionDictionary = [:]

        let unitCorrection = unitSystem == UnitSystem.mm ? 1: 10
        for (key, value) in dictionary {
            if !key.contains(Level.tertiary.rawValue)  && !key.contains(Level.halfSecondary.rawValue){
              
                let value = value[0].y
                let numberName = String(Int(value - lengthBefore)/unitCorrection)
                labelDictionary += [numberName: (x: width/2.0, y: value, z: RulerDataMarks.rulerPositionOnZ)]
            }
        }
       return labelDictionary
    }
    
    
    func createImperialNumberDictionary() -> PositionDictionary{
        let dictionary = getRulerMarks()//number name locations
        var nameDictionary: PositionDictionary = [:]

        for (key, value) in dictionary {
            if (key.contains(Level.primary.rawValue) || //12"
                key.contains(Level.secondary.rawValue)) //6"
                && value[0].x == 0.0 { //line has 2 values, use 1
                let value = value[0].y // y is source of name
                let numberName = //string from y value
                String(Int(((value - lengthBefore) / 25.4 ).rounded()))
                nameDictionary += [numberName: (x: width/2.0, y: value, z: RulerDataMarks.rulerPositionOnZ)]
            }
        }
       return nameDictionary
    }
}


struct RulerDataMarks {
    
    let lengthBefore: Double
    let numberSpan: Double
    let ruleWidth: Double
    let unitSystem: UnitSystem
    var widthIndices: [Int] {
        (0..<10).map { $0 }
    }
    static let rulerPositionOnZ = 1000.0

    
  
    
    func getMarksDictionary() -> CornerDictionary{
        var dictionary: CornerDictionary = [:]
        addToDictionary(getPositions(.tertiary), .tertiary)
        addToDictionary(getPositions(.secondary), .secondary)
        addToDictionary(getPositions(.halfSecondary), .halfSecondary)
        addToDictionary(getPositions(.primary), .primary)

        return dictionary
        
        func addToDictionary(_ positions: [[PositionAsIosAxes]], _ level: Level){
            for i in 0..<positions.count {
                dictionary += [String(i) + level.rawValue: positions[i]]
            }
        }
    }
    
    
    func getPositions(_ level: Level) -> [[PositionAsIosAxes]]{
              var valuesForY: [Double]
        switch unitSystem {
        case .cm, .mm:
            valuesForY = getValuesForMetricY(level)
        case .imperial:
            valuesForY = getValuesForImperialY(level)
        }
        
        let valuesForX = getValuesForX(level)
        var positions: [[PositionAsIosAxes]] = []
        let rulerZ = Self.rulerPositionOnZ
        for y in 0..<valuesForY.count {
            for x in [0,2] {
                positions.append(
                    [(
                        x: valuesForX[x],
                        y: valuesForY[y],
                        z: rulerZ),
                     (
                        x: valuesForX[x + 1],
                        y: valuesForY[y],
                        z: rulerZ) ]
                )
            }
          }
            return positions
    }
    

    
    func getValuesForX(_ level: Level) -> [Double]{
        let stepForX = ruleWidth/18.0
        switch level {
        case .primary:
            return
                getValuesForX([0, 6, 12, 18])
        case .secondary:
            return
                getValuesForX([0, 4, 14, 18])
        case .halfSecondary:
            return
                getValuesForX([0, 3, 15, 18])
        case .tertiary:
            return
                getValuesForX([0, 2, 16, 18])
        }
        
        func getValuesForX(_ indices: [Int] ) -> [Double] {
            indices.map {Double($0) * stepForX }
        }
    }
    
    
    func getValuesForMetricY( _ level: Level) -> [Double]{
        var division: Double
        switch level {
        case .primary:
            division = 1000
        case .secondary:
            division = 100
        case .halfSecondary:
            division = 50
        case .tertiary:
            division = 10
        }
        
        var valuesForY: [Double] = []
        let numberOfDivisions = Int(numberSpan/division)
        for i in 0...numberOfDivisions {
            let positionY = Double(i) * division + lengthBefore
            valuesForY.append(positionY)
        }
        
        return valuesForY
    }
    
    
    func getValuesForImperialY( _ level: Level) -> [Double]{
        var division: Double
        switch level {
        case .primary:
            division = convertInchesToMillimeters(12)
        case .secondary:
            division = convertInchesToMillimeters(6)
        case .halfSecondary:
            division = convertInchesToMillimeters(1)
        case .tertiary:
            division = convertInchesToMillimeters(0.25)
        }
        
        var valuesForY: [Double] = []
       
        let numberOfDivisions = Int(numberSpan/division)
        for i in 0...numberOfDivisions {
            let positionY = Double(i) * division + lengthBefore
            valuesForY.append(positionY)
        }
        
        return valuesForY
        
        
        func convertInchesToMillimeters(_ inches: Double) -> Double {
            let measurementInInches = Measurement(value: inches, unit: UnitLength.inches)
            let measurementInMillimeters = measurementInInches.converted(to: .millimeters)
            return measurementInMillimeters.value
        }
    }
}


struct RulerDataBackground {
    let rulerLength: Double
    let rulerWidth: Double
    var fourCornerDic: CornerDictionary {
        getDictionary()
    }
    var oneCornerDic: PositionDictionary {
        ConvertFourCornerPerKeyToOne(fourCornerPerElement:  fourCornerDic).oneCornerPerKey
    }
    var dimension: Dimension {
        (width: rulerWidth, length: rulerLength)
    }
        
        func getDictionary() -> CornerDictionary {
            let rulerOnTop = 1000.0
            let outline = [
                ZeroValue.iosLocation,
                (x: rulerWidth, y: 0, z: rulerOnTop),
                (x: rulerWidth, y: rulerLength, z: rulerOnTop),
                (x: 0, y: rulerLength, z: rulerOnTop)
            ]
            return
                ["": outline]
        }
}

///rulers have different levels of marks indicating mearurement division
enum Level: String {
    case primary = "p"
    case halfSecondary = "h"
    case secondary = "s"
    case tertiary = "t"
}
