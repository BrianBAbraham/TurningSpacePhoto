//
//  ResetPositionButtonView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 03/06/2024.
//

import SwiftUI

struct  CentrePhotonButtonView: View {
  
    @EnvironmentObject private var centrePhotoButtonViewModel: CentrePhotoButtonViewModel
    

    
    var body: some View {
        let isNotShowing = centrePhotoButtonViewModel.isNotShowing
        Button(action: {
            centrePhotoButtonViewModel.resetPositions()
        }) {Text ("centre photo")}
            .buttonStyle(PictureScaleBlueButton())
            .opacity(isNotShowing ? 0.1: 1.0)
            .modifier(MenuButtonWithTextFont())
            .disabled(isNotShowing)
    }
}
