//
//  ResetPositionButtonView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 03/06/2024.
//

import SwiftUI

struct  CentrePhotoButtonView: View {
  
    @EnvironmentObject private var centrePhotoButtonViewModel: CenterPhotoButtonViewModel
    

    
    var body: some View {
        let isNotShowing = centrePhotoButtonViewModel.notShowing
        Button(action: {
            centrePhotoButtonViewModel.resetPositions()
        }) {Text ("centre photo")}
            .buttonStyle(PictureScaleBlueButton())
            .opacity(isNotShowing ? 0.1: 1.0)
            .modifier(MenuButtonWithTextFont())
            .disabled(isNotShowing)
    }
}
