//
//  ConfirmScaleButtonView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//
import SwiftUI

struct ConfirmScaleButtonView: View {

    @EnvironmentObject  var confirmScaleButtonViewModel: ConfirmScaleButtonViewModel
        
    var body: some View {
        Button(action: {
        
           confirmScaleButtonViewModel.setScalingCompleted()
            
        }) {Text(" Go ") }
            .buttonStyle(PictureScaleBlueButton())
            .opacity(confirmScaleButtonViewModel.notShowing ? 0.1: 1.0)
            .modifier(MenuButtonWithTextFont())
            .disabled(confirmScaleButtonViewModel.notShowing)
    }
}







