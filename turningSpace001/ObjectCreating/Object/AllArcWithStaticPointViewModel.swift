//
//  AllArcWithStaticPointViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import Foundation
import Combine


struct ArcDataModel: Identifiable {
    let id = UUID()
    let arcData: ArcData
}

struct StaticPointModel: Identifiable {
    let id = UUID()
    let name: String
    let position: CGPoint
}


class AllArcWithStaticPointViewModel: ObservableObject {
    
    @Published var movementDictionaryForScreen: CornerDictionary =
        MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    @Published var staticPointModel: [StaticPointModel] = []
    @Published var staticPointDictionary: CornerDictionary = [:]
    @Published var arcDataModels: [ArcDataModel] = []
    @Published var show: Bool = false
  
    var movementType: Movement = MovementEditService.shared.movementType
    var uniqueArcPointNames: [String] = []
    var uniqueArcNames: [String] = []
    var uniqueStaticPointNames: [String] = []
    
    ///each element is the angle to an arc point on a  lower integer object and then a higher integer object
    var arcDictionary: CornerDictionary = [:]
    var lastShortestDifference = 0.0
    var clockwise = true
  
    internal var cancellables: Set<AnyCancellable> = []
    init(){
        
        MovementEditService.shared.$movementType
              .sink { [weak self] newMovementType in
                  self?.movementType = newMovementType
                  self?.setShow()
              }
              .store(in: &cancellables)
        
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .sink { [weak self] newData in
            self?.movementDictionaryForScreen = newData
            self?.update()
            }
            .store( in: &cancellables)

            uniqueArcNames = getUniqueArcNames()
            uniqueArcPointNames = getUniqueArcPointNames()
            uniqueStaticPointNames = getUniqueStaticPointNames()
            arcDictionary = createArcDictionary()

    }
    
    
    func setShow()  {
        show = movementType == .turn
    }
    
    
    func update() {
        setShow()
        arcDictionary = createArcDictionary()
        staticPointDictionary = createStaticPointDictionary()
        uniqueStaticPointNames = getUniqueStaticPointNames()
        uniqueArcPointNames = getUniqueArcPointNames()
      
        createAllArcStaticPointModel()
        createAllArcDataModel()
    }

    
    
    func createAllArcStaticPointModel() {
        staticPointModel = []
        let names = getUniqueStaticPointNames()
        let dic = createStaticPointDictionary()
        
        for index in stride(from: 0, to: names.count, by:  2) {
            let name = names[index]
            let useAnyOfFourIdenticalPositions = 0
            let u = useAnyOfFourIdenticalPositions
            if let staticPoint = dic[name] {
                let point = CGPoint(x: staticPoint[u].x, y: staticPoint[u].y)
                staticPointModel.append(StaticPointModel(name: name , position: point) )
            }
        }
    }
    
    
    func createAllArcDataModel() {
        arcDataModels = []
        let arcData = getArcData()
        for arcDatum in arcData {
            arcDataModels.append(ArcDataModel(arcData: arcDatum))
        }
    }
    
    
    func getUniqueArcPointNames() -> [String] {
       Array( movementDictionaryForScreen.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
    }
    
    
    func getUniqueArcNames() -> [String] {
       var names = getUniqueArcPointNames()
        names = StringAfterSecondUnderscore.get(in: names)
        names = Array(Set(names))//remove duplicates
        return names
    }
    
    
    func getUniqueStaticPointNames() -> [String] {
        let names =
        Array(
            movementDictionaryForScreen.keys
        ).filter {
            $0.contains(
                PartTag.staticPoint.rawValue) }
        return names
    }
    
    
    func createArcDictionary() -> CornerDictionary {
        var arcDictionary: CornerDictionary = [:]
        let names = Array(movementDictionaryForScreen.keys).filter { $0.contains(PartTag.arcPoint.rawValue) }
        
      //  print(names)
        let namesWithoutPrefix = Array(Set(RemovePrefix.get(PartTag.arcPoint.rawValue, names)))
        let prefixNames = SubstringBefore.get(substring: PartTag.arcPoint.rawValue, in: names)
      
        if prefixNames.count > 1 { //ignore when only one object
            
            //objectZero will have the first value and etc
            let orderedPrefixNames = SortStringsByEmbeddedNumber().get(prefixNames)
            
            for name in namesWithoutPrefix {
                
                let firstPointName = orderedPrefixNames[0] + name
                let secondPointName = orderedPrefixNames[1] + name
                guard let firstPointValue = movementDictionaryForScreen[firstPointName] else {
                    fatalError("\(names)")
                }
                guard let secondPointValue = movementDictionaryForScreen[secondPointName] else {
                    fatalError()
                }
                let any = 0//four identical values; conforms to corners; disregard three
                arcDictionary += [name: [firstPointValue[any], secondPointValue[any]]]
            }
        }

        return arcDictionary
    }
    
    ///static point are in pairs, one for first object position and one for second object position
    ///nevertheless, the static point is common to both positions
    ///to conform to CornerDictionary these are in an array
    ///for conformance to corner creation there are four identical values
    func createStaticPointDictionary() -> CornerDictionary {
        movementDictionaryForScreen.filter{$0.key.contains(PartTag.staticPoint.rawValue)}
    }
    
    
    func getArcData() -> [ArcData] {
        var arcData: [ArcData] = []
    
        if uniqueStaticPointNames.count > 0 { //ignore when empty
            guard let staticPoint = staticPointDictionary[uniqueStaticPointNames[0]]?[0] else {
                fatalError()
            }
            
            let pairsOfPoints = arcDictionary.values.map{ $0}
            for index in 0..<pairsOfPoints.count {
                let pairs = pairsOfPoints[index]
                let radius = radius(from: staticPoint, to: pairs[0])
                let firstAngle = angle(pairs[0])
                let secondAngle = angle(pairs[1])
                var shortestDifference = 0.0
               
                if index == 0 {//rigid body one point will indicate direction
        
                    shortestDifference = getShortestDifference([firstAngle, secondAngle])
                    
                    getArcDrawDirection(lastShortestDifference,shortestDifference)
                    
                    lastShortestDifference = shortestDifference
                }
              
                // input for view
                let arcDatum = (id: index, start: firstAngle, end: secondAngle, radius: radius, clockwise: clockwise)
                arcData += [arcDatum]
            }

            
            func angle(_ value: PositionAsIosAxes) -> Double{
                let dy = value.y - staticPoint.y
                let dx = value.x - staticPoint.x
                return atan2(dy, dx)
            }
            
            
            /// swift drawns arcs from start angle to end angle
            /// clockwise or anticlockwise as specified
            /// when a rotated point traverses its original position
            /// and the direction of rotation is anticlockwise
            /// if the angles created by the point positions are
            /// input without change, the arc will be drawn
            /// the long route round creating a visual discontinuity
            /// this code detects this transition
            /// and returns an anticlockwise state
            /// when the rotation then returns to clockwise
            /// the clockwise state is returned
            /// to distinguish the two senses of the rotated point
            /// traversing its original position the last
            /// and shortest difference are required
            func getArcDrawDirection(
                _ lastShortestDifference: Double,
                _ shortestDifference: Double
            ) {

                let anticlockwiseZeroTraverse = zeroTraverse(
                    zero: lastShortestDifference,
                    nonZero: shortestDifference
                )
                
        
                let clockwiseZeroTraverse = zeroTraverse(
                    zero: shortestDifference,
                    nonZero: lastShortestDifference
                )
            
                if anticlockwiseZeroTraverse && !clockwiseZeroTraverse {
                    clockwise = false
                }
                
                if clockwiseZeroTraverse && !anticlockwiseZeroTraverse {
                    clockwise = true
                }
                
                if clockwiseZeroTraverse && anticlockwiseZeroTraverse {
                    fatalError()
                }
                
                    func zeroTraverse(
                        zero zeroDifference: Double,
                        nonZero nonZeroDifference: Double
                    ) -> Bool{
                        let zeroTest = Double(//was the last value zero?
                            String(// allow for possible numerical error
                                format:  "%.3f",
                                zeroDifference
                            )
                        )

                    let anticlockwiseZeroTraverse: Bool = nonZeroDifference < 0.0 ? true: false
                    var state = false
                    if  zeroTest == 0.0 && anticlockwiseZeroTraverse{
                       
                        state = true
                    }
                    return state
                }
            }


            /// when a point is rotated about a static point
            /// the angle between the intitial and rotated position
            /// may be measured in either direction
            /// the shortest angle is determined
            func getShortestDifference(_ anglePairs: [Double]) -> Double {
                let difference = anglePairs[1] - anglePairs[0]
                return
                    atan2(sin(difference), cos(difference))
            }
            
            
            func radius(from: PositionAsIosAxes, to: PositionAsIosAxes) -> Double {
                sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
            }
            

            
        }
        return arcData
    }
    
}
