//
//  PhotoPickerViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 18/05/2024.
//


import Foundation
import SwiftUI
import PhotosUI




@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
   
    //@Published
    var selectedPhoto: Image? = nil
    @Published var selectedPhotoItem: PhotosPickerItem? = nil {
        didSet {
            setPhoto(from: selectedPhotoItem)
        }
    }
   
    var isLoading: Bool = false
    
    let photoService = PhotoService.shared
    
    private func setPhoto(from selection: PhotosPickerItem?) {
        guard let selection else { return }
            
        isLoading = true
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
               
                    self.selectedPhoto = Image(uiImage: uiImage)
                        
                    //make photo available to all subscribers
                    photoService.setPhoto(Image(uiImage: uiImage))
                
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
        guard let unwrapped = selectedPhoto else {
            fatalError()
        }
        
        return unwrapped
    }
    

}

