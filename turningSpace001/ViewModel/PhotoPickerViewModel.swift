//
//  PhotoPickerViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 18/10/2022.
//

import Foundation
class PhotoPickerViewModel: ObservableObject {
 

    @Published private var photoPickerSize: [Double]
   
    init (photoPickerSize: [Double]) {
        self.photoPickerSize = photoPickerSize
    }
}
//
//
//extension PhotoPickerViewModel {
//    
//    
//    func getPhotoDidNotLoad () -> Bool {
//        photoPickerModel.photoDidNotLoad
//    }
//    
//    func getPhotoLoading () -> Bool {
//        photoPickerModel.photoLoading
//    }
//    
//    func setPhotoDidNotLoad (_ status: Bool){
//        photoPickerModel.photoDidNotLoad = status
//    }
//    
//    func setPhotoLoading (_ status: Bool){
//        photoPickerModel.photoLoading = status
//    }
//    
//
//}
