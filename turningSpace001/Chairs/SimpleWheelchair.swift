//
//  SimpleWheelchair.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import Foundation
struct Create {
    let chairMeasurementDictionary: [String: Double]

    func dictonaryOfDictionaries(_ names: [String], _ dictionary: [[String : Double]]) -> [String: Dictionary<String, Double>] {
        var dictionaries: [String: [String: Double]] = [ : ]
        for index in 0..<names.count {
            dictionaries[names[index]] = dictionary[index]
        }
        return dictionaries
    }
    
    func getDimensionFromDictionary(_ measurementName: String) -> Double {
     let dimension = chairMeasurementDictionary[measurementName] ?? 100.0
        return dimension
    }
    
    func simpleWheelchair() -> [String: [String: Double]]{
        let chairWidth = getDimensionFromDictionary(ChairMeasurements.chairWidth.rawValue)
        let chairLength = getDimensionFromDictionary(ChairMeasurements.chairLength.rawValue)
        let seatDepth = getDimensionFromDictionary(ChairMeasurements.seatDepth.rawValue)
        let wheelLength = getDimensionFromDictionary(ChairMeasurements.wheelLength.rawValue)
        var wheelWidth: Double {wheelLength/15}
        var seatWidth: Double { (chairWidth - 2 * wheelWidth) * 0.8 }
        let footplateWidth = 150.0
        var yStartFootplate: Double {chairLength - footplateWidth/2 - wheelLength/2}
        var xRightStartFootplate: Double {-seatWidth/2 }
        let footPlateHangerWidth = 10.0
        var footPlateHangerLength: Double {yStartFootplate - seatDepth }
        let partElementNames: [String] = ArrayOfPartElement.names
        let seatPart = createValueDictionary(partElementNames, [-seatWidth/2, 0, seatWidth, seatDepth])
        let rightFootPlatePart = createValueDictionary(partElementNames, [xRightStartFootplate, yStartFootplate, footplateWidth, footplateWidth/2])
        let rightFootPlateHangerPart = createValueDictionary(partElementNames, [-seatWidth/2,seatDepth,footPlateHangerWidth,footPlateHangerLength])
        let leftFootPlateHangerPart = createValueDictionary(partElementNames, [seatWidth/2 - footPlateHangerWidth ,seatDepth,footPlateHangerWidth,footPlateHangerLength])
        let leftFootPlatePart = createValueDictionary(partElementNames, [-xRightStartFootplate - footplateWidth, yStartFootplate, footplateWidth, footplateWidth/2])
        let rightFixedWheelPart = createValueDictionary(partElementNames, [-chairWidth/2, -wheelLength/2, wheelWidth, wheelLength])
        let leftFixedWheelPart = createValueDictionary(partElementNames, [chairWidth/2 - wheelWidth, -wheelLength/2, wheelWidth, wheelLength])
        let simpleWheelchairNames: [String] = Determine.partNameFromRandomOrderPartAndLocations(
            [[.seat],[.footPlate, .left],[.footPlate, .right],[.footPlateHanger, .left],[.footPlateHanger, .right],[.fixedWheel, .left,.rear], [.fixedWheel, .rear, .right]]
        )
        let simpleWheelchair = dictonaryOfDictionaries(simpleWheelchairNames,
            [seatPart, leftFootPlatePart, rightFootPlatePart, leftFootPlateHangerPart, rightFootPlateHangerPart,   leftFixedWheelPart, rightFixedWheelPart])
        return simpleWheelchair
    }
    
    func createValueDictionary(_ names: [String], _ values: [Double]) -> [String: Double] {
        Dictionary(uniqueKeysWithValues: zip(names, values))
    }
}
