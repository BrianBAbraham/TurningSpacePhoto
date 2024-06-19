//
//  ContentView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI



struct ChairMovementOnChosenBackground: View {
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM
  
    var arrayOfForEachMovementOfOneChairArrayChairMovementPart:  [(chairIndex: Int, chairMovementsParts: [Type.ChairMovementParts])] {
        chairManoeuvreProjectVM.getForEachMovementOfOneChairArrayChairMovementPart()
    }

    var body: some View {
        ZStack{
            ChosenPhotoView()
             
            VStack{
                ForEach( arrayOfForEachMovementOfOneChairArrayChairMovementPart, id: \.chairIndex) { item in
                    ChairMovementsView(forEachMovementOfOneChairArrayChairMovementPart: item.chairMovementsParts)
                    TurnHandleConditionalView(forEachMovementOfOneChairArrayChairMovementPart: item.chairMovementsParts)
                }
            }

        }

    }
}



struct ContentView: View {
    @EnvironmentObject var alertVM: AlertViewModel
    @EnvironmentObject var showUnscaledPhotoAlertVM: UnscaledPhotoAlertViewModel
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM
    @EnvironmentObject var chosenPhotoVM: ChosenPhotoViewModel
    @EnvironmentObject var photoMenuVM: PhotoMenuViewModel
    @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom: Double {
        0.07 / chairManoeuvreProjectVM.model.manoeuvreScale
    }
    private var maximimumZoom = 5.0
    var zoom: CGFloat {
        let zoom =
        limitZoom( 1 + currentZoom + lastCurrentZoom)
       
    return zoom
    }
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    var body: some View {

        ZStack{
     

               ScaleDimensionLineView(zoom)


            ZStack {
                PhotoManagementView()
                    .zIndex(photoMenuVM.showMenu ? 2.0: 2.0)
          
                ChairMovementOnChosenBackground()
                    .scaleEffect(zoom)
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
                
                ReturnToRightSideMenuView()
                    .zIndex(11.0)
                
                ConditionalRightSideMenuView()
                    .zIndex(11.0)
                
               MenuForChairView() 
                
               ConditionalUnscaledPhotoAlertView()
                            
                
            }
        }
    }

}




