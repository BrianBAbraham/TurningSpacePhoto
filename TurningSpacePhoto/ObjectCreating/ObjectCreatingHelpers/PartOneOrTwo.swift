//
//  PartOneOrTwo.swift
//  CreateObject
//
//  Created by Brian Abraham on 04/05/2024.
//

import Foundation




enum OneOrTwoOptional <V> {
    case two(left: V?, right: V?)
    case one(one: V?)
    

    func mapOptionalToNonOptionalOneOrTwo<T>(
        _ defaultValueL: T, _ defaultValueR: T? = nil) -> OneOrTwo<T> {

        var optionalToNonOptional: OneOrTwo<T> = setToParameterType(defaultValueL)
        switch self { //assign default to one or left and right if nil
        case .one(let one):
            if let one = one {
                optionalToNonOptional = .one(one: one as! T)
            } else {
                optionalToNonOptional = .one(one: defaultValueL)
            }

        case .two(let left, let right):
            var returnForLeft: T
            var returnForRight: T
            if let left = left {
                returnForLeft = left as! T
            } else {
                returnForLeft = defaultValueL
            }
            if let right = right {
                returnForRight = right as! T
            } else {
                returnForRight = defaultValueR ?? defaultValueL
            }
            optionalToNonOptional =
                .two(left: returnForLeft, right: returnForRight)
        }
        
        return optionalToNonOptional
    }

    private func setToParameterType<T>(_ defaultValue: T) -> OneOrTwo<T> {
        switch defaultValue {
        case is Dimension3d:
            return OneOrTwo.one(one: ZeroValue.dimension3d) as! OneOrTwo<T>
        case is PositionAsIosAxes:
            return OneOrTwo.one(one: ZeroValue.iosLocation) as! OneOrTwo<T>
        case is RotationAngles:
            return OneOrTwo.one(one: ZeroValue.rotationAngles) as! OneOrTwo<T>
        case is String:
            return OneOrTwo.one(one: "") as! OneOrTwo<T>
        case is AngleMinMax:
            return OneOrTwo.one(one: ZeroValue.angleMinMax) as! OneOrTwo<T>
        default:
            fatalError()
        }
    }

    
    func mapValuesToOptionalOneOrTwoAddition(
        _ defaultValue: PositionAsIosAxes,
        _ defaultValueR: PositionAsIosAxes? = nil) -> OneOrTwo <PositionAsIosAxes> {
            let z = ZeroValue.iosLocation
            var modifiedOnOrTwo: OneOrTwo<PositionAsIosAxes> = .one(one: defaultValue)
            switch self {
            case .one (let one ):
                if one == nil {
                    return .one(one: defaultValue)
                } else {
                    let addedOne =
                    CreateIosPosition.addTwoTouples(one as! PositionAsIosAxes, defaultValue)
                    return .one(one: addedOne)
                }
            case .two(let left, let right):
            
                var returnLeft = z
                var returnRight = z
                guard let unwrappedDefault = defaultValueR else {
                    fatalError("no value for right")
                }
                modifiedOnOrTwo =
                    .two(left: defaultValue, right: unwrappedDefault)
                
                if let unwrapped = left {
                    returnLeft = unwrapped as! PositionAsIosAxes
                    returnLeft =  CreateIosPosition.addTwoTouples(returnLeft, defaultValue)
                }
                
                if let unwrapped = right {
                    returnRight = unwrapped as! PositionAsIosAxes
                    returnRight =  CreateIosPosition.addTwoTouples(returnRight, unwrappedDefault)
                }
                
                if left == nil && right != nil {
                    modifiedOnOrTwo = .two(left: defaultValue, right: returnRight)
                }
                
                if left != nil && right == nil {
                    modifiedOnOrTwo = .two(left: returnLeft, right: unwrappedDefault)
                }
                
                if left != nil && right != nil {
                    modifiedOnOrTwo = .two(left: returnLeft, right: returnRight)
                }
            }
            return  modifiedOnOrTwo
        }
}




enum OneOrTwo <T> {
    case two (left: T, right: T)
    case one (one: T)
    
    //MARK: DEVELOPMENT
    ///a One parent is  mapped to left and right
    /// a Two parent is not mapped to one as two sided to one sided is not yet implemented
    func mapToTouple () -> (one: T?, left: T, right: T) {
        switch self {
        case .one (let one):
            return (one: one, left: one , right: one)
        case .two(let left, let right):
            return (one: nil, left: left, right: right)
        }
    }
    

    //MARK: CHANGE TO AVERAGE
    func mapOneOrTwoToOneOrLeftValue() -> T {
        switch self {
        case .one (let one):
            return one
        case .two (let left, _ ):
            return left
        }
    }
    

    
    func returnValue(_ id: PartTag) -> T {
        switch self {
        case .one (let one):
                return one
        case .two (let left, let right):
            let value = id == .id0 ?  left: right
            return value
        }
    }
    
    
    func mapOneOrTwoToSide() -> [SidesAffected] {
        switch self {
        case .one (let one):
            if PartTag.id0 == one as! PartTag {
                return [.left]
            } else {
                return [.right]
            }
        case .two:
            return [ .both, .left, .right]
        }
    }
    
    
    func getOneOrTwoOriginAllowingForEdit(  _ positions: [PositionAsIosAxes?]) -> OneOrTwo<PositionAsIosAxes> {
        switch self {//
        case let (.two(left, right) ):
            var leftPosition: PositionAsIosAxes
            if let position = positions[0] {
                leftPosition = position
            } else {
                leftPosition = left as! PositionAsIosAxes
            }
            var rightPosition: PositionAsIosAxes
            if let position = positions[1] {
                rightPosition = position
            } else {
                rightPosition = right as! PositionAsIosAxes
            }
            return .two(left: leftPosition, right: rightPosition)
        case let (.one(one)):
            var onePosition: PositionAsIosAxes
            if let position = positions[0] {
                onePosition = position
            } else {
                onePosition = one as! PositionAsIosAxes
            }
            return .one(one: onePosition)
        }
    }
    
    
    func getNamesArray(  _ part: Part) -> [String] {
        var names: [String] = []
        switch (self) {
        case let (.two(left0, right0) ):
           names =
            [CreateNameFromIdAndPart(left0 as! PartTag, part).name,
             CreateNameFromIdAndPart(right0 as! PartTag, part).name]
        case let (.one(one0)):
            names =
            [CreateNameFromIdAndPart(one0 as! PartTag, part).name]
        }
        return names
    }
    
    //DEVELOPMENT combine as one
    func getDictionaryValue(_ dictionary: [String: PositionAsIosAxes ])
    -> OneOrTwo<PositionAsIosAxes>{
        switch self {
        case .two(let left, let right):
            return .two(left: getValues(left), right: getValues(right))
        case .one(let one):
              return .one(one: getValues(one))
        }
        
        func getValues(_ name: T) -> PositionAsIosAxes{
            guard let name = name as? String else {
                fatalError("cannot downcast to String")
            }
            guard let value = dictionary[name] else {
                fatalError("no dictionary entry for \(name)")
            }
            return value
        }
    }
    func getDictionaryValues(_ dictionary: [String: [PositionAsIosAxes] ])
    -> OneOrTwo<[PositionAsIosAxes]>{
        switch self {
        case .two(let left, let right):
            return .two(left: getValues(left), right: getValues(right))
        case .one(let one):
              return .one(one: getValues(one))
        }
        
        func getValues(_ name: T) -> [PositionAsIosAxes]{
            guard let name = name as? String else {
                fatalError("cannot downcast to String")
            }
            guard let values = dictionary[name] else {
                fatalError("no dictionary entry")
            }
            return values
        }
    }
    
    
    func getPositionsArray(  _ part: Part) -> [PositionAsIosAxes] {
        var positions: [PositionAsIosAxes] = []
        switch (self) {
        case let (.two(left0, right0)):
           positions =
            [left0 as! PositionAsIosAxes,
             right0 as! PositionAsIosAxes]
        case let (.one(one0)):
            positions =
            [one0 as!PositionAsIosAxes]
    
        }
        return positions
    }
    
    
    func createOneOrTwoWithOneValue<U>(_ value: U) -> OneOrTwo<U> {
        switch self {
        case .one:
            return .one(one: value)
        case .two:
            return .two(left: value, right: value)
        }
    }
    
    //can this be removed with recoding
    var one: T? {
        switch self {
        case .two:
            return nil
        case .one(let one):
            return one
        }
    }
    
    
    func oneNotTwo()->Bool {
        switch self {
        case .one:
            return true
        case .two:
            return false
        }
    }
    
    
    func getOneOrTwoCornerArrayFromDimension<U>(_ transform: (T) -> U) -> OneOrTwo<U> {
        switch self {
        case .one(let value):
            return .one(one: transform(value))
        case .two(let left, let right):
            return .two(left: transform(left), right: transform(right))
        }
    }
    
    
    func getDefaultOrRotatedCorners(//self is pre-tilt part origin
        _ originPostTilt: OneOrTwo<PositionAsIosAxes>, //post till part origin
        _ preTiltCornersInLocal: OneOrTwo<[PositionAsIosAxes]>,//corners in local
        _ postTiltCornersInGlobal: OneOrTwo<[PositionAsIosAxes]>//post-tilt corners in global
        ) -> OneOrTwo <[PositionAsIosAxes]>{
        let equality: OneOrTwo<Bool> = self.areEqual(originPostTilt)
        let negativeOrigin: OneOrTwo<PositionAsIosAxes> = originPostTilt.negateOneOrTwoValues()
        let postTiltCornersInLocal: OneOrTwo<[PositionAsIosAxes]> = postTiltCornersInGlobal.addToOneOrTwo(negativeOrigin)
        
        switch (equality, preTiltCornersInLocal, postTiltCornersInLocal) {
        case let (.two(equalL, equalR), .two(preL, preR), .two(postL, postR) ) :
            return .two(left: equalL ? preL: postL, right: equalR ? preR: postR )
        case let ( .one(equalO), .one(preO), .one(postO)):
            return .one(one: equalO ? preO: postO)
        default:
            fatalError("oneOrTwo do not match case")
        }
    }
    
    
    func areEqual<U>(_ postValues:OneOrTwo<U>) -> OneOrTwo<Bool> {
        switch (self, postValues) {
        case let (.two(left1 , right1), .two(left2 , right2)  ):
            return .two(left: areEqual(left1, left2), right: areEqual(right1, right2))
        case let (.one( one1), .one(one2)):
            return .one(one: areEqual(one1, one2))
        default:
            fatalError("dictionaries have different OneOrTwo")
        }
        
        func areEqual(_ preValue: T, _ postValue: U) -> Bool{
            guard let preValue = preValue as? PositionAsIosAxes
                   else {
                fatalError("cannot downcast")
            }
            guard let postValue = postValue as? PositionAsIosAxes
                   else {
                fatalError("cannot downcast")
            }
            return preValue.y == postValue.y
        }
    }
    
    
    func negateOneOrTwoValues() -> OneOrTwo<PositionAsIosAxes>{
        switch self {
        case .two(let left, let right):
            let leftResult = subtractFromZero(left)
            let rightResult = subtractFromZero(right)
            return .two(left: leftResult, right: rightResult)
        case .one(let one):
            let oneResult = subtractFromZero(one)
            return .one(one: oneResult)
        }
        func subtractFromZero(_ position: T) -> PositionAsIosAxes {
            guard let position = position as? PositionAsIosAxes else {
                fatalError("cannot downcast to ")
            }
            return
                CreateIosPosition.subtractSecondFromFirstTouple(ZeroValue.iosLocation, position)
        }
    }
    
    
    func addToOneOrTwo(_ origin: OneOrTwo<PositionAsIosAxes>) -> OneOrTwo<[PositionAsIosAxes]> {
        switch (self, origin) {
        case let(.two(left1 , right1 ), .two(originL, originR)):
                    return .two(left: makeAddition(left1, originL ), right: makeAddition(right1, originR ) )
        case let(.one(one1), .one(originO) ):
                    return .one(one: makeAddition(one1, originO ))
          default:
                fatalError()
                  
        }
        
        
        func makeAddition<U, V>(_ positions: V, _ origin: U) -> [PositionAsIosAxes] {
            guard let position = positions as? [PositionAsIosAxes] else {
                fatalError("something has gone wrong should be PositionAsIosAxes")
            }
            guard let origin = origin as? PositionAsIosAxes else {
                fatalError("something has gone wrong should be PositionAsIosAxes")
            }
            return
                CreateIosPosition.addToupleToArrayOfTouples(origin, position )
        }
    }
    
    
    func mapOneOrTwoSingleWithFunc< U>(  _ transform: (T) -> U) -> OneOrTwo<U> {
        switch self {
        case let (.one(value1)):
            return .one(one: transform(value1))
        case let (.two(left1, right1)):
            return .two(
                left: transform(left1),
                right: transform(right1))
        }
    }
    
    
    func mapPairOfOneOrTwoWithFunc<U, V>(
        _ second: OneOrTwo<V>,
        _ transform: (T, V) -> U)
    -> OneOrTwo<U> {
        switch (self, second) {
        case let (.one(value1), .one(value2)):
            return .one(one: transform(value1, value2))
            
        case let (.two(left1, right1), .two(left2, right2)):
            return .two(left: transform(left1, left2), right: transform(right1, right2))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map2")
        }
    }

    
    func mapOneOrTwoPairWithFunc<V, U>( _ second: OneOrTwo<V>, _ transform: (T, V) -> U) -> OneOrTwo<U> {
        let (first,second) = OneOrTwo<Any>.convert2OneOrTwoToAllTwoIfMixedOneAndTwo(self, second)
        switch (first, second) {
        case let (.one(value1), .one(value2)):
            return .one(one: transform(value1, value2))
        case let (.two(left1, right1), .two(left2, right2)):
            return .two(
                        left: transform(left1, left2),
                        right: transform(right1, right2))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map3")
        }
    }
    

    func mapTripleOneOrTwoWithFunc<V, W, U>( _ second: OneOrTwo<V>, _ third: OneOrTwo<W>,_ transform: (T, V, W) -> U) -> OneOrTwo<U> {

       let (first,second, third) = convert3OneOrTwoToAllTwoIfMixedOneAndTwo(self, second, third)
        switch (first, second, third) {
        case let (.one(value1), .one(value2), .one(value3)):
            return .one(one: transform(value1, value2, value3))
        case let (.two(left1, right1), .two(left2, right2), .two(left3, right3)):
            return .two(
                        left: transform(left1, left2, left3),
                        right: transform(right1, right2, right3))
        default:
            // Handle other cases if needed
            fatalError("Incompatible cases for map3")
        }
    }

 
    func mapTwoToOneUsingOneId<Dimension3d>(_ id: PartTag) -> OneOrTwo<Dimension3d> {
        switch self {
        case .two(let left, let right):
            return id == .id0 ? .one(one: left as! Dimension3d): .one(one: right as! Dimension3d )
        case .one:
           fatalError("only .two may be used")
        }
    }
    
    
    ///if the child has one and the parent has two then the child should use the relevant
    ///parent based on its id
  static func convert2OneOrTwoToAllTwoIfMixedOneAndTwo<U, V>(
        _ value1: OneOrTwo<U>,
        _ value2: OneOrTwo<V>
    ) -> (OneOrTwo<U>, OneOrTwo<V>) {
        switch (value1, value2) {
        case let (.one(oneValue), .two):
            return (.two(left: oneValue, right: oneValue), value2)
        case let (.two, .one(oneValue)):
            return (value1, .two(left: oneValue, right: oneValue))
        default:
            return (value1, value2)
        }
    }
    
    
    func convert3OneOrTwoToAllTwoIfMixedOneAndTwo<U, V, W>(
        _ value1: OneOrTwo<U>,
        _ value2: OneOrTwo<V>,
        _ value3: OneOrTwo<W>)
    -> (OneOrTwo<U>, OneOrTwo<V>, OneOrTwo<W>) {
        switch (value1, value2, value3) {
        case let (.one(oneValue), .two, .two):
            return ( .two(left: oneValue, right: oneValue), value2, value3)
        case let (.two, .one(oneValue), .two):
            return (value1, .two(left: oneValue, right: oneValue), value3)
        case let (.one(firstOneValue), .two, .one(secondOneValue)):
            return (.two(left: firstOneValue, right: firstOneValue), value2, .two(left: secondOneValue, right: secondOneValue))
        case let (.two, .two, .one(oneValue)):
            return (value1, value2, .two(left: oneValue, right: oneValue))
        default:
            return (value1, value2, value3)
        }
    }
    
    
    
    func mapWithDoubleOneOrTwoWithOneOrTwoReturn(
        _ value0: OneOrTwo<PositionAsIosAxes>)
    -> OneOrTwo<PositionAsIosAxes> {
        switch (self, value0) {
        case let (.two (left0, right0) , .two(left1, right1)):
            let leftAdd = left0 as! PositionAsIosAxes + left1
            let rightAdd = right0 as! PositionAsIosAxes + right1
            return .two(left: leftAdd, right: rightAdd)
        case let (.one( one0), .one(one1)):
            let oneAdd = one0 as! PositionAsIosAxes + one1
            return .one(one: oneAdd)
        default:
            fatalError("\n\n\(String(describing: type(of: self))): \(#function ) a problem exists with one or both of the OneOrTwo<PositionAsIosAxes>)")
        }
    }

    
    func mapSixOneOrTwoToOneFuncWithVoidReturn(
         _ value1: OneOrTwo<String>,
         _ value2: OneOrTwo<RotationAngles>,
         _ value3: OneOrTwo<AngleMinMax>,
         _ value4: OneOrTwo<PositionAsIosAxes>,
         _ value5: OneOrTwo<PositionAsIosAxes>,
         _ transform: (Dimension3d, String, RotationAngles, AngleMinMax, PositionAsIosAxes, PositionAsIosAxes)  -> ()) {
         switch (self, value1, value2, value3, value4, value5) {
         case let (.one(one0), .one(one1), .one(one2), .one(one3), .one(one4), .one(one5)):
             transform(one0 as! Dimension3d, one1, one2, one3, one4, one5)
         
         
         case let (.two(left0, right0), .two(left1, right1), .two(left2, right2), .two(left3, right3), .two(left4, right4), .two(left5, right5) ):
             transform(left0 as! Dimension3d, left1, left2, left3, left4, left5)
             transform(right0 as! Dimension3d, right1, right2, right3, right4, right5)
         default:
             break
//              fatalError("\n\n\(String(describing: type(of: self))): \(#function ) the fmap has either one globalPosition and two id or vice versa for \(value1)")
         }
     }
}
