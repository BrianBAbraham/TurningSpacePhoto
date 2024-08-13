//
//  RulerViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import Foundation
import Combine
import SwiftUI


struct RulerDivisionModel:  Identifiable {
    var id: String
    let startOfDivisionMark: CGPoint
    let endOfDivisionMark: CGPoint
    
}

struct RulerNumberModel: Identifiable {
    let id: String
    let numberPosition: CGPoint
}


class RightAngleRulerViewModel: ObservableObject {

    @Published var rulerFrameSize = ZeroValue.dimension
    @Published var rulerDivisionModels: [RulerDivisionModel] = []
    @Published var rulerNumberModels: [RulerNumberModel] = []
    
    var rulerNumberDic: PositionDictionary = [:]
    var rulerDivisionDic: CornerDictionary = [:]
    var rulerPartAllCGPoint: [CGPoint] = []
    var unitSystem: UnitSystem = MeasurementSystemService.shared.unitSystem
    static let lengthBefore = 170.0//measurement lines
    static let lengthAfter = 30.0// measurment lines
    static let measuringLength: Double = 3000.0
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
            Self.lengthBefore + Self.measuringLength + Self.lengthAfter
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
            measuringLength: Self.measuringLength,
            rulerWidth: scaledRulerWidth,
            scale: scale,
            unitSystem: unitSystemInitial
        )

        rulerDivisionDic = rulerDivisionMarks.getDictionary()
        
        ScaleService.shared.$scale
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newData in
                    guard let self else {return}
                    if self.scale != newData {
                        self.scale = newData
                        self.setScaledRulerDimensions(newData)
                        self.updateDependentProperties(newData)
                        self.updateRulerDivisionModels()
                        self.updateRulerNumberModels()
                    }
                }
                .store(in: &self.cancellables)
        
        
        MeasurementSystemService.shared.$unitSystem
            .sink { [weak self] newData in
                self?.unitSystem = newData
            }
            .store(in: &self.cancellables)
        
       updateDependentProperties(scale)
        
        updateRulerDivisionModels()
        
        updateRulerNumberModels()

    }

    
    func updateRulerDivisionModels(){
    rulerDivisionModels = []
        for (
            key,
            value
        ) in rulerDivisionDic {
            rulerDivisionModels.append(
                RulerDivisionModel(
                    id: key,
                    startOfDivisionMark: CreateIosPosition.positionToCGPoint(
                        value[0]),
                    endOfDivisionMark:  CreateIosPosition.positionToCGPoint(
                        value[1])
                    )
                )
        }
    }
    
    
    func updateRulerNumberModels() {
        rulerNumberModels = []
        for (
            key,
            value
        ) in rulerNumberDic {
            rulerNumberModels.append(
                RulerNumberModel(
                    id: key,
                    numberPosition: CreateIosPosition.positionToCGPoint(
                        value)
                    )
                )
        }
        
        
        
    }
    
    
    func setScaledRulerDimensions( _ scale: Double) {
        scaledRulerLength = (
            Self.lengthBefore + Self.measuringLength + Self.lengthAfter
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
            measuringLength: Self.measuringLength,
            rulerWidth: scaledRulerWidth,
            scale: scale,
            unitSystem: unitSystem
        )
        
        rulerDivisionDic = rulerDivisionMarks.getDictionary()
   
        switch unitSystem {
        case .cm, .mm:
            rulerNumberDic = createMetricNumberDictionary()
        case .imperial:
            rulerNumberDic = createImperialNumberDictionary()
        }
        
        

 
        rulerFrameSize = (
            width: scaledRulerWidth,
            length: scaledRulerLength
        )
    
        rulerPartAllCGPoint = getPartCorners()
        
        
        func createMetricNumberDictionary() -> PositionDictionary{
            let dictionary = rulerDivisionDic

            var nameDictionary: PositionDictionary = [:]

            let milliOrCentimeters = unitSystem
                == UnitSystem.mm ? 1: 10
           
            for (key, value) in dictionary {
                if !key.contains(Level.tertiary.rawValue)  && !key.contains(Level.halfSecondary.rawValue)
               // if key.contains(Level.secondary.rawValue)
                {
                    let divisionFromRulerPartStartInScreen = value[0].y
                    let yPosition = divisionFromRulerPartStartInScreen
        
                    //transform division screen-value to unscaled
                    let unscaledNumberValue = yPosition / scale - Self.lengthBefore
                    
                    //division is from ruler end and not number start
                    let numberValue = Int(unscaledNumberValue)

                    //make String
                    let numberName = String(numberValue/milliOrCentimeters)
                    
                    nameDictionary += [numberName: (x: scaledRulerWidth/2.0, y: value[0].y, z: RulerDivisionMarks.rulerPositionOnZ)]
                }
            }
           return nameDictionary
        }
        
        
        func createImperialNumberDictionary() -> PositionDictionary{
            let dictionary =  rulerDivisionDic
            
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
    
    
    func getPartCorners() -> [CGPoint] {
        let dic = rulerPartData.rulerPartDatafourCornerDic
        let dictionaryElementIn = DictionaryElementIn(
            dic,
            ""
        )
        let points = dictionaryElementIn.cgPointsOut()
        
    return points
    }

    

}


struct RulerDivisionMarks {
    
    let lengthBefore: Double//zero mark on ruler
    let measuringLength: Double//longest measurement of ruler
    let rulerWidth: Double
    let scale: Double
    let unitSystem: UnitSystem
    var widthIndices: [Int] {
        (0..<10).map { $0 }
    }
    static let rulerPositionOnZ = 1000.0

    
    func getDictionary() -> CornerDictionary{
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
        let numberOfDivisions = Int(measuringLength/division)
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
       
        let numberOfDivisions = Int(measuringLength/division)
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
