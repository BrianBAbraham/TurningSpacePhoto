//
//  AllPartViewModel.swift
//  CreateObject
//
//  Created by Brian Abraham on 25/07/2024.
//

import SwiftUI
import Combine




struct PartModel: Identifiable {
    let id: String
    let points: [CGPoint]
    let screenDepth: Double
    let color: Color
    let cornerRadius: Double
    let lineWidth: Double
    let opacity: Double
}

class AllPartViewModel: ObservableObject,
    SharedPartToEditFunc {
    
    @Published var partModels: [PartModel] = []
  
    
    var movementDictionaryForScreen: CornerDictionary =
       MovementDictionaryForScreenService.shared.movementDictionaryForScreen
    
    var partToEdit: Part = ObjectEditService.shared.partToEdit
    
    var uniquePartNames: [String] = []
    
    var movementImageData: MovementImageData =
        MovementImageService.shared.movementImageData
    
    func handlePartToEditChange( _ newData: Part){
        // newData is not passed in this use of func
        updatePartModels()
    }
    
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        updateData()
    
        MovementDictionaryForScreenService.shared.$movementDictionaryForScreen
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newDictionary in
                self?.movementDictionaryForScreen = newDictionary
                self?.updatePartModels()
            }
            .store(in: &cancellables)
        
        
        MovementImageService.shared.$movementImageData
            .sink { [weak self] newData in
                guard let self = self else { return }
                self.movementImageData = newData
                self.uniquePartNames = getUniquePartNamesFromObjectDictionary()
                self.updateData()
            }
            .store(in: &cancellables)
        
        (self as SharedPartToEditFunc).subscribeToService()

      
    }
    
    
    private  func updateData() {
        /// transfrom data so that the static point on
        /// the first object is at the center of the whole data display
        let newData =
        ObjectZeroStaticPointAtMovementFrameCenter(
                  movementImageData)
        //share the data
        ObjectZeroStaticPointAtMovementFrameCenterService.shared.setObjectZeroStaticPointAtMovementFrameCenter(newData)

        //extract the dictionary for View part
        let movementDictionaryForScreen = newData.movementDictionaryForScreen
        
          //Share the new dictionary
          MovementDictionaryForScreenService.shared.setMovementDictionaryForScreen(
             movementDictionaryForScreen
          )
    }
    
    
    func updatePartModels(){
        // Create a new array of PointsModel from the dictionary
        partModels = []
        
        for name in uniquePartNames {
            //print(name)
            guard let value =  movementDictionaryForScreen[name] else {
                fatalError("the movementDictionaryForScreen is not updated")
            }
            var points: [CGPoint] = []
            for corner in value {
                points.append(CGPoint(x: corner.x , y: corner.y))
            }
            
            let screenDepth = value[0].z// all four heights are equal
            let color = isPartToEdit(name, partToEdit) ? Color("selectedPart"): .white
            
            let partModel =
            PartModel(
                id: name,
                points: points
                ,
                screenDepth: screenDepth,
                color:Color(
                    color
                ),
                cornerRadius: 10.0,
                lineWidth: 5.0,
                opacity: 0.9
            )
            
            partModels.append(partModel)
        }
     }
    
    
    func isPartToEdit(_ uniquePartName: String, _ partToEdit: Part) -> Bool {
        let partName = partToEdit.rawValue
        let generalName = UniqueToGeneralName(uniquePartName).generalName
        return partName == generalName
    }
    
    
    func getUniquePartNamesFromObjectDictionary() -> [String] {
        let dic = movementImageData.objectImageData.postTilt.objectToPartFourCornerPerKeyDic
        let names =
        Array(
            dic.keys
        ).filter {
            !(
                $0.contains(
                    PartTag.arcPoint.rawValue //UI manages differently from parts
                )  || $0.contains(
                    PartTag.origin.rawValue// ditto
                )  || $0.contains(
                    PartTag.staticPoint.rawValue// ditto
                ) //|| $0.contains(
                    //Part.stabiliser.rawValue// fixed wheel edits this
               // )
            ) }
      
        return names
    }
}

