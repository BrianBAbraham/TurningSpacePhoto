//
//  PlanDimensionSelectorViewModel.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 30/05/2024.
////
//
//import Foundation
//import Combine
//
//class PlanDimensionSelectorViewModel: ObservableObject {
//  //  @Published private(set) var scaleButtonModel = ConfirmScaleButtonModel()
//    @Published var scalingCompleted: Bool = ScaleService.shared.scalingCompleted
//    
//    @Published var selecterIsDisabled = true
//    
//    private var cancellables: Set<AnyCancellable> = []
//    
//    init() {
//        PhotoStatusService.shared.$photoStatus
//            .sink { [weak self] newData in
//                self?.updatePhotoStatus(newData)
//            }
//            .store(in: &cancellables)
//        
//        ScaleService.shared.$scalingCompleted
//            .sink { [weak self] newData in
//                self?.updateScalingCompleted(newData)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func updatePhotoStatus(_ newData: Bool) {
//        photoStatus = newData
//        selecterIsDisabled = getSelecterIsDisabledStatus()
//    }
//    
//    private func updateScalingCompleted(_ newData: Bool) {
//        scalingCompleted = newData
//        selecterIsDisabled = getSelecterIsDisabledStatus()
//    }
////    
//    @Published private (set) var photoStatus: Bool = PhotoStatusService.shared.photoStatus// {
////        didSet {
////            scaleButtonModel.buttonIsDisabled = getButtonIsDisabledStatus()
////        }
//   // }
////
//    func getSelecterIsDisabledStatus() -> Bool {
//        //if no photo or photo but scaling completed
//        return !photoStatus || scalingCompleted
//    }
//}
