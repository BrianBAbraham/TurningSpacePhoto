//
//  PhotoPicker.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

//https://www.youtube.com/watch?v=k4h9i6KVvi8

import SwiftUI
import PhotosUI

//struct PHPickerView: UIViewControllerRepresentable {
//    @Binding var image: Image?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//print("makeUIViewController")
//        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//print("PHPickerView")
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: PHPickerView
//        init(parent: PHPickerView) {
//            self.parent = parent
//print("Coordinator")
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//print("Image LOADING")
//            parent.presentationMode.wrappedValue.dismiss()
//            if let itemsProvider = results.first?.itemProvider,
//               itemsProvider.canLoadObject(ofClass: UIImage.self) {
//                itemsProvider.loadObject(ofClass: UIImage.self) {[weak self]
//                    (image, error) in
//                    DispatchQueue.main.async {
//                        guard let self = self,
//                              let image = image as? UIImage
//                        else {
//                            print("Not UIImage")
//                            return }
//                        self.parent.image = Image(uiImage: image)
//                        _ = PhotoPickerViewModel(photoPickerSize: [image.size.width, image.size.height])
//                        print ("image width: \(image.size.width)   image width: \(image.size.height)  screenWidth: \(SizeOf.screenWidth)")
//                    }
//                }
//            } else {
//                print("Cannot load image")
//            }
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//print("Coordinator")
//       return Coordinator(parent: self)
//    }
//}



struct PHPickerView: UIViewControllerRepresentable {
    @Binding var image: Image?
    @Environment(\.presentationMode) var presentationMode
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerView
        init(parent: PHPickerView) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            if let itemsProvider = results.first?.itemProvider,
               itemsProvider.canLoadObject(ofClass: UIImage.self) {
                itemsProvider.loadObject(ofClass: UIImage.self) {[weak self]
                    
                    (image, error) in
                    DispatchQueue.main.async {
                        guard let self = self,
                              let image = image as? UIImage
                        else {
                            print("Not UIImage")
                            return }
                        self.parent.image = Image(uiImage: image)
//print ("image width: \(image.size.width)   image height: \(image.size.height)  screenWidth: \(SizeOf.screenWidth)")
                    }
                }
            } else {
                print("Cannot load image")
            }
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
