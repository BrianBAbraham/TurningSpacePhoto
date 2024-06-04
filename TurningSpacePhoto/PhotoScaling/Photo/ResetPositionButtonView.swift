//
//  ResetPositionButtonView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 03/06/2024.
//

import SwiftUI

struct  ResetPositionButtonView: View {
  
    @EnvironmentObject private var resetPositionButtonViewModel: ResetPositionButtonViewModel
    
    var disabled: Bool {
        !resetPositionButtonViewModel.isActive
    }
    
    var body: some View {
        Button(action: {
            resetPositionButtonViewModel.resetPositions()
        }) {Text ("reset positions")}
            .buttonStyle(PictureScaleBlueButton())
            .opacity(disabled ? 0.1: 1.0)
            .modifier(MenuButtonWithTextFont())
            .disabled(disabled)
    }
}
