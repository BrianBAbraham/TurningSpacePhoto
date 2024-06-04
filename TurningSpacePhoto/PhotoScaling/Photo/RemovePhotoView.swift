//
//  RemovePhotoView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 01/06/2024.
//

import SwiftUI

struct RemovePhotoView: View {
    @EnvironmentObject private var removePhotoVM: RemovePhotoViewModel
   
    var body: some View {
        Button(action: {
            removePhotoVM.removePhoto()

        }) { Text("Remove")}

            .disabled(!removePhotoVM.isActive)
            .opacity(removePhotoVM.isActive ? 1.0: 0.1)
    }
      
}

