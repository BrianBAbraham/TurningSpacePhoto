//
//  ScalingPhotoView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 18/05/2024.
//


import SwiftUI


struct ScalingPhotoView: View {
    @EnvironmentObject var scalingPhotoVM: ScalingPhotoViewModel
    
   
    @GestureState private var startScalingPhotoLocation: CGPoint? = nil // 1
    
    var dragScalingPhoto: some Gesture {
       
        DragGesture()
            .onChanged { value in
                var newLocation = startScalingPhotoLocation ?? scalingPhotoVM.scalingPhotoLocation//
                    newLocation.x += value.translation.width
                    newLocation.y += value.translation.height
                scalingPhotoVM.setScalingPhotoLocation(newLocation)
            }
            .updating($startScalingPhotoLocation) { (value, startLocation, transaction) in
                    startLocation = startLocation ??
                scalingPhotoVM.scalingPhotoLocation
                
            }
    }
    

    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var minimumZoom = 0.1
    private var maximimumZoom = 5.0
    var photoScalingZoom: CGFloat {
        let zoom =
        limitZoom( 1 + currentZoom + lastCurrentZoom)
        return zoom
    }
    
    var body: some View {
        
        if scalingPhotoVM.showScalingPhoto {
            Group {
                scalingPhotoVM.scalingPhoto! // if checks for nil
             
                .initialImageModifier()
                .scaleEffect(photoScalingZoom)
                .position(scalingPhotoVM.scalingPhotoLocation)
                .gesture(dragScalingPhoto)
                .gesture(MagnificationGesture()
                    .onChanged { value in
                        currentZoom = value - 1
                    }
                    .onEnded { value in
                        lastCurrentZoom += currentZoom
                        currentZoom = 0.0
                        scalingPhotoVM.setFinalChosenPhotoZoom(photoScalingZoom)
                    })
            }
        }
    }
    
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
    }
}

