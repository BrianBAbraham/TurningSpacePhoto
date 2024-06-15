//
//  ContentView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI






struct DragBackgroundPictureAndChairsGesture: Gesture {
    @Binding var xChange: Double
    @Binding var yChange: Double
    @EnvironmentObject var chosenPhotoVM: ChosenPhotoViewModel
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM
    @GestureState private var startLocation: CGPoint? = nil

    var body: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .updating($startLocation) { value, startLocation, _ in
                startLocation = startLocation ?? chosenPhotoVM.chosenPhotoLocation
            }
            .onChanged { value in
                guard let startLocation = startLocation else { return }
                let newLocation = CGPoint(
                    x: startLocation.x + value.translation.width,
                    y: startLocation.y + value.translation.height
                )
                chosenPhotoVM.setChosenPhotoLocation(newLocation)

                let xTranslation = value.translation.width
                let yTranslation = value.translation.height

                xChange = xTranslation - xChange
                yChange = yTranslation - yChange
                chairManoeuvreProjectVM.modifyAllMovementLocationsByBackgroundPictureDrag(CGPoint(x: xChange, y: yChange))
                xChange = xTranslation
                yChange = yTranslation
            }
            .onEnded { value in
                xChange = 0.0
                yChange = 0.0
            }
    }
}


struct ChairMovementOnChosenBackground: View {
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM
    @EnvironmentObject var scalingCompletedViewModel: ScalingCompletedViewModel
    @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel
    
    var arrayOfForEachMovementOfOneChairArrayChairMovementPart:  [(chairIndex: Int, chairMovementsParts: [Type.ChairMovementParts])] {
        chairManoeuvreProjectVM.getForEachMovementOfOneChairArrayChairMovementPart()
    }

    var body: some View {
        ZStack{
            ChosenPhotoView()
               
            if scalingCompletedViewModel.scalingCompleted {
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
    @EnvironmentObject var showUnscaledPhotoAlertVM: ShowUnscaledPhotoAlertViewModel
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM
    @EnvironmentObject var chosenPhotoVM: ChosenPhotoViewModel
    @EnvironmentObject var scalingCompletedViewModel: ScalingCompletedViewModel
    @EnvironmentObject var photoMenuVM: PhotoMenuViewModel
    @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
    var scalingCompleted: Bool {
        scalingCompletedViewModel.scalingCompleted
    }
    

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
    
    


    var backgroundWhenInChairMenu: some View {
        LocalFilledRectangle.path(0,0,SizeOf.screenWidth * 1, SizeOf.screenHeight * 1,.white,0.9)
    }

    
    func chosenBackground() -> some View {
        // set backGround to scale that was last applied in the PhotoScaleView
        return
            Group {
                if scalingCompleted {
                    ChosenPhotoView()
                }
       
                else {
                    if scalingCompleted {
                        backgroundWhenInChairMenu
                    }
                }
            }
    }
    
    
    var showAlert: Bool {
        var state = true
//        if alertVM.getPickerImageAddedWhenNoChairsStatus() {
//            state =
//            !scalingCompleted
//            && chairManoeuvreProjectVM.chairManoeuvres.count > 0 && //chosenPhotoScaleVM.getImagePickerStatus() &&
//            scalingCompleted
//
//        }
        return state
    }
    

   
    
    
    
    var body: some View {

        ZStack{
     
            if scalingCompleted
            {
               ScaleDimensionLineView(zoom)
            }

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
                
               ConditionalScaleAlert()
                            
                
            }
        }
    }

}





//struct ConditionalScaleAlert: View {
//    @EnvironmentObject var showUnscaledPhotoAlertVM: ShowUnscaledPhotoAlertViewModel
//    @State private var isAlertPresented = true
//    @State private var showText = false
//
//    var body: some View {
//        if showUnscaledPhotoAlertVM.showAlert {
//            VStack {
//                Button("Alert") {
//                    isAlertPresented = true
//                }
//                Spacer()
//            }
//            .alert(isPresented: $isAlertPresented) {
//                Alert(
//                    title: Text("PLAN NOT SCALED"),
//                    message: Text("You have left the photo-scaling menu without setting a scale. To compare a wheelchair against a plan you must set the correct scale.\n Set dimension and Go to scale"),
//                    dismissButton: .default(Text("OK"), action: {
//                        showText = true
//                        isAlertPresented = false
//                    })
//                )
//            }
//            .padding()
//        } else {
//            EmptyView()
//        }
//    }
//}

struct ConditionalScaleAlert: View {
    @EnvironmentObject var showUnscaledPhotoAlertVM: ShowUnscaledPhotoAlertViewModel
    @State private var isAlertPresented = true
    @State private var showText = false

    var body: some View {
        if showUnscaledPhotoAlertVM.showAlert {
            VStack {
                Button("Alert") {
                    isAlertPresented = true
                }
                Spacer()
            }
            .alert(isPresented: $isAlertPresented) {
                Alert(
                    title: Text("PLAN NOT SCALED"),
                    message: Text("You have left the photo-scaling menu without setting a scale. To compare a wheelchair against a plan you must set the correct scale.\n Set dimension and Go to scale"),
                    primaryButton: .default(Text("Set Scale"), action: {

                        showUnscaledPhotoAlertVM.setPreventPhotoMenuDimissTrue()
                        //showUnscaledPhotoAlertVM.showAlert = false
                    }),
                    secondaryButton: .cancel(Text("Do not scale"), action: {
                        showUnscaledPhotoAlertVM.setPreventPhotoMenuDimissFalse()
                        //showUnscaledPhotoAlertVM.showAlert = false
                    })
                )
            }
            .padding()
        } else {
            EmptyView()
        }
    }
}
