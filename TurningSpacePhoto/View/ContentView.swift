//
//  ContentView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI

struct ContentView: View {

    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private let  minimumZoom = 0.5
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




