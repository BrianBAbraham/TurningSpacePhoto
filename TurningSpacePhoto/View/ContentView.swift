//
//  ContentView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI






struct ContentView: View {
    
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM

   @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    
    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom: Double {
        0.07 / chairManoeuvreProjectVM.model.manoeuvreScale
    }
    private let maximimumZoom = 5.0
    var zoom: CGFloat {
        limitZoom( 1 + currentZoom + lastCurrentZoom)
   
    }
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    
    var body: some View {

        ZStack{
            ScaleDimensionLineView(zoom)

            ZStack {
            PhotoManagementView()
                .zIndex(2.0)
             

            ChairMovementOnChosenPhoto(zoom)
                .gesture(MagnificationGesture()
                    .onChanged { value in
                        currentZoom = value - 1
                        //tools to edit chair movment only appear at sufficient zoom
                        visibleToolViewModel.setZoomForTool(zoom, chairManoeuvreProjectVM.model.manoeuvreScale)
                    }
                    .onEnded { value in
                        lastCurrentZoom += currentZoom
                        currentZoom = 0.0
                    }
                 )


            RightSideMenuView()
                .zIndex(11.0)

            MenuForChairView()

            ConditionalUnscaledPhotoAlertView()
                        
            }
        }
    }

}




