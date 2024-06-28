//
//  PartAngles.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation


struct PartDefaultAngle {
    
    let allAngleData:
        (min: RotationAngles, max: RotationAngles, initial: RotationAngles)
    let angle: RotationAngles
    var minMaxAngle: AngleMinMax = ZeroValue.angleMinMax
  
    
    init(_ part: Part, _ objectType: ObjectTypes) {
        allAngleData = getAllAngleData(part, objectType)
        
        
        self.angle = allAngleData.initial
        minMaxAngle = getMinMaxAngle()
    
        func getAllAngleData(_ part: Part, _ objectType: ObjectTypes)
        -> (min: RotationAngles, max: RotationAngles, initial: RotationAngles) {
            let partObject = PartObject(part, objectType)
            guard let allAngleData =
                    getFineTunedAngleDefault(partObject) ??
                    getGeneralAngleDefault(part) else {
                fatalError("no angle defined for part \(part)")
            }
            return allAngleData
        }
        
        func getFineTunedAngleDefault(_ partObject: PartObject)
        -> (min: RotationAngles, max: RotationAngles, initial: RotationAngles)?{
            let dictionary: [PartObject: (min: RotationAngles, max: RotationAngles, initial: RotationAngles)] = [:]
            
            return dictionary[partObject]
        }
        
        
        func getGeneralAngleDefault(_ part: Part)
        -> (min: RotationAngles, max: RotationAngles, initial: RotationAngles)?{
            let z: Measurement<UnitAngle> = ZeroValue.angleDeg
            let zPlus = 1.0 * pow(10, -Double(10))//arbirtrarilly cose to zero
            let dictionary: [Part: (min: RotationAngles, max: RotationAngles, initial: RotationAngles)] = [
                .sitOnTiltJoint:
                    (min: (x: Measurement(value: zPlus, unit: UnitAngle.degrees), y: z , z: z),
                     max: (x: Measurement(value: 30.0, unit: UnitAngle.degrees), y: z , z: z),
                    initial: (x: Measurement(value: 0.0, unit: UnitAngle.degrees), y: z , z: z) ),
                .backSupportTiltJoint:
                    (min: (x: Measurement(value: zPlus, unit: UnitAngle.degrees), y: z , z: z),
                     max: (x: Measurement(value: 90.0, unit: UnitAngle.degrees), y: z , z: z),
                    initial: (x: Measurement(value: 0.0, unit: UnitAngle.degrees), y: z , z: z) )
            ]
            return dictionary[part]
        }
        
        
        func getMinMaxAngle() -> AngleMinMax {
            
            let min = extractNonZeroAngle(allAngleData.min)
            
            let max = extractNonZeroAngle(allAngleData.max)
            
            return (min: min, max: max)
            
            func extractNonZeroAngle(_ angle: RotationAngles) -> Measurement<UnitAngle> {
                guard let nonZeroAngle = [angle.x, angle.y, angle.z].first(where: { $0.value != 0 }) else {
                    fatalError("All angles are zero.")
                }
                return nonZeroAngle
            }
        }
    }
}

