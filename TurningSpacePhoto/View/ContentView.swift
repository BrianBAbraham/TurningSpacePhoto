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


struct ContentView: View {
    @EnvironmentObject var alertVM: AlertViewModel
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM
    @EnvironmentObject var chosenPhotoVM: ChosenPhotoViewModel
    @EnvironmentObject var scalingCompletedViewModel: ScalingCompletedViewModel
    @EnvironmentObject var scaleMenuVM: PhotoMenuViewModel
    @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel
    @EnvironmentObject  var scaleValueProviderVM: ScaleValueProviderMediator
  //  @EnvironmentObject var photoPickerVM: PhotoPickerViewModel
    @GestureState private var fingerBackgroundPictureLocation: CGPoint? = nil
    @GestureState private var startBackgroundPictureLocation: CGPoint? = nil // 1
    @State private var xChange = 0.0
    @State private var yChange = 0.0
    
    var mainScale: Double {
        
       
        return UIScreen.main.scale
    }


    var selectedChairWidth: Double {
        chairManoeuvreProjectVM.getSelectedChairMeasurement(.chairWidth)
    }

    let firstMovementIndex = 0
    var arrayOfForEachMovementOfOneChairArrayChairMovementPart:  [(chairIndex: Int, chairMovementsParts: [Type.ChairMovementParts])] {
        chairManoeuvreProjectVM.getForEachMovementOfOneChairArrayChairMovementPart()
    }
    var dragBackgroundPictureAndChairsMoveents: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged { value in
                var newLocation = chosenPhotoVM.chosenPhotoLocation
                let xTranslation = value.translation.width
                let yTranslation = value.translation.height
                newLocation.x += xTranslation
                newLocation.y += yTranslation
                chosenPhotoVM.setChosenPhotoLocation(newLocation)
                xChange = xTranslation - xChange
                yChange = yTranslation - yChange
                chairManoeuvreProjectVM.modifyAllMovementLocationsByBackgroundPictureDrag( CGPoint(x: xChange, y: yChange))
                xChange = xTranslation
                yChange = yTranslation
            }
            .updating($startBackgroundPictureLocation) { (value, startBackgroundPictureLocation, transaction) in
                startBackgroundPictureLocation = startBackgroundPictureLocation ?? chosenPhotoVM.chosenPhotoLocation // 2
                chosenPhotoVM.setChosenPhotoLocation(startBackgroundPictureLocation!)
            }
            .onEnded(){ value  in
                self.xChange = 0.0
                self.yChange = 0.0
            }
    }
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerBackgroundPictureLocation) { (value, fingerBackgroundPictureLocation, transaction) in
                fingerBackgroundPictureLocation = value.location
            }
    }

    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom: Double {
        0.07 / chairManoeuvreProjectVM.model.manoeuvreScale
    }
    
    var scalingCompleted: Bool {
        scalingCompletedViewModel.scalingCompleted
    }
    
    
    private var maximimumZoom = 5.0
    var zoom: CGFloat {
        let zoom =
        limitZoom( 1 + currentZoom + lastCurrentZoom)
       // print("zoom in ContentView \(zoom)")
    return zoom
    }
    
    var scale: Double {
        scaleValueProviderVM.scale
    }
    
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    func chairsMovementsOnChosenBackground() -> some View {
        ZStack{
            chosenBackground()
               
          //  if confirmScaleButtonViewModel.getScalingCompletedStatus()
            if scalingCompleted{
                ForEach( arrayOfForEachMovementOfOneChairArrayChairMovementPart, id: \.chairIndex) { item in
                    ChairMovementsView(forEachMovementOfOneChairArrayChairMovementPart: item.chairMovementsParts)
                    TurnHandleConditionalView(forEachMovementOfOneChairArrayChairMovementPart: item.chairMovementsParts)
                }
            }
        }
        .scaleEffect(zoom)
        .gesture(MagnificationGesture()
            .onChanged { value in
                currentZoom = value - 1
                visibleToolViewModel.setZoomForTool(zoom, chairManoeuvreProjectVM.model.manoeuvreScale)
            }
            .onEnded { value in
                lastCurrentZoom += currentZoom
                currentZoom = 0.0
            }
         )
    }
  

    var backgroundWhenInChairMenu: some View {
        LocalFilledRectangle.path(0,0,SizeOf.screenWidth * 1, SizeOf.screenHeight * 1,.white,0.9)
    }

    
    func chosenBackground() -> some View {
        // set backGround to scale that was last applied in the PhotoScaleView
      //  let finalZoomInPhotoPicker = chosenPhotoVM.getFinalChosentPhotoZoom()
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
        var state = false
        if alertVM.getPickerImageAddedWhenNoChairsStatus() {
            state =
            !scalingCompleted
            && chairManoeuvreProjectVM.chairManoeuvres.count > 0 && //chosenPhotoScaleVM.getImagePickerStatus() &&
            scalingCompleted

        }
        return state
    }
    
    var flipHandleZoomSize: Double {
        chairManoeuvreProjectVM.applyChairManoeuvreScale(SizeOf.tool)
    }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
  


    
    var body: some View {

        ZStack{
           // if confirmScaleButtonViewModel.getScalingCompletedStatus() 
            if scalingCompleted
            {
              //scaledDimensionLine
                
                ScaleDimensionLineView(zoom)
            }

            ZStack {
                PhotoManagementView()
                    .zIndex(scaleMenuVM.getMenuActiveStatus() ? 2.0: 2.0)
                
                chairsMovementsOnChosenBackground()
                
                ReturnToNavigation() //OFF!
                    .zIndex(11.0)
                
                NavigationView()
                    .zIndex(11.0)
                
               MenuForChairView() //OFF!
                
                //                if showAlert {
                //                 ScaleAlert()
                //                }
                
            }
        }
    }

}



struct ScaleAlert: View {
    @State private var presentAlert = true
    var body: some View {
        VStack {
            // 2
            Text(presentAlert ? "Presenting": "Nonsense-alert ignored")
                .foregroundColor(.red)
            Button("Alert") {
                // 3
                presentAlert = true
            }
            Spacer()
        }
        .alert(isPresented: $presentAlert) { // 4
            Alert(
                title: Text("PLAN NOT SCALED"),
                message: Text("nonsense results: the chair image and plan are at different scales go to photo menu and scale")
            )
        }
        .padding()
    }
}


