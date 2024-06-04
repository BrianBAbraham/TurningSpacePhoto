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
    let chosenPhoto: Image?
    init (_ chosenPhoto: Image?) {
        self.chosenPhoto = chosenPhoto
    }
    var body: some View {
        // set backGround to scale that was last applied in the PhotoScaleView
        let finalZoomInPhotoPicker = chosenPhotoVM.getFinalChosentPhotoZoom()
        
        return
            Group {
        
                if let unwrapped = self.chosenPhoto {
                    unwrapped
                        .initialImageModifier()
                        .scaleEffect(finalZoomInPhotoPicker )
                        .position(chosenPhotoVM.getChosenPhotoLocation())
                        .gesture(DragBackgroundPictureAndChairsGesture(
                            xChange: $xChange,
                            yChange: $yChange
                        ))
                        .gesture(fingerDrag)
                }
                
                
                else {
                    EmptyView()
                }
            }
    }
}
