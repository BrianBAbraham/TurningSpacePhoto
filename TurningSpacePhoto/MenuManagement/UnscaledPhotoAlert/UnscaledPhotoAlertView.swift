//
//  UnscaledPhotoAlertView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 17/06/2024.
//

import SwiftUI



struct UnscaledPhotoAlertView: View {
    @EnvironmentObject var unscaledPhotoAlertVM: UnscaledPhotoAlertViewModel
    
    @State private var showText = false

    var body: some View {

            VStack {

                Button(action: {
                    unscaledPhotoAlertVM.setShowUnscaledPhotoAlertDialogTrue()
                }) {
                    Text("Plan unscaled!")
                        .foregroundColor(.red) // Set the text color to red
                }
                Spacer()
            }
            .alert(isPresented: $unscaledPhotoAlertVM.showAlertDialog) {
                Alert(
                    title: Text("PLAN NOT SCALED"),
                    message: Text("You have left photo-scaling without setting the scale. To compare a wheelchair against a plan you must position the dotted scaling lines and input the plan dimension and tap \"Go\" \n\nOr if just playing without a scaled plan, do not scale"),
                    primaryButton: .default(Text("Set Scale"), action: {
                        unscaledPhotoAlertVM.setProceedWithScalingPhoto()

                    }),
                    secondaryButton: .cancel(Text("Do not scale"), action: {
                        unscaledPhotoAlertVM.setProceedWithUnscaledPhoto()
                    })
                )
            }
            .padding()
        
    }
}



struct ConditionalUnscaledPhotoAlertView: View {
    
    @EnvironmentObject var conditionalUnscaledPhotoAlertVM: ConditionalUnscaledPhotoAlertViewModel
    
    var body: some View {
        if conditionalUnscaledPhotoAlertVM.showAlert {
             UnscaledPhotoAlertView()
        }  else {
            EmptyView()
        }
    }
}
