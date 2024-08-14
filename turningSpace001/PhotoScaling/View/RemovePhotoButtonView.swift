//
//  RemovePhotoView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 01/06/2024.
//

import SwiftUI

struct RemovePhotoButtonView: View {
    @EnvironmentObject private var removePhotoVM: RemovePhotoButtonViewModel
  
   
    var body: some View {
      
        Button(action: {
            removePhotoVM.removePhoto()
 
        }) { Text("Remove")}

            .disabled(removePhotoVM.notShowing)
            .opacity(removePhotoVM.notShowing ? 0.1: 1.0)
    }
      
}

