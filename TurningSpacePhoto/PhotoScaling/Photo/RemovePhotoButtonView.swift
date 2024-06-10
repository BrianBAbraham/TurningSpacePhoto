//
//  RemovePhotoView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 01/06/2024.
//

import SwiftUI

struct RemovePhotoButtonView: View {
    @EnvironmentObject private var removePhotoVM: RemovePhotoButtonViewModel
    @StateObject private var viewModel = PhotoPickerViewModel()
   
    var body: some View {
        Button(action: {
            removePhotoVM.removePhoto()
            viewModel.removeSelectedImage()
        }) { Text("Remove")}

            .disabled(!removePhotoVM.isActive)
            .opacity(removePhotoVM.isActive ? 1.0: 0.1)
    }
      
}

