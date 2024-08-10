//
//  RulerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import Foundation
import Combine


struct RulerModel {
    let rulerDivisionDic: CornerDictionary
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
    static let lengthBefore = 170.0//measurement lines
    static let lengthAfter = 30.0// measurment lines
    static let numberSpan: Double = 1000.0
    static let width = 170.0

    var rulerPartData: RulerPartData
    var rulerDivisionMarks: RulerDivisionMarks
    
    var scale: Double = ScaleService.shared.scale
    var scaledRulerLength: Double = 1.0
    var scaledRulerWidth: Double = 1.0

    internal var cancellables: Set<AnyCancellable> = []
    
    init(
//        _ numberSpan: Double = 1000.0,
//        _ width: Double = 170.0
    ) {
    
        scaledRulerLength = (
            Self.lengthBefore + Self.numberSpan + Self.lengthAfter
        ) * scale
        
        scaledRulerWidth = Self.width * scale
        
        rulerPartData =
            RulerPartData (
                rulerLength: scaledRulerLength,
                rulerWidth: scaledRulerWidth
            )
       
        let unitSystemInitial = MeasurementSystemService.shared.unitSystem
        
        rulerDivisionMarks = RulerDivisionMarks(
            lengthBefore: Self.lengthBefore,
            numberSpan: Self.numberSpan,
            rulerWidth: scaledRulerWidth,
            scale: scale,
            unitSystem: unitSystemInitial
        )
        
        rulerModel =
            RulerModel(
                rulerDivisionDic: rulerDivisionMarks.getMarksDictionary(),
                rulerNumbers: [:]
        )
        
        ScaleService.shared.$scale
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newData in
                    guard let self else {return}
                    self.scale = newData
                 
                    self.setScaledRulerDimensions(newData)
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

    
    func setScaledRulerDimensions( _ scale: Double
    ) {
        scaledRulerLength = (
            Self.lengthBefore + Self.numberSpan + Self.lengthAfter
        ) * scale
        
        scaledRulerWidth = Self.width * scale
    }
    
    
    func updateDependentProperties(_ scale: Double) {
      
        rulerPartData =
            RulerPartData (
                rulerLength: scaledRulerLength,
                rulerWidth: scaledRulerWidth
            )
        
        rulerDivisionMarks = RulerDivisionMarks(
            lengthBefore: Self.lengthBefore,
            numberSpan: Self.numberSpan,
            rulerWidth: scaledRulerWidth,
            scale: scale,
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
            rulerModel = RulerModel(
                rulerDivisionDic: rulerDivisionMarks.getMarksDictionary(),
                rulerNumbers: rulerNumbers
            )
        }
        
        rulerMarksDic = rulerModel.rulerDivisionDic
        
        rulerPartAllCGPoint = getPartCorners()
        
        rulerFrameSize = (
            width: scaledRulerWidth,
            length: scaledRulerLength
        )
        
        numberDictionary = rulerModel.rulerNumbers
        
        rulerPartAllCGPoint = getPartCorners()
        
    }
    
    
    func getPartCorners() -> [CGPoint] {
        let dic = rulerPartData.rulerPartDatafourCornerDic
        let dictionaryElementIn = DictionaryElementIn(
            dic,
            ""
        )
        let points = dictionaryElementIn.cgPointsOut()
        
    return points
    }

    
    func createMetricNumberDictionary() -> PositionDictionary{
        let dictionary =  rulerModel.rulerDivisionDic
        var nameDictionary: PositionDictionary = [:]

        let unitCorrection = unitSystem == UnitSystem.mm ? 1: 10
        for (key, value) in dictionary {
            if !key.contains(Level.tertiary.rawValue)  && !key.contains(Level.halfSecondary.rawValue){
               
                let value = value[0].y//not scaled: numbers constant if ruler small
                let numberName = String(Int(value - Self.lengthBefore)/unitCorrection)
                
                let yPosition = value * scale//position changes
                nameDictionary += [numberName: (x: scaledRulerWidth/2.0, y: yPosition, z: RulerDivisionMarks.rulerPositionOnZ)]
            }
        }
       return nameDictionary
    }
    
    
    func createImperialNumberDictionary() -> PositionDictionary{
        let dictionary =  rulerModel.rulerDivisionDic//getRulerMarks()//number name locations
        var nameDictionary: PositionDictionary = [:]

        for (key, value) in dictionary {
            if (key.contains(Level.primary.rawValue) || //12"
                key.contains(Level.secondary.rawValue)) //6"
                && value[0].x == 0.0 { //line has 2 values, use 1
                let value = value[0].y //not scaled: numbers constant if ruler small
                
                let numberName = //string from y value
                String(Int(((value - Self.lengthBefore) / 25.4 ).rounded()))
                
                let yPosition = value * scale//position changes
                nameDictionary += [numberName: (x: scaledRulerWidth/2.0, y: yPosition, z: RulerDivisionMarks.rulerPositionOnZ)]
            }
        }
       return nameDictionary
    }
}


struct RulerDivisionMarks {
    
    let lengthBefore: Double//zero mark on ruler
    let numberSpan: Double//longest measurement of ruler
    let rulerWidth: Double
    let scale: Double
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
        
        let valuesForX = getDivisionLength(level)
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
    

    
    func getDivisionLength(_ level: Level) -> [Double]{
        let widthDivisor = 18
        let stepForX = rulerWidth/Double(widthDivisor)
        let leftEdge = 0
        let rightEdge = widthDivisor
        
        var widthDivisionsPositions: [Int] = []
        
        switch level {
        case .primary:
            widthDivisionsPositions = getWidthDivisions(
                leftEdgeToDivisionEnd: 6,
                dvisionStartToRightEdge: 12
            )
        case .secondary:
            widthDivisionsPositions = getWidthDivisions(
                leftEdgeToDivisionEnd: 4,
                dvisionStartToRightEdge: 14
            )
        case .halfSecondary:
            widthDivisionsPositions = getWidthDivisions(
                leftEdgeToDivisionEnd: 3,
                dvisionStartToRightEdge: 15
            )
        case .tertiary:
            widthDivisionsPositions = getWidthDivisions(
                leftEdgeToDivisionEnd: 2,
                dvisionStartToRightEdge: 16
            )
        }
        
        return getWidthDivisionValues(widthDivisionsPositions)
        
        func getWidthDivisions(
            leftEdgeToDivisionEnd: Int,
            dvisionStartToRightEdge: Int
        ) -> [Int] {
            return (
                [
                    leftEdge,
                    leftEdgeToDivisionEnd,
                    dvisionStartToRightEdge,
                    rightEdge
                ]
            )
        }
        
        
        func getWidthDivisionValues(_ indices: [Int] ) -> [Double] {
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
            let positionY = (Double(i) * division + lengthBefore) * scale
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
            let positionY = (Double(i) * division + lengthBefore) * scale
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
