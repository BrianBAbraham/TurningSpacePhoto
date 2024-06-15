//
//  PhotoPickerViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 18/05/2024.
//


import Foundation
import SwiftUI
import PhotosUI


//struct PhotoPickerModel {
//    var modelSelectedImage: Image?
//    var pickerSelectedImage: Image?
//}




@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
   
    @Published var selectedImage: Image? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
   
    var isLoading: Bool = false
    
    var photoService = PhotoService.shared
    var scaleService = ScaleService.shared

    private func setImage(from selection: PhotosPickerItem?) {
            guard let selection else { return }
            
        isLoading = true
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
               
                    self.selectedImage = Image(uiImage: uiImage)
                        //make photo presence known to all
                                        
                        photoService.setPhoto(Image(uiImage: uiImage))
                    
                        scaleService.setScalingCompletedFalse()
                    
                    //if a photo exists protect against unscalred use
                    let _ = UnscaledPhotoAlertMediator.shared
                    
                        self.isLoading = false
                 
                } else {
                        self.isLoading = false
                }
            } else {
                    self.isLoading = false
                }
        }
    }
    
    
    func getSelectedImage() -> Image {
        guard let unwrapped = selectedImage else {
            fatalError()
        }
        
        return unwrapped
    }
    
    func removeSelectedImage() {
        selectedImage = nil
        imageSelection = nil
        photoService.removePhoto()
    }

}

//
//import SwiftUI
//import PhotosUI

//@MainActor
//final class PhotoPickerViewModel: ObservableObject {
//    
//    @Published var selectedImage: Image? = nil
//    @Published var imageSelection: PhotosPickerItem? = nil {
//        didSet {
//            setImage(from: imageSelection)
//        }
//    }
//    @Published var refreshPicker: Bool = false // Add this line
//    var isLoading: Bool = false
//    
//    var photoService = PhotoService.shared
//    var scaleService = ScaleService.shared
//
//    private func setImage(from selection: PhotosPickerItem?) {
//        guard let selection else { return }
//        
//        isLoading = true
//        print("Loading image...")
//        Task {
//            if let data = try? await selection.loadTransferable(type: Data.self) {
//                if let uiImage = UIImage(data: data) {
//                    self.selectedImage = Image(uiImage: uiImage)
//                    print("Image set successfully")
//                    // Make photo presence known to all
//                    photoService.setPhoto(Image(uiImage: uiImage))
//                    scaleService.setScalingCompletedFalse()
//                }
//                self.isLoading = false
//            } else {
//                self.isLoading = false
//            }
//        }
//    }
//    
//    func getSelectedImage() -> Image {
//        guard let unwrapped = selectedImage else {
//            fatalError()
//        }
//        return unwrapped
//    }
//
//    func removeSelectedImage() {
//    
//        selectedImage = nil
//        imageSelection = nil
//        refreshPicker.toggle()
//        print("Selected image and image selection set to nil")
//        photoService.removePhoto() // Assuming this method exists in your PhotoService
//    }
//}
