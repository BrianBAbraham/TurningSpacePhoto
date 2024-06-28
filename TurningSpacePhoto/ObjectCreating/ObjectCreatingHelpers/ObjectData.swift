//
//  ObjectData.swift
//  CreateObject
//
//  Created by Brian Abraham on 17/05/2024.
//

import Foundation

struct ObjectData {
    let objectChainLabelsDefaultDic: ObjectChainLabelDictionary
    
    let objectChainLabelsUserEditedDic: ObjectChainLabelDictionary
    
    var partDataDic: [Part: PartData] = [:]
    
    let objectType: ObjectTypes
    
    let userEditedDic: UserEditedDictionaries?
    
    let size: Dimension = (width: 0.0, length: 0.0)

    var allChainLabels: [Part] = []
    
    let chainLabelsAccountingForEdit: [Part]
    
    var oneOfEachPartInAllPartChainAccountingForEdit: [Part] = []
    
   // let linkedPartsDictionary = LinkedParts().dictionary
    
    init(
        _ objectType: ObjectTypes,
        _ userEditedDic: UserEditedDictionaries?,
        _ chainLabelsAccountingForEdit: [Part]) {
        
        self.objectType = objectType
        self.userEditedDic = userEditedDic
        self.objectChainLabelsDefaultDic = ObjectChainLabel.dictionary
        self.objectChainLabelsUserEditedDic = userEditedDic?.objectChainLabelsUserEditDic ?? [:]
        self.chainLabelsAccountingForEdit = chainLabelsAccountingForEdit
        allChainLabels = getAllPartChainLabels()
            
        
        oneOfEachPartInAllPartChainAccountingForEdit = AllPartInObject.getOneOfAllPartInObjectAfterEdit(chainLabelsAccountingForEdit)
       
            
        checkObjectHasAtLeastOnePartChain()
        
        initialiseAllPart()
        
        postProcessGlobalOrigin()
    
    }
    
    func checkObjectHasAtLeastOnePartChain(){
        for label in allChainLabels {
            let labelInPartChainOut = LabelInPartChainOut(label)
            guard labelInPartChainOut.partChain.isEmpty == false else {
                fatalError("chainLabel \(label) has no partChain in LabelInPartChainOut")
            }
        }
    }
    
    
   mutating func postProcessGlobalOrigin(){
        let allPartChain = getAllPartChain()
        var partsToHaveGlobalOriginSet =
           oneOfEachPartInAllPartChainAccountingForEdit
     
        for chain in allPartChain {
            processPart( chain)
        }

        func processPart(_ chain: [Part]) {
            for index in 0..<chain.count {
                let part = chain[index]
                if partsToHaveGlobalOriginSet.contains(part){
                let parentGlobalOrigin = getParentGlobalOrigin(index)
                    setGlobalOrigin(part, parentGlobalOrigin)
                  partsToHaveGlobalOriginSet = removePartFromArray(part)
                }
            }
            
            
            func getParentGlobalOrigin(_ index: Int) -> OneOrTwo<PositionAsIosAxes> {
                if index == 0 {
                    return .one(one: ZeroValue.iosLocation)
                } else {
                   let parentPart = chain[index - 1]
                    
                    guard let parentPartValue = partDataDic[parentPart] else {
                        fatalError()
                    }
                    return parentPartValue.globalOrigin
                }
            }
        }

       
        func getAllPartChain() -> [[Part]]{
            var allPartChain: [[Part]] = []
            for label in allChainLabels {
                allPartChain.append(getPartChain(label))
            }
            return allPartChain
        }

        
       func setGlobalOrigin(
        _ part: Part,
        _ parentGlobalOrigin: OneOrTwo<PositionAsIosAxes>) {
            guard let partData = partDataDic[part] else {
                fatalError("This part:\(part) has not been intialised where the parent global origin is \(parentGlobalOrigin)")
            }
            let childOrigin = partData.childOrigin
            
            let modifiedParentGlobalOrigin: OneOrTwo<PositionAsIosAxes> = allowForTwoParentAndOneChild()
            
            let globalOrigin =
                   getGlobalOrigin(childOrigin, modifiedParentGlobalOrigin)
            
            let modifiedPartValue = partData.withNewGlobalOrigin(globalOrigin)
            
            partDataDic[part] = modifiedPartValue
            
            
            func allowForTwoParentAndOneChild() -> OneOrTwo<PositionAsIosAxes>{
                if childOrigin.oneNotTwo() && !parentGlobalOrigin.oneNotTwo() {
                    guard let childId = partData.id.one else {
                        fatalError("no child id")
                    }
                    return
                        parentGlobalOrigin.mapTwoToOneUsingOneId(childId)
                } else {
                    return
                        parentGlobalOrigin
                }
            }
        }
        
        
        func getGlobalOrigin(
        _ childOrigin: OneOrTwo<PositionAsIosAxes>,
        _ parentGlobalOrigin: OneOrTwo<PositionAsIosAxes>)
       -> OneOrTwo<PositionAsIosAxes> {
            let (modifiedChildOrigin, modifiedParentGlobalOrigin) =
                OneOrTwo<Any>.convert2OneOrTwoToAllTwoIfMixedOneAndTwo (childOrigin, parentGlobalOrigin)
            return
                modifiedChildOrigin.mapWithDoubleOneOrTwoWithOneOrTwoReturn(modifiedParentGlobalOrigin)
        }
       
       
       func removePartFromArray(_ elementToRemove: Part) -> [Part] {
           partsToHaveGlobalOriginSet.filter { $0 != elementToRemove }
       }
    }
}



//MARK: Create PartData Dictionary
extension ObjectData {
    mutating func initialiseAllPart() {
        
        partDataDic +=
        [.objectOrigin: ZeroValue.partData]
        
        if oneOfEachPartInAllPartChainAccountingForEdit.contains(.stabiliser) {
            initialiseFoundationalPart(.stabiliser)//ADDED
        }
        
        for part in oneOfEachPartInAllPartChainAccountingForEdit {
            if part != .stabiliser {
                let parentOrLinkedPart: Part
                
                parentOrLinkedPart = getLinkedOrParentPart(part)
            
                initialisePart(parentOrLinkedPart, part )
            }
        }
    }

    
    //foundational part has no parent parts
    mutating func initialiseFoundationalPart(
        _ child: Part
    ) {
        let foundationalData =
        StructFactory(
            objectType,
            userEditedDic,
            independantPart: child
        )
        .partData
            
        partDataDic +=
            [child: foundationalData]
    }
    
    
    //all non-foundational have a parent or linked part
    mutating func initialisePart(
        _ linkedlOrParentPart: Part,
        _ child: Part
    ) {
        var childData: PartData = ZeroValue.partData
        guard let linkedOrParentData = partDataDic[linkedlOrParentPart] else {
            fatalError("no partValue for \(linkedlOrParentPart)")
        }
        childData =
            StructFactory(
                objectType,
                userEditedDic,
                linkedOrParentData,
                child,
                chainLabelsAccountingForEdit)
                    .partData
        partDataDic +=
            [child: childData]
    }
    

    func getOneOfEachPartInAllPartChain() -> [Part]{
        var oneOfEachPartInAllChainLabel: [Part] = []
            for label in allChainLabels {
               let partChain = LabelInPartChainOut(label).partChain
                for part in partChain {
                    if !oneOfEachPartInAllChainLabel.contains(part) {
                        oneOfEachPartInAllChainLabel.append(part)
                    }
                }
            }
        return oneOfEachPartInAllChainLabel
    }
    
    
    func getLinkedOrParentPart(_ childPart: Part) -> Part {
        /// a part may have a physical parent part
        /// or a part which  it is linked to
        let linkedPartDic: [Part: Part] = getLinkedPartDic()
        var linkedOrParentPart: Part = .stabiliser//default
        for label in allChainLabels {
            let partChain = LabelInPartChainOut(label).partChain//get partChain for label
            for i in 0..<partChain.count {
                if let linkedPart = linkedPartDic[childPart], linkedPart != .notFound {
                    //use dictionary devined part as linked part
                    linkedOrParentPart = linkedPart
                } else if childPart == partChain[i] && i != 0 {
                    //use the preceding part in the partChain as parent
                    linkedOrParentPart = partChain[i - 1]
                }
            }
        }
        return linkedOrParentPart
        
        
        func getLinkedPartDic() -> [Part: Part] {
             [
                    .fixedWheelHorizontalJointAtRear: .mainSupport,
                    .fixedWheelHorizontalJointAtMid: .mainSupport,
                    .fixedWheelHorizontalJointAtFront: .mainSupport,
                    .casterVerticalJointAtRear: .mainSupport,
                    .casterVerticalJointAtMid: .mainSupport,
                    .casterVerticalJointAtFront: .mainSupport,
                    .steeredVerticalJointAtFront: .mainSupport
                    ]
        }
        
    }
    
    
    func getPartChain(_ label: Part) -> [Part] {
        LabelInPartChainOut(label).partChain
    }
    
    
    func getAllPartChainLabels() -> [Part] {
        guard let chainLabels =
        objectChainLabelsUserEditedDic[objectType] ??
                objectChainLabelsDefaultDic[objectType] else {
            fatalError("there are no partChainLabel for object \(objectType)")
        }
        return chainLabels
    }
}
