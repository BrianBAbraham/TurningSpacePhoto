//
//
// ObjectImageData
//
//  Created by Brian Abraham on 02/06/2023.
//

import Foundation


struct ObjectImageData {
    
    var angleMinMaxDic: AngleMinMaxDictionary = [:]
    
    struct PreTilt {
        fileprivate  var objectToPartOriginDic: PositionDictionary = [:]
        fileprivate  var parentToPartOriginDic: PositionDictionary = [:]
        var objectToPartFourCornerPerKeyDic: CornerDictionary = [:]//external access
        fileprivate var objectToPartEightCornerPerKeyDic: CornerDictionary = [:]
    }
    var preTilt = PreTilt()
    
    struct PostTilt {
        fileprivate var objectToRotatedPartOriginDic: PositionDictionary = [:]
        var objectToPartFourCornerPerKeyDic: CornerDictionary = [:]
        fileprivate var objectToPartEightCornerPerKeyDic: CornerDictionary = [:]
        var objectToOneCornerPerKeyDic: PositionDictionary = [:]
    }
    var postTilt = PostTilt()
    
    let objectChainLabelsDefaultDic: ObjectChainLabelsDictionary = ObjectChainLabel.dictionary
    
    var partDataDic: [Part: PartData] = [:]
   
    var objectDimension: Dimension = (width: 0.0, length: 0.0)

    fileprivate var dimensionDic: Part3DimensionDictionary = [:]
    fileprivate var angleUserEditDic: AnglesDictionary = [:]
    fileprivate let chainLabelsAccountingForEdit: [Part]
    fileprivate var rotators: [Part] = []
    fileprivate var rotatedParts: [[Part]] = []
  
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?) {
            let objectType = objectType
            
            let objectChainLabelsUserEditedDic = userEditedDic?.objectChainLabelsUserEditDic ?? [:]
            
            chainLabelsAccountingForEdit = ObjectImageData.getChainLabelsAccountingForEdit(
                for: objectType,
                using: objectChainLabelsUserEditedDic,
                defaultDic: objectChainLabelsDefaultDic)
            
            let objectData = ObjectData(
                objectType,
                userEditedDic,
                chainLabelsAccountingForEdit)
            
            partDataDic =
                objectData.partDataDic
              
            createPreTiltDictionaryFromStructFactory()
            
            createPostTiltDictionaries()
            
            addOriginToDictionary()
            
            addArcPointsToDictionary()
            
            getSize()
    }
    
    
    mutating func addOriginToDictionary() {
        let z = ZeroValue.iosLocation
        let name =
            CreateNameFromIdAndPart(PartTag.id0, PartTag.origin).name

        postTilt.objectToPartFourCornerPerKeyDic[name] = [z,z,z,z]
    }

    
   mutating func getSize() {
        let  postTiltObjectToOneCornerPerKeyDic =
        ConvertFourCornerPerKeyToOne(
            fourCornerPerElement:  postTilt.objectToPartFourCornerPerKeyDic
        ).oneCornerPerKey
       
        let minMax =
        CreateIosPosition.minMaxPosition(
            postTiltObjectToOneCornerPerKeyDic
        )
        
      objectDimension =
       CreateIosPosition.convertMinMaxToDimension(minMax)

    }
    
    
    mutating func addArcPointsToDictionary( ) {
        let arcPoints =
        CreateIosPosition.filterPointsToConvexHull( points:
            postTilt.objectToOneCornerPerKeyDic.map {$0.value}
        )
        
        var arcNames = postTilt.objectToOneCornerPerKeyDic.map{$0.key}
        arcNames = PrependArcNameToGenericNamePart.get(arcNames)
                
        for index in 0..<arcNames.count {
            
            if arcPoints[index].x != Double.infinity {
                let corners = Array(repeating: arcPoints[index], count: 4)
                postTilt.objectToPartFourCornerPerKeyDic += [arcNames[index]: corners]
            }
        }
    }
    
    
    static func getChainLabelsAccountingForEdit(
        for objectType: ObjectTypes,
        using userEditedDic: [ObjectTypes: [Part]],
        defaultDic: [ObjectTypes: [Part]]
    ) -> [Part] {
        guard let unwrapped = userEditedDic[objectType] ?? defaultDic[objectType] else {
            fatalError(
                "no chain labels for this object \(objectType)"
            )
        }
        return unwrapped
    }
}



//MARK: PretTiltDic
extension ObjectImageData {

    mutating func createPreTiltDictionaryFromStructFactory() {
        for chainLabel in chainLabelsAccountingForEdit {
            processChainLabelForDictionaryCreation(chainLabel)
        }
    }

    
    mutating  func processChainLabelForDictionaryCreation(_ chainLabel: Part) {
        let chain = LabelInPartChainOut(chainLabel).partChain
        for part in chain {
           processPartForDictionaryCreation(
           part)
        }
    }
            
    
    mutating func processPartForDictionaryCreation(
        _ part: Part) {
        guard let partValue = partDataDic[part]
            else {
            return fatalErrorGettingPartValue() }

        let globalOrigin = partValue.globalOrigin
        let childOrigin = partValue.childOrigin
            
        partValue.dimension.mapSixOneOrTwoToOneFuncWithVoidReturn  (
        partValue.originName,
        partValue.angles,
        partValue.minMaxAngle,
        globalOrigin,
        childOrigin,
            { (dimension,
               originName,
               angles,
               minMaxAngle,
               globalOrigin,
               childOrigin)
                in self.updateDictionaries(//the whole point
                    dimension,
                    originName,
                    angles,
                    minMaxAngle,
                    globalOrigin,
                    childOrigin) }
        )
            
        func fatalErrorGettingPartValue(){
            fatalError( "\n\n\(String(describing: type(of: self))): \(#function ) no values exist for this part: \(part)")
        }
    }
            
    
    mutating func updateDictionaries(
        _ dimension: Dimension3d,
        _ name: String,
        _ angle: RotationAngles,
        _ minMaxAngle: AngleMinMax,
        _ globalOrigin: PositionAsIosAxes,
        _ childOrigin: PositionAsIosAxes) {
        let allCorners = createCorner(dimension, globalOrigin)
        let displayedCorners = [4,5,6,7].map {allCorners[$0]}
        let dictionaryUpdate =
            DictionaryUpdate(
                name: name,
                dimension: dimension,
                globalOrigin: globalOrigin,
                childOrigin: childOrigin,
                angle: angle,
                minMaxAngle: minMaxAngle,
                allCorners: allCorners,
                dispayedCorners: displayedCorners)
            
        process(dictionaryUpdate)
            
            
    func process(_ update: DictionaryUpdate) {
            let name = update.name
            angleUserEditDic +=
             [name: update.angle]
            angleMinMaxDic +=
             [name: update.minMaxAngle]
            dimensionDic +=
              [name: update.dimension]
            preTilt.objectToPartOriginDic +=
              [name: update.globalOrigin]
            preTilt.parentToPartOriginDic +=
              [name: update.childOrigin]
            preTilt.objectToPartFourCornerPerKeyDic +=
              [name: update.dispayedCorners]
            preTilt.objectToPartEightCornerPerKeyDic +=
              [name: update.allCorners]
        }
         

        struct DictionaryUpdate {
            let name: String
            let dimension: Dimension3d
            let globalOrigin: PositionAsIosAxes
            let childOrigin: PositionAsIosAxes
            let angle: RotationAngles
            let minMaxAngle: AngleMinMax
            let allCorners: [PositionAsIosAxes]
            let dispayedCorners: [PositionAsIosAxes]
        }
    }
    
            
    func createCorner(
        _ dimension: Dimension3d,
        _ origin: PositionAsIosAxes)
    -> [PositionAsIosAxes]{
        let corners: [PositionAsIosAxes] =  CreateIosPosition
            .getCornersFromDimension(
                dimension
            )
        let cornersFromObject =
        CreateIosPosition.addToupleToArrayOfTouples(
            origin,
            corners
        )
        //let topViewCorners = [4,5,6,7].map {cornersFromObject[$0]}
        return
            cornersFromObject
            //topViewCorners
    }
}



//MARK: PostTiltDic
    extension ObjectImageData {
   
        
    func getRotators() -> [Part] {
        var rotators: [Part] = []
        for chainLabel in self.chainLabelsAccountingForEdit {
            guard let  values = partDataDic[chainLabel] else {
               fatalError("no values defined for chain labels \(chainLabel)")
            }
            rotators += values.partsToBeRotated != [] ? [chainLabel]: []
        }
       let orderedRotators = orderRotatorsForMultipleRotations(rotators)

        return orderedRotators
        
        func orderRotatorsForMultipleRotations(_ unorderedRotators: [Part]) -> [Part] {
            let rotatorOrder: [Part] = [.sitOnTiltJoint, .backSupportTiltJoint]
            var correctedRotatorOrder: [Part] = []
            for rotator in rotatorOrder {
                if unorderedRotators.contains(rotator) {
                    correctedRotatorOrder.append(rotator)
                }
            }
            return correctedRotatorOrder
        }
    }
        
        
    func getOrderedPartsToBeRotatedByEachRotator(_ rotators: [Part]) -> [[Part]] {
        var orderedPartsToBeRotatedByEachRotator: [[Part]] = []
        for rotator in rotators {
            guard let partData = partDataDic[rotator] else {fatalError("\(rotator)")}
            orderedPartsToBeRotatedByEachRotator.append( partData.partsToBeRotated)
        }
        return orderedPartsToBeRotatedByEachRotator
    }
        
        
    mutating func createPostTiltDictionaries(){
        // initially set postTilt to preTilt values
        postTilt.objectToPartFourCornerPerKeyDic =
        preTilt.objectToPartFourCornerPerKeyDic
        postTilt.objectToPartEightCornerPerKeyDic =
            preTilt.objectToPartEightCornerPerKeyDic
            
            rotators = getRotators()
            rotatedParts = getOrderedPartsToBeRotatedByEachRotator(rotators)
   
            for index in 0..<rotators.count {
                processRotationOfAllPartsByOneRotator(rotators[index],rotatedParts[index])
            }
            
            postTilt.objectToOneCornerPerKeyDic =
                ConvertFourCornerPerKeyToOne(
                    fourCornerPerElement: postTilt.objectToPartFourCornerPerKeyDic).oneCornerPerKey
    }
        
        
    mutating func processRotationOfAllPartsByOneRotator(
        _ rotatorPart: Part,
        _ allPartsRotatableByRotator:[Part]){

        let partDataForAllPartsToBeRotated = getPartData(allPartsRotatableByRotator)
            
        let rotatorPartData = getPartData([rotatorPart])[0]//only one
        let originNames: [OneOrTwo<String>] = getAllOriginNames()
            
        let rotatorData = getRotatorData()
            
        let allOriginsAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] =
            getAllOriginsAfterRotationdByOneRotator(rotatorData)
            
            for i in 0..<rotatorData.allPartsToBeRotated.count {
                let cornerPositionFromDimension: OneOrTwo<[PositionAsIosAxes]> =
                getLocalCornerPositionsBeforePartRotation(i)
                
                //order matters start
                //do first
                let cornerPositionsAccountingForPriorRotation: OneOrTwo<[PositionAsIosAxes]> =
                rotatorPart == .backSupportTiltJoint ?
                getCornerPositionsAllowingForPriorDimensionRotation(
                    partDataForAllPartsToBeRotated[i],
                    cornerPositionFromDimension): cornerPositionFromDimension
                //do second otherwise prior origin is not used
                updatePostTiltObjectToRotatedPartOriginDic(i)
                //order matters end
                
                let allLocalCornerPositionsAfterRotationAccountingForPriorRotation =
                getLocalCornerPositionsForOneRotatedPartAfterRotation(cornerPositionsAccountingForPriorRotation)
                
                let displayedLocalCornerPositionsAfterRotationAccountingForPriorRotation =
                removeUnseenCorners(allLocalCornerPositionsAfterRotationAccountingForPriorRotation)
                
                let displayedGlobalCornerPosition =
                getDisplayedGlobalCornerPositionForOneRotatedPartAfterRotationByOneRotator(
                    displayedLocalCornerPositionsAfterRotationAccountingForPriorRotation, i)
                
                let allGlobalCornerPosition =
                getDisplayedGlobalCornerPositionForOneRotatedPartAfterRotationByOneRotator(
                    allLocalCornerPositionsAfterRotationAccountingForPriorRotation, i)
                
                let _ = originNames[i].mapPairOfOneOrTwoWithFunc(displayedGlobalCornerPosition){addPartsToFourCornerDic($0, $1)}
                let _ = originNames[i].mapPairOfOneOrTwoWithFunc(allGlobalCornerPosition){addPartsToEightCornerDic($0, $1)}
            }
            
            
        func getPartData(_ parts: [Part]) -> [PartData]{
            var partDataForAllPartsToBeRotated: [PartData] = []
            for part in parts {// get PartData for rotated parts
                guard let partData = partDataDic[part] else {
                    fatalError("part \(parts) has no PartData \(rotatorPart)" )
                    }
                partDataForAllPartsToBeRotated.append(partData)
            }
            return partDataForAllPartsToBeRotated
        }
        

        func getAllOriginNames () -> [OneOrTwo<String>] {
            var originNames: [OneOrTwo<String>] = []
            for i in 0..<allPartsRotatableByRotator.count {
                let partData = partDataForAllPartsToBeRotated[i]
                originNames.append(partData.originName)
            }
            return originNames
        }
            
            
        func getRotatorData() -> Rotator {
            guard let angle: OneOrTwo<RotationAngles> = partDataDic[rotatorPart]?.angles else {
                fatalError("\n\n\(String(describing: type(of: self))): \(#function ) no values exists for: \(rotatorPart) ") }
            var dimensions: [OneOrTwo<Dimension3d>] = []
            var globalOriginsAccountingForPriorRotations: [OneOrTwo<PositionAsIosAxes>] = []
            for i in 0..<allPartsRotatableByRotator.count {
                let partData = partDataForAllPartsToBeRotated[i]
                let originsAccountingForPriorRotations = getOneOrTwoOriginsAccountingForPriorRotation(partData)
                dimensions.append(partData.dimension)
                globalOriginsAccountingForPriorRotations.append(originsAccountingForPriorRotations)
            }
            return
                Rotator(
                    rotatorOrigin:
                        getOneOrTwoOriginsAccountingForPriorRotation(rotatorPartData),
                    originOfAllPartsToBeRotated:
                        globalOriginsAccountingForPriorRotations,
                    partsToBeRotatedDimension:
                        dimensions,
                    angle:
                        angle,
                    allPartsToBeRotated: allPartsRotatableByRotator,
                    rotator: rotatorPart)
            
                func getOneOrTwoOriginsAccountingForPriorRotation(
                    _ partData:PartData )
                -> OneOrTwo<PositionAsIosAxes>{
                    let names = partData.id.getNamesArray(partData.part)
                    var dictionaryOrigin: [PositionAsIosAxes?] = []
                    for name in names {
                        dictionaryOrigin.append( postTilt.objectToRotatedPartOriginDic[name])
                    }
                    return partData.globalOrigin.getOneOrTwoOriginAllowingForEdit(dictionaryOrigin)
                }
        }

            
        func updatePostTiltObjectToRotatedPartOriginDic(_ index: Int) {
            let partData = partDataForAllPartsToBeRotated[index]
            let originAfterRotationByRotator = allOriginsAfterRotationByRotator[index]

                let part = partData.part
                let names =  partData.id.getNamesArray( part)
                let positions = originAfterRotationByRotator.getPositionsArray(part)
         
                for (name, position) in zip (names, positions) {
                    postTilt.objectToRotatedPartOriginDic += [name: position]
                }
        }
     
            
        func getLocalCornerPositionsBeforePartRotation (
             _ index: Int)
        -> OneOrTwo<[PositionAsIosAxes]> {
                let dimension = rotatorData.partsToBeRotatedDimension[index]
                let allCornerPositionsBeforeRotation: OneOrTwo<[PositionAsIosAxes]> =
                    dimension.getOneOrTwoCornerArrayFromDimension
                    { CreateIosPosition.getCornersFromDimension($0) }

                return allCornerPositionsBeforeRotation
        }
        
        
        func getLocalCornerPositionsForOneRotatedPartAfterRotation (
             _ allCornerPositionsBeforeRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]>)
        -> OneOrTwo<[PositionAsIosAxes]> {
           let allCornerPositionsAfterRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]> =
                        allCornerPositionsBeforeRotationByOneRotator.mapOneOrTwoPairWithFunc(
                            rotatorData.angle) {calculateRotatedCornerInLocal($0, $1)}
            
            return allCornerPositionsAfterRotationByOneRotator
        }
        
        
        func removeUnseenCorners(
            _ oneLocalCornerPositionsForPartAfterRotationByOneRotator: OneOrTwo<[PositionAsIosAxes]>)
        -> OneOrTwo<[PositionAsIosAxes]> {
                oneLocalCornerPositionsForPartAfterRotationByOneRotator
                    .mapOneOrTwoSingleWithFunc {getTopViewCorners($0)}
        }
        
        
        func getDisplayedGlobalCornerPositionForOneRotatedPartAfterRotationByOneRotator(
            _ oneLocalCornerPositionsForPartAfterRotationByOneRotator:
                OneOrTwo<[PositionAsIosAxes]>,
            _ index: Int)
        -> OneOrTwo<[PositionAsIosAxes]> {
            
            let rotatedOrigin = allOriginsAfterRotationByRotator[index]//this should be backSupportTiltJoint
            let global =  oneLocalCornerPositionsForPartAfterRotationByOneRotator.addToOneOrTwo(rotatedOrigin)
            return global
        }
        
        
        func getCornerPositionsAllowingForPriorDimensionRotation(
            _ partData: PartData,
            _ cornerPositionsFromDimension: OneOrTwo<[PositionAsIosAxes]>)
        -> OneOrTwo<[PositionAsIosAxes]> {
         
            // comparing part origin to determine if prior rotation exists
            let preOrigin: OneOrTwo<PositionAsIosAxes> =
            partData.originName.getDictionaryValue(preTilt.objectToPartOriginDic)
            let postOrigin: OneOrTwo<PositionAsIosAxes> =
                partData.originName.getDictionaryValue(postTilt.objectToRotatedPartOriginDic)
            let postGlobalCorners: OneOrTwo<[PositionAsIosAxes]> =
                partData.originName.getDictionaryValues(postTilt.objectToPartEightCornerPerKeyDic)
            let localCornerPositions: OneOrTwo<[PositionAsIosAxes]> =
                preOrigin.getDefaultOrRotatedCorners(postOrigin, cornerPositionsFromDimension, postGlobalCorners)
            
            return localCornerPositions
        }
    }
            
            
    func getTopViewCorners(_ allCorners: [PositionAsIosAxes]) -> [PositionAsIosAxes]{
        return [4,5,2,3].map{allCorners[$0]}
    }
    

            
     mutating  func addPartsToFourCornerDic(
         _ name: String,
         _ partCornerPosition: [PositionAsIosAxes]) {
            postTilt.objectToPartFourCornerPerKeyDic += [name: partCornerPosition]
    }

        
    mutating  func addPartsToEightCornerDic(
        _ name: String,
        _ partCornerPosition: [PositionAsIosAxes]) {
           postTilt.objectToPartEightCornerPerKeyDic += [name: partCornerPosition]
    }

        
    struct Rotator {
        let rotatorOrigin: OneOrTwo<PositionAsIosAxes>
        let originOfAllPartsToBeRotated: [OneOrTwo<PositionAsIosAxes>]
        let partsToBeRotatedDimension: [OneOrTwo<Dimension3d>]
        let angle: OneOrTwo<RotationAngles>
        let allPartsToBeRotated: [Part]
        let rotator: Part
    }
       
        
    func getAllOriginsAfterRotationdByOneRotator(
        _ rotator: Rotator)
    -> [OneOrTwo<PositionAsIosAxes>] {
        var allOriginAfterRotationByRotator: [OneOrTwo<PositionAsIosAxes>] = []
        
        for i in 0..<rotator.originOfAllPartsToBeRotated.count {
                    allOriginAfterRotationByRotator.append(
                    rotator.rotatorOrigin.mapTripleOneOrTwoWithFunc(
                    rotator.originOfAllPartsToBeRotated[i],
                    rotator.angle ) { calculateRotatedOrigin($0, $1, $2) } )
        }
        
        return allOriginAfterRotationByRotator
    }


    func calculateRotatedOrigin(
        _ rotatorOrigin: PositionAsIosAxes,
        _ partOrigin: PositionAsIosAxes,
        _ angle: RotationAngles)
    -> PositionAsIosAxes {
        let positionRelativeToRotator =
            CreateIosPosition.subtractSecondFromFirstTouple(partOrigin, rotatorOrigin)
        let rotatedPosition =
            PositionOfPointAfterRotationAboutPoint(
                staticPoint:ZeroValue.iosLocation,
                movingPoint: positionRelativeToRotator,
                angleChange: angle.x,
                rotationAxis: .yAxis //
            ).fromObjectOriginToPointWhichHasMoved + rotatorOrigin

        return   rotatedPosition
    }

    
        
    func calculateRotatedCornerInLocal(
        _ cornerPositions: [PositionAsIosAxes],
        _ angle: RotationAngles = ZeroValue.rotationAngles)
    -> [PositionAsIosAxes]  {
        var rotatedCorners: [PositionAsIosAxes] = []
        guard angle.y.value == 0.0 || angle.z.value == 0.0 else {
            fatalError("\(String(describing: type(of: self))): \(#function ) only x rotation are coded \(angle.y.value)  \(angle.z.value) ")
        }
        for index in 0..<cornerPositions.count {
            let newCornerPosition =
            PositionOfPointAfterRotationAboutPoint(
                staticPoint:ZeroValue.iosLocation,
                movingPoint: cornerPositions[index],
                angleChange: angle.x,
                rotationAxis: .yAxis
            ).fromObjectOriginToPointWhichHasMoved
            rotatedCorners.append(
             newCornerPosition)
        }
        return rotatedCorners
    }
        
}

//    func getSideViewCorners(_ allCorners: [PositionAsIosAxes]) -> [PositionAsIosAxes]{
//        let corners = [7,3,0,4].map{allCorners[$0]}
//        var sideWaysCorners: [PositionAsIosAxes] = []
//        for corner in corners {
//            sideWaysCorners.append((x: corner.y, y:corner.z ,z: corner.x))
//        }
                
        //print(corners.count)
//        return sideWaysCorners
//    }

//    func calculateRotatedCorner(
//        _ rotatedOriginOfPart: PositionAsIosAxes,
//        _ cornerPositions: [PositionAsIosAxes],
//        _ angle: RotationAngles = ZeroValue.rotationAngles)
//    -> [PositionAsIosAxes]  {
//        var rotatedCorners: [PositionAsIosAxes] = []
//        guard angle.y.value == 0.0 || angle.z.value == 0.0 else {
//            fatalError("\(String(describing: type(of: self))): \(#function ) only x rotation are coded \(angle.y.value)  \(angle.z.value) ")
//        }
//        for index in 0..<cornerPositions.count {
//            let newCornerPosition =
//            PositionOfPointAfterRotationAboutPoint(
//                staticPoint:ZeroValue.iosLocation,
//                movingPoint: cornerPositions[index],
//                angleChange: angle.x
//            ).fromObjectOriginToPointWhichHasMoved
//            rotatedCorners.append(
//             newCornerPosition + rotatedOriginOfPart)
//        }
//        return rotatedCorners
//    }
