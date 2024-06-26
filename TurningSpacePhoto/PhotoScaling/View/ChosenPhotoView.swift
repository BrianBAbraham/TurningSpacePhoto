//
//  ChosenPhotoView2.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 31/05/2024.
//

import SwiftUI

struct ChosenPhotoView: View {
    @EnvironmentObject var chosenPhotoVM: ChosenPhotoViewModel
    @State private var xChange = 0.0
    @State private var yChange = 0.0
    @GestureState private var fingerBackgroundPictureLocation: CGPoint? = nil
    @GestureState private var startBackgroundPictureLocation: CGPoint? = nil // 1
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerBackgroundPictureLocation) { (value, fingerBackgroundPictureLocation, transaction) in
                fingerBackgroundPictureLocation = value.location
            }
    }
    

    var body: some View {
        if chosenPhotoVM.chosenPhotoStatus {
            chosenPhotoVM.chosenPhoto!//safe with if
                .initialImageModifier()
            // set backGround to scale last applied in the PhotoScaleView
            // all further scale change in chair and photo view as must synchronise
            // all drag must act on chair and photo
                .scaleEffect(chosenPhotoVM.finalPhotoZoom)
                .position(chosenPhotoVM.photoLocation)
                .gesture(DragPhotoAndChairsGesture(
                    xChange: $xChange,
                    yChange: $yChange
                ))
                .gesture(fingerDrag)
                .zIndex(0)
            
        } else {
            EmptyView()
               
        }
     }
}
