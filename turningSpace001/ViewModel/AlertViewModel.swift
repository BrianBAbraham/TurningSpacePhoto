//
//  AlertViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 15/10/2022.
//

import Foundation

class AlertViewModel: ObservableObject {
 

    @Published private var alertModel: AlertModel = AlertModel()
   
    
}

extension AlertViewModel {
    func getPickerImageAddedWhenNoChairsStatus() -> Bool {
        alertModel.pickerImageAddedWhenNoChairsStatus
    }
    
    func setPickerImageAddedWhenNoChairsStatus(_ status: Bool) {
        alertModel.pickerImageAddedWhenNoChairsStatus = status
    }
    
}
