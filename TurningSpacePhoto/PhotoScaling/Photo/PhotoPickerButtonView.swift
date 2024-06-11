//
//  PhotoPickerButtonView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 20/05/2024.
//

import SwiftUI

struct PhotoPickerButtonView: View {
    @EnvironmentObject private var photoPickerVM: PhotoPickerViewModel

    @State private var showPicker = false
    var body: some View {

        Button(action: {
            showPicker = true
        }) {
            Text(
                "Photo"
            )
        }
        .photosPicker(
            isPresented: $showPicker,
            selection: $photoPickerVM.imageSelection,
            matching: .images
        )
    }
}


