//
//  PositionTransformation.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/03/2023.
//

import Foundation

struct ZeroValue {
    static let iosLocation: PositionAsIosAxes = (x: 0.0, y: 0.0, z: 0.0 )
    static let oneOrTwoPositionAsTuple =
    (left: Self.iosLocation, right: Self.iosLocation, one: Self.iosLocation)
    static let dimension: Dimension = (width:  0.0,  length: 0.0 )
    static let dimension3d: Dimension3d = (width:  0.0,  length: 0.0, height:  0.0)
    static let angle: Measurement<UnitAngle> = Measurement(value: 0.0, unit: UnitAngle.radians)
    static let angleDeg: Measurement<UnitAngle> = Measurement(value: 0.0, unit: UnitAngle.degrees)
    
    static let angleMinMax: AngleMinMax = (min: angle, max: Measurement(value: 1.0, unit: UnitAngle.radians))
    
    static let anglesMinMax: AnglesMinMax = (min: rotationAngles, max: rotationAngles)


    
    static let rotationAngles: RotationAngles =
        (
        x: Self.angle,
        y: Self.angle,
        z: Self.angle)
    
    static let partData: PartData = PartData(part: .objectOrigin, originName: .one(one: Part.objectOrigin.rawValue), dimensionName: .one(one: Part.objectOrigin.rawValue), dimension: .one(one: ZeroValue.dimension3d), origin: .one(one: ZeroValue.iosLocation), minMaxAngle: nil, angles: nil, id: .one(one: .id0))
    
}
    

struct CreateIosPosition {
    static func addToToupleX(_ touple: PositionAsIosAxes, _ value: Double) -> PositionAsIosAxes {
        let p = touple
        return
            (x: p.x + value, y: p.y, z: p.z)
    }
    
    
    static  func addTwoTouples(_ first: PositionAsIosAxes, _ second: PositionAsIosAxes) -> PositionAsIosAxes {
        
        (x: first.x + second.x,y: first.y + second.y, z: first.z + second.z )
    }
    
    
    static func addArrayOfTouples(
        _ toupleArray: [PositionAsIosAxes])
        -> PositionAsIosAxes {
            
            var toupleSum = toupleArray[0]
            for index in 1..<toupleArray.count {
                toupleSum =
                CreateIosPosition.addTwoTouples(
                    toupleSum,
                    toupleArray[index])
            }
        return toupleSum
    }
    

    static func subtractSecondFromFirstTouple(_ first: PositionAsIosAxes, _ second: PositionAsIosAxes)  -> PositionAsIosAxes {
        (x: first.x - second.x,y: first.y - second.y, z: first.z - second.z )
    }
    
    
    static func getCornersFromDimension (
        _ dimension: Dimension3d)
        -> Corners {
            let (w,l,h) = dimension
            let initialCorners: Corners =
            [
            (x: -w/2,  y: -l/2, z: -h/2 ),//c0
            (x: w/2,   y: -l/2, z: -h/2 ),//c1
            (x: w/2,   y: l/2, z: -h/2 ),//c2 thirdOfTopView bottomRightOnScreen
            (x: -w/2,  y: l/2, z: -h/2),//c3 fourthOfTopView bottomLeftOnScreen
            (x: -w/2,  y: -l/2, z: h/2 ),//c4 firstOfTopView topLeftOnScreen
            (x: w/2,   y: -l/2, z: h/2 ),//c5 seondOfTopView topRightOnScreen
            (x: w/2,   y: l/2, z: h/2 ),//c6
            (x: -w/2,  y: l/2, z: h/2) ]//c7
            return
                initialCorners
    }
    
//    static func dimensionFromIosPositions(_ positions: [PositionAsIosAxes])
//    -> Dimension {
//        
//        let arrayTouple = getArrayFromPositions(positions)
//        let xArray = arrayTouple.x
//        let yArray = arrayTouple.z
//        
//        func getDimension(_ measurements :[Double]) -> Double {
//            let defaultMeasurement = measurements[0]
//            let maxMeasurement = measurements.max() ?? defaultMeasurement
//            let minMeasurement = measurements.min() ?? defaultMeasurement
//            return maxMeasurement - minMeasurement
//        }
//        return
//            (
//            width: getDimension(xArray),
//            length: getDimension(yArray))
//    }
    
    static func convertMinMaxToDimension(_ minMax: [PositionAsIosAxes]) -> Dimension {
        return (
            width: minMax[1].x - minMax[0].x,
            length: minMax[1].y - minMax[0].y
        )
    }
    
    
    static func getArrayFromPositions( _ positions: [PositionAsIosAxes])
    -> PositionArrayAsIosAxes {
        var xArray: [Double] = []
        var yArray: [Double] = []
        var zArray: [Double] = []
        
        for position in positions {
            xArray.append(position.x)
            yArray.append(position.y)
            zArray.append(position.z)
        }
        
        return (x: xArray, y: yArray, z: zArray)
    }
    
    
    static func addToupleToArrayOfTouples(_ touple: PositionAsIosAxes, _ toupleArray: [PositionAsIosAxes]) -> [PositionAsIosAxes] {
        var newArrayOfTouple: [PositionAsIosAxes] = []
        for array in toupleArray {
            newArrayOfTouple.append(addTwoTouples(touple, array))
        }
        return newArrayOfTouple
    }
    

    static func negative(_ touple:
    PositionAsIosAxes)
    -> PositionAsIosAxes {
        (x: -touple.x, y: -touple.y, z: touple.z)
    }
    
    static func getLeftFromRight (
        _ right: PositionAsIosAxes)
        -> PositionAsIosAxes{
        (
            x: -right.x,
            y: right.y,
            z: right.z)
    }
    
    static func minMaxPosition(
        _ corners: PositionDictionary)
        -> [PositionAsIosAxes] {
            
        let values = corners.map { $0.value }
        let valuesAsArray = CreateIosPosition
            .getArrayFromPositions(values)
        let yValues = minMax(valuesAsArray.y)
        let xValues = minMax(valuesAsArray.x)

            func minMax(_ values: [Double]) -> [Double] {
                let minValue = values.min() ?? 0.0
                let maxValue = values.max() ?? 0.0
                let minIndex = values.firstIndex(of: minValue) ?? 0
                let maxIndex = values.firstIndex(of: maxValue) ?? 0
                
                let minCorner = values[minIndex]
                let maxCorner = values[maxIndex]
                return [minCorner, maxCorner]
            }
            return  [(x: xValues[0], y: yValues[0], z: 0.0), (x: xValues[1], y: yValues[1], z: 0.0)]
    }
    
    
    static func filterPointsToConvexHull(points: [(x: Double, y: Double, z: Double)]) -> [(x: Double, y: Double, z: Double)] {
        guard points.count >= 4 else { return points }
        
        // Helper function to find the bottom-most point (or left-most if there are ties).
        func lowestPoint() -> (x: Double, y: Double, z: Double) {
            return points.min { $0.y == $1.y ? $0.x < $1.x : $0.y < $1.y }!
        }
        
        // Helper function to calculate the orientation of three points
        func orientation(_ p1: (Double, Double), _ p2: (Double, Double), _ p3: (Double, Double)) -> Int {
            let val = (p2.1 - p1.1) * (p3.0 - p2.0) - (p2.0 - p1.0) * (p3.1 - p2.1)
            if val == 0 { return 0 } // colinear
            return val > 0 ? 1 : 2 // clock or counterclock wise
        }
        
        let lowest = lowestPoint()
        
        // Sort points by polar angle with the lowest point. If angles are equal, sort by distance to the lowest point.
        let sortedPoints = points.sorted {
            let o1 = orientation((lowest.x, lowest.y), ($0.x, $0.y), ($1.x, $1.y))
            if o1 == 0 {
                return ($0.x - lowest.x) * ($0.x - lowest.x) + ($0.y - lowest.y) * ($0.y - lowest.y) <
                       ($1.x - lowest.x) * ($1.x - lowest.x) + ($1.y - lowest.y) * ($1.y - lowest.y)
            }
            return o1 == 2
        }
        
        // Initialize the hull with the lowest and the first sorted point
        var hull: [(Double, Double, Double)] = [lowest, sortedPoints[1]]
        
        // Iterate through the sorted points and construct the hull
        for p in sortedPoints[2...] {
            while hull.count >= 2 && orientation((hull[hull.count-2].0, hull[hull.count-2].1), (hull.last!.0, hull.last!.1), (p.0, p.1)) != 2 {
                hull.removeLast()
            }
            hull.append(p)
        }
        
        // Convert the hull into a set for faster lookup
        // Convert hull points to a Set of String for lookup
        let hullPointIdentifiers = Set(hull.map { "\($0.0),\($0.1)" })
        
        // Replace non-hull points with (Double.infinity, Double.infinity, Double.infinity)
        return points.map { point in
            let pointIdentifier = "\(point.0),\(point.1)"
            if hullPointIdentifiers.contains(pointIdentifier) {
                return point
            } else {
                return (Double.infinity, Double.infinity, Double.infinity)
            }
        }
    }
}



