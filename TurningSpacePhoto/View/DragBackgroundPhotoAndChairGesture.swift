//
//  DragBackgroundPhotoAndChairGesture.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 18/06/2024.
//

import Foundation
import SwiftUI



struct DragPhotoAndChairsGesture: Gesture {
    @Binding var xChange: Double
    @Binding var yChange: Double
 
   
    @EnvironmentObject var dragPhotoAndChairsGestureMediator: DragPhotoAndChairsGestureMediator
    @GestureState private var startLocation: CGPoint? = nil

    var body: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .updating($startLocation) { value, startLocation, _ in
                startLocation = startLocation ?? dragPhotoAndChairsGestureMediator.photoLocation
            }
            .onChanged { value in
                guard let startLocation = startLocation else { return }
                let newLocation = CGPoint(
                    x: startLocation.x + value.translation.width,
                    y: startLocation.y + value.translation.height
                )
               
                dragPhotoAndChairsGestureMediator.setPhotoLocation((newLocation.x, newLocation.y))

                let xTranslation = value.translation.width
                let yTranslation = value.translation.height

                xChange = xTranslation - xChange
                yChange = yTranslation - yChange
          
                dragPhotoAndChairsGestureMediator.setPhotoLocationChange((x: xChange, y: yChange))
                
                xChange = xTranslation
                yChange = yTranslation
            }
            .onEnded { value in
                xChange = 0.0
                yChange = 0.0
            }
    }
}




import Combine

class DragPhotoAndChairsGestureMediator: ObservableObject {
    @Published var photoLocation = PhotoService.shared.photoLocation
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        PhotoService.shared.$photoLocation
            .sink { [weak self] newData in
                self?.photoLocation = newData
            }
            .store(
                in: &cancellables
            )
    }
    
    
    func setPhotoLocationChange(_ value: (x: Double, y: Double)) {
        PhotoLocationChangeService.shared.setLocationChange(value)
    }
    
    
    func setPhotoLocation(_ value: (x: Double, y: Double)) {
        PhotoService.shared.setPhotoLocation(CGPoint(x: value.x, y: value.y))
    }
}
