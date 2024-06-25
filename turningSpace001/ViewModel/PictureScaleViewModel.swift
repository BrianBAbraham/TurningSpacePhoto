//
//  PictureScaleViewModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import SwiftUI


class PictureScaleViewModel: ObservableObject {
    
    @Published private (set) var pictureScaleModel: ImageScaleModel =
    ImageScaleModel(imageMagnification: 1.0)
    
}


extension PictureScaleViewModel {
    
    func getBackgroundImage() -> Image? {
       let image = pictureScaleModel.backgroundPicture

        return image
    }
    
    
    func getBackgroundImageExists(_ photoPicImage: Image?) -> Bool {
        let image = pictureScaleModel.backgroundPicture

        let state = photoPicImage == nil && image == nil

        return state
    }
    
    func getBackgroundPictureLocation() -> CGPoint {
//print("getBackgroundPictureLocation")
       return pictureScaleModel.backgroundPictureLocation
    }
    
    
    func getBackgroundPictureSatus() -> Bool {
        //
        //pictureScaleModel.backgroundPicture == nil ? false: true
        let status =
        pictureScaleModel.backgroundPicture == nil ? false: true
       // print("getBackgroundPictureSatus \(status)")
    return status
        
    }
        
    
    func getImageZoom( _ callerName: String? = "unknown") -> Double {
       // print("Get final phto zoom by \(String(describing: callerName)) \(pictureScaleModel.imageMagnification))")
        return
        pictureScaleModel.imageMagnification
    }
    
    
    func getImagePickerStatus() -> Bool {
        //pictureScaleModel.pickerImageStatus
        
        let status =
        pictureScaleModel.pickerImageStatus
        
       // print(" getImagePickerStatus \(status)" )
        
        return status
    }
 
    
    func setBackgroundImage (_ picture: Image?) {
//print("\nVM SETS BACKGROUND PICTURE\n")
        pictureScaleModel.backgroundPicture = picture
    }
    
    func setBackgroundImageToNil () {
//print("\nVM SETS BACKGROUND PICTURE\n")
        pictureScaleModel.backgroundPicture = nil
    }

    
    func setBackgroundPictureLocation(_ location: CGPoint) {
//print("SET IMAGE LOCATION")
        pictureScaleModel.backgroundPictureLocation = location
    }
    
    
    func setImageZoom(_ magnification: CGFloat ) {

        pictureScaleModel.imageMagnification = magnification
    }
    

    func setImagePickerStatus(_ status: Bool)  {
        pictureScaleModel.pickerImageStatus = status
    }
}

