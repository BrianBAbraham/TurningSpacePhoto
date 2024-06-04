//
//  MenuScalePictureViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//


    
import Foundation
import Combine

class ScalingViewModel: ObservableObject {
    private(set) var scalingModel = ScalingModel()
    @Published var scalingCompleted: Bool = ScaleService.shared.scalingCompleted
    @Published var scale: Double = ScaleService.shared.scale
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.updatePhotoStatus(newData)
            }
            .store(in: &cancellables)
        
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.updateScalingCompleted(newData)
            }
            .store(in: &cancellables)
        
        
        ScaleService.shared.$scale
            .sink { [weak self] newData in
                self?.updateScale(newData)
            }
            .store(in: &cancellables)
    }
    
    private func updatePhotoStatus(_ newData: Bool) {
        photoStatus = newData
        scalingModel.buttonIsDisabled = getButtonIsDisabledStatus()
        
    }
    
    private func updateScalingCompleted(_ newData: Bool) {
        scalingCompleted = newData
        scalingModel.buttonIsDisabled = getButtonIsDisabledStatus()
    }
    
    private func updateScale(_ newData: Double) {
        scale = newData
        scalingModel.scale = scale
    }
    
    private var photoStatus: Bool = PhotoService.shared.photoStatus {
        didSet {
            scalingModel.buttonIsDisabled = getButtonIsDisabledStatus()
        }
    }
    
    func getButtonIsDisabledStatus() -> Bool {
        //if no photo or photo but scaling completed
        return !photoStatus || scalingCompleted
    }
}

    
 
