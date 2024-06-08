//
//  ShowScalingDimensionSelectorMediator.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 06/06/2024.
//

import Foundation
import Combine



class ShowScalingDimensionSelectorMediator {
    
    static let shared = ShowScalingDimensionSelectorMediator()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private (set) var notShowing = true
    private var scalingCompleted = ScaleService.shared.scalingCompleted
    private var photoStatus = PhotoService.shared.photoStatus
 
    init() {
      
        //other processes may set scalingCompleted
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
                self?.setShowing()
                
        }
        .store(in: &cancellables)
        
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
                self?.setShowing()
               
        }
        .store(in: &cancellables)
    }
    
    func setShowing()  {
        if photoStatus == true && scalingCompleted == false {
            notShowing = false
        } else {
            notShowing = true
        }
        ShowViewService.shared.setScalingDimensionSelectorView(notShowing)
    }
    
}
