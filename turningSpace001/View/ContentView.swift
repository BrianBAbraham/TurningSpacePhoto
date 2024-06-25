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
    @EnvironmentObject var pictureScaleViewModel: PictureScaleViewModel
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @GestureState private var startLocation: CGPoint? = nil

    var body: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .updating($startLocation) { value, startLocation, _ in
                startLocation = startLocation ?? pictureScaleViewModel.getBackgroundPictureLocation()
            }
            .onChanged { value in
                guard let startLocation = startLocation else { return }
                let newLocation = CGPoint(
                    x: startLocation.x + value.translation.width,
                    y: startLocation.y + value.translation.height
                )
                pictureScaleViewModel.setBackgroundPictureLocation(newLocation)

                let xTranslation = value.translation.width
                let yTranslation = value.translation.height

                xChange = xTranslation - xChange
                yChange = yTranslation - yChange
                vm.modifyAllMovementLocationsByBackgroundPictureDrag(CGPoint(x: xChange, y: yChange))
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
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @EnvironmentObject var pictureScaleViewModel: PictureScaleViewModel
    @EnvironmentObject var menuPictureScaleViewModel: MenuPictureScaleViewModel
    @EnvironmentObject var visibleToolViewModel: VisibleToolViewModel
    
    

    @GestureState private var fingerBackgroundPictureLocation: CGPoint? = nil
    @GestureState private var startBackgroundPictureLocation: CGPoint? = nil // 1
    
    
    
    @State private var xChange = 0.0
    @State private var yChange = 0.0

    var selectedChairWidth: Double {
        vm.getSelectedChairMeasurement(.chairWidth)
    }

    let firstMovementIndex = 0
    var arrayOfForEachMovementOfOneChairArrayChairMovementPart:  [(chairIndex: Int, chairMovementsParts: [Type.ChairMovementParts])] {
        vm.getForEachMovementOfOneChairArrayChairMovementPart()
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
        0.07 / vm.model.manoeuvreScale
    }
    private var maximimumZoom = 5.0
    var zoom: CGFloat {
        let zoom =
        limitZoom( 1 + currentZoom + lastCurrentZoom)
        
      //  print("zoom in ContentView \(zoom)")
    return zoom
    }
    var scale: Double {
        let scale =
        vm.model.manoeuvreScale
     //   print("scale in ContentView \(scale)")
        return scale
    }
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    func chairsMovementsOnChosenBackground() -> some View {
        ZStack{
            chosenBackground()

            if !menuPictureScaleViewModel.getShowMenuStatus() {
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
                visibleToolViewModel.setZoomForTool(zoom, vm.model.manoeuvreScale)
            }
            .onEnded { value in
                lastCurrentZoom += currentZoom
                currentZoom = 0.0

            }
         )
    }
  
//    var background: some View {
//        Rectangle()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(UIColor.white))
//    }
    
    var backgroundWhenInChairMenu: some View {
        LocalFilledRectangle.path(0,0,SizeOf.screenWidth * 1, SizeOf.screenHeight * 1,.white,0.9)
    }

    func chosenBackground() -> some View {
        let position = pictureScaleViewModel.getBackgroundPictureLocation()
        let scaleEffect = pictureScaleViewModel.getImageZoom("CotentView:choseenBackground")
        return
            Group {
                if pictureScaleViewModel.getBackgroundImage() == nil {
                    if !menuPictureScaleViewModel.getShowMenuStatus() {
    //                    background
                        backgroundWhenInChairMenu
                    }
                }
                else {
                    pictureScaleViewModel.getBackgroundImage()!
                        .initialImageModifier()
                        .scaleEffect(scaleEffect)
                        .position(position)
                        .gesture(DragBackgroundPictureAndChairsGesture(
                            xChange: $xChange,
                            yChange: $yChange
                        ))
                        .gesture(fingerDrag)
                    
                        //.gesture(dragBackgroundPictureAndChairsMoveents)
                }
            }
    }
    
    var showAlert: Bool {
        var state = false
        if alertVM.getPickerImageAddedWhenNoChairsStatus() {
            state =
            !menuPictureScaleViewModel.getScalingCompletedStatus() && vm.chairManoeuvres.count > 0 && pictureScaleViewModel.getImagePickerStatus() && !menuPictureScaleViewModel.getShowMenuStatus()
        }
        return state
    }
    
    var flipHandleZoomSize: Double {
        vm.applyChairManoeuvreScale(SizeOf.tool)
    }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    var scaledDimensionLine: some View {
        let dimensionOnPlan = menuPictureScaleViewModel.getDimensionOnPlan()
        
        return
            ZStack{
                Text(" Plan dimension: \(Int(dimensionOnPlan))")
                    .foregroundColor(.red)
                    .font(horizontalSizeClass == .compact ? .footnote: .title)
                    .padding(.bottom, 20)
                Rectangle()
                    .frame(width: dimensionOnPlan * scale * zoom, height: 1)
                    .foregroundColor(.red)
                    .padding(.leading, 20)
              }
              .zIndex(10.0)
        
    }
    
    var body: some View {
        ZStack{
            if menuPictureScaleViewModel.getScalingCompletedStatus() {
//                VStack(alignment: .leading){
//                    Text("Plan dimension: \(Int(menuPictureScaleViewModel.getDimensionOnPlan()))")
//                        .foregroundColor(.red)
//                        .font(horizontalSizeClass == .compact ? .footnote: .title)
//                        .padding(-5)
//                    HStack{
//                            Text("900mm door")
//                                .foregroundColor(.red)
//                                .font(horizontalSizeClass == .compact ? .footnote: .title)
//
//                        LocalFilledRectangle.path(0.0
//                                                      ,5.0 ,900.0 * scale * zoom ,2.0, .red, 1.0)
//                        Spacer()
//                        }
//                    .frame(height: 15)
                
                scaledDimensionLine
                }
//                .padding()
//                .zIndex(10.0)
            

            //}
            //            Text("\((visibleToolViewModel.getZoomForTool() * vm.model.manoeuvreScale ))").zIndex(10.0)
            ZStack {
                PictureScaleView()
                    .zIndex(menuPictureScaleViewModel.getShowMenuStatus() ? 2.0: 0)
                
                chairsMovementsOnChosenBackground()
                
                ReturnToNavigation()
                    .zIndex(11.0)

                NavigationView()
                    .zIndex(11.0)

                MenuForChairView()
                 
//                if showAlert {
//                 ScaleAlert()
//                }

            }
        }
    }
}

//struct MyPreferenceKey: PreferenceKey{
//    static var defaultValue: Double = 1.0
//
//    static func reduce(value: inout Double, nextValue: ()->Double) {
//        value = newValue
//    }
//}

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



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let vm = ChairManoeuvreProjectVM()
        let navigationViewModel = NavigationViewModel()
        let pictureScaleViewModel = PictureScaleViewModel()
        let menuChairViewModel = MenuChairViewModel()
        let menuPictureScaleViewModel = MenuPictureScaleViewModel()
        let alertViewModel = AlertViewModel()

        ContentView()
            .environmentObject(menuPictureScaleViewModel)
            .environmentObject(navigationViewModel)
            .environmentObject(pictureScaleViewModel)
            .environmentObject(vm)
            .environmentObject(menuChairViewModel)
            .environmentObject(alertViewModel)
    }
}


