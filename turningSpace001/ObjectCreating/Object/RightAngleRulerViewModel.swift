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
    let rulerMarksDic: CornerDictionary
    var rulerNumbers: PositionDictionary
}


class RightAngleRulerViewModel: ObservableObject {

    @Published var preTiltObjectToPartFourCornerPerKeyDic: CornerDictionary = [:]
    @Published var rulerFrameSize = ZeroValue.dimension
    @Published var numberDictionary: PositionDictionary = [:]
    @Published var rulerMarksDic: CornerDictionary = [:]
    @Published var rulerPartAllCGPoint: [CGPoint] = []
    
    var rulerModel: RulerModel
    var unitSystem: UnitSystem = MeasurementSystemService.shared.unitSystem
    let lengthBefore = 170.0//measurement lines
    let lengthAfter = 30.0// measurment lines
    let numberSpan: Double
    let width: Double
    var rulerPartData: RulerPartData
    var rulerDataMarks: RulerDataMarks
    var rulerLength = 0.0
    var scale: Double = ScaleService.shared.scale
    

    internal var cancellables: Set<AnyCancellable> = []
    
    init(
        _ numberSpan: Double = 1000.0,
        _ width: Double = 170.0
    ) {
        
        self.numberSpan = numberSpan
        self.width = width
        rulerLength = lengthBefore + numberSpan + lengthAfter
        
        rulerPartData =
            RulerPartData (
                rulerLength: rulerLength * scale,
                rulerWidth: width * scale
            )
       
        
        let unitSystemInitial = MeasurementSystemService.shared.unitSystem
        
        rulerDataMarks = RulerDataMarks(
            lengthBefore: lengthBefore * scale,
            numberSpan: numberSpan * scale ,
            ruleWidth: width * scale,
            unitSystem: unitSystemInitial
        )
        
        rulerModel =
            RulerModel(
                ensureInitialRulerIsOnScreen: EnsureNoNegativePositions(
                fourCornerDic: rulerPartData.rulerPartDatafourCornerDic,
                objectDimension: rulerPartData.dimension,
                scale: scale),
                rulerMarksDic: rulerDataMarks.getMarksDictionary(),
                rulerNumbers: [:]
        )
        
        ScaleService.shared.$scale
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newData in
                    guard let self else {return}
                    self.scale = newData
                    print("SCAL:E MODIFIRED to \(newData)")
                    self.updateDependentProperties(newData)
                }
                .store(in: &self.cancellables)
        
        
        MeasurementSystemService.shared.$unitSystem
            .sink { [weak self] newData in
                self?.unitSystem = newData
            }
            .store(in: &self.cancellables)
        
        updateDependentProperties(scale)

    }
//    
//    func updateRulerDataBackground(_ rulerLength: Double) {
//        rulerDataBackGround =
//            RulerDataBackground (
//                rulerLength: rulerLength * scale,
//                rulerWidth: width * scale
//            )
//    }
    
//    
//    func createRulerModel(_ scale: Double) {
//        rulerModel =
//            RulerModel(
//                ensureInitialRulerIsOnScreen: EnsureNoNegativePositions(
//                fourCornerDic: rulerDataBackGround.fourCornerDic,
//                objectDimension: rulerDataBackGround.dimension,
//                scale: scale),
//                rulerMarksDic: rulerDataMarks.getMarksDictionary(),
//                rulerNumbers: [:]
//        )
//    }
    
    
    func updateDependentProperties(_ scale: Double) {
        print("scale at update \(scale)")
        rulerPartData =
            RulerPartData (
                rulerLength: rulerLength * scale,
                rulerWidth: width * scale
            )

      self.rulerDataMarks = RulerDataMarks(
        lengthBefore: lengthBefore * scale,
        numberSpan: numberSpan * scale,
        ruleWidth: width * scale,
        unitSystem: unitSystem
      )
     
      var rulerNumbers: PositionDictionary
      
      switch unitSystem {
      case .cm, .mm:
          rulerNumbers = createMetricNumberDictionary()
      case .imperial:
          rulerNumbers = createImperialNumberDictionary()
      }
      
      updateRulerModel(rulerNumbers)
      
      func updateRulerModel(_ rulerNumbers: PositionDictionary) {
          print("scale input into ruler model \(scale)")
          
          self.rulerModel = RulerModel(
            ensureInitialRulerIsOnScreen: EnsureNoNegativePositions(
                fourCornerDic: rulerPartData.rulerPartDatafourCornerDic,
                objectDimension: rulerPartData.dimension,
                scale: scale
            ),
            rulerMarksDic: self.rulerDataMarks.getMarksDictionary(),
            rulerNumbers: rulerNumbers
          )
      }
      
      rulerMarksDic = rulerModel.rulerMarksDic
      
      rulerPartAllCGPoint = getPartCorners()
  
      rulerFrameSize = getRulerFrameSize()

      numberDictionary = rulerModel.rulerNumbers
    }
    
    
//    func getDictionaryForScreen() -> CornerDictionary {
//        rulerModel.ensureInitialRulerIsOnScreen.fourCornerDic
//    }
    
    
    func getPartCorners() -> [CGPoint] {
        let dic = rulerModel.ensureInitialRulerIsOnScreen.fourCornerDic
        //print(dic  )
        let dictionaryElementIn = DictionaryElementIn(
            dic,
            ""
        )
        let points = dictionaryElementIn.cgPointsOut()
        
        print(points)
    return points
    }
    
    
    func getRulerFrameSize() -> Dimension {
        let frameSize = rulerModel.ensureInitialRulerIsOnScreen.objectDimension
        
        print("\nframe size \(frameSize)\n")
        return frameSize
    }
    
//    
//    func getRulerMarks() -> CornerDictionary{
//        rulerModel.rulerMarksDic
//    }
    
    
    func createMetricNumberDictionary() -> PositionDictionary{
        let dictionary =  rulerModel.rulerMarksDic//getRulerMarks()
        var labelDictionary: PositionDictionary = [:]

        let unitCorrection = unitSystem == UnitSystem.mm ? 1: 10
        for (key, value) in dictionary {
            if !key.contains(Level.tertiary.rawValue)  && !key.contains(Level.halfSecondary.rawValue){
              
                let value = value[0].y * scale
                let numberName = String(Int(value - lengthBefore)/unitCorrection)
                labelDictionary += [numberName: (x: width/2.0, y: value, z: RulerDataMarks.rulerPositionOnZ)]
            }
        }
       return labelDictionary
    }
    
    
    func createImperialNumberDictionary() -> PositionDictionary{
        let dictionary =  rulerModel.rulerMarksDic//getRulerMarks()//number name locations
        var nameDictionary: PositionDictionary = [:]

        for (key, value) in dictionary {
            if (key.contains(Level.primary.rawValue) || //12"
                key.contains(Level.secondary.rawValue)) //6"
                && value[0].x == 0.0 { //line has 2 values, use 1
                let value = value[0].y * scale// y is source of name
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


struct RulerPartData {
    let rulerLength: Double
    let rulerWidth: Double
    var rulerPartDatafourCornerDic: CornerDictionary {
        getDictionary()
    }
    var oneCornerDic: PositionDictionary {
        ConvertFourCornerPerKeyToOne(fourCornerPerElement:  rulerPartDatafourCornerDic).oneCornerPerKey
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
