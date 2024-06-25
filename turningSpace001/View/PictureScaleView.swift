//
//  PictureScaleView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.sd
//

import SwiftUI
import UIKit
struct PictureScaleView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @EnvironmentObject var menuPhotoScaleVM: MenuPictureScaleViewModel
    @EnvironmentObject var pictureScaleViewModel: PictureScaleViewModel
    @EnvironmentObject var photoScaleSettingViewModel: PhotoScaleSettingViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var chairManoeuvreVM: ChairManoeuvreProjectVM
    @EnvironmentObject var alertVM: AlertViewModel
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var showScalingRuler = false
    @State private var millimeterDimensionOnPlan = 2000.0

    var leftScalingTriangleLocation = PhotoScaleSettingModel.initialLeftcalingTriangleLocation// CGPoint(x: 75, y: 50)
    var rightScalingTriangleLocation = PhotoScaleSettingModel.initialRightScalingTriangleLocation
    
    static let scalerBoxSize = CGFloat(60)
    
    var neitherImageOrBackground: Bool {
        image == nil && !pictureScaleViewModel.getBackgroundPictureSatus()
    }
    var eitherImageOrBackground: Bool {
        image != nil || pictureScaleViewModel.getBackgroundPictureSatus()
    }
    
    var buttonForScalingImage: some View {
        Button(action: {
            if image != nil {
                pictureScaleViewModel.setBackgroundImage(image)
            }
            menuPhotoScaleVM.setDimensionOnPlan(millimeterDimensionOnPlan)
            
            
            chairManoeuvreVM.modifyManoeuvreScale(chairManoeuvreScale, "pictureScaler")
            
       //     print("input chairManoeuvreScale \(chairManoeuvreScale)")
         
            menuPhotoScaleVM.setShowMenuStatus(false)
            pictureScaleViewModel.setImageZoom(zoom)
            
          //  print("input zoom \(zoom)")
            menuPhotoScaleVM.setScalingCompletedStatus(true)
            image = nil
            showScalingRuler = false
//print("CONFIRM")
        }) {Text("Confirm") }
            .buttonStyle(PictureScaleBlueButton())
            .opacity(neitherImageOrBackground ? 0.1: 1.0)
            .modifier(MenuButtonWithTextFont())
            .disabled(neitherImageOrBackground)
    }

    
    var dragLeftScalerTriangle: some Gesture {
        DragGesture()
            .onChanged { value in
                photoScaleSettingViewModel.setLeftScalingTriangleLocation(value.location)
            }
    }
    
    var dragRightScalerTriangle: some Gesture {
        DragGesture()
            .onChanged { value in
                photoScaleSettingViewModel.setRightScalingTriangleLocation(value.location)
//print("TRIANGLE \(value.location.x)")
            }
    }
    
    var chairManoeuvreScale: CGFloat {
        let separation = photoScaleSettingViewModel.getScalingTriangleSeparation(PictureScaleView.scalerBoxSize,"PictureScaleView.chairManouevreScale")
        
        let dimensionOnPlan = menuPhotoScaleVM.getDimensionOnPlan()
        print("\nseparation \(separation)")
        print("dimnensionOnPlan \(dimensionOnPlan)\n")
        return
            separation/dimensionOnPlan
    }
    
    @GestureState private var fingerBackgroundPictureLocation: CGPoint? = nil
    @GestureState private var startBackgroundPictureLocation: CGPoint? = nil // 1
    var dragBackgroundPicture: some Gesture {
        DragGesture()
            .onChanged { value in
//                if menuPhotoScaleVM.getShowMenuStatus() {
                    var newLocation = startBackgroundPictureLocation ?? pictureScaleViewModel.getBackgroundPictureLocation() // 3
                    newLocation.x += value.translation.width
                    newLocation.y += value.translation.height
                    pictureScaleViewModel.setBackgroundPictureLocation(newLocation)
//                }
            }
            .updating($startBackgroundPictureLocation) { (value, startBackgroundPictureLocation, transaction) in
//                if menuPhotoScaleVM.getShowMenuStatus() {
                    startBackgroundPictureLocation = startBackgroundPictureLocation ?? pictureScaleViewModel.getBackgroundPictureLocation() // 2
//                }
            }
    }
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerBackgroundPictureLocation) { (value, fingerBackgroundPictureLocation, transaction) in
                fingerBackgroundPictureLocation = value.location
            }
    } //https://sarunw.com/posts/move-view-around-with-drag-gesture-in-swiftui/

    
    

    
    @State var currentZoom: CGFloat = 0.0
    @State var lastCurrentZoom: CGFloat = 0.0
    private var  minimumZoom = 0.1
    private var maximimumZoom = 5.0
    var zoom: CGFloat {
        limitZoom( 1 + currentZoom + lastCurrentZoom)
    }
    
    func limitZoom (_ zoom: CGFloat) -> CGFloat {
       return max(min(zoom, maximimumZoom),minimumZoom)
    }
    
    var chosenPicture: some View {
        Group {
            if image != nil {
                image!
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: SizeOf.screenWidth, height: SizeOf.screenHeight)
//                    .initialImageModifier()
                .scaleEffect(zoom)
                .position(pictureScaleViewModel.getBackgroundPictureLocation())
                .gesture(dragBackgroundPicture)
                .gesture(MagnificationGesture()
                .onChanged { value in
                 currentZoom = value - 1
                }
                .onEnded { value in
                  //  print(SizeOf.screenWidth)
                 lastCurrentZoom += currentZoom
                 currentZoom = 0.0
                })
            }
        }
    }
    


    
    
    
    
    
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    

    var grayOut: Double {
        image == nil && !pictureScaleViewModel.getImagePickerStatus() ? 0.1: 1
    }
    var grayOutSlider: Color {
        image == nil && !pictureScaleViewModel.getImagePickerStatus() ? .gray: .orange
    }
    
    var dimensionSliders: some View {
        VStack{
            HStack{
                Button(action: {
                    millimeterDimensionOnPlan -= 5
                     })  {Text ( "-5")}
                    .buttonStyle(PictureScaleBlueButton())
                    .modifier(MenuButtonWithTextFont())
                    .opacity(grayOut)
                Slider(value: $millimeterDimensionOnPlan, in: 1000...6000, step: 100)//
                    .onChange(of: millimeterDimensionOnPlan) { value in
                    }
                    .disabled(image == nil && !pictureScaleViewModel.getBackgroundPictureSatus() )
                    .accentColor(grayOutSlider)
                Button(action: {
                    millimeterDimensionOnPlan += 5
                     })  {Text ( "+5")}
                    .buttonStyle(PictureScaleBlueButton())
                    .modifier(MenuButtonWithTextFont())
                    .opacity(grayOut)
            }
            .padding()
        }
    }
    
    func getDimensionOnPlan() -> Double{
        millimeterDimensionOnPlan
    }
    
    var buttonToShowChallenge: some View {
        Button(action: {
            image = nil
            pictureScaleViewModel.setBackgroundImageToNil ()
            menuPhotoScaleVM.setScalingCompletedStatus(false)
            image = Image("Practice")
            showScalingRuler = true
            pictureScaleViewModel.setImagePickerStatus(true)
            imageLoadFailed = false
           
        }) { Text("TRY ME")}
           // .modifier(ConditionalMenuButtonWithTextFont(status: image == nil))
            .modifier(MenuButtonWithTextFont())
        .sheet(isPresented: $showingImagePicker) {
//            PHPickerView(image: $image)
        }
        .buttonStyle(PictureScaleBlueButton())
//        .disabled(image != nil)
    }
    
   @State var neitherPhotoPicOrBackgroundImage = true
    
    
    
    
    
    
    
    var buttonToCancelPhoto: some View {
        Button(action: {
            image = nil
            pictureScaleViewModel.setBackgroundImageToNil()
            showScalingRuler = false
            neitherPhotoPicOrBackgroundImage = image == nil && pictureScaleViewModel.getBackgroundImageExists(image)
            pictureScaleViewModel.setImagePickerStatus(false)
            menuPhotoScaleVM.setScalingCompletedStatus(false)
print("REMOVE")
        }) { Text("Remove")}
            .opacity(eitherImageOrBackground ? 1.0: 0.1)
            .modifier(MenuButtonWithRedTextFont())
        .sheet(isPresented: $showingImagePicker) {
//            PHPickerView(image: $image)
        }
        .disabled(image == nil && pictureScaleViewModel.getBackgroundImageExists(image))
    }
    
    
    var buttonToShowImagePicker: some View {
        Button(action: {
//print("GET PICTURE")
            image = nil
            menuPhotoScaleVM.setScalingCompletedStatus(false)
            showingImagePicker = true //.toggle()
//print("SHOW IMAGE PICKER")
        }) { Text("Import")}
//            .modifier(ConditionalMenuButtonWithTextFont(status: image == nil))
//            .disabled(!neitherImageOrBackground)
            
//        .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingImagePicker) {
                PHPickerView(image: $image)
                .onDisappear(perform:
                    {
                    if image != nil {
                        showScalingRuler = true
                        
                        pictureScaleViewModel.setImagePickerStatus(true)
//                        pictureScaleViewModel.setImagePickerStatus(false)
                        imageLoadFailed = false
                    } else {
                        imageLoadFailed = true
                    }
                    pictureScaleViewModel.setBackgroundImageToNil()
                })
        }
            .buttonStyle(PictureScaleBlueButton())
//        .disabled(image != nil)
        
    }

    @State var imageLoadFailed = false

    
    
    @State private var showingPopover = false
    var helpButton: some View {
    Button(action: {
        showingPopover = true
    })
        {Text("?")}
            .buttonStyle(PictureScaleBlueButton())
        .modifier(MenuButtonWithSymbolFont())
        .popover(isPresented: $showingPopover) {
            VStack (alignment: .leading){
                Text("'TRY ME'\nPractice with example plan\nReproduce the plan wheelchair positions\nAlso see Scale and 'Confirm'")
                Text("\n'Import'\nImported photo must be:\n To scale\n Have one known horizontal dimension(mm)\n Also see Scale and 'Confirm'")
                Text("\nScale and 'Confirm'\nTo make chairs and plan the same scale\n Drag and zoom plan\n Position dash-lines at dimension ends\n Use triangle-box to drag dash-lines\n Set nearest dimension with slider and '+'/'-'\n Tap 'Confirm' to finish")
                Text("\n'Remove'\nTo remove plan")
                Text("\n'Center plan/triangle'\nReset plan/ scaling triangles to original position")
            }

            .modifier(PopOverBodyFont())

        }
    }
    
    var triangleHasNotMovedStatus: Bool {
        photoScaleSettingViewModel.getAreScalingTrianglesAtInitialHeight()
    }
    
    var imageOrBackgroundHasNotMovedSatus: Bool {
        pictureScaleViewModel.getBackgroundPictureLocation() == SizeOf.centre || neitherImageOrBackground
    }

    var disableResetStatus: Bool{
        triangleHasNotMovedStatus && imageOrBackgroundHasNotMovedSatus
        
    }
    var centrePlanButton: some View {
        Button(action: {

            pictureScaleViewModel.setBackgroundPictureLocation(SizeOf.centre)
            photoScaleSettingViewModel.setScalingTrianglesToInitialPosition()
        }) {Text ("Center plan/triangle")}
            .buttonStyle(PictureScaleBlueButton())
            .opacity(disableResetStatus ? 0.1: 1.0)
        
            .modifier(MenuButtonWithTextFont())
            .disabled(disableResetStatus)


    }

    
    struct TextView: UIViewRepresentable {
        var text: String

        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            textView.textAlignment = .center
            return textView
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.text = text
        }
    }
    
    
    var menu: some View {
        Group {
             SlideFromBottom("photo", 200) {
                 VStack{
                     HStack{
                         buttonToShowImagePicker
                         buttonToShowChallenge
                         buttonToCancelPhoto
                     }
                     HStack{
                         centrePlanButton
                         Spacer()
                         helpButton
                     }
                     .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

                     HStack{
                         buttonForScalingImage
                         Text("\(Int( millimeterDimensionOnPlan)) mm (between triangles)")
                             .modifier(MenuButtonTextFont())
                             .opacity(neitherImageOrBackground ? 0.1: 1.0)
                     }

                    dimensionSliders
                     .padding(EdgeInsets(top: -20, leading: 0, bottom: 50, trailing: 0))
                     Spacer()
                 }

             }
             .onDisappear(){
                 if  !menuPhotoScaleVM.getScalingCompletedStatus() {
                     image = nil
                     pictureScaleViewModel.setBackgroundImageToNil()
    print("NO IMAGE")
                 }

             }
         }
    }
    
    
    
    var body: some View {
        VStack {
            ZStack {
                chosenPicture


                if imageLoadFailed {
                    TextView(text: "PHOTO DID NOT LOAD PROBABLY WILL IF YOU TRY AGAIN")
                        .font(.largeTitle)
                }

                if menuPhotoScaleVM.getShowMenuStatus() {
//                    if showScalingRuler && !imageLoadFailed{
                    if image != nil || pictureScaleViewModel.getBackgroundPictureSatus() {
                        DragScalerBox("left", photoScaleSettingViewModel.getLeftScalingTriangleLocation(), dragLeftScalerTriangle as! _ChangedGesture<DragGesture>)
                        DragScalerBox("right", photoScaleSettingViewModel.getRightScalingTriangleLocation(), dragRightScalerTriangle as! _ChangedGesture<DragGesture>)
                    }
                    menu

//                        .font(horizontalSizeClass == .compact ? .footnote: .title)
                }
            }
        }
    }
}


